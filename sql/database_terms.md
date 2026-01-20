# Database Terms and Concepts

## ACID Properties

Guarantees for database transactions:

**Atomicity**: All or nothing. Transaction either completes fully or not at all.
```sql
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;  -- Both succeed or both fail
```

**Consistency**: Data must follow all rules (constraints, triggers).
```sql
-- Foreign key constraint ensures consistency
CREATE TABLE orders (
    id INT PRIMARY KEY,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

**Isolation**: Concurrent transactions don't interfere with each other.
```sql
-- Transaction A and B run simultaneously
-- Each sees consistent data
```

**Durability**: Committed data persists even after system failure.
```sql
COMMIT;  -- Data written to disk, survives crashes
```

## Keys

### Primary Key

Uniquely identifies each row.

```sql
CREATE TABLE users (
    id INT PRIMARY KEY,  -- Cannot be NULL, must be unique
    username VARCHAR(50)
);

-- Composite primary key
CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    PRIMARY KEY (student_id, course_id)
);
```

### Foreign Key

References primary key in another table.

```sql
CREATE TABLE orders (
    id INT PRIMARY KEY,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- With actions
CREATE TABLE orders (
    id INT PRIMARY KEY,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE      -- Delete orders when user deleted
        ON UPDATE CASCADE      -- Update orders when user id changes
);
```

### Unique Key

Ensures column values are unique (can be NULL).

```sql
CREATE TABLE users (
    id INT PRIMARY KEY,
    email VARCHAR(100) UNIQUE,
    username VARCHAR(50) UNIQUE
);
```

### Candidate Key

Any column(s) that could be a primary key.

```sql
-- email and username are both candidate keys
CREATE TABLE users (
    id INT PRIMARY KEY,     -- Chosen as primary key
    email VARCHAR(100) UNIQUE,     -- Candidate key
    username VARCHAR(50) UNIQUE    -- Candidate key
);
```

## Normalization

Process of organizing data to reduce redundancy.

### First Normal Form (1NF)

- Each column contains atomic (indivisible) values
- No repeating groups

```sql
-- ❌ Not 1NF
CREATE TABLE users (
    id INT,
    phones VARCHAR(200)  -- "555-1234, 555-5678"
);

-- ✅ 1NF
CREATE TABLE users (
    id INT PRIMARY KEY
);
CREATE TABLE user_phones (
    user_id INT,
    phone VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

### Second Normal Form (2NF)

- Must be in 1NF
- All non-key columns depend on entire primary key

```sql
-- ❌ Not 2NF (instructor_name depends only on instructor_id)
CREATE TABLE courses (
    student_id INT,
    course_id INT,
    instructor_id INT,
    instructor_name VARCHAR(100),
    PRIMARY KEY (student_id, course_id)
);

-- ✅ 2NF
CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    instructor_id INT,
    PRIMARY KEY (student_id, course_id)
);
CREATE TABLE instructors (
    instructor_id INT PRIMARY KEY,
    instructor_name VARCHAR(100)
);
```

### Third Normal Form (3NF)

- Must be in 2NF
- No transitive dependencies (non-key columns depend only on primary key)

```sql
-- ❌ Not 3NF (city depends on zip_code, not on id)
CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    zip_code VARCHAR(10),
    city VARCHAR(50)
);

-- ✅ 3NF
CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    zip_code VARCHAR(10)
);
CREATE TABLE zip_codes (
    zip_code VARCHAR(10) PRIMARY KEY,
    city VARCHAR(50)
);
```

## Relationships

### One-to-One (1:1)

```sql
CREATE TABLE users (
    id INT PRIMARY KEY,
    username VARCHAR(50)
);

CREATE TABLE user_profiles (
    user_id INT PRIMARY KEY,
    bio TEXT,
    avatar VARCHAR(200),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

### One-to-Many (1:N)

```sql
CREATE TABLE users (
    id INT PRIMARY KEY,
    username VARCHAR(50)
);

CREATE TABLE posts (
    id INT PRIMARY KEY,
    user_id INT,
    title VARCHAR(200),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
-- One user has many posts
```

### Many-to-Many (N:M)

```sql
CREATE TABLE students (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE courses (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

-- Junction table
CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    enrolled_date DATE,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);
```

## Constraints

### NOT NULL

```sql
CREATE TABLE users (
    id INT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL
);
```

### DEFAULT

```sql
CREATE TABLE users (
    id INT PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'active'
);
```

### CHECK

```sql
CREATE TABLE users (
    id INT PRIMARY KEY,
    age INT CHECK (age >= 18),
    email VARCHAR(100) CHECK (email LIKE '%@%')
);

-- Named constraint
CREATE TABLE products (
    id INT PRIMARY KEY,
    price DECIMAL(10,2),
    CONSTRAINT check_positive_price CHECK (price > 0)
);
```

## Transactions

Group of SQL statements that execute as a single unit.

```sql
-- Start transaction
BEGIN;  -- or START TRANSACTION;

UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;

-- If all good:
COMMIT;

-- If error:
ROLLBACK;
```

### Isolation Levels

```sql
-- Read Uncommitted: Can read uncommitted changes (dirty reads)
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Read Committed: Only read committed data (default in PostgreSQL)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Repeatable Read: Same read always returns same data (default in MySQL)
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Serializable: Strictest, fully isolated
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

## Stored Procedures

Pre-compiled SQL code stored in database.

**MySQL/PostgreSQL:**
```sql
-- Create procedure
CREATE PROCEDURE GetUserOrders(IN user_id INT)
BEGIN
    SELECT * FROM orders WHERE user_id = user_id;
END;

-- Call procedure
CALL GetUserOrders(123);
```

## Triggers

Automatic actions when certain events occur.

```sql
-- MySQL
CREATE TRIGGER update_modified_time
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    SET NEW.modified_at = NOW();
END;

-- PostgreSQL
CREATE TRIGGER update_modified_time
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();
```

## Views

Virtual table based on query.

```sql
-- Create view
CREATE VIEW active_users AS
SELECT id, username, email
FROM users
WHERE active = 1;

-- Use like a table
SELECT * FROM active_users WHERE username LIKE 'john%';

-- Materialized view (PostgreSQL)
CREATE MATERIALIZED VIEW user_stats AS
SELECT user_id, COUNT(*) as order_count
FROM orders
GROUP BY user_id;

-- Refresh when data changes
REFRESH MATERIALIZED VIEW user_stats;
```

## Schema

Logical grouping of database objects.

```sql
-- PostgreSQL
CREATE SCHEMA sales;
CREATE TABLE sales.orders (id INT, amount DECIMAL);
SELECT * FROM sales.orders;

-- MySQL (schema = database)
CREATE DATABASE sales;
USE sales;
CREATE TABLE orders (id INT, amount DECIMAL);
```

## Cardinality

Number of unique values in a column.

```sql
-- High cardinality (good for indexing)
-- email: 10,000 unique values in 10,000 rows

-- Low cardinality (bad for indexing)
-- gender: 3 unique values in 10,000 rows
```

## Sharding

Splitting data across multiple databases.

```sql
-- Horizontal sharding (by rows)
-- users_shard1: users with id 1-1000
-- users_shard2: users with id 1001-2000

-- Vertical sharding (by columns)
-- users_basic: id, username, email
-- users_profile: id, bio, avatar, preferences
```

## Partitioning

Splitting table into smaller pieces.

```sql
-- Range partitioning (MySQL)
CREATE TABLE orders (
    id INT,
    order_date DATE,
    amount DECIMAL
)
PARTITION BY RANGE (YEAR(order_date)) (
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025)
);

-- List partitioning
PARTITION BY LIST (country) (
    PARTITION p_us VALUES IN ('USA'),
    PARTITION p_eu VALUES IN ('UK', 'FR', 'DE'),
    PARTITION p_asia VALUES IN ('JP', 'CN', 'IN')
);
```

## Connection Pooling

Reusing database connections instead of creating new ones.

```python
# Python example
import psycopg2.pool

# Create pool
pool = psycopg2.pool.SimpleConnectionPool(
    minconn=1,
    maxconn=10,
    host='localhost',
    database='mydb'
)

# Get connection from pool
conn = pool.getconn()

# Use connection
cursor = conn.cursor()
cursor.execute("SELECT * FROM users")

# Return connection to pool
pool.putconn(conn)
```

## CAP Theorem

In distributed systems, you can only have 2 of 3:

- **Consistency**: All nodes see same data
- **Availability**: System always responds
- **Partition Tolerance**: System works despite network failures

```
CA: Traditional RDBMS (MySQL, PostgreSQL)
CP: MongoDB, HBase
AP: Cassandra, DynamoDB
```

## OLTP vs OLAP

**OLTP (Online Transaction Processing)**
- Many small transactions
- INSERT, UPDATE, DELETE heavy
- E.g., e-commerce, banking
- Optimized for writes

**OLAP (Online Analytical Processing)**
- Complex queries, aggregations
- SELECT heavy, few writes
- E.g., data warehousing, analytics
- Optimized for reads

## Deadlock

Two transactions waiting for each other.

```sql
-- Transaction 1:
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
-- waits for lock on id = 2

-- Transaction 2:
BEGIN;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
-- waits for lock on id = 1

-- Deadlock! One transaction will be rolled back
```

**Prevention**: Always acquire locks in same order.
