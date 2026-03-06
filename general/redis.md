# Redis

In-memory data structure store used as a database, cache, message broker, and queue.

```
Client → Redis (RAM) → Response   # microsecond latency
                ↕
          Persistence (optional)
```

## Overview

Redis (Remote Dictionary Server) stores data in memory, making reads/writes extremely fast. It supports rich data structures beyond simple key-value pairs and optionally persists data to disk.

## Pros and Cons

```
✅ Pros:
- Sub-millisecond latency (data in RAM)
- Rich data structures (strings, hashes, lists, sets, sorted sets, streams)
- Atomic operations
- Built-in TTL / expiry
- Pub/Sub messaging
- Horizontal scaling via clustering
- Optional persistence (RDB snapshots, AOF logs)

❌ Cons:
- Data limited by available RAM
- Not a primary database replacement (no relations, no complex queries)
- Single-threaded command execution (one core)
- Persistence adds I/O overhead
- Clustering adds operational complexity
```

## When to Use Redis

```
✅ Good fit:
- Caching database queries or API responses
- Session storage
- Rate limiting / counters
- Leaderboards / rankings
- Real-time pub/sub (chat, notifications)
- Job queues / background tasks
- Distributed locks

❌ Not a good fit:
- Primary relational data store
- Complex queries / joins
- Data larger than available RAM
- Strong ACID transactions across multiple keys
```

## Setup

```bash
# Install and start (Linux/Mac)
brew install redis   # Mac
sudo apt install redis-server  # Ubuntu

redis-server         # start server
redis-cli            # connect to CLI

# Python client
pip install redis

# Ruby client
gem install redis
```

## Basic Operations

### Strings

```python
import redis

r = redis.Redis(host='localhost', port=6379, decode_responses=True)

r.set('name', 'Alice')
print(r.get('name'))         # Alice

r.set('counter', 10)
r.incr('counter')            # 11
r.incrby('counter', 5)       # 16

# With TTL (seconds)
r.setex('token', 3600, 'abc123')
print(r.ttl('token'))        # seconds remaining

r.delete('name')
print(r.exists('name'))      # 0
```

```ruby
require 'redis'

r = Redis.new(host: 'localhost', port: 6379)

r.set('name', 'Alice')
puts r.get('name')           # Alice

r.set('counter', 10)
r.incr('counter')            # 11
r.incrby('counter', 5)       # 16

r.setex('token', 3600, 'abc123')
puts r.ttl('token')          # seconds remaining

r.del('name')
puts r.exists('name')        # 0
```

### Hashes (objects)

```python
r.hset('user:1', mapping={'name': 'Alice', 'age': '30', 'city': 'NYC'})

print(r.hget('user:1', 'name'))    # Alice
print(r.hgetall('user:1'))         # {'name': 'Alice', 'age': '30', 'city': 'NYC'}

r.hset('user:1', 'age', '31')      # update single field
r.hdel('user:1', 'city')           # remove field
print(r.hexists('user:1', 'city')) # False
```

```ruby
r.hset('user:1', 'name', 'Alice', 'age', '30', 'city', 'NYC')

puts r.hget('user:1', 'name')      # Alice
puts r.hgetall('user:1').inspect   # {"name"=>"Alice", "age"=>"30", "city"=>"NYC"}

r.hset('user:1', 'age', '31')
r.hdel('user:1', 'city')
puts r.hexists('user:1', 'city')   # false
```

### Lists (queues / stacks)

```python
# Queue (FIFO): push right, pop left
r.rpush('jobs', 'job1', 'job2', 'job3')
print(r.lpop('jobs'))              # job1
print(r.llen('jobs'))              # 2

# Stack (LIFO): push right, pop right
r.rpush('stack', 'a', 'b', 'c')
print(r.rpop('stack'))             # c

# Blocking pop (waits up to 5s for an item)
task = r.blpop('jobs', timeout=5)
```

```ruby
r.rpush('jobs', 'job1', 'job2', 'job3')
puts r.lpop('jobs')                # job1
puts r.llen('jobs')                # 2

r.rpush('stack', 'a', 'b', 'c')
puts r.rpop('stack')               # c

task = r.blpop('jobs', timeout: 5)
```

### Sets (unique collections)

```python
r.sadd('tags', 'python', 'redis', 'backend')
r.sadd('tags', 'python')           # duplicate, ignored

print(r.smembers('tags'))          # {'python', 'redis', 'backend'}
print(r.sismember('tags', 'ruby')) # False
print(r.scard('tags'))             # 3

# Set operations
r.sadd('a', 1, 2, 3)
r.sadd('b', 2, 3, 4)
print(r.sinter('a', 'b'))          # {2, 3}   intersection
print(r.sunion('a', 'b'))          # {1,2,3,4} union
print(r.sdiff('a', 'b'))           # {1}       difference
```

```ruby
r.sadd('tags', 'python', 'redis', 'backend')
puts r.smembers('tags').inspect    # ["python", "redis", "backend"]
puts r.sismember('tags', 'ruby')   # false
puts r.scard('tags')               # 3

r.sadd('a', 1, 2, 3)
r.sadd('b', 2, 3, 4)
puts r.sinter('a', 'b').inspect    # ["2", "3"]
```

### Sorted Sets (leaderboards / rankings)

