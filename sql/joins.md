# SQL Joins

## Sample Tables

```sql
-- users table
| id | name    | country |
|----|---------|---------|
| 1  | Alice   | USA     |
| 2  | Bob     | UK      |
| 3  | Charlie | Canada  |
| 4  | Diana   | USA     |

-- orders table
| id | user_id | product | amount |
|----|---------|---------|--------|
| 1  | 1       | Book    | 20     |
| 2  | 1       | Pen     | 5      |
| 3  | 2       | Book    | 20     |
| 4  | 5       | Laptop  | 1000   |
```

## INNER JOIN

Returns only matching rows from both tables.

```sql
SELECT users.name, orders.product, orders.amount
FROM users
INNER JOIN orders ON users.id = orders.user_id;

-- Result:
| name  | product | amount |
|-------|---------|--------|
| Alice | Book    | 20     |
| Alice | Pen     | 5      |
| Bob   | Book    | 20     |
```

## LEFT JOIN (LEFT OUTER JOIN)

Returns all rows from left table, matching rows from right table (NULL if no match).

```sql
SELECT users.name, orders.product, orders.amount
FROM users
LEFT JOIN orders ON users.id = orders.user_id;

-- Result:
| name    | product | amount |
|---------|---------|--------|
| Alice   | Book    | 20     |
| Alice   | Pen     | 5      |
| Bob     | Book    | 20     |
| Charlie | NULL    | NULL   |
| Diana   | NULL    | NULL   |
```

## RIGHT JOIN (RIGHT OUTER JOIN)

Returns all rows from right table, matching rows from left table (NULL if no match).

```sql
SELECT users.name, orders.product, orders.amount
FROM users
RIGHT JOIN orders ON users.id = orders.user_id;

-- Result:
| name  | product | amount |
|-------|---------|--------|
| Alice | Book    | 20     |
| Alice | Pen     | 5      |
| Bob   | Book    | 20     |
| NULL  | Laptop  | 1000   |
```

## FULL OUTER JOIN

Returns all rows from both tables (NULL where no match).

```sql
-- PostgreSQL
SELECT users.name, orders.product, orders.amount
FROM users
FULL OUTER JOIN orders ON users.id = orders.user_id;

-- MySQL (emulated)
SELECT users.name, orders.product, orders.amount
FROM users LEFT JOIN orders ON users.id = orders.user_id
UNION
SELECT users.name, orders.product, orders.amount
FROM users RIGHT JOIN orders ON users.id = orders.user_id;

-- Result:
| name    | product | amount |
|---------|---------|--------|
| Alice   | Book    | 20     |
| Alice   | Pen     | 5      |
| Bob     | Book    | 20     |
| Charlie | NULL    | NULL   |
| Diana   | NULL    | NULL   |
| NULL    | Laptop  | 1000   |
```

## CROSS JOIN

Returns Cartesian product (all combinations).

```sql
SELECT users.name, orders.product
FROM users
CROSS JOIN orders;

-- Result: 4 users × 4 orders = 16 rows
| name    | product |
|---------|---------|
| Alice   | Book    |
| Alice   | Pen     |
| Alice   | Book    |
| Alice   | Laptop  |
| Bob     | Book    |
| ...     | ...     |
```

## SELF JOIN

Join table to itself.

```sql
-- employees table
| id | name  | manager_id |
|----|-------|------------|
| 1  | Alice | NULL       |
| 2  | Bob   | 1          |
| 3  | Carol | 1          |
| 4  | Dave  | 2          |

-- Get employees with their manager names
SELECT
    e.name as employee,
    m.name as manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id;

-- Result:
| employee | manager |
|----------|---------|
| Alice    | NULL    |
| Bob      | Alice   |
| Carol    | Alice   |
| Dave     | Bob     |
```

## Multiple Joins

```sql
-- Three tables
SELECT
    users.name,
    orders.product,
    payments.method,
    payments.amount
FROM users
INNER JOIN orders ON users.id = orders.user_id
INNER JOIN payments ON orders.id = payments.order_id;
```

