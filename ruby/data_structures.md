## Ruby Data Structures - Mutability and Usage Guide

Complete guide to Ruby's data structures, their mutability, and when to use each.

### Immutable Data Types

Data that **cannot be changed** after creation.

#### Numbers (Integer, Float)

```ruby
x = 5
x.object_id  # 11

x = 10
x.object_id  # 21 (different object!)

# Numbers are immutable - operations create new objects
a = 5
b = a + 3   # Creates new Integer (8)
# 'a' is still 5
```

**When to use:**
- Mathematical calculations
- Counters, indices
- IDs, timestamps

#### Symbols

```ruby
sym = :hello
sym.object_id  # 1234567

# Same symbol always has same object_id
:hello.object_id  # 1234567 (same!)

# Cannot modify a symbol
sym.upcase!  # Error! Symbols are immutable
```

**When to use:**
- Hash keys (most common)
- Method names
- Constants/identifiers
- Status flags (`:active`, `:pending`)
- Anything that represents a name or label

```ruby
# Good - symbols as hash keys
user = { name: "Alice", role: :admin }

# Good - status flags
order.status = :pending
```

#### true, false, nil

```ruby
# Singleton objects - only one instance exists
true.object_id   # Always 20
false.object_id  # Always 0
nil.object_id    # Always 8
```

**When to use:**
- Boolean flags
- Null/absence of value (nil)

#### Frozen Strings

```ruby
immutable_str = "hello".freeze
immutable_str.upcase!  # Error! FrozenError

# Check if frozen
immutable_str.frozen?  # true

# Frozen string literal (Ruby 3.0+)
# frozen_string_literal: true
str = "hello"  # Automatically frozen
```

**When to use:**
- Constants that shouldn't change
- Hash keys (frozen strings)
- Configuration values

#### Ranges

```ruby
range = (1..10)
# Cannot modify range endpoints

# But can iterate
range.each { |n| puts n }
```

**When to use:**
- Iterations (1..100)
- Slice operations
- Case statements
- Checking inclusion (`age.in?(18..65)`)

### Mutable Data Types

Data that **can be changed** after creation.

#### Strings

```ruby
str = "hello"
str.object_id  # 12345

str.upcase!    # Modifies in place
str            # "HELLO"
str.object_id  # 12345 (same object!)

# Creates new string
new_str = str.upcase  # "HELLO"
new_str.object_id     # Different!
```

**Methods that modify in place (!):**
```ruby
str.upcase!
str.downcase!
str.reverse!
str.gsub!(/o/, "0")
str.strip!
str.concat!("world")
str << "world"  # Same as concat
```

**When to use:**
- Text processing
- User input
- File content
- Templates

**Best practices:**
```ruby
# Use immutable operations when possible
name = name.upcase  # Creates new string

# Use ! methods when memory is concern
big_string.downcase!  # Modifies in place

# Use frozen strings for constants
GREETING = "Hello".freeze
```

#### Arrays

```ruby
arr = [1, 2, 3]
arr.object_id  # 12345

arr << 4       # Modifies in place
arr            # [1, 2, 3, 4]
arr.object_id  # 12345 (same object!)
```

**Mutating methods:**
```ruby
arr.push(4)         # Add to end
arr << 5            # Add to end
arr.pop             # Remove from end
arr.shift           # Remove from start
arr.unshift(0)      # Add to start
arr.delete_at(1)    # Delete at index
arr.delete(3)       # Delete by value
arr.clear           # Remove all
arr.sort!           # Sort in place
arr.reverse!        # Reverse in place
arr.map! { |x| x * 2 }  # Transform in place
```

**Non-mutating methods (return new array):**
```ruby
arr.map { |x| x * 2 }
arr.select { |x| x > 2 }
arr.reject { |x| x > 2 }
arr + [6, 7]
arr - [2, 3]
arr.sort
arr.reverse
```

**When to use:**
- Ordered collections
- Lists of items
- Stacks (push/pop)
- Queues (push/shift)
- Iteration over elements

**Best practices:**
```ruby
# Use dup/clone to avoid modifying original
original = [1, 2, 3]
copy = original.dup
copy << 4
# original is still [1, 2, 3]

# Freeze to make immutable
frozen_arr = [1, 2, 3].freeze
frozen_arr << 4  # Error!
```

#### Hashes

```ruby
hash = { a: 1, b: 2 }
hash.object_id  # 12345

hash[:c] = 3   # Modifies in place
hash           # { a: 1, b: 2, c: 3 }
hash.object_id # 12345 (same object!)
```

**Mutating methods:**
```ruby
hash[:key] = value      # Add/update
hash.merge!({ c: 3 })   # Merge in place
hash.delete(:a)         # Remove key
hash.delete_if { |k,v| v > 2 }
hash.keep_if { |k,v| v > 2 }
hash.clear              # Remove all
```

**Non-mutating methods:**
```ruby
hash.merge({ c: 3 })    # Returns new hash
hash.select { |k,v| v > 1 }
hash.reject { |k,v| v > 1 }
hash.transform_values { |v| v * 2 }
```

**When to use:**
- Key-value pairs
- Configuration options
- Lookup tables
- JSON-like data structures
- Named parameters

**Best practices:**
```ruby
# Use symbols for keys (better performance)
user = { name: "Alice", age: 30 }

# Use fetch with defaults
user.fetch(:city, "Unknown")

# Freeze for constants
CONFIG = { api_url: "..." }.freeze

# Use dig for nested access
data.dig(:user, :address, :city)
```

#### Sets

```ruby
require 'set'

set = Set.new([1, 2, 3])
set.add(4)        # Modifies in place
set << 5          # Modifies in place
set.delete(2)     # Modifies in place
```

