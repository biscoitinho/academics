## Blocks, Procs & Lambdas

Three ways to create reusable chunks of code in Ruby.

### Blocks

Blocks are chunks of code enclosed in `{}` or `do...end`.
Blocks are NOT objects - they're just syntax.

```ruby
# Single line with {}
[1, 2, 3].each { |num| puts num }

# Multiple lines with do...end
[1, 2, 3].each do |num|
  puts num * 2
end
```

### Using yield with blocks

```ruby
def greet
  puts "Before"
  yield
  puts "After"
end

greet { puts "Hello!" }
# Output:
# Before
# Hello!
# After

# With parameters
def greet_with_name
  yield("Alice")
end

greet_with_name { |name| puts "Hello, #{name}!" }
# Hello, Alice!
```

### Check if block given

```ruby
def maybe_yield
  if block_given?
    yield
  else
    puts "No block provided"
  end
end

maybe_yield { puts "Block!" }  # Block!
maybe_yield                     # No block provided
```

### Procs

Proc (procedure) is a block wrapped in an object.
Can be stored in variables and passed around.

```ruby
# Creating a Proc
my_proc = Proc.new { |x| puts x * 2 }

# Calling a Proc
my_proc.call(5)     # 10
my_proc.(5)         # 10 (alternate syntax)
my_proc[5]          # 10 (alternate syntax)
```

### Passing Proc to methods

```ruby
def run_proc(p)
  p.call
end

my_proc = Proc.new { puts "Hello from Proc!" }
run_proc(my_proc)
```

### Converting block to Proc

```ruby
def use_proc(&block)
  # & converts block to Proc
  block.call
  block.call
end

use_proc { puts "Called!" }
# Called!
# Called!
```

### Lambdas

Lambda is a special type of Proc with stricter behavior.

```ruby
# Creating lambdas
my_lambda = lambda { |x| x * 2 }
my_lambda = ->(x) { x * 2 }  # Shorthand (stabby lambda)

# Calling lambdas
my_lambda.call(5)   # 10
my_lambda.(5)       # 10
my_lambda[5]        # 10
```

### Proc vs Lambda: Key Differences

#### 1. Return behavior

```ruby
# Proc - returns from enclosing method
def proc_test
  my_proc = Proc.new { return "Proc return" }
  my_proc.call
  return "Method return"  # Never reached!
end
puts proc_test  # "Proc return"

# Lambda - returns from lambda itself
def lambda_test
  my_lambda = lambda { return "Lambda return" }
  my_lambda.call
  return "Method return"  # This IS reached
end
puts lambda_test  # "Method return"
```

#### 2. Argument checking

```ruby
# Proc - flexible with arguments
my_proc = Proc.new { |a, b| puts "a=#{a}, b=#{b}" }
my_proc.call(1)       # a=1, b= (no error)
my_proc.call(1, 2, 3) # a=1, b=2 (ignores extra)

# Lambda - strict with arguments
my_lambda = lambda { |a, b| puts "a=#{a}, b=#{b}" }
my_lambda.call(1)       # ArgumentError!
my_lambda.call(1, 2, 3) # ArgumentError!
my_lambda.call(1, 2)    # Works fine
```

### When to use what?

**Blocks:**
- One-time use with methods
- Iterating over collections
- Standard Ruby idiom

**Procs:**
- Need to store code for later use
- Want flexible argument handling
- Callback functions

**Lambdas:**
- Want strict argument checking
- Need proper return behavior
- More function-like behavior

### Practical examples

**Using blocks for iteration:**
```ruby
[1, 2, 3].map { |n| n * 2 }        # [2, 4, 6]
[1, 2, 3].select { |n| n > 1 }     # [2, 3]
[1, 2, 3].reduce(0) { |sum, n| sum + n }  # 6
```

**Storing Procs:**
```ruby
operations = {
  add: Proc.new { |a, b| a + b },
  multiply: Proc.new { |a, b| a * b }
}

operations[:add].call(5, 3)      # 8
operations[:multiply].call(5, 3) # 15
```

**Using lambdas for callbacks:**
```ruby
class Button
  def initialize(label, &on_click)
    @label = label
    @on_click = on_click
  end
  
  def click
    @on_click.call
  end
end

button = Button.new("Submit") { puts "Form submitted!" }
button.click  # Form submitted!
```

### Quick comparison table

| Feature | Block | Proc | Lambda |
|---------|-------|------|--------|
| Is an object? | No | Yes | Yes |
| Flexible args? | N/A | Yes | No |
| Return behavior | N/A | Returns from method | Returns from lambda |
| Can store in variable? | No | Yes | Yes |
| Strict syntax? | N/A | No | Yes |
