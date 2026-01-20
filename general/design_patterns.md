# Design Patterns

## What are Design Patterns?

Reusable solutions to common software design problems.

**Categories:**
- Creational: Object creation
- Structural: Object composition
- Behavioral: Object interaction

## Singleton

Ensure only one instance exists.

```python
class Database:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance.connection = None
        return cls._instance

    def connect(self):
        if not self.connection:
            self.connection = "Connected to DB"
            print(self.connection)

# Usage
db1 = Database()
db2 = Database()
print(db1 is db2)  # True (same instance)

db1.connect()
# db2.connection is also set (same object)
```

```ruby
class Database
  @instance = nil

  def self.instance
    @instance ||= new
  end

  private_class_method :new

  def connect
    @connection ||= "Connected to DB"
    puts @connection
  end
end

# Usage
db1 = Database.instance
db2 = Database.instance
puts db1 == db2  # true
```

**Use cases:**
- Database connections
- Configuration managers
- Logging

## Factory

Create objects without specifying exact class.

```python
class Dog:
    def speak(self):
        return "Woof!"

class Cat:
    def speak(self):
        return "Meow!"

class AnimalFactory:
    @staticmethod
    def create_animal(animal_type):
        if animal_type == "dog":
            return Dog()
        elif animal_type == "cat":
            return Cat()
        else:
            raise ValueError(f"Unknown animal: {animal_type}")

# Usage
factory = AnimalFactory()
dog = factory.create_animal("dog")
print(dog.speak())  # Woof!

cat = factory.create_animal("cat")
print(cat.speak())  # Meow!
```

```ruby
class Dog
  def speak
    "Woof!"
  end
end

class Cat
  def speak
    "Meow!"
  end
end

class AnimalFactory
  def self.create_animal(animal_type)
    case animal_type
    when :dog then Dog.new
    when :cat then Cat.new
    else raise "Unknown animal: #{animal_type}"
    end
  end
end

# Usage
dog = AnimalFactory.create_animal(:dog)
puts dog.speak  # Woof!
```

**Use cases:**
- Object creation based on input
- Plugin systems
- Different database adapters

## Builder

Construct complex objects step by step.

```python
class Pizza:
    def __init__(self):
        self.size = None
        self.cheese = False
        self.pepperoni = False
        self.mushrooms = False

    def __str__(self):
        return f"Pizza: size={self.size}, cheese={self.cheese}, pepperoni={self.pepperoni}, mushrooms={self.mushrooms}"

class PizzaBuilder:
    def __init__(self):
        self.pizza = Pizza()

    def set_size(self, size):
        self.pizza.size = size
        return self

    def add_cheese(self):
        self.pizza.cheese = True
        return self

    def add_pepperoni(self):
        self.pizza.pepperoni = True
        return self

    def add_mushrooms(self):
        self.pizza.mushrooms = True
        return self

    def build(self):
        return self.pizza

# Usage
pizza = (PizzaBuilder()
    .set_size("large")
    .add_cheese()
    .add_pepperoni()
    .build())

print(pizza)
# Pizza: size=large, cheese=True, pepperoni=True, mushrooms=False
```

**Use cases:**
- Complex object construction
- Fluent APIs
- SQL query builders

## Observer

Notify multiple objects of state changes.

```python
class Subject:
    def __init__(self):
        self._observers = []

    def attach(self, observer):
        self._observers.append(observer)

    def detach(self, observer):
        self._observers.remove(observer)

    def notify(self, message):
        for observer in self._observers:
            observer.update(message)

class EmailObserver:
    def update(self, message):
        print(f"Email: {message}")

class SMSObserver:
    def update(self, message):
        print(f"SMS: {message}")

# Usage
subject = Subject()

email = EmailObserver()
sms = SMSObserver()

subject.attach(email)
subject.attach(sms)

subject.notify("Order placed!")
# Email: Order placed!
# SMS: Order placed!
```

```ruby
class Subject
  def initialize
    @observers = []
  end

  def attach(observer)
    @observers << observer
  end

  def notify(message)
    @observers.each { |observer| observer.update(message) }
  end
end

class EmailObserver
  def update(message)
    puts "Email: #{message}"
  end
end

# Usage
subject = Subject.new
subject.attach(EmailObserver.new)
subject.notify("Order placed!")
```

