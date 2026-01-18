## Magic Methods

Special methods that start and end with double underscores (`__`).

### Basic

```python
class MyClass:
    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return f"MyClass({self.value})"

    def __str__(self):
        return f"Value: {self.value}"

obj = MyClass(42)
print(repr(obj))  # MyClass(42)
print(str(obj))   # Value: 42
```

### Comparison

```python
class Number:
    def __init__(self, n):
        self.n = n

    def __eq__(self, other):
        return self.n == other.n

    def __lt__(self, other):
        return self.n < other.n

    def __le__(self, other):
        return self.n <= other.n

# __gt__, __ge__, __ne__ work similarly
```

### Arithmetic

```python
class Vector:
    def __init__(self, x, y):
        self.x, self.y = x, y

    def __add__(self, other):
        return Vector(self.x + other.x, self.y + other.y)

    def __mul__(self, scalar):
        return Vector(self.x * scalar, self.y * scalar)

# __sub__, __truediv__, __floordiv__, __mod__, __pow__
```

### Container

```python
class MyList:
    def __init__(self, items):
        self.items = items

    def __len__(self):
        return len(self.items)

    def __getitem__(self, index):
        return self.items[index]

    def __setitem__(self, index, value):
        self.items[index] = value

    def __contains__(self, item):
        return item in self.items

lst = MyList([1, 2, 3])
len(lst)      # 3
lst[0]        # 1
2 in lst      # True
```

### Context Manager

```python
class File:
    def __init__(self, filename):
        self.filename = filename

    def __enter__(self):
        self.file = open(self.filename, 'r')
        return self.file

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.file.close()

with File("data.txt") as f:
    content = f.read()
```

### Callable

```python
class Multiplier:
    def __init__(self, factor):
        self.factor = factor

    def __call__(self, x):
        return x * self.factor

double = Multiplier(2)
double(5)  # 10
```

### Common Magic Methods

```python
__init__        # Constructor
__repr__        # Official string representation
__str__         # Informal string representation
__len__         # len(obj)
__getitem__     # obj[key]
__setitem__     # obj[key] = value
__contains__    # key in obj
__iter__        # for item in obj
__next__        # next(iterator)
__call__        # obj()
__enter__       # with obj
__exit__        # with obj (cleanup)
__eq__          # ==
__lt__          # <
__add__         # +
__mul__         # *
```
