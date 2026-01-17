## is vs ==

Two different ways to compare objects in Python.

### == (Equality operator)

Compares **values** of objects.

```python
a = [1, 2, 3]
b = [1, 2, 3]

print(a == b)  # True - same values
```

### is (Identity operator)

Compares **identity** (memory location) of objects.

```python
a = [1, 2, 3]
b = [1, 2, 3]

print(a is b)  # False - different objects in memory
```

### Example showing the difference

```python
a = [1, 2, 3]
b = [1, 2, 3]
c = a

print(a == b)  # True - same values
print(a is b)  # False - different objects

print(a == c)  # True - same values
print(a is c)  # True - SAME object (c points to a)
```

### When to use is

**With None:**
```python
value = None

# Correct - use 'is' with None
if value is None:
    print("Value is None")

# Wrong - don't use ==
if value == None:
    print("This works but not recommended")
```

**With True/False:**
```python
flag = True

# Correct
if flag is True:
    print("Flag is True")

# Even better - just use the boolean
if flag:
    print("Flag is True")
```

### Small integer and string caching

Python caches small integers (-5 to 256) and short strings:

```python
# Small integers - cached
a = 5
b = 5
print(a is b)  # True - same object

# Large integers - not cached
a = 1000
b = 1000
print(a is b)  # False - different objects
print(a == b)  # True - same value

# Short strings - cached
a = "hello"
b = "hello"
print(a is b)  # True - same object

# Strings with spaces - may not be cached
a = "hello world"
b = "hello world"
print(a is b)  # False (usually) - different objects
print(a == b)  # True - same value
```

### Checking object identity

```python
a = [1, 2, 3]
b = a

print(id(a))  # Memory address of a
print(id(b))  # Same memory address
print(a is b) # True
```

### Summary

- Use `==` to compare **values**
- Use `is` to compare **identity** (same object in memory)
- Always use `is` with `None`, `True`, `False`
- For everything else, use `==` unless you specifically need identity check
