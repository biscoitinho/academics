# Transactions and Locking

## What is a Transaction?

A transaction is a sequence of operations treated as a single unit of work. Either all operations succeed (COMMIT) or all fail (ROLLBACK).

```sql
-- Basic transaction
BEGIN;  -- or START TRANSACTION;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;

-- Transaction with rollback
BEGIN;
INSERT INTO orders (user_id, total) VALUES (1, 500);
-- Error occurs...
ROLLBACK;  -- Undo changes
```

## ACID Properties

**Atomicity**: All or nothing - transaction either completes fully or not at all

```sql
BEGIN;
UPDATE inventory SET quantity = quantity - 1 WHERE product_id = 10;
INSERT INTO orders (product_id, quantity) VALUES (10, 1);
-- Both succeed or both fail
COMMIT;
```

**Consistency**: Database moves from one valid state to another

```sql
-- Constraint ensures consistency
ALTER TABLE accounts ADD CONSTRAINT balance_positive CHECK (balance >= 0);
```

**Isolation**: Concurrent transactions don't interfere with each other

```sql
-- Transaction 1
BEGIN;
SELECT balance FROM accounts WHERE id = 1;  -- Reads 100
-- Transaction 2 updates balance here
UPDATE accounts SET balance = 150 WHERE id = 1;
-- Isolation level determines what Transaction 1 sees
```

**Durability**: Committed changes persist even after crashes

```sql
COMMIT;  -- Changes written to disk, survive power loss
```

## Transaction Commands

### MySQL

```sql
-- Start transaction
START TRANSACTION;
BEGIN;

-- Commit
COMMIT;

-- Rollback
ROLLBACK;

-- Savepoint
SAVEPOINT sp1;
-- Do some work...
ROLLBACK TO SAVEPOINT sp1;  -- Partial rollback
RELEASE SAVEPOINT sp1;

-- Auto-commit (default: ON)
SET autocommit = 0;  -- Disable
SET autocommit = 1;  -- Enable
```

### PostgreSQL

```sql
-- Start transaction
BEGIN;
START TRANSACTION;

-- Commit
COMMIT;
END;

-- Rollback
ROLLBACK;
ABORT;

-- Savepoint
SAVEPOINT sp1;
ROLLBACK TO SAVEPOINT sp1;
RELEASE SAVEPOINT sp1;
```

### SQLite

```sql
BEGIN;
BEGIN IMMEDIATE;  -- Acquires write lock immediately
BEGIN EXCLUSIVE;  -- Exclusive access

COMMIT;
ROLLBACK;

SAVEPOINT sp1;
ROLLBACK TO sp1;
```

## Isolation Levels

From least to most strict:

### 1. READ UNCOMMITTED

Allows dirty reads (read uncommitted changes from other transactions).

```sql
-- MySQL
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- PostgreSQL (not supported, uses READ COMMITTED minimum)
```

**Problems:**
- Dirty reads: Read uncommitted data that may be rolled back

### 2. READ COMMITTED (Default in PostgreSQL)

Only reads committed data.

```sql
-- MySQL
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- PostgreSQL
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ COMMITTED;
```

**Problems:**
- Non-repeatable reads: Same query returns different results

```sql
-- Transaction 1
BEGIN;
SELECT balance FROM accounts WHERE id = 1;  -- Returns 100

-- Transaction 2 commits update
UPDATE accounts SET balance = 150 WHERE id = 1;
COMMIT;

-- Transaction 1
SELECT balance FROM accounts WHERE id = 1;  -- Returns 150 (different!)
COMMIT;
```

### 3. REPEATABLE READ (Default in MySQL)

Same query always returns same results within transaction.

```sql
-- MySQL (default)
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- PostgreSQL
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL REPEATABLE READ;
```

**Problems:**
- Phantom reads: New rows appear in range queries

```sql
-- Transaction 1
BEGIN;
SELECT COUNT(*) FROM users WHERE age > 18;  -- Returns 10

-- Transaction 2
INSERT INTO users (name, age) VALUES ('John', 25);
COMMIT;

-- Transaction 1
SELECT COUNT(*) FROM users WHERE age > 18;  -- MySQL: 10, PostgreSQL: 10
COMMIT;
```

