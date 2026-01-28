# Distributed Systems Basics

Fundamentals of systems running across multiple machines.

## What is a Distributed System?

**Multiple computers working together to appear as one system**.

Examples:
- Google Search (thousands of servers)
- Netflix (content delivery)
- Database clusters (PostgreSQL, MySQL)
- Microservices architectures

## CAP Theorem

**You can only guarantee 2 of 3**:

### Consistency (C)
All nodes see the same data at the same time.

### Availability (A)
Every request receives a response (success or failure).

### Partition Tolerance (P)
System continues working despite network failures.

```
Pick 2:
- CP: Consistent + Partition Tolerant (may be unavailable)
  Examples: MongoDB, HBase, Redis
  
- AP: Available + Partition Tolerant (eventual consistency)
  Examples: Cassandra, DynamoDB, Riak
  
- CA: Consistent + Available (no partition tolerance)
  Examples: Traditional RDBMS (single server)
```

**Reality**: Networks always partition, so choose CP or AP.

## Consistency Models

### Strong Consistency
Read always returns latest write. Expensive!

```python
# Write
db.write("x", 10)

# Read immediately after (any node)
value = db.read("x")  # Always returns 10
```

### Eventual Consistency
Reads may return old data temporarily, but eventually converge.

```python
# Write to node A
db_a.write("x", 10)

# Read from node B immediately
value = db_b.read("x")  # Might still be old value

# Read later
time.sleep(1)
value = db_b.read("x")  # Eventually becomes 10
```

### Causal Consistency
If operation A causes B, everyone sees A before B.

## Partitioning (Sharding)

**Split data across multiple machines**.

```python
# Hash-based partitioning
def get_shard(user_id, num_shards=3):
    return user_id % num_shards

# User 1 -> Shard 1
# User 2 -> Shard 2
# User 3 -> Shard 0
# User 4 -> Shard 1
```

**Range-based**:
```
Shard 1: users 1-1000
Shard 2: users 1001-2000
Shard 3: users 2001-3000
```

**Problems**:
- Cross-shard queries are slow
- Uneven distribution (hot spots)
- Rebalancing is complex

## Replication

**Copy data to multiple machines**.

### Master-Slave (Leader-Follower)

```
Master (writes) -> Slave 1 (reads)
                -> Slave 2 (reads)
                -> Slave 3 (reads)
```

**Pros**: Simple, scales reads
**Cons**: Single point of failure, replication lag

### Master-Master (Multi-Leader)

```
Master 1 <-> Master 2 <-> Master 3
```

**Pros**: High availability, geographic distribution
**Cons**: Conflict resolution needed

### Leaderless (Peer-to-Peer)

```
Node 1 <-> Node 2 <-> Node 3
```

All nodes equal, no master.

**Examples**: Cassandra, DynamoDB

## Consensus Algorithms

**Getting distributed nodes to agree**.

### Two-Phase Commit (2PC)

```
1. Coordinator: "Can you commit?"
2. Participants: "Yes" or "No"
3. If all yes: "Commit!"
   If any no: "Abort!"
```

**Problem**: Coordinator failure blocks system.

### Paxos / Raft

More resilient consensus algorithms.

**Raft steps**:
1. Leader election
2. Log replication
3. Safety guarantees

Used in: etcd, Consul, MongoDB

## Distributed Transactions

**ACID across multiple databases**.

```python
# Saga pattern (compensating transactions)
try:
    order_service.create_order()
    payment_service.charge()
    inventory_service.reserve()
except:
    # Compensate
    inventory_service.release()
    payment_service.refund()
    order_service.cancel()
```

## Common Patterns

### Load Balancer

Distribute requests across servers.

```
Client -> Load Balancer -> Server 1
                        -> Server 2
                        -> Server 3
```

**Algorithms**:
- Round robin
- Least connections
- IP hash

### Circuit Breaker

Prevent cascading failures.

