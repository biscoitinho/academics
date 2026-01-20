# Caching

## What is Caching?

Storing frequently accessed data in fast storage to reduce latency and load.

```
Without cache:
  Request → Database (slow) → Response

With cache:
  Request → Cache (fast) → Response
  Cache miss → Database → Cache → Response
```

## Benefits

- Faster response times
- Reduced database load
- Lower costs (fewer DB queries)
- Better scalability

## Cache Levels

```
Browser Cache → CDN → Application Cache → Database Query Cache

Closest to user = Fastest
```

## Simple In-Memory Cache (Python)

```python
# Dictionary-based cache
cache = {}

def get_user(user_id):
    # Check cache first
    if user_id in cache:
        print("Cache hit")
        return cache[user_id]

    # Cache miss - fetch from database
    print("Cache miss")
    user = database.get_user(user_id)  # Slow

    # Store in cache
    cache[user_id] = user
    return user

# First call
get_user(1)  # Cache miss

# Second call
get_user(1)  # Cache hit (fast!)
```

```ruby
# Dictionary-based cache
cache = {}

def get_user(user_id, cache)
  # Check cache first
  if cache.key?(user_id)
    puts "Cache hit"
    return cache[user_id]
  end

  # Cache miss
  puts "Cache miss"
  user = Database.get_user(user_id)

  # Store in cache
  cache[user_id] = user
  user
end
```

## Cache with TTL (Time To Live)

```python
import time

class CacheWithTTL:
    def __init__(self):
        self.cache = {}

    def get(self, key):
        if key in self.cache:
            value, expiry = self.cache[key]
            if time.time() < expiry:
                return value
            else:
                # Expired
                del self.cache[key]
        return None

    def set(self, key, value, ttl=60):
        expiry = time.time() + ttl
        self.cache[key] = (value, expiry)

# Usage
cache = CacheWithTTL()
cache.set('user:1', {'name': 'Alice'}, ttl=5)  # 5 seconds

print(cache.get('user:1'))  # {'name': 'Alice'}
time.sleep(6)
print(cache.get('user:1'))  # None (expired)
```

## LRU Cache (Least Recently Used)

```python
from functools import lru_cache

# Decorator - caches last 128 calls
@lru_cache(maxsize=128)
def expensive_function(n):
    print(f"Computing {n}")
    return n * n

print(expensive_function(5))  # Computing 5 → 25
print(expensive_function(5))  # 25 (cached, no print)
print(expensive_function(3))  # Computing 3 → 9

# Check cache stats
print(expensive_function.cache_info())
# CacheInfo(hits=1, misses=2, maxsize=128, currsize=2)

# Clear cache
expensive_function.cache_clear()
```

### Manual LRU Implementation

```python
from collections import OrderedDict

class LRUCache:
    def __init__(self, capacity):
        self.cache = OrderedDict()
        self.capacity = capacity

    def get(self, key):
        if key not in self.cache:
            return None
        # Move to end (most recently used)
        self.cache.move_to_end(key)
        return self.cache[key]

    def put(self, key, value):
        if key in self.cache:
            self.cache.move_to_end(key)
        self.cache[key] = value
        if len(self.cache) > self.capacity:
            # Remove oldest (least recently used)
            self.cache.popitem(last=False)

# Usage
cache = LRUCache(capacity=2)
cache.put(1, 'one')
cache.put(2, 'two')
cache.get(1)        # Access 1
cache.put(3, 'three')  # Evicts 2 (least recently used)
print(cache.get(2))    # None
```

## Redis Cache

```python
import redis
import json

# Connect to Redis
r = redis.Redis(host='localhost', port=6379, decode_responses=True)

# Set value
r.set('user:1', json.dumps({'name': 'Alice', 'age': 30}))

# Get value
user = json.loads(r.get('user:1'))
print(user)  # {'name': 'Alice', 'age': 30}

# Set with expiry (TTL)
r.setex('session:abc', 3600, 'user_data')  # Expires in 1 hour

# Check TTL
print(r.ttl('session:abc'))  # Seconds remaining

# Delete
r.delete('user:1')

# Check existence
print(r.exists('user:1'))  # 0 (False)
```

### Redis Hash

```python
# Store hash (like nested dict)
r.hset('user:1', mapping={
    'name': 'Alice',
    'age': '30',
    'email': 'alice@example.com'
})

# Get single field
print(r.hget('user:1', 'name'))  # Alice

# Get all fields
print(r.hgetall('user:1'))
# {'name': 'Alice', 'age': '30', 'email': 'alice@example.com'}

# Update field
r.hset('user:1', 'age', '31')

# Delete field
r.hdel('user:1', 'email')
```

### Redis Lists (for queues)

```python
# Push to list
r.rpush('queue', 'task1')
r.rpush('queue', 'task2')
r.rpush('queue', 'task3')

# Pop from list
task = r.lpop('queue')
print(task)  # task1

# List length
print(r.llen('queue'))  # 2
```

