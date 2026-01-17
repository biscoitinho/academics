## Modules and Mixins

Modules are containers for methods, classes, and constants.
They provide namespacing and mixins for code reuse.

### Creating a module

```ruby
module Greetings
  def hello
    "Hello!"
  end
  
  def goodbye
    "Goodbye!"
  end
end
```

### Include vs Extend

#### Include - adds instance methods

```ruby
module Greetings
  def hello
    "Hello from #{self.class}!"
  end
end

class Person
  include Greetings
end

person = Person.new
person.hello  # "Hello from Person!"
```

#### Extend - adds class methods

```ruby
module Greetings
  def hello
    "Hello from #{self}!"
  end
end

class Person
  extend Greetings
end

Person.hello  # "Hello from Person!"
```

### Include and Extend together

```ruby
module Greetings
  def hello
    "Instance: Hello!"
  end
  
  module ClassMethods
    def hello
      "Class: Hello!"
    end
  end
  
  def self.included(base)
    base.extend(ClassMethods)
  end
end

class Person
  include Greetings
end

Person.new.hello  # "Instance: Hello!"
Person.hello      # "Class: Hello!"
```

### Namespacing

```ruby
module Animals
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
end

dog = Animals::Dog.new
cat = Animals::Cat.new

dog.speak  # "Woof!"
cat.speak  # "Meow!"
```

### Module constants

```ruby
module Config
  API_URL = "https://api.example.com"
  MAX_RETRIES = 3
  TIMEOUT = 30
end

puts Config::API_URL  # "https://api.example.com"
```

### Module methods

```ruby
module MathUtils
  def self.square(n)
    n * n
  end
  
  def self.cube(n)
    n * n * n
  end
end

MathUtils.square(5)  # 25
MathUtils.cube(3)    # 27
```

### Mixins for shared behavior

```ruby
module Walkable
  def walk
    "Walking on #{legs} legs"
  end
end

module Swimmable
  def swim
    "Swimming!"
  end
end

class Dog
  include Walkable
  
  def legs
    4
  end
end

class Duck
  include Walkable
  include Swimmable
  
  def legs
    2
  end
end

dog = Dog.new
duck = Duck.new

dog.walk   # "Walking on 4 legs"
duck.walk  # "Walking on 2 legs"
duck.swim  # "Swimming!"
```

### Prepend (adds methods before class)

```ruby
module Logger
  def save
    puts "Logging save..."
    super  # Calls original save
  end
end

class User
  prepend Logger
  
  def save
    puts "Saving user..."
  end
end

user = User.new
user.save
# Logging save...
# Saving user...
```

### Method lookup order

```ruby
module A
  def test
    "A"
  end
end

module B
  def test
    "B"
  end
end

class MyClass
  include A
  include B
end

MyClass.new.test  # "B" (last included wins)

# Check lookup order
MyClass.ancestors
# [MyClass, B, A, Object, Kernel, BasicObject]
```

### Checking module inclusion

```ruby
module Greetings
end

class Person
  include Greetings
end

Person.include?(Greetings)       # true
Person.ancestors.include?(Greetings)  # true
Person.new.is_a?(Greetings)      # true
```

### Real-world example: Comparable

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
alice < bob   # false
alice == bob  # false
[alice, bob].sort  # [bob, alice] (sorted by age)
```

### Real-world example: Enumerable

```ruby
class Playlist
  include Enumerable
  
  def initialize
    @songs = []
  end
  
  def add(song)
    @songs << song
  end
  
  def each(&block)
    @songs.each(&block)
  end
end

playlist = Playlist.new
playlist.add("Song 1")
playlist.add("Song 2")

# Now we get all Enumerable methods for free!
playlist.map { |song| song.upcase }
playlist.select { |song| song.include?("1") }
playlist.count  # 2
```

### When to use modules

**Use modules for:**
- Namespacing (organizing related classes)
- Mixins (sharing behavior across classes)
- Utility methods (module methods)
- Constants (configuration values)

**Don't use modules for:**
- Inheritance (use classes)
- Creating instances (modules can't be instantiated)

### Include vs Extend vs Prepend

| Method | Adds | Use Case |
|--------|------|----------|
| `include` | Instance methods | Shared behavior for objects |
| `extend` | Class methods | Shared class-level behavior |
| `prepend` | Instance methods (before class) | Wrap/override with super |
