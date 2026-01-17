## Composition vs Inheritance

Two ways to reuse code in OOP.

### Inheritance (IS-A relationship)

"A Dog IS-A Animal"

```python
class Animal:
    def __init__(self, name):
        self.name = name
    
    def speak(self):
        pass

class Dog(Animal):
    def speak(self):
        return f"{self.name} says Woof!"

class Cat(Animal):
    def speak(self):
        return f"{self.name} says Meow!"

dog = Dog("Buddy")
print(dog.speak())  # Buddy says Woof!
```

### Composition (HAS-A relationship)

"A Car HAS-A Engine"

```python
class Engine:
    def __init__(self, horsepower):
        self.horsepower = horsepower
    
    def start(self):
        return "Engine started"
    
    def stop(self):
        return "Engine stopped"

class Car:
    def __init__(self, make, horsepower):
        self.make = make
        self.engine = Engine(horsepower)  # Composition
    
    def start(self):
        return f"{self.make}: {self.engine.start()}"
    
    def stop(self):
        return f"{self.make}: {self.engine.stop()}"

car = Car("Toyota", 200)
print(car.start())  # Toyota: Engine started
```

### When inheritance goes wrong

```python
# Problem: Rigid hierarchy
class Bird:
    def fly(self):
        return "Flying!"

class Penguin(Bird):
    def fly(self):
        # Penguins can't fly! But they inherit fly()
        raise NotImplementedError("Penguins can't fly")

# This is a design problem!
```

### Better solution with composition

```python
class FlyBehavior:
    def fly(self):
        return "Flying!"

class NoFlyBehavior:
    def fly(self):
        return "Can't fly"

class Bird:
    def __init__(self, fly_behavior):
        self.fly_behavior = fly_behavior
    
    def perform_fly(self):
        return self.fly_behavior.fly()

# Now we can compose behaviors
eagle = Bird(FlyBehavior())
penguin = Bird(NoFlyBehavior())

print(eagle.perform_fly())    # Flying!
print(penguin.perform_fly())  # Can't fly
```

### Real-world example: Logger

**With inheritance (problematic):**
```python
class FileLogger:
    def log(self, message):
        with open("log.txt", "a") as f:
            f.write(message + "\n")

class Database(FileLogger):
    # Database has to inherit from FileLogger
    # What if we want different logging later?
    pass
```

**With composition (flexible):**
```python
class FileLogger:
    def log(self, message):
        with open("log.txt", "a") as f:
            f.write(message + "\n")

class ConsoleLogger:
    def log(self, message):
        print(message)

class Database:
    def __init__(self, logger):
        self.logger = logger  # Composition
    
    def save(self, data):
        # Save data...
        self.logger.log(f"Saved: {data}")

# Easy to swap loggers
db1 = Database(FileLogger())
db2 = Database(ConsoleLogger())
```

### Multiple compositions

```python
class GPS:
    def get_location(self):
        return "40.7128° N, 74.0060° W"

class Radio:
    def play(self, station):
        return f"Playing {station}"

class Engine:
    def start(self):
        return "Engine started"

class Car:
    def __init__(self):
        self.engine = Engine()
        self.gps = GPS()
        self.radio = Radio()
    
    def start(self):
        return self.engine.start()
    
    def navigate(self):
        return self.gps.get_location()
    
    def entertainment(self):
        return self.radio.play("98.7 FM")

car = Car()
print(car.start())         # Engine started
print(car.navigate())      # 40.7128° N, 74.0060° W
print(car.entertainment()) # Playing 98.7 FM
```

### Composition with dependency injection

```python
class EmailService:
    def send(self, to, message):
        print(f"Email to {to}: {message}")

class SMSService:
    def send(self, to, message):
        print(f"SMS to {to}: {message}")

class NotificationSystem:
    def __init__(self, service):
        self.service = service  # Inject dependency
    
    def notify(self, user, message):
        self.service.send(user, message)

# Easy to switch services
email_notifier = NotificationSystem(EmailService())
sms_notifier = NotificationSystem(SMSService())

email_notifier.notify("alice@example.com", "Hello!")
sms_notifier.notify("+1234567890", "Hello!")
```

### When to use what?

**Use Inheritance when:**
- Clear IS-A relationship
- Shared behavior among subclasses
- Polymorphism is needed
- Example: `Dog IS-A Animal`, `Square IS-A Shape`

**Use Composition when:**
- HAS-A relationship
- Need flexibility to change behavior
- Want to avoid rigid hierarchies
- Multiple independent behaviors needed
- Example: `Car HAS-A Engine`, `User HAS-A Role`

### The rule of thumb

**"Favor composition over inheritance"** - Gang of Four Design Patterns

Composition is more flexible and easier to change.
