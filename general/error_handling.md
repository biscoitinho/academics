# Error Handling and Exceptions

## Python Exceptions

### Try-Except

```python
try:
    result = 10 / 0
except ZeroDivisionError:
    print("Cannot divide by zero!")

# Multiple exceptions
try:
    file = open('file.txt')
    content = file.read()
except FileNotFoundError:
    print("File not found")
except PermissionError:
    print("Permission denied")

# Catch multiple in one block
try:
    risky_operation()
except (ValueError, TypeError) as e:
    print(f"Error: {e}")
```

### Catch All

```python
try:
    risky_operation()
except Exception as e:
    print(f"An error occurred: {e}")

# Get exception details
import sys
try:
    risky_operation()
except Exception:
    exc_type, exc_value, exc_traceback = sys.exc_info()
    print(f"Type: {exc_type}")
    print(f"Value: {exc_value}")
```

### Finally

```python
try:
    file = open('file.txt')
    content = file.read()
except FileNotFoundError:
    print("File not found")
finally:
    # Always executes
    if 'file' in locals():
        file.close()
```

### Else

```python
try:
    result = int(input("Enter number: "))
except ValueError:
    print("Invalid number")
else:
    # Runs if no exception
    print(f"You entered: {result}")
finally:
    print("Done")
```

## Ruby Exceptions

### Begin-Rescue

```ruby
begin
  result = 10 / 0
rescue ZeroDivisionError
  puts "Cannot divide by zero!"
end

# Multiple exceptions
begin
  File.open('file.txt')
rescue Errno::ENOENT
  puts "File not found"
rescue Errno::EACCES
  puts "Permission denied"
end

# Catch all
begin
  risky_operation
rescue => e
  puts "Error: #{e.message}"
end
```

### Ensure

```ruby
begin
  file = File.open('file.txt')
  content = file.read
rescue
  puts "Error reading file"
ensure
  # Always executes
  file.close if file
end
```

### Else

```ruby
begin
  result = Integer(input)
rescue ArgumentError
  puts "Invalid number"
else
  # Runs if no exception
  puts "You entered: #{result}"
ensure
  puts "Done"
end
```

## Raising Exceptions

### Python

```python
# Raise exception
raise ValueError("Invalid value")

# Re-raise
try:
    risky_operation()
except ValueError:
    print("Logging error")
    raise  # Re-raise same exception

# Raise with cause
try:
    operation1()
except ValueError as e:
    raise RuntimeError("Operation failed") from e
```

### Ruby

```ruby
# Raise exception
raise ArgumentError, "Invalid argument"

# Re-raise
begin
  risky_operation
rescue ArgumentError
  puts "Logging error"
  raise  # Re-raise
end

# Custom message
begin
  risky_operation
rescue ArgumentError => e
  raise ArgumentError, "Custom message: #{e.message}"
end
```

## Custom Exceptions

### Python

```python
class InsufficientFundsError(Exception):
    pass

class BankAccount:
    def __init__(self, balance):
        self.balance = balance

    def withdraw(self, amount):
        if amount > self.balance:
            raise InsufficientFundsError(
                f"Insufficient funds: have {self.balance}, need {amount}"
            )
        self.balance -= amount

# Usage
account = BankAccount(100)
try:
    account.withdraw(150)
except InsufficientFundsError as e:
    print(e)
```

### Ruby

```ruby
class InsufficientFundsError < StandardError
end

class BankAccount
  def initialize(balance)
    @balance = balance
  end

  def withdraw(amount)
    if amount > @balance
      raise InsufficientFundsError,
        "Insufficient funds: have #{@balance}, need #{amount}"
    end
    @balance -= amount
  end
end

# Usage
account = BankAccount.new(100)
begin
  account.withdraw(150)
rescue InsufficientFundsError => e
  puts e.message
end
```

## Context Managers (Python)

```python
# Automatic cleanup
with open('file.txt') as f:
    content = f.read()
# File automatically closed

# Multiple context managers
with open('input.txt') as infile, open('output.txt', 'w') as outfile:
    content = infile.read()
    outfile.write(content)

# Custom context manager
class DatabaseConnection:
    def __enter__(self):
        self.conn = connect_to_database()
        return self.conn

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.conn.close()
        return False  # Don't suppress exceptions

with DatabaseConnection() as conn:
    conn.execute('SELECT 1')
```