### 4. SERIALIZABLE

Strictest level - transactions appear to run sequentially.

```sql
-- MySQL
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- PostgreSQL
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

**No problems, but:**
- Slowest performance
- More lock contention

## Locking Mechanisms

### Row-Level Locks

**Shared Lock (S)**: Multiple transactions can read, none can write

```sql
-- PostgreSQL
BEGIN;
SELECT * FROM users WHERE id = 1 FOR SHARE;
-- Other transactions can read, but not update/delete
COMMIT;

-- MySQL
BEGIN;
SELECT * FROM users WHERE id = 1 LOCK IN SHARE MODE;
COMMIT;
```

**Exclusive Lock (X)**: Only one transaction can read/write

```sql
-- PostgreSQL
BEGIN;
SELECT * FROM users WHERE id = 1 FOR UPDATE;
-- Other transactions blocked from reading/writing
UPDATE users SET balance = balance + 100 WHERE id = 1;
COMMIT;

-- MySQL
BEGIN;
SELECT * FROM users WHERE id = 1 FOR UPDATE;
UPDATE users SET balance = balance + 100 WHERE id = 1;
COMMIT;
```

### Table-Level Locks

```sql
-- MySQL
LOCK TABLES users WRITE;
-- Do work...
UNLOCK TABLES;

LOCK TABLES users READ;
SELECT * FROM users;
UNLOCK TABLES;

-- PostgreSQL
BEGIN;
LOCK TABLE users IN EXCLUSIVE MODE;
-- Do work...
COMMIT;
```

### Lock Types Comparison

```sql
-- SELECT FOR UPDATE: Exclusive lock
BEGIN;
SELECT * FROM accounts WHERE id = 1 FOR UPDATE;
-- Block: Other transactions can't read/write this row
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
COMMIT;

-- SELECT FOR SHARE: Shared lock
BEGIN;
SELECT * FROM accounts WHERE id = 1 FOR SHARE;
-- Allow: Other transactions can read
-- Block: Other transactions can't update/delete
COMMIT;
```

## MVCC (Multi-Version Concurrency Control)

PostgreSQL and MySQL (InnoDB) use MVCC for better concurrency.

```sql
-- Each row has hidden version columns
-- Transaction 1
BEGIN;
UPDATE users SET name = 'Alice' WHERE id = 1;
-- Creates new version, old version still readable by other transactions
COMMIT;

-- Transaction 2 (started before Transaction 1 committed)
BEGIN;
SELECT name FROM users WHERE id = 1;
-- Still sees old version (snapshot isolation)
COMMIT;
```

## Deadlocks

Occur when two transactions wait for each other's locks.

```sql
-- Transaction 1
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;  -- Locks row 1
-- Wait...
UPDATE accounts SET balance = balance + 100 WHERE id = 2;  -- Waits for row 2

-- Transaction 2
BEGIN;
UPDATE accounts SET balance = balance - 50 WHERE id = 2;   -- Locks row 2
-- Wait...
UPDATE accounts SET balance = balance + 50 WHERE id = 1;   -- Waits for row 1

-- DEADLOCK! Database aborts one transaction
```

### Detecting Deadlocks

**MySQL:**
```sql
-- Show recent deadlock
SHOW ENGINE INNODB STATUS;

-- Deadlock info in error log
```

**PostgreSQL:**
```sql
-- Deadlock detected automatically
-- One transaction gets error: ERROR: deadlock detected
```

### Preventing Deadlocks

```sql
-- 1. Always acquire locks in same order
-- ✅ Good: Always lock lower ID first
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;  -- Lock 1 first
UPDATE accounts SET balance = balance + 100 WHERE id = 5;  -- Lock 5 second
COMMIT;

-- 2. Keep transactions short
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
COMMIT;  -- Release lock quickly

-- 3. Use appropriate isolation level
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- 4. Use lock timeout
SET innodb_lock_wait_timeout = 5;  -- MySQL
SET lock_timeout = '5s';            -- PostgreSQL
```

## Transaction Best Practices

### 1. Keep Transactions Short

```sql
-- ❌ Bad: Long transaction
BEGIN;
SELECT * FROM orders;  -- Read lots of data
-- Process for 10 seconds...
UPDATE orders SET status = 'processed';
COMMIT;

