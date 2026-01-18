## Truthy and Falsy Values

In Python, every value has a truth value used in boolean contexts.

### Falsy Values

These evaluate to `False`:

```python
False          # Boolean False
None           # None type
0              # Zero (int)
0.0            # Zero (float)
0j             # Zero (complex)
''             # Empty string
""             # Empty string
[]             # Empty list
()             # Empty tuple
{}             # Empty dict
set()          # Empty set
range(0)       # Empty range
```

### Truthy Values

Everything else is truthy:

```python
True           # Boolean True
1, 42, -5      # Non-zero numbers
"text"         # Non-empty strings
[1, 2]         # Non-empty lists
{'a': 1}       # Non-empty dicts
```

### Boolean Context

```python
# if statements
if value:
    print("Truthy")

# while loops
while items:
    item = items.pop()

# not operator
if not value:
    print("Falsy")

# bool()
bool(0)        # False
bool(42)       # True
bool([])       # False
bool([1])      # True
```

### Comparisons

```python
# and - returns first falsy or last value
True and True          # True
True and False         # False
1 and 2                # 2
0 and 2                # 0
'' and 'hello'         # ''

# or - returns first truthy or last value
True or False          # True
0 or 1                 # 1
'' or 'hello'          # 'hello'
[] or {}               # {}
```

### Practical Examples

```python
# Default values
name = user_input or "Guest"
count = get_count() or 0

# Check if non-empty
if items:
    process(items)

# Loop until empty
while stack:
    item = stack.pop()
```

### Custom Truthiness

```python
class MyClass:
    def __init__(self, value):
        self.value = value

    def __bool__(self):
        return self.value > 0

obj = MyClass(5)
bool(obj)              # True

obj = MyClass(0)
bool(obj)              # False
```
