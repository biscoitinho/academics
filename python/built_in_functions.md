## Built-in Functions

### Iterables

```python
len([1, 2, 3])              # 3
sum([1, 2, 3])              # 6
min([1, 2, 3])              # 1
max([1, 2, 3])              # 3
sorted([3, 1, 2])           # [1, 2, 3]
reversed([1, 2, 3])         # iterator
```

### map/filter/zip

```python
# map - apply function to each item
list(map(lambda x: x**2, [1, 2, 3]))  # [1, 4, 9]

# filter - keep items where function returns True
list(filter(lambda x: x % 2 == 0, [1, 2, 3, 4]))  # [2, 4]

# zip - combine iterables
list(zip([1, 2], ['a', 'b']))  # [(1, 'a'), (2, 'b')]
```

### enumerate/range

```python
# enumerate - index and value
for i, val in enumerate(['a', 'b', 'c']):
    print(i, val)  # 0 a, 1 b, 2 c

# range
range(5)           # 0, 1, 2, 3, 4
range(1, 5)        # 1, 2, 3, 4
range(0, 10, 2)    # 0, 2, 4, 6, 8
```

### any/all

```python
any([False, True, False])   # True (at least one True)
all([True, True, False])    # False (not all True)
```

### Type Functions

```python
type(42)                    # <class 'int'>
isinstance(42, int)         # True
callable(print)             # True
```

### String Functions

```python
chr(65)                     # 'A' (int to char)
ord('A')                    # 65 (char to int)
ascii('é')                  # "'\xe9'"
```

### Math Functions

```python
abs(-5)                     # 5
round(3.7)                  # 4
round(3.14159, 2)           # 3.14
pow(2, 3)                   # 8 (same as 2**3)
divmod(10, 3)               # (3, 1) - quotient and remainder
```

### Other Useful Functions

```python
# Input/Output
input("Enter name: ")
print("Hello", "World", sep=", ")

# Object functions
dir(obj)                    # List object attributes
vars(obj)                   # Object's __dict__
id(obj)                     # Object's memory address
hash(obj)                   # Object's hash value

# Conversion
bin(10)                     # '0b1010'
hex(255)                    # '0xff'
oct(8)                      # '0o10'

# Iteration
iter([1, 2, 3])            # Iterator object
next(iterator)             # Next value from iterator

# Advanced
eval("2 + 2")              # 4 (evaluate string as code)
exec("x = 5")              # Execute code
compile(source, '', 'exec')  # Compile code
```
