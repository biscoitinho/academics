## Object-Oriented Programming in Ruby

Comprehensive guide to OOP concepts in Ruby.

### Classes and Objects

#### Basic class definition

```ruby
class Person
  def initialize(name, age)
    @name = name
    @age = age
  end
  
  def introduce
    "Hi, I'm #{@name}, #{@age} years old"
  end
end

person = Person.new("Alice", 30)
puts person.introduce
```

#### Instance variables

Start with `@` - visible only within the object.

```ruby
class Car
  def initialize(brand)
    @brand = brand
    @mileage = 0
  end
  
  def drive(miles)
    @mileage += miles
  end
  
  def status
    "#{@brand}: #{@mileage} miles"
  end
end
```

#### Class variables

Start with `@@` - shared across all instances.

```ruby
class Counter
  @@count = 0
  
  def initialize
    @@count += 1
  end
  
  def self.total
    @@count
  end
end

Counter.new
Counter.new
Counter.total  # 2
```

### Attribute accessors

```ruby
class Person
  # Read only
  attr_reader :name
  
  # Write only
  attr_writer :password
  
  # Both read and write
  attr_accessor :age
  
  def initialize(name, age)
    @name = name
    @age = age
  end
end

person = Person.new("Alice", 30)
person.name          # "Alice" (getter)
person.age = 31      # (setter)
person.age           # 31 (getter)
```

### Class methods vs Instance methods

```ruby
class MathUtils
  # Class method - called on class
  def self.square(n)
    n * n
  end
  
  # Instance method - called on object
  def double(n)
    n * 2
  end
end

MathUtils.square(5)      # 25 (class method)
MathUtils.new.double(5)  # 10 (instance method)
```

### Inheritance

```ruby
class Animal
  def initialize(name)
    @name = name
  end
  
  def speak
    "Some sound"
  end
  
  def info
    "I'm #{@name}"
  end
end

class Dog < Animal
  def speak
    "Woof!"
  end
  
  def fetch
    "Fetching ball!"
  end
end

dog = Dog.new("Buddy")
dog.speak  # "Woof!" (overridden)
dog.info   # "I'm Buddy" (inherited)
dog.fetch  # "Fetching ball!" (new method)
```

### super keyword

Call parent class method.

```ruby
class Animal
  def initialize(name)
    @name = name
  end
end

class Dog < Animal
  def initialize(name, breed)
    super(name)  # Call parent's initialize
    @breed = breed
  end
end

# super without arguments passes all arguments
class Cat < Animal
  def initialize(name)
    super  # Passes name automatically
  end
end
```

### Method visibility

```ruby
class BankAccount
  def initialize(balance)
    @balance = balance
  end
  
  # Public (default) - can be called anywhere
  def deposit(amount)
    @balance += amount
  end
  
  # Protected - can be called by instances of same class
  protected
  
  def transfer_to(other_account, amount)
    other_account.add_balance(amount)
    @balance -= amount
  end
  
  # Private - can only be called within the object
  private
  
  def add_balance(amount)
    @balance += amount
  end
end

account = BankAccount.new(100)
account.deposit(50)        # OK
account.add_balance(50)    # Error! Private method
```

### Encapsulation

Hiding implementation details.

```ruby
class Temperature
  def initialize(celsius)
    @celsius = celsius
  end
  
  def celsius
    @celsius
  end
  
  def fahrenheit
    @celsius * 9.0 / 5.0 + 32
  end
  
  def celsius=(value)
    if value < -273.15
      raise "Temperature below absolute zero!"
    end
    @celsius = value
  end
end

temp = Temperature.new(25)
temp.celsius         # 25
temp.fahrenheit      # 77.0
temp.celsius = 30    # OK
temp.celsius = -300  # Error!
```

### Polymorphism

Different classes responding to same method.

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

class Duck
  def speak
    "Quack!"
  end
end

animals = [Dog.new, Cat.new, Duck.new]
animals.each { |animal| puts animal.speak }
# Woof!
# Meow!
# Quack!
```

### Duck typing

"If it walks like a duck and quacks like a duck, it's a duck."

```ruby
class FileLogger
  def log(message)
    File.open("log.txt", "a") { |f| f.puts message }
  end
end

class ConsoleLogger
  def log(message)
    puts message
  end
end

# Both respond to 'log', so they're interchangeable
def do_logging(logger, message)
  logger.log(message)
end

