## Hash Methods in Ruby

Hashes are key-value pairs (like dictionaries in Python).

### Creating hashes

```ruby
# With symbol keys (modern syntax)
person = { name: "Alice", age: 30 }

# With hash rocket =>
person = { :name => "Alice", :age => 30 }

# Mixed keys (strings and symbols)
mixed = { "name" => "Alice", :age => 30 }

# Empty hash
empty = {}
empty = Hash.new
```

### Accessing values

```ruby
person = { name: "Alice", age: 30 }

# Using []
person[:name]           # "Alice"
person[:city]           # nil

# Using fetch (with default)
person.fetch(:name)     # "Alice"
person.fetch(:city, "NYC")  # "NYC" (default value)

# Using dig (nested access)
data = { user: { name: "Alice" } }
data.dig(:user, :name)  # "Alice"
data.dig(:user, :age)   # nil
```

### Adding/updating values

```ruby
person = { name: "Alice" }

# Add new key-value
person[:age] = 30
person[:city] = "NYC"

# Update existing
person[:age] = 31

# Using store
person.store(:email, "alice@example.com")

# Merge (creates new hash)
person.merge({ city: "LA", age: 32 })

# Merge! (modifies original)
person.merge!({ city: "LA" })
```

### Removing values

```ruby
person = { name: "Alice", age: 30, city: "NYC" }

# Delete by key
person.delete(:age)     # Returns 30

# Delete if condition met
person.delete_if { |k, v| v == "NYC" }

# Keep only if condition met
person.keep_if { |k, v| k == :name }

# Remove all
person.clear
```

### Checking keys/values

```ruby
person = { name: "Alice", age: 30 }

# Check key exists
person.key?(:name)      # true
person.has_key?(:name)  # true (same)

# Check value exists
person.value?("Alice")  # true
person.has_value?(30)   # true (same)

# Check if empty
person.empty?           # false
```

### Getting keys and values

```ruby
person = { name: "Alice", age: 30, city: "NYC" }

# All keys
person.keys             # [:name, :age, :city]

# All values
person.values           # ["Alice", 30, "NYC"]

# Key-value pairs
person.to_a             # [[:name, "Alice"], [:age, 30], [:city, "NYC"]]
```

### Iterating

```ruby
person = { name: "Alice", age: 30 }

# Each key-value pair
person.each { |key, value| puts "#{key}: #{value}" }

# Each key
person.each_key { |key| puts key }

# Each value
person.each_value { |value| puts value }

# Map (transform to array)
person.map { |k, v| "#{k}=#{v}" }  # ["name=Alice", "age=30"]
```

### Transforming hashes

```ruby
person = { name: "Alice", age: 30 }

# Transform keys
person.transform_keys { |k| k.to_s }  # {"name" => "Alice", "age" => 30}

# Transform values
person.transform_values { |v| v.to_s }  # {name: "Alice", age: "30"}

# Select pairs
person.select { |k, v| v.is_a?(String) }  # {name: "Alice"}

# Reject pairs
person.reject { |k, v| k == :age }  # {name: "Alice"}

# Invert (swap keys and values)
person.invert           # {"Alice" => :name, 30 => :age}
```

### Combining hashes

```ruby
hash1 = { a: 1, b: 2 }
hash2 = { b: 3, c: 4 }

# Merge (hash2 wins on conflicts)
hash1.merge(hash2)      # {a: 1, b: 3, c: 4}

# Merge with block (custom conflict resolution)
hash1.merge(hash2) { |key, old_val, new_val| old_val + new_val }
# {a: 1, b: 5, c: 4}
```

### Default values

```ruby
# Default value for missing keys
hash = Hash.new(0)
hash[:count] += 1       # Works! (starts at 0)

# Default block
hash = Hash.new { |h, k| h[k] = [] }
hash[:items] << "first"
hash[:items]            # ["first"]
```

### Converting

```ruby
# Array to hash
[[:a, 1], [:b, 2]].to_h  # {a: 1, b: 2}

# Hash to array
{a: 1, b: 2}.to_a        # [[:a, 1], [:b, 2]]
```

### Size and counting

```ruby
person = { name: "Alice", age: 30 }

person.size             # 2
person.length           # 2 (same as size)
person.count            # 2 (same as size)
```

### Comparison

```ruby
hash1 = { a: 1, b: 2 }
hash2 = { b: 2, a: 1 }

hash1 == hash2          # true (order doesn't matter)
```

### Nested hashes

```ruby
user = {
  name: "Alice",
  address: {
    city: "NYC",
    zip: "10001"
  }
}

# Access nested values
user[:address][:city]   # "NYC"
user.dig(:address, :city)  # "NYC" (safer)
user.dig(:address, :country)  # nil (no error)
```

### Useful patterns

**Counting occurrences:**
```ruby
words = ["apple", "banana", "apple", "cherry", "banana", "apple"]
count = Hash.new(0)
words.each { |word| count[word] += 1 }
# {apple: 3, banana: 2, cherry: 1}
```

**Grouping:**
```ruby
people = [
  { name: "Alice", age: 30 },
  { name: "Bob", age: 25 },
  { name: "Charlie", age: 30 }
]

people.group_by { |p| p[:age] }
# {30 => [{name: "Alice", age: 30}, {name: "Charlie", age: 30}],
#  25 => [{name: "Bob", age: 25}]}
```

**Filter by value type:**
```ruby
mixed = { a: 1, b: "hello", c: 2, d: "world" }
mixed.select { |k, v| v.is_a?(String) }  # {b: "hello", d: "world"}
```

**Get first/last pair:**
```ruby
hash = { a: 1, b: 2, c: 3 }
hash.first          # [:a, 1]
hash.first(2)       # [[:a, 1], [:b, 2]]
```

**Compact (remove nil values):**
```ruby
hash = { a: 1, b: nil, c: 3 }
hash.compact        # {a: 1, c: 3}
```