-- ✅ Good: Short transaction
-- Read data outside transaction
SELECT * FROM orders;
-- Process data...
-- Quick update
BEGIN;
UPDATE orders SET status = 'processed' WHERE id IN (1, 2, 3);
COMMIT;
```

### 2. Avoid User Interaction in Transactions

```sql
-- ❌ Bad: Wait for user input
BEGIN;
SELECT * FROM cart WHERE user_id = 1;
-- Wait for user to confirm...
UPDATE cart SET status = 'purchased';
COMMIT;

-- ✅ Good: No waiting
-- Show cart to user
SELECT * FROM cart WHERE user_id = 1;
-- User confirms
BEGIN;
UPDATE cart SET status = 'purchased';
COMMIT;
```

### 3. Handle Errors

**Python (MySQL):**
```python
import mysql.connector

conn = mysql.connector.connect(...)
cursor = conn.cursor()

try:
    conn.start_transaction()
    cursor.execute("UPDATE accounts SET balance = balance - 100 WHERE id = 1")
    cursor.execute("UPDATE accounts SET balance = balance + 100 WHERE id = 2")
    conn.commit()
except Exception as e:
    conn.rollback()
    print(f"Transaction failed: {e}")
```

**Python (PostgreSQL):**
```python
import psycopg2

conn = psycopg2.connect(...)
cursor = conn.cursor()

try:
    cursor.execute("BEGIN")
    cursor.execute("UPDATE accounts SET balance = balance - 100 WHERE id = 1")
    cursor.execute("UPDATE accounts SET balance = balance + 100 WHERE id = 2")
    cursor.execute("COMMIT")
except Exception as e:
    cursor.execute("ROLLBACK")
    print(f"Transaction failed: {e}")
```

### 4. Use Savepoints for Partial Rollback

```sql
BEGIN;

INSERT INTO orders (user_id, total) VALUES (1, 100);
SAVEPOINT order_created;

INSERT INTO order_items (order_id, product_id) VALUES (1, 10);
-- Error: Product 10 doesn't exist

ROLLBACK TO SAVEPOINT order_created;  -- Keep order, remove items
-- Fix and retry
INSERT INTO order_items (order_id, product_id) VALUES (1, 11);

COMMIT;
```

## Common Patterns

### Bank Transfer

```sql
BEGIN;

-- Check sufficient funds
SELECT balance FROM accounts WHERE id = 1 FOR UPDATE;
-- If balance < 100, ROLLBACK

-- Transfer
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;

COMMIT;
```

### Inventory Management

```sql
BEGIN;

-- Check stock
SELECT quantity FROM inventory WHERE product_id = 10 FOR UPDATE;
-- If quantity < 1, ROLLBACK

-- Reduce inventory and create order
UPDATE inventory SET quantity = quantity - 1 WHERE product_id = 10;
INSERT INTO orders (product_id, quantity) VALUES (10, 1);

COMMIT;
```

### Audit Trail

```sql
BEGIN;

UPDATE users SET email = 'new@example.com' WHERE id = 1;

-- Log change
INSERT INTO audit_log (table_name, record_id, action, changed_at)
VALUES ('users', 1, 'UPDATE email', NOW());

COMMIT;
```

## Lock Wait Timeout

```sql
-- MySQL
SET SESSION innodb_lock_wait_timeout = 10;  -- Wait 10 seconds for lock

-- PostgreSQL
SET SESSION lock_timeout = '10s';

-- Query will fail with timeout error if lock not acquired
```

## Monitoring Locks

**MySQL:**
```sql
-- Show current locks
SELECT * FROM information_schema.innodb_locks;

-- Show lock waits
SELECT * FROM information_schema.innodb_lock_waits;

-- Show transactions
SELECT * FROM information_schema.innodb_trx;

-- Kill transaction
KILL 12345;
```

**PostgreSQL:**
```sql
-- Show locks
SELECT * FROM pg_locks;