## Ruby with Redis

```ruby
require 'redis'
require 'json'

redis = Redis.new(host: 'localhost', port: 6379)

# Set value
redis.set('user:1', { name: 'Alice', age: 30 }.to_json)

# Get value
user = JSON.parse(redis.get('user:1'))
puts user['name']  # Alice

# Set with TTL
redis.setex('session:abc', 3600, 'user_data')

# Hash
redis.hset('user:2', 'name', 'Bob')
redis.hset('user:2', 'age', '25')
puts redis.hget('user:2', 'name')  # Bob
```

## Cache Strategies

### Cache-Aside (Lazy Loading)

```python
def get_user(user_id):
    # Try cache
    user = cache.get(f'user:{user_id}')
    if user:
        return user

    # Cache miss - load from DB
    user = db.get_user(user_id)

    # Store in cache
    cache.set(f'user:{user_id}', user)
    return user

# Most common strategy
```

### Write-Through

```python
def update_user(user_id, data):
    # Update DB
    db.update_user(user_id, data)

    # Update cache immediately
    cache.set(f'user:{user_id}', data)

# Ensures cache is always in sync
```

### Write-Behind (Write-Back)

```python
def update_user(user_id, data):
    # Update cache immediately
    cache.set(f'user:{user_id}', data)

    # Queue DB update for later
    queue.add_task('update_user', user_id, data)

# Fast writes, eventual consistency
```

### Read-Through

```python
# Cache handles loading from DB
def get_user(user_id):
    return cache.get_or_load(f'user:{user_id}',
        loader=lambda: db.get_user(user_id))

# Cache abstracts data source
```

## Cache Invalidation

```python
# 1. Time-based (TTL)
cache.set('key', value, ttl=60)  # Expires after 60s

# 2. Manual invalidation
def update_user(user_id, data):
    db.update_user(user_id, data)
    cache.delete(f'user:{user_id}')  # Remove from cache

# 3. Event-based invalidation
def on_user_updated(user_id):
    cache.delete(f'user:{user_id}')

# 4. Cache versioning
def get_user(user_id, version):
    return cache.get(f'user:{user_id}:v{version}')
```

## Cache Warming

```python
# Pre-populate cache
def warm_cache():
    popular_users = db.get_popular_users()
    for user in popular_users:
        cache.set(f'user:{user.id}', user)

# Run at startup or periodically
warm_cache()
```

## Cache Stampede Prevention

```python
import threading

locks = {}

def get_user_with_lock(user_id):
    cache_key = f'user:{user_id}'

    # Try cache
    user = cache.get(cache_key)
    if user:
        return user

    # Get lock
    if cache_key not in locks:
        locks[cache_key] = threading.Lock()

    lock = locks[cache_key]

    with lock:
        # Double-check cache (another thread might have loaded it)
        user = cache.get(cache_key)
        if user:
            return user

        # Load from DB (only one thread does this)
        user = db.get_user(user_id)
        cache.set(cache_key, user)
        return user

# Prevents multiple threads from loading same data
```

## Distributed Caching

### Memcached

```python
import memcache

mc = memcache.Client(['127.0.0.1:11211'])

# Set
mc.set('key', 'value', time=60)  # TTL in seconds

# Get
value = mc.get('key')

# Delete
mc.delete('key')

# Multiple keys
mc.set_multi({'key1': 'value1', 'key2': 'value2'})
values = mc.get_multi(['key1', 'key2'])
```

## Cache Patterns

### Memoization

```python
# Cache function results
def memoize(func):
    cache = {}
    def wrapper(*args):
        if args not in cache:
            cache[args] = func(*args)
        return cache[args]
    return wrapper

@memoize
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)

print(fibonacci(100))  # Fast with caching
```

### Database Query Cache

```python
def get_posts(category, cache_time=300):
    cache_key = f'posts:{category}'

    # Try cache
    posts = cache.get(cache_key)
    if posts:
        return posts

    # Query database
    posts = db.query('SELECT * FROM posts WHERE category = ?', category)

    # Cache result
    cache.set(cache_key, posts, ttl=cache_time)
    return posts
```

### Fragment Cache (Web)

```python
# Cache rendered HTML
def render_user_profile(user_id):
    cache_key = f'profile_html:{user_id}'

    html = cache.get(cache_key)
    if html:
        return html

    # Render template
    user = get_user(user_id)
    html = render_template('profile.html', user=user)

    cache.set(cache_key, html, ttl=600)
    return html
```

## Eviction Policies

```
LRU (Least Recently Used):
  Evict oldest accessed item
  Most common

LFU (Least Frequently Used):
  Evict least accessed item
  Tracks access count

FIFO (First In First Out):
  Evict oldest item
  Simple

Random:
  Evict random item
  Fast, unpredictable

TTL (Time To Live):
  Evict expired items
  Time-based
```

## Cache Metrics

