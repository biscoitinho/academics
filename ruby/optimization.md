# Ruby Optimization

Basic optimization principles and techniques for Ruby code.

## Rule #1: Profile First

Always measure before optimizing. Use benchmarking to find bottlenecks.

```ruby
require 'benchmark'

n = 100_000

Benchmark.bm do |x|
  x.report("method 1:") { n.times { "string" + "concat" } }
  x.report("method 2:") { n.times { "string #{'concat'}" } }
end
```

## Use Symbols Instead of Strings

Symbols are immutable and reuse the same object in memory.

```ruby
# Slower - creates new string objects
hash = { "name" => "Alice", "age" => 30 }
hash["name"]

# Faster - symbols are reused
hash = { name: "Alice", age: 30 }
hash[:name]

# Check object_id
"name".object_id  # Different each time
:name.object_id   # Always the same
```

## String Interpolation vs Concatenation

String interpolation is generally faster and more readable.

```ruby
name = "Alice"
age = 30

# Slower - concatenation
msg = "Name: " + name + ", Age: " + age.to_s

# Faster - interpolation
msg = "Name: #{name}, Age: #{age}"

# For simple cases, concatenation is ok
full_name = first_name + " " + last_name
```

## Use Bang Methods

Bang methods (!) modify objects in place, avoiding new object creation.

```ruby
# Creates new array each time
numbers = [3, 1, 4, 1, 5]
sorted = numbers.sort
capitalized = names.map { |n| n.capitalize }

# Modifies in place (when you don't need original)
numbers.sort!
names.map! { |n| n.capitalize }

# String mutations
str = "hello"
str.upcase!    # Modifies in place
str.reverse!   # Modifies in place
```

## Parallel Assignment

Ruby's parallel assignment is efficient and clean.

```ruby
# Slower
temp = a
a = b
b = temp

# Faster - no temp variable
a, b = b, a

# Multiple assignments
x, y, z = 1, 2, 3
first, *rest, last = array
```

## Use Each Instead of For

`each` is more idiomatic and slightly faster than `for`.

```ruby
items = [1, 2, 3, 4, 5]

# Slower and less idiomatic
for item in items
  puts item
end

# Faster and idiomatic
items.each do |item|
  puts item
end

# Even better with blocks
items.each { |item| puts item }
```

## Blocks vs Procs vs Lambdas

Blocks are fastest, use procs/lambdas only when needed.

```ruby
# Fastest - direct block
[1, 2, 3].map { |x| x * 2 }

# Slower - proc conversion
double = proc { |x| x * 2 }
[1, 2, 3].map(&double)

# Use lambdas when you need strict argument checking
multiply = ->(x, y) { x * y }
multiply.call(3, 4)  # => 12
```

## Avoid Unnecessary Object Creation

Reuse objects when possible.

```ruby
# Slower - creates objects repeatedly
1000.times do
  regex = /\A[a-z]+\z/
  "hello" =~ regex
end

# Faster - create once
regex = /\A[a-z]+\z/
1000.times do
  "hello" =~ regex
end

# Freeze constants
REGEX = /\A[a-z]+\z/.freeze
```

## Use Select/Reject Instead of Loops

Built-in enumerable methods are optimized.

```ruby
numbers = (1..1000).to_a

# Slower - manual loop
evens = []
numbers.each { |n| evens << n if n.even? }

# Faster - built-in method
evens = numbers.select(&:even?)

# Filter out values
odds = numbers.reject(&:even?)
```

## Memoization

Cache expensive calculations.

```ruby
# Without memoization - recalculates every time
class User
  def full_name
    expensive_database_call
  end
end

# With memoization - calculates once
class User
  def full_name
    @full_name ||= expensive_database_call
  end
end

# Memoization with false/nil handling
def expensive_operation
  return @result if defined?(@result)
  @result = calculate_result
end
```

## Use Appropriate Data Structures

Choose the right collection for your needs.

```ruby
# Array - ordered collection
items = [1, 2, 3]
items << 4              # Fast append
items.include?(2)       # Slow O(n) lookup

# Set - unique unordered collection
require 'set'
items = Set.new([1, 2, 3])
items.include?(2)       # Fast O(1) lookup

# Hash - key-value pairs
counts = Hash.new(0)
words.each { |word| counts[word] += 1 }
```

## Method Call Performance

Direct method calls are faster than send.

```ruby
# Faster - direct call
user.name

# Slower - dynamic dispatch
user.send(:name)
user.public_send(:name)

# Use direct calls in performance-critical loops
1000.times { user.name }  # Better
1000.times { user.send(:name) }  # Slower
```

