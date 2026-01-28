# Database Concepts

Fundamental database principles beyond specific SQL syntax.

## ACID Properties

Core properties for reliable database transactions.

### Atomicity

**All or nothing** - Transaction either completes fully or not at all.

```python
# Python example
try:
    # Transfer money
    account_a.balance -= 100  # Withdraw
    account_b.balance += 100  # Deposit
    db.commit()  # Both succeed
except:
    db.rollback()  # Or both fail
```

**Without atomicity**: Money could be withdrawn but not deposited (lost money!).

### Consistency

**Valid state only** - Database moves from one valid state to another.

```python
# Constraint: balance >= 0
account.balance = 100
account.balance -= 150  # Fails! Would violate constraint
```

**Rules enforced**:
- Foreign keys must reference existing records
- Unique constraints
- Check constraints
- Data types

### Isolation

**Concurrent transactions don't interfere** - Each transaction sees consistent view.

```python
# Transaction 1
balance = account.balance  # Reads 100
# Transaction 2 changes balance to 50
balance += 50              # Still uses 100, not 50
account.balance = balance  # Writes 150 (wrong!)
```

**Isolation levels** (from weakest to strongest):
1. **Read Uncommitted** - Can read uncommitted changes (dirty reads)
2. **Read Committed** - Only read committed data
3. **Repeatable Read** - Same reads return same results
4. **Serializable** - Full isolation, like running sequentially

### Durability

**Persisted changes survive crashes** - Once committed, data is safe.

```python
db.commit()  # After this, data survives crash/power loss
```

**How**: Write-ahead logging, disk syncs.

## Normalization

Organizing data to reduce redundancy.

### First Normal Form (1NF)

**Atomic values** - No repeating groups, each cell has single value.

```
❌ Bad (not 1NF):
users
| id | name  | phones           |
|----|-------|------------------|
| 1  | Alice | 111-1111,222-2222|

✅ Good (1NF):
users                    user_phones
| id | name  |          | user_id | phone    |
|----|-------|          |---------|----------|
| 1  | Alice |          | 1       | 111-1111 |
                        | 1       | 222-2222 |
```

### Second Normal Form (2NF)

**No partial dependencies** - Non-key columns depend on full primary key.

```
❌ Bad (not 2NF):
order_items (order_id, product_id, product_name, quantity)
# product_name depends only on product_id, not full key

✅ Good (2NF):
order_items (order_id, product_id, quantity)
products (product_id, product_name)
```

### Third Normal Form (3NF)

**No transitive dependencies** - Non-key columns depend only on primary key.

```
❌ Bad (not 3NF):
employees (id, name, department, department_head)
# department_head depends on department, not id

✅ Good (3NF):
employees (id, name, department_id)
departments (id, name, head)
```

### When to Denormalize

Sometimes breaking normal forms improves performance:

```python
# Normalized (slow - requires join)
orders.customer_id -> customers.name

# Denormalized (fast - no join)
orders.customer_name  # Duplicate data, but faster reads
```

**Trade-off**: Read speed vs write complexity.

## Indexing

Speed up queries by creating lookup structures.

### How Indexes Work

Like a book's index - find pages without reading entire book.

```sql
-- Without index: Table scan O(n)
SELECT * FROM users WHERE email = 'alice@example.com';
-- Reads all rows

-- With index: Tree search O(log n)
CREATE INDEX idx_email ON users(email);
-- Much faster lookup
```

### Index Types

**1. B-Tree Index** (default, most common):
```sql
CREATE INDEX idx_name ON users(name);
```
- Good for: equality and range queries
- Use when: `=`, `<`, `>`, `BETWEEN`, `LIKE 'prefix%'`

**2. Hash Index**:
```sql
CREATE INDEX idx_email USING HASH ON users(email);
```
- Good for: exact matches only
- Fast for `=`, but not for `<` or `>`

**3. Unique Index**:
```sql
CREATE UNIQUE INDEX idx_email ON users(email);
```
- Enforces uniqueness
- Also speeds up lookups

**4. Composite Index**:
```sql
CREATE INDEX idx_name_age ON users(last_name, first_name, age);
```
- Multiple columns
- Order matters!

