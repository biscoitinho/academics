## Exception Handling

Handle errors gracefully without crashing your program.

### Basic try/except

```python
try:
    result = 10 / 0
except ZeroDivisionError:
    print("Cannot divide by zero!")
```

### Multiple exceptions

```python
try:
    number = int("abc")
except ValueError:
    print("Invalid number format")
except TypeError:
    print("Wrong type")
```

### Catch multiple in one block

```python
try:
    # some code
    pass
except (ValueError, TypeError) as e:
    print(f"Error: {e}")
```

### try/except/else/finally

```python
try:
    file = open("data.txt", "r")
    data = file.read()
except FileNotFoundError:
    print("File not found!")
else:
    # Runs only if NO exception occurred
    print("File read successfully")
finally:
    # Always runs, even if exception occurred
    print("Cleanup complete")
```

### Catching all exceptions

```python
try:
    # risky code
    pass
except Exception as e:
    print(f"Something went wrong: {e}")
```

### Raising exceptions

```python
def check_age(age):
    if age < 0:
        raise ValueError("Age cannot be negative")
    if age < 18:
        raise Exception("Must be 18 or older")
    return True

try:
    check_age(-5)
except ValueError as e:
    print(e)
```

### Custom exceptions

```python
class InsufficientFundsError(Exception):
    """Raised when account has insufficient funds."""
    pass

class BankAccount:
    def __init__(self, balance):
        self.balance = balance
    
    def withdraw(self, amount):
        if amount > self.balance:
            raise InsufficientFundsError(
                f"Insufficient funds. Balance: {self.balance}"
            )
        self.balance -= amount

account = BankAccount(100)
try:
    account.withdraw(150)
except InsufficientFundsError as e:
    print(e)
```

### Re-raising exceptions

```python
try:
    # some code
    pass
except ValueError as e:
    print("Logging error...")
    raise  # Re-raises the same exception
```