**Use cases:**
- Event systems
- MVC (Model notifies View)
- Pub/Sub patterns

## Strategy

Select algorithm at runtime.

```python
class PaymentStrategy:
    def pay(self, amount):
        raise NotImplementedError

class CreditCardPayment(PaymentStrategy):
    def pay(self, amount):
        print(f"Paid ${amount} with credit card")

class PayPalPayment(PaymentStrategy):
    def pay(self, amount):
        print(f"Paid ${amount} with PayPal")

class CryptoPayment(PaymentStrategy):
    def pay(self, amount):
        print(f"Paid ${amount} with crypto")

class ShoppingCart:
    def __init__(self, payment_strategy):
        self.payment_strategy = payment_strategy

    def checkout(self, amount):
        self.payment_strategy.pay(amount)

# Usage
cart = ShoppingCart(CreditCardPayment())
cart.checkout(100)  # Paid $100 with credit card

cart.payment_strategy = PayPalPayment()
cart.checkout(50)   # Paid $50 with PayPal
```

**Use cases:**
- Multiple algorithms (sorting, compression)
- Payment methods
- Rendering strategies

## Decorator

Add functionality to objects dynamically.

```python
class Coffee:
    def cost(self):
        return 5

    def description(self):
        return "Coffee"

class MilkDecorator:
    def __init__(self, coffee):
        self._coffee = coffee

    def cost(self):
        return self._coffee.cost() + 2

    def description(self):
        return self._coffee.description() + ", Milk"

class SugarDecorator:
    def __init__(self, coffee):
        self._coffee = coffee

    def cost(self):
        return self._coffee.cost() + 1

    def description(self):
        return self._coffee.description() + ", Sugar"

# Usage
coffee = Coffee()
print(f"{coffee.description()}: ${coffee.cost()}")
# Coffee: $5

coffee = MilkDecorator(coffee)
print(f"{coffee.description()}: ${coffee.cost()}")
# Coffee, Milk: $7

coffee = SugarDecorator(coffee)
print(f"{coffee.description()}: ${coffee.cost()}")
# Coffee, Milk, Sugar: $8
```

**Python decorator syntax:**
```python
def log_decorator(func):
    def wrapper(*args, **kwargs):
        print(f"Calling {func.__name__}")
        result = func(*args, **kwargs)
        print(f"Finished {func.__name__}")
        return result
    return wrapper

@log_decorator
def greet(name):
    print(f"Hello {name}")

greet("Alice")
# Calling greet
# Hello Alice
# Finished greet
```

**Use cases:**
- Adding features (logging, caching)
- UI components
- HTTP middleware

## Adapter

Make incompatible interfaces work together.

```python
# Old interface
class OldPrinter:
    def print_document(self, text):
        print(f"Old printer: {text}")

# New interface
class NewPrinter:
    def render(self, content):
        print(f"New printer: {content}")

# Adapter
class PrinterAdapter:
    def __init__(self, new_printer):
        self.new_printer = new_printer

    def print_document(self, text):
        self.new_printer.render(text)

# Usage
def use_printer(printer):
    printer.print_document("Hello World")

old = OldPrinter()
use_printer(old)  # Old printer: Hello World

new = NewPrinter()
adapted = PrinterAdapter(new)
use_printer(adapted)  # New printer: Hello World
```

**Use cases:**
- Legacy code integration
- Third-party libraries
- API version compatibility

## Command

Encapsulate requests as objects.

```python
class Light:
    def on(self):
        print("Light is ON")

    def off(self):
        print("Light is OFF")

class Command:
    def execute(self):
        raise NotImplementedError

class LightOnCommand(Command):
    def __init__(self, light):
        self.light = light

    def execute(self):
        self.light.on()

class LightOffCommand(Command):
    def __init__(self, light):
        self.light = light

    def execute(self):
        self.light.off()

class RemoteControl:
    def __init__(self):
        self.command = None

    def set_command(self, command):
        self.command = command

    def press_button(self):
        self.command.execute()

# Usage
light = Light()
light_on = LightOnCommand(light)
light_off = LightOffCommand(light)

remote = RemoteControl()

remote.set_command(light_on)
remote.press_button()  # Light is ON

remote.set_command(light_off)
remote.press_button()  # Light is OFF
```