```python
# zadd(key, {member: score})
r.zadd('leaderboard', {'alice': 1500, 'bob': 1200, 'carol': 1800})

# Top 3 (highest score first)
print(r.zrevrange('leaderboard', 0, 2, withscores=True))
# [('carol', 1800.0), ('alice', 1500.0), ('bob', 1200.0)]

# User rank (0-indexed, lower = better in zrank)
print(r.zrevrank('leaderboard', 'alice'))  # 1

# Update score
r.zincrby('leaderboard', 100, 'bob')       # bob: 1300
```

```ruby
r.zadd('leaderboard', 1500, 'alice')
r.zadd('leaderboard', 1200, 'bob')
r.zadd('leaderboard', 1800, 'carol')

puts r.zrevrange('leaderboard', 0, 2, with_scores: true).inspect
# [["carol", 1800.0], ["alice", 1500.0], ["bob", 1200.0]]

puts r.zrevrank('leaderboard', 'alice')    # 1
r.zincrby('leaderboard', 100, 'bob')
```

## Common Patterns

### Caching with TTL

```python
import json

def get_user(user_id):
    key = f'user:{user_id}'
    cached = r.get(key)
    if cached:
        return json.loads(cached)

    user = db.find_user(user_id)              # slow DB call
    r.setex(key, 3600, json.dumps(user))      # cache 1 hour
    return user
```

```ruby
require 'json'

def get_user(user_id)
  key = "user:#{user_id}"
  cached = r.get(key)
  return JSON.parse(cached) if cached

  user = db.find_user(user_id)
  r.setex(key, 3600, user.to_json)
  user
end
```

### Rate Limiting

```python
def is_rate_limited(user_id, limit=100, window=60):
    key = f'rate:{user_id}'
    count = r.incr(key)
    if count == 1:
        r.expire(key, window)   # set TTL on first request
    return count > limit

# Usage
if is_rate_limited('user:42'):
    raise Exception('Too many requests')
```

```ruby
def rate_limited?(user_id, limit: 100, window: 60)
  key = "rate:#{user_id}"
  count = r.incr(key)
  r.expire(key, window) if count == 1
  count > limit
end

raise 'Too many requests' if rate_limited?('user:42')
```

### Distributed Lock

```python
import uuid

def acquire_lock(resource, ttl=10):
    token = str(uuid.uuid4())
    # SET NX = only set if not exists
    acquired = r.set(f'lock:{resource}', token, nx=True, ex=ttl)
    return token if acquired else None

def release_lock(resource, token):
    key = f'lock:{resource}'
    if r.get(key) == token:       # verify ownership
        r.delete(key)

# Usage
token = acquire_lock('payment:123')
if token:
    try:
        process_payment()
    finally:
        release_lock('payment:123', token)
```

### Pub/Sub (messaging)

```python
# Publisher
r.publish('notifications', 'New order placed')

# Subscriber (runs in separate thread/process)
pubsub = r.pubsub()
pubsub.subscribe('notifications')

for message in pubsub.listen():
    if message['type'] == 'message':
        print(f"Received: {message['data']}")
```

```ruby
# Publisher
r.publish('notifications', 'New order placed')

# Subscriber
r.subscribe('notifications') do |on|
  on.message do |channel, message|
    puts "Received: #{message}"
  end
end
```

### Job Queue (with Sidekiq in Ruby / RQ in Python)

```python
# Using RQ (Redis Queue)
from rq import Queue
from redis import Redis

q = Queue(connection=Redis())

def send_email(to, subject):
    # ... email logic
    pass

q.enqueue(send_email, 'alice@example.com', 'Welcome!')
```

```ruby
# Using Sidekiq
class EmailWorker
  include Sidekiq::Worker

  def perform(to, subject)
    # ... email logic
  end
end

EmailWorker.perform_async('alice@example.com', 'Welcome!')
```

## Persistence Options

```
RDB (snapshots):
  Saves a point-in-time snapshot to disk at intervals
  Faster restarts, may lose recent writes
  Good for: backups, non-critical caches

AOF (Append-Only File):
  Logs every write command to disk
  Slower, more durable (can replay on restart)
  Good for: session stores, queues

Both:
  Combines safety of AOF with fast RDB restores
  Recommended for production
```

```bash
# redis.conf
save 900 1          # RDB: snapshot if 1 key changed in 900s
appendonly yes      # AOF: enable append-only log
appendfsync everysec  # flush to disk every second
```

## Eviction Policies

When memory is full Redis evicts keys based on the configured policy:

```
allkeys-lru      Most common — evict least recently used key (any key)
volatile-lru     LRU among keys with TTL set
allkeys-lfu      Evict least frequently used key
volatile-ttl     Evict key with shortest TTL first
noeviction       Return error on writes (default) — don't evict anything
```

```bash
# redis.conf
maxmemory 256mb
maxmemory-policy allkeys-lru
```

## Cluster vs Sentinel

```
Sentinel:
  High availability for a single shard
  Automatic failover (promotes replica to primary)
  Use when: one Redis instance is enough, need HA

Cluster:
  Horizontal scaling across multiple shards
  Data partitioned by hash slot (16384 slots)
  Each shard has its own replicas
  Use when: data exceeds single-node RAM or need write scaling
```

## Key Naming Conventions

```
user:42           object type + ID
user:42:sessions  nested resource
rate:user:42      prefix for functional grouping
leaderboard:2024  time-scoped key
lock:payment:99   distributed lock

Rules:
- Use colons as separators
- Keep keys short (stored in RAM)
- Prefix by namespace to avoid collisions
```
