## Symbols in Ruby

A symbol is like a lightweight string that starts with a colon `:`.
Symbols are immutable (cannot be changed) and are more memory efficient than strings.

### Creating symbols

```ruby
:my_symbol
:name
:user_id
:"with spaces"
```

### Symbol vs String

```ruby
# Strings - mutable, each creates new object
str1 = "hello"
str2 = "hello"
str1.object_id == str2.object_id  # false (different objects)

# Symbols - immutable, same symbol always has same object_id
sym1 = :hello
sym2 = :hello
sym1.object_id == sym2.object_id  # true (same object!)
```

### When to use symbols

**Use symbols for:**
- Hash keys
- Method names
- Constants/identifiers that don't change
- Anything that represents a name or label

```ruby
# Hash with symbol keys (recommended)
person = { name: "Alice", age: 30 }
person[:name]  # "Alice"

# Hash with string keys (less efficient)
person = { "name" => "Alice", "age" => 30 }
person["name"]  # "Alice"
```

### Converting between symbols and strings

```ruby
# Symbol to string
:hello.to_s      # "hello"

# String to symbol
"hello".to_sym   # :hello
"hello".intern   # :hello (same as to_sym)
```

### Symbol methods

```ruby
:hello.length          # 5
:hello.upcase          # :HELLO
:hello.capitalize      # :Hello
:hello.to_s.reverse    # "olleh"
```

### Symbols in case statements

```ruby
status = :active

case status
when :active
  puts "User is active"
when :inactive
  puts "User is inactive"
when :banned
  puts "User is banned"
end
```

### Common use cases

**Hash keys:**
```ruby
user = {
  name: "Bob",
  email: "bob@example.com",
  role: :admin
}
```

**Method arguments:**
```ruby
def send_email(to:, subject:, body:)
  # ...
end

send_email(to: "alice@example.com", subject: "Hello", body: "Hi there")
```

**Attribute accessors:**
```ruby
class Person
  attr_reader :name
  attr_accessor :age
end
```

### Memory efficiency

```ruby
# This creates 1000 different string objects
1000.times do
  puts "hello".object_id
end

# This uses the SAME symbol object 1000 times
1000.times do
  puts :hello.object_id
end
```

### Why symbols?

- **Immutable**: Cannot be changed
- **Unique**: Same symbol always has same object_id
- **Faster**: Comparison is faster than strings
- **Memory efficient**: Only one copy in memory
- **Readable**: Clear intent as identifiers