### When to Index

✅ **Create index when**:
- Column frequently in WHERE clause
- Column in JOIN conditions
- Column in ORDER BY
- High cardinality (many unique values)

❌ **Don't index when**:
- Small table (index overhead > benefit)
- Frequently updated column
- Low cardinality (few unique values like boolean)
- Rarely queried column

### Index Trade-offs

```python
# Pros
- Faster SELECT queries
- Faster JOIN operations
- Faster ORDER BY

# Cons
- Slower INSERT/UPDATE/DELETE (must update index)
- Takes disk space
- Too many indexes hurt performance
```

## Transactions

Group operations into atomic unit.

```python
# Python with SQLAlchemy
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

engine = create_engine('postgresql://...')
Session = sessionmaker(bind=engine)
session = Session()

try:
    # Start transaction (implicit)
    user = User(name='Alice')
    session.add(user)

    account = Account(user_id=user.id, balance=1000)
    session.add(account)

    # Commit - all or nothing
    session.commit()
except Exception as e:
    # Rollback on error
    session.rollback()
    raise
finally:
    session.close()
```

```ruby
# Ruby with ActiveRecord
ActiveRecord::Base.transaction do
  user = User.create!(name: 'Alice')
  Account.create!(user_id: user.id, balance: 1000)
  # Both succeed or both rollback
end
```

### Transaction Isolation Problems

**1. Dirty Read** - Read uncommitted changes:
```
T1: UPDATE accounts SET balance = 500 WHERE id = 1  (not committed)
T2: SELECT balance FROM accounts WHERE id = 1       (reads 500)
T1: ROLLBACK                                         (T2 saw wrong data!)
```

**2. Non-Repeatable Read** - Same query, different results:
```
T1: SELECT balance FROM accounts WHERE id = 1       (gets 1000)
T2: UPDATE accounts SET balance = 500 WHERE id = 1
T2: COMMIT
T1: SELECT balance FROM accounts WHERE id = 1       (gets 500, different!)
```

**3. Phantom Read** - Rows appear/disappear:
```
T1: SELECT * FROM accounts WHERE balance > 1000     (gets 5 rows)
T2: INSERT INTO accounts VALUES (6, 1500)
T2: COMMIT
T1: SELECT * FROM accounts WHERE balance > 1000     (gets 6 rows, new phantom!)
```

## Locking

Prevent concurrent access conflicts.

### Optimistic Locking

**Assume conflicts are rare**, check before committing.

```python
# Using version column
class User:
    id = Column(Integer, primary_key=True)
    name = Column(String)
    version = Column(Integer, default=1)

# Load record
user = session.query(User).get(1)
original_version = user.version

# Modify
user.name = 'New Name'
user.version += 1

# Update only if version hasn't changed
result = session.execute(
    update(User)
    .where(User.id == 1, User.version == original_version)
    .values(name='New Name', version=original_version + 1)
)

if result.rowcount == 0:
    raise ConcurrentUpdateError("Record was modified by another transaction")
```

### Pessimistic Locking

**Lock rows** to prevent others from modifying.

```python
# SELECT FOR UPDATE - locks row
user = session.query(User).with_for_update().get(1)
user.balance += 100
session.commit()  # Lock released
```

```sql
-- SQL locking
BEGIN;
SELECT * FROM accounts WHERE id = 1 FOR UPDATE;  -- Locks row
UPDATE accounts SET balance = balance + 100 WHERE id = 1;
COMMIT;  -- Releases lock
```

**Lock types**:
- **Shared lock** (READ) - Multiple readers, no writers
- **Exclusive lock** (WRITE) - One writer, no readers

## CAP Theorem

**You can only have 2 of 3**:

1. **Consistency** - All nodes see same data
2. **Availability** - System always responds
3. **Partition Tolerance** - Works despite network splits

```
        Consistency
            /\
           /  \
          /    \
         /      \
        /   CA   \    (Traditional RDBMS)
       /  (no partition tolerance)
      /______________\
Partition        Availability
Tolerance

CP - Redis Cluster (consistent but may be unavailable)
AP - Cassandra (available but eventual consistency)
CA - Single server DB (consistent + available, but no partition tolerance)
```

