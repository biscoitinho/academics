## Magic Methods (Dunder Methods)

Special methods with double underscores that define behavior for built-in operations.

### String representation

```python
class Book:
    def __init__(self, title, author):
        self.title = title
        self.author = author
    
    def __str__(self):
        """For print() and str() - user-friendly."""
        return f"{self.title} by {self.author}"
    
    def __repr__(self):
        """For repr() and debugging - unambiguous."""
        return f"Book('{self.title}', '{self.author}')"

book = Book("1984", "George Orwell")
print(book)        # Uses __str__: 1984 by George Orwell
print(repr(book))  # Uses __repr__: Book('1984', 'George Orwell')
```

### Comparison operators

```python
class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age
    
    def __eq__(self, other):
        """Equal =="""
        return self.age == other.age
    
    def __lt__(self, other):
        """Less than <"""
        return self.age < other.age
    
    def __le__(self, other):
        """Less than or equal <="""
        return self.age <= other.age
    
    def __gt__(self, other):
        """Greater than >"""
        return self.age > other.age

alice = Person("Alice", 30)
bob = Person("Bob", 25)

print(alice > bob)   # True
print(alice == bob)  # False
```

### Arithmetic operators

```python
class Vector:
    def __init__(self, x, y):
        self.x = x
        self.y = y
    
    def __add__(self, other):
        """Addition +"""
        return Vector(self.x + other.x, self.y + other.y)
    
    def __sub__(self, other):
        """Subtraction -"""
        return Vector(self.x - other.x, self.y - other.y)
    
    def __mul__(self, scalar):
        """Multiplication *"""
        return Vector(self.x * scalar, self.y * scalar)
    
    def __str__(self):
        return f"Vector({self.x}, {self.y})"

v1 = Vector(1, 2)
v2 = Vector(3, 4)
print(v1 + v2)  # Vector(4, 6)
print(v1 * 3)   # Vector(3, 6)
```

### Container methods

```python
class Playlist:
    def __init__(self):
        self.songs = []
    
    def __len__(self):
        """len() function"""
        return len(self.songs)
    
    def __getitem__(self, index):
        """Indexing playlist[0]"""
        return self.songs[index]
    
    def __setitem__(self, index, value):
        """Assignment playlist[0] = 'song'"""
        self.songs[index] = value
    
    def __contains__(self, item):
        """'in' operator"""
        return item in self.songs
    
    def __iter__(self):
        """Make iterable"""
        return iter(self.songs)

playlist = Playlist()
playlist.songs = ["Song1", "Song2", "Song3"]

print(len(playlist))           # 3
print(playlist[0])             # Song1
print("Song2" in playlist)     # True

for song in playlist:
    print(song)
```

### Callable objects

```python
class Multiplier:
    def __init__(self, factor):
        self.factor = factor
    
    def __call__(self, x):
        """Makes instance callable like a function."""
        return x * self.factor

times_three = Multiplier(3)
print(times_three(5))  # 15
print(times_three(10)) # 30
```

### Context manager

```python
class DatabaseConnection:
    def __enter__(self):
        """Called when entering 'with' block."""
        print("Opening connection")
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        """Called when exiting 'with' block."""
        print("Closing connection")
        return False

with DatabaseConnection() as db:
    print("Using database")
```

### Common magic methods

**Initialization:**
- `__init__`: Constructor
- `__new__`: Create instance (before __init__)
- `__del__`: Destructor

**Representation:**
- `__str__`: str() and print()
- `__repr__`: repr() and interactive console

**Comparison:**
- `__eq__`: ==
- `__ne__`: !=
- `__lt__`: <
- `__le__`: <=
- `__gt__`: >
- `__ge__`: >=

**Arithmetic:**
- `__add__`: +
- `__sub__`: -
- `__mul__`: *
- `__truediv__`: /
- `__floordiv__`: //
- `__mod__`: %
- `__pow__`: **

**Container:**
- `__len__`: len()
- `__getitem__`: obj[key]
- `__setitem__`: obj[key] = value
- `__delitem__`: del obj[key]
- `__contains__`: in operator
- `__iter__`: for loops

**Other:**
- `__call__`: obj()
- `__bool__`: bool()
- `__hash__`: hash()
