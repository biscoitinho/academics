# Object-Oriented Programming Principles

## Four Pillars of OOP

### 1. Encapsulation

Hide internal state and require interaction through methods.

```python
class BankAccount:
    def __init__(self, balance=0):
        self.__balance = balance  # Private attribute

    def deposit(self, amount):
        if amount > 0:
            self.__balance += amount

    def withdraw(self, amount):
        if 0 < amount <= self.__balance:
            self.__balance -= amount
            return True
        return False

    def get_balance(self):
        return self.__balance

# Usage
account = BankAccount(100)
account.deposit(50)
print(account.get_balance())  # 150
# account.__balance  # AttributeError (private)
```

```ruby
class BankAccount
  def initialize(balance = 0)
    @balance = balance  # Private by convention
  end

  def deposit(amount)
    @balance += amount if amount > 0
  end

  def withdraw(amount)
    if amount > 0 && amount <= @balance
      @balance -= amount
      true
    else
      false
    end
  end

  def balance
    @balance
  end

  private  # Methods below are private

  def internal_method
    # Can't be called from outside
  end
end
```

### 2. Inheritance

Create new classes from existing ones.

```python
class Animal:
    def __init__(self, name):
        self.name = name

    def speak(self):
        raise NotImplementedError

class Dog(Animal):
    def speak(self):
        return f"{self.name} says Woof!"

class Cat(Animal):
    def speak(self):
        return f"{self.name} says Meow!"

dog = Dog("Buddy")
print(dog.speak())  # Buddy says Woof!

cat = Cat("Whiskers")
print(cat.speak())  # Whiskers says Meow!
```

```ruby
class Animal
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def speak
    raise NotImplementedError
  end
end

class Dog < Animal
  def speak
    "#{name} says Woof!"
  end
end

class Cat < Animal
  def speak
    "#{name} says Meow!"
  end
end
```

### 3. Polymorphism

Same interface, different implementations.

```python
def make_speak(animal):
    print(animal.speak())

animals = [Dog("Buddy"), Cat("Whiskers"), Dog("Max")]

for animal in animals:
    make_speak(animal)
# Buddy says Woof!
# Whiskers says Meow!
# Max says Woof!
```

### 4. Abstraction

Hide complex implementation details.

```python
from abc import ABC, abstractmethod

class Shape(ABC):
    @abstractmethod
    def area(self):
        pass

    @abstractmethod
    def perimeter(self):
        pass

class Circle(Shape):
    def __init__(self, radius):
        self.radius = radius

    def area(self):
        return 3.14 * self.radius ** 2

    def perimeter(self):
        return 2 * 3.14 * self.radius

circle = Circle(5)
print(circle.area())  # 78.5
```

## SOLID Principles

### S - Single Responsibility

Class should have only one reason to change.

```python
# ❌ Bad: Multiple responsibilities
class User:
    def save_to_database(self):
        pass

    def send_email(self):
        pass

    def generate_report(self):
        pass

# ✅ Good: Single responsibility
class User:
    def __init__(self, name):
        self.name = name

class UserRepository:
    def save(self, user):
        pass

class EmailService:
    def send(self, user, message):
        pass

class ReportGenerator:
    def generate(self, user):
        pass
```

### O - Open/Closed

Open for extension, closed for modification.

```python
# ❌ Bad: Modify class for new shapes
class AreaCalculator:
    def calculate(self, shape):
        if shape.type == 'circle':
            return 3.14 * shape.radius ** 2
        elif shape.type == 'square':
            return shape.side ** 2

# ✅ Good: Extend without modifying
class Shape:
    def area(self):
        raise NotImplementedError

class Circle(Shape):
    def __init__(self, radius):
        self.radius = radius

    def area(self):
        return 3.14 * self.radius ** 2

class Square(Shape):
    def __init__(self, side):
        self.side = side

    def area(self):
        return self.side ** 2

class AreaCalculator:
    def calculate(self, shape):
        return shape.area()
```

### L - Liskov Substitution

Subclass should be substitutable for base class.

```python
# ❌ Bad: Breaks substitution
class Bird:
    def fly(self):
        pass

class Penguin(Bird):
    def fly(self):
        raise Exception("Can't fly!")  # Violates LSP

# ✅ Good: Proper hierarchy
class Bird:
    def move(self):
        pass

class FlyingBird(Bird):
    def fly(self):
        pass

class Penguin(Bird):
    def move(self):
        print("Waddle")

class Eagle(FlyingBird):
    def fly(self):
        print("Soar")
```

### I - Interface Segregation

Many specific interfaces better than one general.