**Use cases:**
- Undo/redo
- Task scheduling
- Macro recording

## Template Method

Define algorithm skeleton, let subclasses implement steps.

```python
class DataProcessor:
    def process(self):
        self.load_data()
        self.parse_data()
        self.analyze_data()
        self.save_results()

    def load_data(self):
        raise NotImplementedError

    def parse_data(self):
        print("Parsing data...")

    def analyze_data(self):
        raise NotImplementedError

    def save_results(self):
        print("Saving results...")

class CSVProcessor(DataProcessor):
    def load_data(self):
        print("Loading CSV data...")

    def analyze_data(self):
        print("Analyzing CSV data...")

class JSONProcessor(DataProcessor):
    def load_data(self):
        print("Loading JSON data...")

    def analyze_data(self):
        print("Analyzing JSON data...")

# Usage
csv = CSVProcessor()
csv.process()
# Loading CSV data...
# Parsing data...
# Analyzing CSV data...
# Saving results...
```

**Use cases:**
- Frameworks (Django, Rails)
- Test frameworks
- Data processing pipelines

## Facade

Simplified interface to complex subsystem.

```python
class CPU:
    def freeze(self):
        print("CPU frozen")

    def execute(self):
        print("CPU executing")

class Memory:
    def load(self):
        print("Memory loaded")

class HardDrive:
    def read(self):
        print("HardDrive read")
        return "data"

class ComputerFacade:
    def __init__(self):
        self.cpu = CPU()
        self.memory = Memory()
        self.hard_drive = HardDrive()

    def start(self):
        print("Starting computer...")
        self.cpu.freeze()
        self.memory.load()
        data = self.hard_drive.read()
        self.cpu.execute()
        print("Computer started!")

# Usage
computer = ComputerFacade()
computer.start()
# Starting computer...
# CPU frozen
# Memory loaded
# HardDrive read
# CPU executing
# Computer started!
```

**Use cases:**
- Complex library APIs
- Subsystem integration
- Legacy code wrappers

## Proxy

Control access to another object.

```python
class RealImage:
    def __init__(self, filename):
        self.filename = filename
        self.load_from_disk()

    def load_from_disk(self):
        print(f"Loading {self.filename}")

    def display(self):
        print(f"Displaying {self.filename}")

class ImageProxy:
    def __init__(self, filename):
        self.filename = filename
        self.real_image = None

    def display(self):
        if self.real_image is None:
            self.real_image = RealImage(self.filename)
        self.real_image.display()

# Usage
image = ImageProxy("photo.jpg")
# Image not loaded yet

image.display()
# Loading photo.jpg
# Displaying photo.jpg

image.display()
# Displaying photo.jpg (no loading, already cached)
```

**Use cases:**
- Lazy loading
- Access control
- Remote proxies (RPC)
- Caching

## Chain of Responsibility

Pass request through chain of handlers.

```python
class Handler:
    def __init__(self):
        self.next_handler = None

    def set_next(self, handler):
        self.next_handler = handler
        return handler

    def handle(self, request):
        if self.next_handler:
            return self.next_handler.handle(request)
        return None

class AuthHandler(Handler):
    def handle(self, request):
        if not request.get('authenticated'):
            print("Auth failed")
            return False
        print("Auth passed")
        return super().handle(request)

class ValidationHandler(Handler):
    def handle(self, request):
        if not request.get('valid'):
            print("Validation failed")
            return False
        print("Validation passed")
        return super().handle(request)

class SaveHandler(Handler):
    def handle(self, request):
        print("Saving data")
        return True

# Usage
auth = AuthHandler()
validation = ValidationHandler()
save = SaveHandler()

auth.set_next(validation).set_next(save)

request = {'authenticated': True, 'valid': True}
auth.handle(request)
# Auth passed
# Validation passed
# Saving data
```

