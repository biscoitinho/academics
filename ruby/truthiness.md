## Truthiness in Ruby

Understanding true, false, and truthy/falsy values.

### Only two falsy values

In Ruby, only **two** values are falsy:
- `nil`
- `false`

Everything else is truthy!

```ruby
# Falsy
if nil
  puts "Won't print"
end

if false
  puts "Won't print"
end

# Truthy (everything else!)
if 0
  puts "Prints!"  # 0 is truthy in Ruby!
end

if ""
  puts "Prints!"  # Empty string is truthy!
end

if []
  puts "Prints!"  # Empty array is truthy!
end

if {}
  puts "Prints!"  # Empty hash is truthy!
end
```

### Ruby vs Other Languages

```ruby
# Ruby - 0 is truthy
puts "Yes" if 0           # Prints "Yes"

# Python/JavaScript - 0 is falsy
# puts "Yes" if 0         # Would NOT print

# Ruby - empty string is truthy
puts "Yes" if ""          # Prints "Yes"

# Python/JavaScript - empty string is falsy
# puts "Yes" if ""        # Would NOT print
```

### Checking for nil

```ruby
value = nil

# Check if nil
value.nil?                # true

# Check if not nil
!value.nil?               # false
value.present?            # Rails only
```

### Using || for default values

```ruby
# Only returns right side if left is nil or false
name = nil
name ||= "Guest"          # "Guest"

name = false
name ||= "Guest"          # "Guest"

name = 0
name ||= "Guest"          # 0 (not nil or false!)

name = ""
name ||= "Guest"          # "" (not nil or false!)
```

### Safe navigation operator

```ruby
user = nil

# Bad - raises error
user.address.city         # NoMethodError

# Good - returns nil safely
user&.address&.city       # nil
```

### Conditional assignment

```ruby
# Set only if currently nil or false
name ||= "Default"

# Always set
name = "Value"

# Set only if currently nil
name = "Default" if name.nil?
```

### Using presence (Rails)

```ruby
# Returns value if present, otherwise nil
name = "".presence        # nil
name = "Alice".presence   # "Alice"

# Useful for defaults
name = params[:name].presence || "Guest"
```

### Checking empty collections

```ruby
array = []

# Check if empty
array.empty?              # true
array.any?                # false

# Check if has elements
array.any?                # false
!array.empty?             # false
```

### Double negation trick

```ruby
# Convert to boolean
value = "hello"
!!value                   # true

value = nil
!!value                   # false

value = 0
!!value                   # true (0 is truthy!)
```

### Ternary operator

```ruby
# condition ? if_true : if_false
age = 18
status = age >= 18 ? "adult" : "minor"

# Can be truthy/falsy
value = nil
result = value ? "has value" : "no value"  # "no value"
```

### unless keyword

```ruby
# Opposite of if
unless condition
  # Runs if condition is falsy
end

# Same as
if !condition
  # Runs if condition is falsy
end

# Modifier form
do_something unless condition
```

### Combining conditions

```ruby
# && (and) - short-circuits on first falsy
result = true && false && true    # false
result = nil && puts("Won't run") # nil (doesn't execute puts)

# || (or) - short-circuits on first truthy
result = false || nil || "value"  # "value"
result = "first" || "second"      # "first"
```

### Practical examples

**Set default only if nil:**
```ruby
options = { timeout: 0 }
options[:timeout] ||= 30  # Still 0! (0 is truthy)

# Better for default:
options[:timeout] = 30 if options[:timeout].nil?
# or
options[:timeout] = options.fetch(:timeout, 30)
```

**Check if variable has been set:**
```ruby
if defined?(variable)
  puts "Variable exists"
end
```

**Safe hash access:**
```ruby
user = {}

# Bad - might be nil
city = user[:address][:city]  # Error!

# Good - returns nil safely
city = user.dig(:address, :city)  # nil

# With default
city = user.dig(:address, :city) || "Unknown"
```

**Guard clauses:**
```ruby
def process(user)
  return unless user          # Exit if nil
  return unless user.active?  # Exit if inactive
  
  # Process active user
end
```

**Checking for blank (Rails):**
```ruby
# blank? - true for nil, false, "", [], {}, and whitespace
"".blank?                     # true
"  ".blank?                   # true
[].blank?                     # true
nil.blank?                    # true
false.blank?                  # true

# present? - opposite of blank?
"hello".present?              # true
```

### Common pitfalls

```ruby
# Pitfall 1: 0 is truthy!
count = 0
if count
  puts "This prints!"         # Prints!
end

# Better: explicit check
if count > 0
  puts "Only prints if positive"
end

# Pitfall 2: Empty string is truthy!
name = ""
if name
  puts "This prints!"         # Prints!
end

# Better: check for empty
if !name.empty?
  puts "Has name"
end

# Pitfall 3: ||= with false
flag = false
flag ||= true                 # Sets to true! (false is falsy)
```

### Summary

**Falsy values (only 2):**
- `nil`
- `false`

**Truthy values (everything else):**
- `true`
- `0` (unlike Python/JavaScript!)
- `""` (unlike Python/JavaScript!)
- `[]` (unlike Python/JavaScript!)
- `{}` (unlike Python/JavaScript!)
- Any object
