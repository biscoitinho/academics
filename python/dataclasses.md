## Dataclasses

Simplified way to create classes for storing data. Automatically generates `__init__`, `__repr__`, `__eq__` and more.

### Basic dataclass

```python
from dataclasses import dataclass

@dataclass
class Person:
    name: str
    age: int
    city: str

# Automatically has __init__
person = Person("Alice", 30, "NYC")

# Automatically has __repr__
print(person)  # Person(name='Alice', age=30, city='NYC')

# Automatically has __eq__
person2 = Person("Alice", 30, "NYC")
print(person == person2)  # True
```

### Without dataclass (manual way)

```python
class Person:
    def __init__(self, name, age, city):
        self.name = name
        self.age = age
        self.city = city
    
    def __repr__(self):
        return f"Person(name={self.name!r}, age={self.age!r}, city={self.city!r})"
    
    def __eq__(self, other):
        if not isinstance(other, Person):
            return False
        return (self.name, self.age, self.city) == (other.name, other.age, other.city)
```

### Default values

```python
from dataclasses import dataclass

@dataclass
class Product:
    name: str
    price: float
    quantity: int = 0
    in_stock: bool = True

product = Product("Laptop", 999.99)
print(product)  # Product(name='Laptop', price=999.99, quantity=0, in_stock=True)
```

### Immutable dataclass (frozen)

```python
from dataclasses import dataclass

@dataclass(frozen=True)
class Point:
    x: int
    y: int

point = Point(1, 2)
# point.x = 5  # Error! FrozenInstanceError
```

### Field options

```python
from dataclasses import dataclass, field

@dataclass
class User:
    name: str
    age: int
    
    # Don't include in __init__
    created_at: str = field(init=False, default="2024-01-01")
    
    # Don't include in __repr__
    password: str = field(repr=False, default="secret")
    
    # Mutable default value (list, dict)
    friends: list = field(default_factory=list)

user = User("Alice", 30)
print(user)  # User(name='Alice', age=30, created_at='2024-01-01', friends=[])
```

### Post-init processing

```python
from dataclasses import dataclass, field

@dataclass
class Rectangle:
    width: float
    height: float
    area: float = field(init=False)
    
    def __post_init__(self):
        """Called after __init__."""
        self.area = self.width * self.height

rect = Rectangle(5, 10)
print(rect.area)  # 50
```

### With methods

```python
from dataclasses import dataclass

@dataclass
class BankAccount:
    owner: str
    balance: float = 0.0
    
    def deposit(self, amount):
        self.balance += amount
    
    def withdraw(self, amount):
        if amount > self.balance:
            raise ValueError("Insufficient funds")
        self.balance -= amount

account = BankAccount("Alice", 100)
account.deposit(50)
print(account.balance)  # 150
```

### Ordering (comparison)

```python
from dataclasses import dataclass

@dataclass(order=True)
class Person:
    name: str
    age: int

people = [
    Person("Charlie", 35),
    Person("Alice", 30),
    Person("Bob", 25)
]

# Can now sort because order=True
sorted_people = sorted(people)
for p in sorted_people:
    print(p)
```

### Inheritance

```python
from dataclasses import dataclass

@dataclass
class Animal:
    name: str
    age: int

@dataclass
class Dog(Animal):
    breed: str

dog = Dog("Buddy", 5, "Golden Retriever")
print(dog)  # Dog(name='Buddy', age=5, breed='Golden Retriever')
```

### Converting to dict/tuple

```python
from dataclasses import dataclass, asdict, astuple

@dataclass
class Person:
    name: str
    age: int

person = Person("Alice", 30)

# To dictionary
print(asdict(person))  # {'name': 'Alice', 'age': 30}

# To tuple
print(astuple(person))  # ('Alice', 30)
```

### When to use dataclasses

**Use when:**
- Primarily storing data
- Need automatic `__init__`, `__repr__`, `__eq__`
- Want immutable objects (frozen=True)
- Clean, readable code

**Don't use when:**
- Complex initialization logic
- Need custom `__init__` behavior
- Python version < 3.7