## Error Codes vs Exceptions

```python
# ❌ Error codes (C-style)
def divide(a, b):
    if b == 0:
        return None, "Division by zero"
    return a / b, None

result, error = divide(10, 0)
if error:
    print(error)

# ✅ Exceptions (Python-style)
def divide(a, b):
    if b == 0:
        raise ZeroDivisionError("Division by zero")
    return a / b

try:
    result = divide(10, 0)
except ZeroDivisionError as e:
    print(e)
```

## Assertions

```python
# Check assumptions (development/testing)
def calculate_average(numbers):
    assert len(numbers) > 0, "List cannot be empty"
    return sum(numbers) / len(numbers)

# Disable in production: python -O script.py
```

## Logging Errors

```python
import logging

logger = logging.getLogger(__name__)

try:
    risky_operation()
except Exception as e:
    logger.error("Operation failed", exc_info=True)
    # exc_info=True includes traceback
```

## Retry Logic

```python
import time

def retry(max_attempts=3, delay=1):
    def decorator(func):
        def wrapper(*args, **kwargs):
            for attempt in range(max_attempts):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    if attempt == max_attempts - 1:
                        raise
                    print(f"Attempt {attempt + 1} failed: {e}")
                    time.sleep(delay)
        return wrapper
    return decorator

@retry(max_attempts=3, delay=2)
def unreliable_api_call():
    # May fail sometimes
    return requests.get('https://api.example.com/data')
```

## Exception Hierarchy

```
Python:
BaseException
  ├── SystemExit
  ├── KeyboardInterrupt
  └── Exception
        ├── StopIteration
        ├── ArithmeticError
        │     ├── ZeroDivisionError
        │     └── OverflowError
        ├── AssertionError
        ├── AttributeError
        ├── EOFError
        ├── ImportError
        ├── LookupError
        │     ├── IndexError
        │     └── KeyError
        ├── NameError
        ├── OSError
        │     ├── FileNotFoundError
        │     └── PermissionError
        ├── RuntimeError
        ├── TypeError
        └── ValueError
```

## Best Practices

```python
# 1. Catch specific exceptions
# ❌ Bad
try:
    operation()
except:
    pass

# ✅ Good
try:
    operation()
except ValueError:
    pass

# 2. Don't swallow exceptions
# ❌ Bad
try:
    operation()
except Exception:
    pass  # Error hidden!

# ✅ Good
try:
    operation()
except Exception as e:
    logger.error(f"Operation failed: {e}")
    raise

# 3. Use finally for cleanup
try:
    file = open('file.txt')
    process(file)
finally:
    file.close()

# 4. Fail fast
def process_user(user_id):
    if not user_id:
        raise ValueError("user_id required")
    # Continue processing

# 5. Provide context
raise ValueError(f"Invalid age: {age}. Must be between 0 and 120")

# 6. Use custom exceptions for domain errors
class InvalidOrderError(Exception):
    pass

# 7. Log exceptions
import logging
try:
    operation()
except Exception:
    logging.exception("Operation failed")  # Includes traceback
```

## Common Patterns

### Resource Management

```python
# File
with open('file.txt') as f:
    content = f.read()

# Database
with get_db_connection() as conn:
    conn.execute('SELECT 1')

# Lock
with threading.Lock():
    # Critical section
    pass
```

### Error Recovery

```python
def robust_api_call():
    try:
        return api.get_data()
    except requests.ConnectionError:
        # Retry once
        time.sleep(1)
        return api.get_data()
    except requests.Timeout:
        # Return cached data
        return get_cached_data()
    except Exception as e:
        # Log and re-raise
        logger.error(f"API call failed: {e}")
        raise
```

### Validation

```python
def create_user(name, email, age):
    if not name:
        raise ValueError("Name is required")
    if not email or '@' not in email:
        raise ValueError("Valid email is required")
    if age < 0 or age > 120:
        raise ValueError("Age must be between 0 and 120")

    return User(name, email, age)
```

## Testing Exceptions

```python
import pytest

def test_divide_by_zero():
    with pytest.raises(ZeroDivisionError):
        divide(10, 0)

    with pytest.raises(ZeroDivisionError, match="division"):
        divide(10, 0)

# unittest
import unittest

class TestDivide(unittest.TestCase):
    def test_divide_by_zero(self):
        with self.assertRaises(ZeroDivisionError):
            divide(10, 0)
```