## Join with WHERE

```sql
-- Filter after join
SELECT users.name, orders.product
FROM users
INNER JOIN orders ON users.id = orders.user_id
WHERE orders.amount > 10;

-- Multiple conditions
SELECT users.name, orders.product
FROM users
INNER JOIN orders ON users.id = orders.user_id
WHERE users.country = 'USA' AND orders.amount > 10;
```

## Join with GROUP BY

```sql
-- Count orders per user
SELECT users.name, COUNT(orders.id) as order_count
FROM users
LEFT JOIN orders ON users.id = orders.user_id
GROUP BY users.id, users.name;

-- Total amount per user
SELECT
    users.name,
    COALESCE(SUM(orders.amount), 0) as total_spent
FROM users
LEFT JOIN orders ON users.id = orders.user_id
GROUP BY users.id, users.name;
```

## Table Aliases

```sql
-- Short aliases
SELECT u.name, o.product, o.amount
FROM users u
INNER JOIN orders o ON u.id = o.user_id;

-- Clearer with AS
SELECT u.name, o.product, o.amount
FROM users AS u
INNER JOIN orders AS o ON u.id = o.user_id;
```

## Join with Subquery

```sql
-- Join with derived table
SELECT u.name, recent_orders.product
FROM users u
INNER JOIN (
    SELECT user_id, product
    FROM orders
    WHERE created_at > NOW() - INTERVAL 7 DAY
) AS recent_orders ON u.id = recent_orders.user_id;
```

## USING Clause

When join columns have the same name:

```sql
-- Instead of:
SELECT * FROM users
INNER JOIN orders ON users.id = orders.id;

-- Use USING:
SELECT * FROM users
INNER JOIN orders USING (id);
```

## NATURAL JOIN

Automatically joins on columns with same names (use with caution):

```sql
SELECT * FROM users
NATURAL JOIN orders;
-- Joins on all columns with matching names
```

## Common Join Patterns

```sql
-- Find users with no orders (LEFT JOIN + NULL check)
SELECT users.name
FROM users
LEFT JOIN orders ON users.id = orders.user_id
WHERE orders.id IS NULL;

-- Find users with at least one order
SELECT DISTINCT users.name
FROM users
INNER JOIN orders ON users.id = orders.user_id;

-- Find users with more than 5 orders
SELECT users.name, COUNT(orders.id) as order_count
FROM users
INNER JOIN orders ON users.id = orders.user_id
GROUP BY users.id, users.name
HAVING COUNT(orders.id) > 5;
```

## Join Performance Tips

```sql
-- Use indexes on join columns
CREATE INDEX idx_user_id ON orders(user_id);

-- Filter before joining (subquery)
SELECT u.name, o.product
FROM users u
INNER JOIN (
    SELECT * FROM orders WHERE amount > 100
) o ON u.id = o.user_id;

-- Avoid SELECT *, specify only needed columns
SELECT u.name, o.product  -- Good
-- SELECT *  -- Bad for performance
FROM users u
INNER JOIN orders o ON u.id = o.user_id;
```

## Visual Guide

```
INNER JOIN:      LEFT JOIN:       RIGHT JOIN:      FULL OUTER JOIN:
    A ∩ B            A ∪ (A ∩ B)      B ∪ (A ∩ B)      A ∪ B
    [===]            [====]           [====]           [=======]

CROSS JOIN: A × B (all combinations)
```

## Common Mistakes

```sql
-- WRONG: Missing join condition (creates CROSS JOIN)
SELECT * FROM users, orders;

-- CORRECT: Always specify join condition
SELECT * FROM users
INNER JOIN orders ON users.id = orders.user_id;

-- WRONG: Ambiguous column names
SELECT id, name FROM users
INNER JOIN orders ON users.id = orders.user_id;  -- Which id?

-- CORRECT: Qualify column names
SELECT users.id, users.name FROM users
INNER JOIN orders ON users.id = orders.user_id;
```