## String Building

Use Array#join or String#<< for multiple concatenations.

```ruby
# Slow - creates new string each time
result = ""
1000.times { |i| result = result + i.to_s }

# Faster - mutates in place
result = ""
1000.times { |i| result << i.to_s }

# Fastest - join array
parts = []
1000.times { |i| parts << i.to_s }
result = parts.join
```

## Reduce Allocations in Loops

Avoid creating objects inside tight loops.

```ruby
# Slower - creates objects in loop
users.map { |u| { name: u.name, email: u.email } }

# Same performance but more readable
users.map { |u| { name: u.name, email: u.email } }

# For large datasets, consider lazy evaluation
(1..1_000_000).lazy.map { |n| n * 2 }.first(10)
```

## Use Fetch for Hash Access

`fetch` with default is faster than || for hash access.

```ruby
hash = { a: 1, b: 2 }

# Slower - evaluates default even if key exists
value = hash[:c] || "default"

# Faster - only evaluates default if needed
value = hash.fetch(:c, "default")

# Fetch with block (for expensive defaults)
value = hash.fetch(:c) { expensive_calculation }
```

## Lazy Evaluation

Use lazy for large collections to avoid intermediate arrays.

```ruby
# Creates intermediate arrays
result = (1..1_000_000)
  .map { |n| n * 2 }
  .select { |n| n > 100 }
  .first(10)

# No intermediate arrays - lazy evaluation
result = (1..1_000_000)
  .lazy
  .map { |n| n * 2 }
  .select { |n| n > 100 }
  .first(10)
```

## Use tap for Method Chaining

`tap` helps maintain readability without sacrificing performance.

```ruby
# Without tap
user = User.new
user.name = "Alice"
user.email = "alice@example.com"
user.save
user

# With tap - returns user
user = User.new.tap do |u|
  u.name = "Alice"
  u.email = "alice@example.com"
  u.save
end
```

## Avoid Regex When Simple String Methods Work

String methods are faster than regex for simple operations.

```ruby
# Slower - regex
string.match?(/^hello/)

# Faster - string method
string.start_with?("hello")

# Slower - regex
string.match?(/world$/)

# Faster - string method
string.end_with?("world")

# Slower - regex
string.match?(/substring/)

# Faster - string method
string.include?("substring")
```

## Use Struct for Simple Data Objects

Structs are faster and use less memory than full classes.

```ruby
# Slower - full class
class Point
  attr_accessor :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end
end

# Faster - Struct
Point = Struct.new(:x, :y)
point = Point.new(10, 20)

# Keyword arguments with Struct
Point = Struct.new(:x, :y, keyword_init: true)
point = Point.new(x: 10, y: 20)
```

## Batch Database Operations

Minimize database queries in loops.

```ruby
# Slow - N+1 queries
users.each do |user|
  puts user.posts.count  # Query per user
end

# Fast - eager loading
users.includes(:posts).each do |user|
  puts user.posts.count  # No additional queries
end

# Batch insert
User.insert_all([
  { name: "Alice", email: "alice@example.com" },
  { name: "Bob", email: "bob@example.com" }
])
```

## Use Count vs Size vs Length

Know the difference for collections.

```ruby
# Array
arr = [1, 2, 3]
arr.length  # Fast - O(1)
arr.size    # Alias of length
arr.count   # Slower - iterates (unless cached)

# ActiveRecord
User.count      # SQL COUNT query
users.length    # Loads all records then counts
users.size      # Smart: uses count if not loaded, length if loaded
```

## Freeze Constants

Frozen objects can't be modified and may enable optimizations.

```ruby
# Can be modified
CONSTANT = [1, 2, 3]
CONSTANT << 4  # Works but shouldn't

# Cannot be modified
CONSTANT = [1, 2, 3].freeze
CONSTANT << 4  # Raises FrozenError

# Freeze strings
GREETING = "Hello".freeze
```

## Key Takeaways

1. **Profile first** - Measure before optimizing
2. **Use symbols** - Faster than strings for keys
3. **Prefer built-in methods** - They're optimized
4. **Avoid object creation in loops** - Reuse when possible
5. **Use appropriate data structures** - Set for membership testing
6. **Memoize expensive operations** - Cache when appropriate
7. **Lazy evaluation** - For large datasets
8. **String interpolation** - Faster than concatenation
9. **Bang methods** - Modify in place when original not needed
10. **Readable code first** - Optimize only when necessary
