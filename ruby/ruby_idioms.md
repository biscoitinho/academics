## Ruby Idioms and Best Practices

Common Ruby patterns and conventions.

### Use implicit returns

```ruby
# Bad
def add(a, b)
  return a + b
end

# Good
def add(a, b)
  a + b
end
```

### Use symbols for hash keys

```ruby
# Bad
person = { "name" => "Alice", "age" => 30 }

# Good
person = { name: "Alice", age: 30 }
```

### Use if/unless modifiers

```ruby
# Bad
if condition
  do_something
end

# Good (when one line)
do_something if condition
do_something unless opposite_condition
```

### Use safe navigation operator

```ruby
# Bad
user && user.address && user.address.city

# Good (Ruby 2.3+)
user&.address&.city
```

### Use double pipe for default values

```ruby
# Bad
name = name ? name : "Guest"

# Good
name = name || "Guest"
name ||= "Guest"  # Even better
```

### Use each instead of for

```ruby
# Bad
for item in array
  puts item
end

# Good
array.each do |item|
  puts item
end
```

### Use map instead of each for transformations

```ruby
# Bad
result = []
array.each { |item| result << item * 2 }

# Good
result = array.map { |item| item * 2 }
```

### Use select/reject for filtering

```ruby
# Bad
result = []
array.each { |item| result << item if item > 0 }

# Good
result = array.select { |item| item > 0 }
```

### Use reduce for aggregations

```ruby
# Bad
sum = 0
array.each { |item| sum += item }

# Good
sum = array.reduce(0, :+)
sum = array.sum  # Even better for sum
```

### Use string interpolation

```ruby
# Bad
"Hello " + name + "!"

# Good
"Hello #{name}!"
```

### Use %w for word arrays

```ruby
# Bad
fruits = ["apple", "banana", "cherry"]

# Good
fruits = %w[apple banana cherry]
```

### Use attr_accessor

```ruby
# Bad
class Person
  def name
    @name
  end
  
  def name=(value)
    @name = value
  end
end

# Good
class Person
  attr_accessor :name
end
```

### Use block form for File operations

```ruby
# Bad
file = File.open("file.txt")
content = file.read
file.close

# Good
File.open("file.txt") do |file|
  content = file.read
end
```

### Use compact to remove nils

```ruby
# Bad
array.select { |item| !item.nil? }

# Good
array.compact
```

### Use dig for safe nested access

```ruby
# Bad
user[:address][:city] if user[:address]

# Good
user.dig(:address, :city)
```

### Use tap for method chaining

```ruby
# Useful for debugging and side effects
def create_user
  User.new.tap do |user|
    user.name = "Alice"
    user.save
    puts "Created user: #{user.id}"
  end
end
```

### Use then (or yield_self) for transformations

```ruby
# Chain operations
"hello"
  .then { |s| s.upcase }
  .then { |s| s.reverse }
  .then { |s| s + "!" }
# "!OLLEH"
```

### Use presence

```ruby
# Rails-specific but useful
name = params[:name].presence || "Guest"
```

### Use guard clauses

```ruby
# Bad
def process(user)
  if user
    if user.active?
      # do work
    end
  end
end

# Good
def process(user)
  return unless user
  return unless user.active?
  # do work
end
```

### Use case statements for multiple conditions

```ruby
# Bad
if status == :active
  activate
elsif status == :inactive
  deactivate
elsif status == :pending
  wait
end

# Good
case status
when :active then activate
when :inactive then deactivate
when :pending then wait
end
```

### Use splat operator

```ruby
# Collect remaining arguments
def method(first, *rest)
  puts "First: #{first}"
  puts "Rest: #{rest}"
end

# Destructure arrays
first, *middle, last = [1, 2, 3, 4, 5]
```

### Use spaceship operator for comparison

```ruby
class Person
  include Comparable
  attr_reader :age
  
  def initialize(age)
    @age = age
  end
  
  def <=>(other)
    age <=> other.age
  end
end
```

### Use freeze for constants

```ruby
# Prevent modification
CONSTANT = "value".freeze
ARRAY = [1, 2, 3].freeze
```

### Use fetch with default

```ruby
# Bad
hash[:key] || "default"  # Fails if value is false

# Good
hash.fetch(:key, "default")
```

### Use destructuring

```ruby
# Array destructuring
first, second = [1, 2, 3]

# Hash destructuring
def greet(name:, age:)
  "Hello #{name}, age #{age}"
end

person = { name: "Alice", age: 30 }
greet(**person)
```

### Common anti-patterns to avoid

**Don't use return unnecessarily:**
```ruby
# Bad
def calculate
  return result
end

# Good
def calculate
  result
end
```

**Don't use self unnecessarily:**
```ruby
# Bad (in most cases)
def method
  self.some_method
end

# Good
def method
  some_method
end

# Only needed for writers:
def update
  self.name = "New"  # Need self here
end
```

**Don't compare with true/false:**
```ruby
# Bad
if flag == true

# Good
if flag
```

### Ruby naming conventions

- **Classes/Modules**: CamelCase
- **Methods/Variables**: snake_case
- **Constants**: UPPER_CASE
- **Predicate methods**: end with `?`
- **Dangerous methods**: end with `!`
