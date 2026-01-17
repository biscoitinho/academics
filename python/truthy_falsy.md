## Truthy and Falsy Values

In Python, every value can be evaluated as True or False in a boolean context.

### Falsy values

Values that evaluate to False:

```python
# None
if not None:
    print("None is falsy")

# False
if not False:
    print("False is falsy")

# Zero of any numeric type
if not 0:
    print("0 is falsy")
if not 0.0:
    print("0.0 is falsy")
if not 0j:
    print("0j (complex) is falsy")

# Empty sequences and collections
if not "":
    print("Empty string is falsy")
if not []:
    print("Empty list is falsy")
if not ():
    print("Empty tuple is falsy")
if not {}:
    print("Empty dict is falsy")
if not set():
    print("Empty set is falsy")
```

### Truthy values

Everything else is truthy:

```python
# Non-zero numbers
if 1:
    print("1 is truthy")
if -5:
    print("-5 is truthy")
if 3.14:
    print("3.14 is truthy")

# Non-empty sequences
if "hello":
    print("Non-empty string is truthy")
if [1, 2, 3]:
    print("Non-empty list is truthy")
if {'a': 1}:
    print("Non-empty dict is truthy")

# Objects
class MyClass:
    pass

if MyClass():
    print("Objects are truthy by default")
```

### Practical examples

**Checking if list is empty:**
```python
my_list = []

# Pythonic way
if not my_list:
    print("List is empty")

# Not pythonic
if len(my_list) == 0:
    print("List is empty")
```

**Default values:**
```python
def greet(name):
    # If name is empty string or None, use default
    name = name or "Guest"
    print(f"Hello, {name}!")

greet("")      # Hello, Guest!
greet(None)    # Hello, Guest!
greet("Alice") # Hello, Alice!
```

**Chaining with or:**
```python
# Returns first truthy value or last value
result = 0 or "" or [] or "default"
print(result)  # "default"

result = 0 or "" or [1, 2] or "default"
print(result)  # [1, 2]
```

**Chaining with and:**
```python
# Returns first falsy value or last value
result = 5 and "hello" and [1, 2]
print(result)  # [1, 2]

result = 5 and "" and [1, 2]
print(result)  # ""
```

### Custom truthy/falsy behavior

```python
class BankAccount:
    def __init__(self, balance):
        self.balance = balance
    
    def __bool__(self):
        """Account is truthy if balance > 0."""
        return self.balance > 0

account1 = BankAccount(100)
account2 = BankAccount(0)

if account1:
    print("Account 1 has money")  # This prints

if not account2:
    print("Account 2 is empty")   # This prints
```

### Common patterns

**Check if variable exists and has value:**
```python
data = get_data()  # might return None or empty

if data:
    process(data)
else:
    print("No data to process")
```

**Get first truthy value:**
```python
value = user_input or default_value or "fallback"
```

**Validate all conditions:**
```python
name = "Alice"
age = 25

if name and age and age >= 18:
    print("Valid adult user")
```

### Summary

**Falsy:** `None`, `False`, `0`, `0.0`, `""`, `[]`, `()`, `{}`, `set()`

**Truthy:** Everything else

Use this to write cleaner, more Pythonic code!