do_logging(FileLogger.new, "Error occurred")
do_logging(ConsoleLogger.new, "Debug info")
```

### Composition

Has-a relationship.

```ruby
class Engine
  def start
    "Engine started"
  end
end

class Car
  def initialize
    @engine = Engine.new  # Composition
  end
  
  def start
    @engine.start
  end
end

car = Car.new
car.start  # "Engine started"
```

### Class inheritance vs Module mixins

```ruby
# Single inheritance
class Vehicle
  def move
    "Moving"
  end
end

class Car < Vehicle
  # Inherits move
end

# Multiple behaviors with modules
module Drivable
  def drive
    "Driving"
  end
end

module Flyable
  def fly
    "Flying"
  end
end

class FlyingCar < Vehicle
  include Drivable
  include Flyable
end

car = FlyingCar.new
car.move   # "Moving" (inherited)
car.drive  # "Driving" (from module)
car.fly    # "Flying" (from module)
```

### Singleton methods

Methods defined on a specific object.

```ruby
dog = "Buddy"

def dog.speak
  "Woof! I'm #{self}"
end

dog.speak  # "Woof! I'm Buddy"

# Other strings don't have this method
"Rex".speak  # Error!
```

### Class instance variables vs Class variables

```ruby
class Counter
  # Class variable - shared by all subclasses
  @@shared = 0
  
  # Class instance variable - separate for each class
  @separate = 0
  
  class << self
    attr_accessor :separate
  end
  
  def self.increment_shared
    @@shared += 1
  end
  
  def self.increment_separate
    @separate += 1
  end
end

class SubCounter < Counter
end

Counter.increment_shared
SubCounter.increment_shared
# @@shared is now 2 (shared!)

Counter.separate = 5
SubCounter.separate = 10
# Each class has its own @separate
```

### Method aliasing

```ruby
class User
  def name
    @name
  end
  
  alias_method :username, :name
  alias :login, :name
end

user = User.new
user.name      # Same as...
user.username  # ...these two
user.login
```

### method_missing

Catch calls to undefined methods.

```ruby
class DynamicObject
  def method_missing(method_name, *args)
    if method_name.to_s.start_with?('get_')
      attribute = method_name.to_s.sub('get_', '')
      instance_variable_get("@#{attribute}")
    else
      super
    end
  end
  
  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?('get_') || super
  end
end

obj = DynamicObject.new
obj.instance_variable_set(:@name, "Alice")
obj.get_name  # "Alice"
```

### Struct - quick class creation

```ruby
# Create simple class
Person = Struct.new(:name, :age) do
  def introduce
    "Hi, I'm #{name}, #{age} years old"
  end
end

person = Person.new("Alice", 30)
person.name         # "Alice"
person.age = 31     # Can modify
person.introduce    # "Hi, I'm Alice, 31 years old"
```

### OpenStruct - dynamic attributes

```ruby
require 'ostruct'

person = OpenStruct.new
person.name = "Alice"
person.age = 30
person.city = "NYC"

person.name  # "Alice"
```

### Comparable module

```ruby
class Person
  include Comparable
  attr_reader :age
  
  def initialize(name, age)
    @name = name
    @age = age
  end
  
  def <=>(other)
    age <=> other.age
  end
end

alice = Person.new("Alice", 30)
bob = Person.new("Bob", 25)

alice > bob   # true
alice == bob  # false
[alice, bob].sort  # [bob, alice]
```

### Operator overloading

```ruby
class Vector
  attr_reader :x, :y
  
  def initialize(x, y)
    @x = x
    @y = y
  end
  
  def +(other)
    Vector.new(x + other.x, y + other.y)
  end
  
  def -(other)
    Vector.new(x - other.x, y - other.y)
  end
  
  def *(scalar)
    Vector.new(x * scalar, y * scalar)
  end
  
  def to_s
    "(#{x}, #{y})"
  end
end

v1 = Vector.new(1, 2)
v2 = Vector.new(3, 4)
v3 = v1 + v2  # Vector.new(4, 6)
```

### Constants

```ruby
class Config
  VERSION = "1.0.0"
  MAX_CONNECTIONS = 100
  
  def self.version
    VERSION
  end
end

Config::VERSION  # "1.0.0"
Config.version   # "1.0.0"
```

### Class << self (eigenclass)

```ruby
class Person
  # Class methods defined in eigenclass
  class << self
    def species
      "Homo sapiens"
    end
    
    def create(name)
      new(name)
    end
  end
  
  def initialize(name)
    @name = name
  end
end

Person.species  # "Homo sapiens"
Person.create("Alice")
```
