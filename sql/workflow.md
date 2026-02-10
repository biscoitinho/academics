# SQL Workflow

How a generic development workflow looks when working with SQL and databases.

## Database Setup

### 1. Choose a Database

- **PostgreSQL** - Best general-purpose choice. Full-featured, standards-compliant, excellent for production.
- **SQLite** - File-based, zero configuration. Good for development, prototyping, embedded use.
- **MySQL/MariaDB** - Widely used, especially in web hosting. Good ecosystem.

### 2. Set Up Local Development

```bash
# PostgreSQL
sudo apt install postgresql
sudo -u postgres createuser --interactive
createdb myproject_dev

# SQLite (no setup needed)
sqlite3 myproject.db

# MySQL
sudo apt install mysql-server
mysql -u root -p
# CREATE DATABASE myproject_dev;
```

### 3. Connect

```bash
# PostgreSQL
psql -d myproject_dev

# SQLite
sqlite3 myproject.db

# MySQL
mysql -u username -p myproject_dev
```

## Schema Development Cycle

### Design Tables First

Before writing SQL, design the schema:

1. Identify entities (users, orders, products)
2. Define relationships (one-to-many, many-to-many)
3. Choose appropriate data types
4. Identify indexes needed (foreign keys, frequently queried columns)
5. Add constraints (NOT NULL, UNIQUE, CHECK, FOREIGN KEY)

### Write Migrations

Always change the schema through migration files, never by hand.

```sql
-- migrations/001_create_users.sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_users_email ON users(email);
```

```sql
-- migrations/002_create_orders.sql
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    total_cents INTEGER NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
```

### Apply Migrations

```bash
# With dbmate
dbmate up

# With framework tools
rails db:migrate              # Rails
python manage.py migrate      # Django
alembic upgrade head          # Alembic
```

### Typical Schema Cycle
```
design schema -> write migration -> apply migration -> verify with \d or DESCRIBE -> commit
```

## Query Development Cycle

### 1. Start in the CLI Client

Develop queries interactively:

```bash
psql -d myproject_dev
```

### 2. Write and Test Incrementally

Build complex queries step by step:

```sql
-- Step 1: Get the base data
SELECT * FROM users LIMIT 10;

-- Step 2: Add joins
SELECT u.name, o.total_cents
FROM users u
JOIN orders o ON o.user_id = u.id
LIMIT 10;

-- Step 3: Add aggregation
SELECT u.name, COUNT(o.id) AS order_count, SUM(o.total_cents) AS total_spent
FROM users u
JOIN orders o ON o.user_id = u.id
GROUP BY u.id, u.name
ORDER BY total_spent DESC
LIMIT 10;
```

### 3. Check the Query Plan

```sql
EXPLAIN ANALYZE
SELECT u.name, COUNT(o.id) AS order_count
FROM users u
JOIN orders o ON o.user_id = u.id
GROUP BY u.id, u.name;
```

Look for:
- Seq Scan on large tables (might need an index)
- Nested Loop with high row counts (might need a different join strategy)
- High actual vs estimated rows (statistics may be stale, run `ANALYZE`)

### 4. Move to Application Code

Once the query works, move it into application code using parameterized queries.

## Best Practices

### Schema Design
- Use `SERIAL` or `BIGSERIAL` for primary keys (or UUIDs if needed for distribution)
- Add `NOT NULL` constraints wherever possible - nullable columns are usually a design smell
- Add foreign key constraints - they enforce data integrity at the database level
- Add `created_at` and `updated_at` timestamps to most tables
- Use appropriate data types: `INTEGER` for counts, `NUMERIC` for money, `TIMESTAMPTZ` for times
- Normalize to third normal form (3NF) as a starting point, denormalize only when performance requires it