**When to use:**
- Unique collections
- Fast membership testing
- Mathematical set operations (union, intersection)
- Removing duplicates

```ruby
# Fast membership check - O(1)
set = Set.new([1, 2, 3, 4, 5])
set.include?(3)  # true (very fast)

# Remove duplicates
arr = [1, 2, 2, 3, 3, 3]
unique = Set.new(arr).to_a  # [1, 2, 3]

# Set operations
set1 = Set.new([1, 2, 3])
set2 = Set.new([2, 3, 4])

set1 | set2  # Union: [1, 2, 3, 4]
set1 & set2  # Intersection: [2, 3]
set1 - set2  # Difference: [1]
```

### Comparison Table

| Type | Mutable? | Use Case | Performance |
|------|----------|----------|-------------|
| Integer | ❌ No | Math, counters, IDs | O(1) operations |
| Float | ❌ No | Decimals, calculations | O(1) operations |
| Symbol | ❌ No | Hash keys, identifiers | O(1) equality |
| String | ✅ Yes* | Text, input, content | Varies |
| Array | ✅ Yes | Ordered lists | Access: O(1), Search: O(n) |
| Hash | ✅ Yes | Key-value pairs | Access: O(1) |
| Set | ✅ Yes | Unique items | Membership: O(1) |
| Range | ❌ No | Sequences, iteration | Memory efficient |

*Strings can be frozen to make immutable

### When to Choose Each Data Structure

#### Use **Array** when:
- Order matters
- Need indexed access
- Have duplicates
- Iterating sequentially
- Implementing stack/queue

```ruby
# Order matters
steps = ["login", "select item", "checkout"]

# Stack (LIFO)
stack = []
stack.push(1)
stack.pop

# Queue (FIFO)
queue = []
queue.push(1)
queue.shift
```

#### Use **Hash** when:
- Need key-value pairs
- Fast lookup by key
- Storing attributes/properties
- Configuration data

```ruby
# User attributes
user = { 
  id: 1, 
  name: "Alice", 
  email: "alice@example.com" 
}

# Counting occurrences
word_count = {}
words.each { |word| word_count[word] = (word_count[word] || 0) + 1 }
```

#### Use **Set** when:
- Need unique values only
- Fast membership testing
- Mathematical set operations
- Don't care about order

```ruby
# Unique visitors
visitors = Set.new
visitors.add(user.id)

# Fast lookup
allowed_roles = Set.new([:admin, :moderator, :user])
allowed_roles.include?(current_user.role)
```

#### Use **Symbol** when:
- Hash keys
- Constants/identifiers
- Method names
- Status flags

```ruby
# Hash keys
person = { name: "Alice", age: 30 }

# Status
order.status = :pending
```

#### Use **Range** when:
- Need sequence of numbers
- Slicing arrays
- Iteration with bounds
- Checking inclusion

```ruby
# Iteration
(1..10).each { |n| puts n }

# Slicing
arr[0..5]

# Checking bounds
age.in?(18..65)
```

### Memory Efficiency Tips

```ruby
# Use symbols for repeated strings
# Bad - creates new string each time
users.each { |u| u["name"] }  # 1000 strings created

# Good - reuses same symbol
users.each { |u| u[:name] }   # 1 symbol reused

# Freeze strings to prevent copies
GREETING = "Hello".freeze

# Use ranges instead of arrays for sequences
# Bad - creates array in memory
(1..1000000).to_a.each { |n| ... }

# Good - iterates without array
(1..1000000).each { |n| ... }

# Reuse objects instead of creating new ones
# Bad
def process
  config = { timeout: 30 }  # New hash each call
end

# Good
CONFIG = { timeout: 30 }.freeze
def process
  CONFIG  # Reuse same hash
end
```

### Making Objects Immutable

```ruby
# Freeze to prevent modifications
arr = [1, 2, 3].freeze
arr << 4  # Error!

hash = { a: 1 }.freeze
hash[:b] = 2  # Error!

# Deep freeze (freeze nested objects)
def deep_freeze(obj)
  obj.freeze
  obj.each_value { |v| deep_freeze(v) } if obj.is_a?(Hash)
  obj.each { |v| deep_freeze(v) } if obj.is_a?(Array)
end

data = { users: [{ name: "Alice" }] }
deep_freeze(data)
```

### Performance Characteristics

```ruby
# Array
arr = [1, 2, 3, 4, 5]
arr[2]           # O(1) - index access
arr.include?(3)  # O(n) - linear search
arr << 6         # O(1) - append

# Hash
hash = { a: 1, b: 2, c: 3 }
hash[:b]         # O(1) - lookup
hash[:d] = 4     # O(1) - insert

# Set
set = Set.new([1, 2, 3, 4, 5])
set.include?(3)  # O(1) - membership
set.add(6)       # O(1) - insert
```

### Common Patterns

**Converting between types:**
```ruby
# Array to Set
Set.new([1, 2, 2, 3])  # Set[1, 2, 3]

# Set to Array
set.to_a

# Array to Hash
[[:a, 1], [:b, 2]].to_h  # { a: 1, b: 2 }

# Hash to Array
{ a: 1, b: 2 }.to_a  # [[:a, 1], [:b, 2]]

# String to Symbol
"hello".to_sym  # :hello

# Symbol to String
:hello.to_s     # "hello"
```

**Safe copying:**
```ruby
# Shallow copy
arr_copy = arr.dup
hash_copy = hash.dup

# Deep copy (for nested structures)
require 'json'
deep_copy = JSON.parse(data.to_json)

# Or use Marshal
deep_copy = Marshal.load(Marshal.dump(data))
```
