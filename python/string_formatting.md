## String Formatting

Different ways to format strings in Python.

### f-strings (Python 3.6+) - Recommended

```python
name = "Alice"
age = 30

# Basic f-string
message = f"Hello, {name}!"
print(message)  # Hello, Alice!

# With expressions
print(f"{name} is {age} years old")
print(f"Next year: {age + 1}")

# With formatting
pi = 3.14159
print(f"Pi: {pi:.2f}")  # Pi: 3.14

# Alignment
print(f"{name:>10}")   # Right align (     Alice)
print(f"{name:<10}")   # Left align  (Alice     )
print(f"{name:^10}")   # Center      (  Alice   )
```

### .format() method

```python
name = "Bob"
age = 25

# Positional arguments
print("Hello, {}!".format(name))
print("{} is {} years old".format(name, age))

# Named arguments
print("{name} is {age} years old".format(name=name, age=age))

# Index-based
print("{0} is {1} years old. {0} likes Python.".format(name, age))

# With formatting
pi = 3.14159
print("Pi: {:.2f}".format(pi))
```

### % formatting (old style)

```python
name = "Charlie"
age = 35

print("Hello, %s!" % name)
print("%s is %d years old" % (name, age))

# With formatting
pi = 3.14159
print("Pi: %.2f" % pi)
```

### Advanced f-string features

**Debugging (Python 3.8+):**
```python
value = 42
print(f"{value=}")  # value=42
```

**Multiline:**
```python
name = "Alice"
age = 30
message = (
    f"Name: {name}\n"
    f"Age: {age}\n"
    f"Adult: {age >= 18}"
)
print(message)
```

**Calling functions:**
```python
def square(n):
    return n ** 2

print(f"5 squared is {square(5)}")
```

**Dictionary access:**
```python
person = {"name": "Alice", "age": 30}
print(f"{person['name']} is {person['age']} years old")
```

### Number formatting

```python
number = 1234567.89

# Thousands separator
print(f"{number:,}")        # 1,234,567.89

# Decimal places
print(f"{number:.2f}")      # 1234567.89

# Scientific notation
print(f"{number:e}")        # 1.234568e+06

# Percentage
rate = 0.856
print(f"{rate:.1%}")        # 85.6%

# Binary, Octal, Hex
num = 42
print(f"Binary: {num:b}")   # 101010
print(f"Octal: {num:o}")    # 52
print(f"Hex: {num:x}")      # 2a
```

### When to use which?

- **f-strings**: Modern, fast, readable - use this!
- **.format()**: Backward compatibility (Python < 3.6)
- **% formatting**: Legacy code only
