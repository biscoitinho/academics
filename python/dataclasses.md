## Dataclasses

Auto-generate special methods (`__init__`, `__repr__`, etc.).

```python
from dataclasses import dataclass

@dataclass
class Point:
    x: int
    y: int

p = Point(1, 2)
print(p)  # Point(x=1, y=2)
```

### Default Values

```python
@dataclass
class User:
    name: str
    age: int = 0
    active: bool = True

user = User("Alice")
```

### Field Options

```python
from dataclasses import dataclass, field

@dataclass
class Item:
    name: str
    price: float = field(default=0.0)
    tags: list = field(default_factory=list)
    _internal: str = field(default="", repr=False)
```

### Immutable

```python
@dataclass(frozen=True)
class Point:
    x: int
    y: int

p = Point(1, 2)
# p.x = 3  # Error! Frozen
```

### Ordering

```python
@dataclass(order=True)
class Person:
    name: str
    age: int

p1 = Person("Alice", 30)
p2 = Person("Bob", 25)
print(p2 < p1)  # True (compared by fields)
```

### Custom Methods

```python
@dataclass
class Rectangle:
    width: float
    height: float

    def area(self):
        return self.width * self.height
```

### Post-init

```python
@dataclass
class Circle:
    radius: float
    area: float = field(init=False)

    def __post_init__(self):
        self.area = 3.14 * self.radius ** 2
```

### Quick Reference

```python
from dataclasses import dataclass, field

@dataclass(frozen=True, order=True)
class Item:
    name: str
    price: float = 0.0
    tags: list = field(default_factory=list)

item = Item("Book", 9.99, ["fiction"])
```
