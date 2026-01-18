## Composition vs Inheritance

### Inheritance (IS-A)

```python
class Animal:
    def __init__(self, name):
        self.name = name

    def speak(self):
        pass

class Dog(Animal):
    def speak(self):
        return f"{self.name} says Woof"

class Cat(Animal):
    def speak(self):
        return f"{self.name} says Meow"

dog = Dog("Buddy")
dog.speak()        # Buddy says Woof
```

### Composition (HAS-A)

```python
class Engine:
    def start(self):
        return "Engine started"

class Wheels:
    def rotate(self):
        return "Wheels rotating"

class Car:
    def __init__(self):
        self.engine = Engine()
        self.wheels = Wheels()

    def drive(self):
        return f"{self.engine.start()}, {self.wheels.rotate()}"

car = Car()
car.drive()        # Engine started, Wheels rotating
```

### When to Use Each

**Use Inheritance when:**
- Clear "is-a" relationship (Dog IS-A Animal)
- Shared behavior among related classes
- Natural hierarchy exists

**Use Composition when:**
- "has-a" relationship (Car HAS-A Engine)
- Need flexibility to change behavior
- Want to avoid deep inheritance chains

### Example: Prefer Composition

```python
# Bad: Inheritance for code reuse
class Logger:
    def log(self, message):
        print(f"LOG: {message}")

class UserService(Logger):  # UserService is not a Logger!
    def create_user(self, name):
        self.log(f"Creating user {name}")

# Good: Composition
class UserService:
    def __init__(self, logger):
        self.logger = logger

    def create_user(self, name):
        self.logger.log(f"Creating user {name}")

service = UserService(Logger())
```

### Multiple Composition

```python
class Database:
    def save(self, data):
        print(f"Saving {data}")

class Cache:
    def get(self, key):
        return f"Cached: {key}"

class UserService:
    def __init__(self, db, cache):
        self.db = db
        self.cache = cache

    def get_user(self, id):
        cached = self.cache.get(id)
        if not cached:
            # Fetch from db
            pass
        return cached

service = UserService(Database(), Cache())
```

**Rule of thumb**: Favor composition over inheritance.