### Indexing
- Always index foreign keys
- Index columns used in `WHERE`, `JOIN`, and `ORDER BY` clauses
- Use composite indexes for queries that filter on multiple columns (put most selective column first)
- Don't over-index - each index slows down writes
- Use partial indexes when you only query a subset of rows:
  ```sql
  CREATE INDEX idx_orders_pending ON orders(created_at) WHERE status = 'pending';
  ```

### Query Writing
- Use explicit `JOIN` syntax, not comma-separated `FROM` with `WHERE`
- Always use parameterized queries in application code (prevents SQL injection)
- Use `EXISTS` instead of `IN` for subqueries on large datasets
- Use `LIMIT` during development to avoid accidentally dumping huge tables
- Use meaningful aliases: `u` for users, `o` for orders (not `t1`, `t2`)

### Transactions
- Wrap related changes in transactions
- Keep transactions short (don't hold locks while doing slow operations)
- Use appropriate isolation levels for your use case
- Handle deadlocks in application code (retry the transaction)

### Migrations
- Make every migration reversible (include both `up` and `down`)
- Never modify a migration that has been applied to shared environments
- Test migrations on a copy of production data before deploying
- Add indexes concurrently on large tables to avoid locking:
  ```sql
  CREATE INDEX CONCURRENTLY idx_users_email ON users(email);
  ```

## What to Avoid

### Schema Anti-Patterns
- **No primary key** - Every table needs one
- **VARCHAR(255) for everything** - Use appropriate types and sizes
- **Entity-Attribute-Value (EAV)** - Storing everything as key-value pairs destroys query ability
- **Polymorphic associations without constraints** - A `type` + `id` column pair cannot have foreign keys
- **Storing comma-separated values** - Use a join table or array type instead
- **No foreign keys** - Orphaned rows will accumulate

### Query Anti-Patterns
- **SELECT *** in application code - Always specify columns you need
- **N+1 queries** - Query in a loop instead of using a JOIN or IN clause
- **String concatenation for queries** - Always use parameterized queries
- **LIKE '%value%'** on large tables without full-text search index
- **ORDER BY RAND()** - Extremely slow on large tables
- **Functions on indexed columns in WHERE** - `WHERE YEAR(created_at) = 2024` can't use an index; use `WHERE created_at >= '2024-01-01' AND created_at < '2025-01-01'`

### Operational Anti-Patterns
- **No backups** - Set up automated backups and test restores
- **Modifying schema by hand** - Always use migrations
- **Running untested queries on production** - Test on staging first
- **Ignoring slow query logs** - Monitor and optimize regularly
- **No connection pooling** - Use PgBouncer (PostgreSQL) or equivalent

## Debugging Workflow

### Slow Queries
1. Enable slow query logging
2. Identify the slow query
3. Run `EXPLAIN ANALYZE` on it
4. Look for sequential scans on large tables
5. Add missing indexes or rewrite the query
6. Verify improvement with `EXPLAIN ANALYZE` again

### Data Issues
1. Check constraints: `\d tablename` to see what constraints exist
2. Look for orphaned records: `SELECT * FROM orders WHERE user_id NOT IN (SELECT id FROM users)`
3. Check for duplicates: `SELECT email, COUNT(*) FROM users GROUP BY email HAVING COUNT(*) > 1`
4. Inspect recent changes: `SELECT * FROM users ORDER BY updated_at DESC LIMIT 20`

### Connection Issues
```sql
-- PostgreSQL: See active connections
SELECT * FROM pg_stat_activity;

-- Kill a stuck query
SELECT pg_terminate_backend(pid);
```

## Environment Management

### Separate Databases per Environment

```
myproject_dev       # Local development
myproject_test      # Automated tests (wiped between runs)
myproject_staging   # Pre-production
myproject_prod      # Production
```

### Seed Data

```sql
-- seeds.sql
INSERT INTO users (name, email) VALUES
    ('Alice', 'alice@example.com'),
    ('Bob', 'bob@example.com');
```

Keep seed data idempotent (safe to run multiple times).