-- Show blocking queries
SELECT blocked_locks.pid AS blocked_pid,
       blocking_locks.pid AS blocking_pid,
       blocked_activity.query AS blocked_query,
       blocking_activity.query AS blocking_query
FROM pg_catalog.pg_locks blocked_locks
JOIN pg_catalog.pg_locks blocking_locks
    ON blocked_locks.locktype = blocking_locks.locktype
WHERE NOT blocked_locks.granted;

-- Cancel query
SELECT pg_cancel_backend(12345);

-- Terminate connection
SELECT pg_terminate_backend(12345);
```

**SQLite:**
```sql
-- SQLite uses file-level locking
-- Check if database is locked:
-- ERROR: database is locked

-- Set busy timeout
PRAGMA busy_timeout = 5000;  -- Wait 5 seconds
```

## Transaction Isolation Examples

### Example: Concurrent Updates

```sql
-- Transaction 1 (REPEATABLE READ)
BEGIN;
SELECT balance FROM accounts WHERE id = 1;  -- 100
-- Wait 5 seconds...
UPDATE accounts SET balance = balance + 50 WHERE id = 1;
COMMIT;

-- Transaction 2 (starts during wait)
BEGIN;
UPDATE accounts SET balance = balance + 25 WHERE id = 1;
-- Waits for Transaction 1 lock
-- After Transaction 1 commits: updates to 175 (not 125)
COMMIT;
```

### Example: Lost Update Problem

```sql
-- ❌ Bad: Lost update
-- Transaction 1
BEGIN;
SELECT balance FROM accounts WHERE id = 1;  -- 100
-- Calculate new balance: 100 + 50 = 150
UPDATE accounts SET balance = 150 WHERE id = 1;
COMMIT;

-- Transaction 2
BEGIN;
SELECT balance FROM accounts WHERE id = 1;  -- 100 (before T1 commits)
-- Calculate new balance: 100 + 25 = 125
UPDATE accounts SET balance = 125 WHERE id = 1;  -- Overwrites T1!
COMMIT;

-- ✅ Good: Use FOR UPDATE
-- Transaction 1
BEGIN;
SELECT balance FROM accounts WHERE id = 1 FOR UPDATE;  -- 100, locked
UPDATE accounts SET balance = balance + 50 WHERE id = 1;
COMMIT;

-- Transaction 2
BEGIN;
SELECT balance FROM accounts WHERE id = 1 FOR UPDATE;  -- Waits for T1
-- After T1 commits, reads 150
UPDATE accounts SET balance = balance + 25 WHERE id = 1;  -- 175
COMMIT;
```

## Performance Tips

```sql
-- 1. Use appropriate isolation level
-- READ COMMITTED is often sufficient
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- 2. Use row-level locks instead of table-level
-- ✅ Good
SELECT * FROM users WHERE id = 1 FOR UPDATE;
-- ❌ Bad
LOCK TABLES users WRITE;

-- 3. Acquire locks in consistent order
-- Always lock users before orders

-- 4. Keep transactions short
-- Do computation outside transaction

-- 5. Use indexes on locked columns
CREATE INDEX idx_user_id ON orders(user_id);

-- 6. Batch operations when possible
-- ✅ Good
BEGIN;
UPDATE orders SET status = 'shipped' WHERE id IN (1,2,3,4,5);
COMMIT;
-- ❌ Bad
BEGIN;
UPDATE orders SET status = 'shipped' WHERE id = 1;
UPDATE orders SET status = 'shipped' WHERE id = 2;
-- ...
COMMIT;
```

## When to Use Transactions

**Always use transactions for:**
- Multiple related writes
- Data consistency requirements
- Financial operations
- Inventory management

**Don't need transactions for:**
- Single SELECT queries
- Single INSERT/UPDATE/DELETE (atomic by default)
- Read-only operations

```sql
-- Need transaction
BEGIN;
UPDATE inventory SET quantity = quantity - 1 WHERE product_id = 10;
INSERT INTO orders (product_id) VALUES (10);
COMMIT;

-- Don't need transaction
SELECT * FROM products;
INSERT INTO logs (message) VALUES ('User logged in');
```