```python
class CacheMetrics:
    def __init__(self):
        self.hits = 0
        self.misses = 0

    def hit_rate(self):
        total = self.hits + self.misses
        return self.hits / total if total > 0 else 0

    def record_hit(self):
        self.hits += 1

    def record_miss(self):
        self.misses += 1

metrics = CacheMetrics()

def get_cached(key):
    if key in cache:
        metrics.record_hit()
        return cache[key]
    else:
        metrics.record_miss()
        value = fetch_from_db(key)
        cache[key] = value
        return value

# Monitor hit rate
print(f"Hit rate: {metrics.hit_rate():.2%}")
```

## Multi-Level Caching

```python
# L1: In-memory (fast, small)
# L2: Redis (medium, larger)
# L3: Database (slow, largest)

def get_user_multi_level(user_id):
    key = f'user:{user_id}'

    # Try L1 (memory)
    if key in memory_cache:
        return memory_cache[key]

    # Try L2 (Redis)
    user = redis.get(key)
    if user:
        memory_cache[key] = user  # Promote to L1
        return user

    # L3 (Database)
    user = db.get_user(user_id)

    # Populate caches
    redis.set(key, user, ttl=3600)
    memory_cache[key] = user

    return user
```

## CDN Caching

```
Client → CDN Edge Server → Origin Server

CDN caches:
- Static files (images, CSS, JS)
- API responses
- Rendered pages

Benefits:
- Reduced latency (geographically close)
- Reduced origin load
- DDoS protection
```

```python
# HTTP headers for CDN
from flask import Flask, make_response

app = Flask(__name__)

@app.route('/api/data')
def get_data():
    response = make_response({'data': 'value'})

    # Cache in CDN for 1 hour
    response.headers['Cache-Control'] = 'public, max-age=3600'

    return response
```

## Browser Caching

```html
<!-- HTML meta tags -->
<meta http-equiv="Cache-Control" content="max-age=3600">

<!-- HTTP headers -->
Cache-Control: public, max-age=3600
ETag: "abc123"
Last-Modified: Wed, 21 Oct 2015 07:28:00 GMT
```

## Common Pitfalls

```python
# 1. Caching mutable objects
user = {'name': 'Alice'}
cache['user:1'] = user
user['name'] = 'Bob'  # Modifies cached object!

# Fix: Deep copy or use immutable data
import copy
cache['user:1'] = copy.deepcopy(user)

# 2. Cache key collisions
# ❌ Bad
cache[user_id] = user

# ✅ Good
cache[f'user:{user_id}'] = user

# 3. Not setting TTL
# Data becomes stale
cache.set('key', value)  # Never expires!

# Fix
cache.set('key', value, ttl=3600)

# 4. Thundering herd
# Multiple requests hit cache miss at once
# Solution: Use locking or cache stampede prevention

# 5. Cache everything
# Don't cache rarely accessed data
# Monitor hit rates
```

## When to Cache

```
✅ Cache:
- Frequently accessed data
- Expensive computations
- Rarely changing data
- Database queries
- API responses
- Rendered HTML

❌ Don't cache:
- User-specific data (unless per-user cache)
- Rapidly changing data
- Large objects (use compression)
- Security-sensitive data
```

## Cache Size

```python
# Limit cache size
from collections import OrderedDict

class SizedCache:
    def __init__(self, max_size=1000):
        self.cache = OrderedDict()
        self.max_size = max_size

    def get(self, key):
        if key in self.cache:
            # Move to end (LRU)
            self.cache.move_to_end(key)
            return self.cache[key]
        return None

    def set(self, key, value):
        if key in self.cache:
            self.cache.move_to_end(key)
        self.cache[key] = value

        # Evict oldest if over limit
        while len(self.cache) > self.max_size:
            self.cache.popitem(last=False)
```

## Best Practices

```python
# 1. Use consistent key naming
USER_CACHE_PREFIX = 'user:'
POST_CACHE_PREFIX = 'post:'

def get_user_cache_key(user_id):
    return f'{USER_CACHE_PREFIX}{user_id}'

# 2. Set appropriate TTL
SHORT_TTL = 60       # 1 minute
MEDIUM_TTL = 3600    # 1 hour
LONG_TTL = 86400     # 1 day

# 3. Handle cache failures gracefully
try:
    value = cache.get(key)
except CacheError:
    value = None  # Fall back to DB

# 4. Monitor cache performance
# Track hit rate, evictions, memory usage

# 5. Version your cache keys
VERSION = 'v1'
cache_key = f'user:{user_id}:{VERSION}'

# 6. Compress large values
import json
import zlib

def set_compressed(key, value):
    json_data = json.dumps(value)
    compressed = zlib.compress(json_data.encode())
    cache.set(key, compressed)

def get_compressed(key):
    compressed = cache.get(key)
    if compressed:
        json_data = zlib.decompress(compressed).decode()
        return json.loads(json_data)
    return None
```