```python
class CircuitBreaker:
    def __init__(self, failure_threshold=5):
        self.failure_count = 0
        self.threshold = failure_threshold
        self.state = "closed"  # closed, open, half-open

    def call(self, func):
        if self.state == "open":
            raise Exception("Circuit open!")

        try:
            result = func()
            self.failure_count = 0
            return result
        except:
            self.failure_count += 1
            if self.failure_count >= self.threshold:
                self.state = "open"
            raise
```

### Message Queue

Async communication between services.

```python
# Producer
queue.publish("user.created", {"id": 123})

# Consumer
def handle_user_created(message):
    send_welcome_email(message["id"])

queue.subscribe("user.created", handle_user_created)
```

**Examples**: RabbitMQ, Kafka, SQS

### Service Discovery

Find service locations dynamically.

```python
# Register service
registry.register("user-service", "http://10.0.0.5:3000")

# Discover service
url = registry.discover("user-service")
response = requests.get(f"{url}/users")
```

**Tools**: Consul, etcd, ZooKeeper

## Time and Ordering

### Problem: No Global Clock

Clocks drift, can't trust timestamps.

### Logical Clocks (Lamport)

```python
class LamportClock:
    def __init__(self):
        self.time = 0

    def tick(self):
        self.time += 1
        return self.time

    def update(self, received_time):
        self.time = max(self.time, received_time) + 1
```

### Vector Clocks

Track causality between events.

```python
# Each node has vector of all nodes' clocks
node_a = {"A": 1, "B": 0, "C": 0}
node_b = {"A": 1, "B": 2, "C": 0}

# Can determine if A happened before B
```

## Failure Handling

### Types of Failures

1. **Crash** - Node stops responding
2. **Omission** - Messages lost
3. **Timing** - Too slow to respond
4. **Byzantine** - Malicious behavior

### Detecting Failures

**Heartbeats**:
```python
def health_check():
    while True:
        for node in cluster:
            try:
                node.ping()
                mark_alive(node)
            except:
                mark_dead(node)
        time.sleep(1)
```

### Handling Failures

1. **Retry** - Try again
2. **Timeout** - Don't wait forever
3. **Fallback** - Use default
4. **Circuit breaker** - Stop trying

## Scalability Patterns

### Vertical Scaling (Scale Up)
Add more CPU/RAM to single machine.

**Pros**: Simple
**Cons**: Expensive, limited

### Horizontal Scaling (Scale Out)
Add more machines.

**Pros**: Unlimited growth
**Cons**: Complex

### Caching

```python
# Cache layer
cache = Redis()

def get_user(id):
    # Check cache first
    user = cache.get(f"user:{id}")
    if user:
        return user

    # Cache miss, get from DB
    user = db.query("SELECT * FROM users WHERE id = ?", id)
    cache.set(f"user:{id}", user, ttl=3600)
    return user
```

## Event Sourcing

Store all changes as events.

```python
# Instead of current state
users = {"id": 1, "name": "Alice", "balance": 100}

# Store events
events = [
    {"type": "UserCreated", "name": "Alice"},
    {"type": "BalanceAdded", "amount": 100},
    {"type": "BalanceSubtracted", "amount": 20}
]

# Replay to get current state
def get_current_state(events):
    state = {}
    for event in events:
        apply(state, event)
    return state
```

## Idempotency

**Same operation multiple times = same result**.

```python
# Not idempotent
def add_balance(user_id, amount):
    user.balance += amount  # Running twice doubles it!

# Idempotent
def set_balance(user_id, amount, version):
    if user.version == version:
        user.balance = amount
        user.version += 1
```

## Key Takeaways

1. **CAP Theorem** - Pick 2: Consistency, Availability, Partition Tolerance
2. **Eventual Consistency** - Trade immediate consistency for availability
3. **Partitioning** - Split data across machines
4. **Replication** - Copy data for availability
5. **Consensus** - Getting nodes to agree is hard
6. **Failures happen** - Design for them
7. **No global clock** - Use logical clocks
8. **Idempotency** - Make operations safe to retry

**Remember**: Distributed systems are complex. Start simple, distribute only when needed!