```python
# ❌ Bad: Fat interface
class Worker:
    def work(self):
        pass

    def eat(self):
        pass

class Robot(Worker):
    def work(self):
        print("Working")

    def eat(self):
        raise Exception("Robots don't eat!")  # Forced to implement

# ✅ Good: Specific interfaces
class Workable:
    def work(self):
        pass

class Eatable:
    def eat(self):
        pass

class Human(Workable, Eatable):
    def work(self):
        print("Working")

    def eat(self):
        print("Eating")

class Robot(Workable):
    def work(self):
        print("Working")
```

### D - Dependency Inversion

Depend on abstractions, not concretions.

```python
# ❌ Bad: Depends on concrete class
class MySQLDatabase:
    def save(self, data):
        print("Save to MySQL")

class UserService:
    def __init__(self):
        self.db = MySQLDatabase()  # Tight coupling

# ✅ Good: Depends on abstraction
class Database:
    def save(self, data):
        raise NotImplementedError

class MySQLDatabase(Database):
    def save(self, data):
        print("Save to MySQL")

class MongoDatabase(Database):
    def save(self, data):
        print("Save to MongoDB")

class UserService:
    def __init__(self, database):
        self.db = database  # Inject dependency

# Usage
service = UserService(MySQLDatabase())
service = UserService(MongoDatabase())
```

## DRY (Don't Repeat Yourself)

```python
# ❌ Bad: Repetition
def calculate_circle_area(radius):
    return 3.14159 * radius * radius

def calculate_circle_circumference(radius):
    return 2 * 3.14159 * radius

# ✅ Good: No repetition
PI = 3.14159

def calculate_circle_area(radius):
    return PI * radius * radius

def calculate_circle_circumference(radius):
    return 2 * PI * radius
```

## KISS (Keep It Simple, Stupid)

```python
# ❌ Complex
def is_even(n):
    if n % 2 == 0:
        return True
    else:
        return False

# ✅ Simple
def is_even(n):
    return n % 2 == 0
```

## YAGNI (You Aren't Gonna Need It)

```python
# ❌ Over-engineering
class User:
    def __init__(self, name):
        self.name = name
        self.preferences = {}
        self.settings = {}
        self.metadata = {}
        # ... many unused attributes

# ✅ Start simple
class User:
    def __init__(self, name):
        self.name = name
    # Add features when actually needed
```

## Composition over Inheritance

```python
# ❌ Deep inheritance hierarchy
class Animal:
    pass

class Mammal(Animal):
    pass

class Dog(Mammal):
    pass

class ServiceDog(Dog):
    pass

# ✅ Composition
class Animal:
    def __init__(self):
        self.behaviors = []

    def add_behavior(self, behavior):
        self.behaviors.append(behavior)

class FlyBehavior:
    def fly(self):
        print("Flying")

class SwimBehavior:
    def swim(self):
        print("Swimming")

# Usage
duck = Animal()
duck.add_behavior(FlyBehavior())
duck.add_behavior(SwimBehavior())
```

## Law of Demeter

Don't talk to strangers.

```python
# ❌ Bad: Chaining
customer.wallet.money.amount

# ✅ Good: Ask for what you need
customer.get_money_amount()
```

## Design by Contract

```python
def divide(a, b):
    # Precondition
    assert b != 0, "Divisor cannot be zero"

    result = a / b

    # Postcondition
    assert result * b == a, "Result is incorrect"

    return result
```

## Class Design Principles

```python
# 1. High Cohesion
class Order:
    def __init__(self):
        self.items = []
        self.total = 0

    def add_item(self, item):
        self.items.append(item)
        self.calculate_total()

    def calculate_total(self):
        self.total = sum(item.price for item in self.items)

# All methods related to Order

# 2. Low Coupling
# Classes should have minimal dependencies

# 3. Information Hiding
# Hide implementation details
```

## Common Anti-Patterns

```python
# God Object
# ❌ Class that does everything
class Application:
    def connect_db(self): pass
    def send_email(self): pass
    def render_ui(self): pass
    def process_payment(self): pass
    # ... 50 more methods

# Solution: Split into focused classes

# Anemic Domain Model
# ❌ Classes with only getters/setters
class User:
    def get_name(self): return self.name
    def set_name(self, name): self.name = name
    # No behavior

# Solution: Add behavior to classes

# Circular Dependencies
# ❌ A depends on B, B depends on A
# Solution: Introduce interface or mediator
```

## Best Practices

```python
# 1. Favor composition over inheritance
# 2. Program to interfaces
# 3. Keep classes small and focused
# 4. Use meaningful names
# 5. Write tests
# 6. Follow SOLID
# 7. Don't premature optimize
# 8. Document complex logic
```