**Real world**: Networks partition, so choose CP or AP.

## Sharding

Split database across multiple servers.

### Horizontal Sharding

Split by rows.

```python
# Shard by user_id
def get_shard(user_id):
    if user_id % 3 == 0:
        return shard_0
    elif user_id % 3 == 1:
        return shard_1
    else:
        return shard_2

# User 1 -> Shard 1
# User 2 -> Shard 2
# User 3 -> Shard 0
```

**Pros**: Scales writes
**Cons**: Cross-shard queries are hard

### Vertical Sharding

Split by columns (tables).

```
Server 1: users, accounts
Server 2: orders, products
Server 3: logs, analytics
```

## Replication

Copy data to multiple servers.

### Master-Slave (Primary-Replica)

```
       Master (writes)
      /      |      \
Slave 1  Slave 2  Slave 3 (reads)
```

```python
# Write to master
master_db.execute("INSERT INTO users ...")

# Read from slaves
slave_db.execute("SELECT * FROM users ...")
```

**Pros**: Scale reads
**Cons**: Replication lag, writes don't scale

### Master-Master

```
Master 1  <->  Master 2
```

Both can accept writes.

**Pros**: High availability
**Cons**: Conflict resolution needed

## Query Optimization

### Use EXPLAIN

```sql
EXPLAIN SELECT * FROM users WHERE email = 'alice@example.com';
```

Shows:
- Whether index is used
- Number of rows scanned
- Join method

### Common Optimizations

**1. Add indexes**:
```sql
CREATE INDEX idx_email ON users(email);
```

**2. Select only needed columns**:
```sql
-- Bad
SELECT * FROM users;

-- Good
SELECT id, name FROM users;
```

**3. Avoid SELECT DISTINCT** (if possible):
```sql
-- Slower
SELECT DISTINCT name FROM users;

-- Faster (if name is unique)
SELECT name FROM users;
```

**4. Use LIMIT**:
```sql
SELECT * FROM users LIMIT 100;  -- Don't fetch millions of rows
```

**5. Avoid N+1 queries**:
```python
# Bad - N+1 queries
users = User.query.all()
for user in users:
    print(user.orders)  # Additional query per user!

# Good - 2 queries total
users = User.query.options(joinedload('orders')).all()
for user in users:
    print(user.orders)  # No additional query
```

## Denormalization vs Normalization

### When to Normalize

✅ Write-heavy applications
✅ Data integrity critical
✅ Storage space limited
✅ Frequent updates

### When to Denormalize

✅ Read-heavy applications
✅ Complex joins hurt performance
✅ Acceptable data duplication
✅ Analytics/reporting

**Example**:
```python
# Normalized - slow reads
orders JOIN customers JOIN products

# Denormalized - fast reads
orders (customer_name, product_name)  # Duplicated data
```

## Connection Pooling

Reuse database connections instead of creating new ones.

```python
# Python - connection pool
from sqlalchemy import create_engine

engine = create_engine(
    'postgresql://...',
    pool_size=10,           # Keep 10 connections open
    max_overflow=20,        # Create up to 20 more if needed
    pool_timeout=30,        # Wait 30s for connection
    pool_recycle=3600       # Recycle connections after 1 hour
)
```

```ruby
# Ruby - connection pool
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  pool: 10,                # Pool size
  timeout: 5000            # Wait 5s for connection
)
```

**Why**: Creating connections is expensive (~100ms).

## Key Takeaways

1. **ACID** - Reliable transactions need all 4 properties
2. **Normalization** - Reduces redundancy, may slow reads
3. **Indexes** - Speed up reads, slow down writes
4. **Transactions** - Group operations, ensure consistency
5. **Locking** - Prevent conflicts (optimistic or pessimistic)
6. **CAP** - Can't have all 3, choose 2
7. **Sharding** - Scale by splitting data
8. **Replication** - Copy data for availability/reads
9. **Optimize queries** - Use EXPLAIN, add indexes, avoid N+1
10. **Connection pooling** - Reuse connections

**Remember**: Database design is about trade-offs. Choose based on your application's needs!