**Use cases:**
- HTTP middleware
- Event bubbling
- Logging chains

## Repository

Separate data access logic.

```python
class User:
    def __init__(self, id, name):
        self.id = id
        self.name = name

class UserRepository:
    def __init__(self):
        self._users = {}

    def add(self, user):
        self._users[user.id] = user

    def get(self, user_id):
        return self._users.get(user_id)

    def find_by_name(self, name):
        return [u for u in self._users.values() if u.name == name]

    def all(self):
        return list(self._users.values())

# Usage
repo = UserRepository()
repo.add(User(1, "Alice"))
repo.add(User(2, "Bob"))

user = repo.get(1)
print(user.name)  # Alice

users = repo.find_by_name("Bob")
print(users[0].name)  # Bob
```

**Use cases:**
- Data access layer
- ORM abstraction
- Testing (mock repository)

## Dependency Injection

Provide dependencies from outside.

```python
# ❌ Bad: Hard-coded dependency
class UserService:
    def __init__(self):
        self.db = Database()  # Tight coupling

# ✅ Good: Injected dependency
class UserService:
    def __init__(self, database):
        self.db = database  # Loose coupling

    def get_user(self, id):
        return self.db.get_user(id)

# Usage
db = Database()
service = UserService(db)

# Easy to test with mock
mock_db = MockDatabase()
service = UserService(mock_db)
```

**Use cases:**
- Testing
- Configuration
- Flexibility

## MVC (Model-View-Controller)

Separate concerns.

```python
# Model
class User:
    def __init__(self, name):
        self.name = name

# View
class UserView:
    def display(self, user):
        print(f"User: {user.name}")

# Controller
class UserController:
    def __init__(self, model, view):
        self.model = model
        self.view = view

    def set_name(self, name):
        self.model.name = name

    def display_user(self):
        self.view.display(self.model)

# Usage
user = User("Alice")
view = UserView()
controller = UserController(user, view)

controller.display_user()  # User: Alice
controller.set_name("Bob")
controller.display_user()  # User: Bob
```

## Common Pattern Combinations

```python
# Factory + Singleton
class ConnectionFactory:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    def create_connection(self, db_type):
        if db_type == "mysql":
            return MySQLConnection()
        elif db_type == "postgres":
            return PostgresConnection()

# Strategy + Factory
class CompressionFactory:
    @staticmethod
    def get_compressor(type):
        strategies = {
            'zip': ZipCompressor(),
            'gzip': GzipCompressor(),
            'bz2': Bz2Compressor()
        }
        return strategies.get(type)

# Observer + Singleton (Event Bus)
class EventBus:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance.observers = {}
        return cls._instance

    def subscribe(self, event, observer):
        if event not in self.observers:
            self.observers[event] = []
        self.observers[event].append(observer)

    def publish(self, event, data):
        if event in self.observers:
            for observer in self.observers[event]:
                observer.update(data)
```

## When to Use Patterns

```
Singleton:
  ✅ Configuration, logging, connection pools
  ❌ Don't overuse (global state issues)

Factory:
  ✅ Object creation varies
  ❌ Simple cases (use constructors)

Observer:
  ✅ Event-driven systems
  ❌ Simple callbacks sufficient

Strategy:
  ✅ Multiple algorithms
  ❌ Only one algorithm

Decorator:
  ✅ Dynamic features
  ❌ Static composition works
```

## Anti-Patterns to Avoid

```python
# God Object (class does everything)
# ❌ Bad
class Application:
    def connect_database(self): pass
    def send_email(self): pass
    def render_html(self): pass
    def process_payment(self): pass
    # ... 50 more methods

# ✅ Good: Separate concerns
class Database: pass
class EmailService: pass
class TemplateEngine: pass
class PaymentProcessor: pass
```

## Best Practices

```python
# 1. Don't force patterns
# Use when problem matches

# 2. Keep it simple
# Simplest solution first

# 3. Consider alternatives
# Sometimes plain code is better

# 4. Test your patterns
# Patterns should make testing easier

# 5. Document why
# Explain pattern choice in comments
```
