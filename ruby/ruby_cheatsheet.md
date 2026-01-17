# 💎 Ruby Language Cheat Sheet (In-Depth)

# Basic types available in Ruby, including numbers, text, collections, symbols, and ranges.

# Integer - whole numbers
```ruby
x = 42
puts x.class  # Integer
```

# Float - decimal numbers
```ruby
y = 3.14
puts y.class  # Float
```
# String - text
```ruby
name = "Alice"
puts name.upcase  # ALICE
```
# Boolean - true / false
```ruby
flag = true
puts flag.class  # TrueClass
```
# Array - ordered collection
```ruby
arr = [1,2,3]
arr.each { |i| puts i }
```
# Hash - key-value collection
```ruby
h = {a:1, b:2}
h.each { |k,v| puts "#{k}: #{v}" }
```
# Symbol - immutable identifier
```ruby
sym = :my_symbol
puts sym.class  # Symbol
```

# NilClass - nil / null
```ruby
n = nil
puts n.nil?  # true
```

# Range - sequence of values
```ruby
r = 1..5
r.each { |i| puts i }
```

## Variables & Assignments
# How to create and assign variables, multiple assignment, and constants.
# Local variable

```ruby
x = 10
y = 2.5
name = "Alice"
flag = true
```

# Multiple assignment
```ruby
a, b, c = 1, 2, 3
puts a, b, c
```
# Constants
```ruby
PI = 3.14
puts PI
```
## Control Flow
# Conditional statements and loops for controlling program flow.

# if / elsif / else
```ruby
x = 10
if x > 0
  puts "Positive"
elsif x < 0
  puts "Negative"
else
  puts "Zero"
end
```

# unless
```ruby
x = -1
unless x > 0
  puts "Non-positive"
end
```
# case / when
```ruby
x = 2
case x
when 1 then puts "One"
when 2 then puts "Two"
else puts "Other"
end
```

# for loop
```ruby
for i in 0..3
  puts i
end
```
# while loop
```ruby
count = 3
while count > 0
  puts count
  count -= 1
end
```
# break / next
```ruby
(1..5).each do |i|
  next if i == 2
  break if i == 4
  puts i
end
```
## Methods
# Defining reusable functions, with support for default, variable, and keyword arguments.

# Define method
```ruby
def add(a,b)
  a + b
end
puts add(3,4)
```
# Default args
```ruby
def greet(name="Guest")
  puts "Hello #{name}"
end
greet()
greet("Alice")
```
# Variable args
```ruby
def sum_all(*nums)
  nums.sum
end
puts sum_all(1,2,3,4)
```
# Keyword args
```ruby
def info(name:, age:)
  puts "#{name}, #{age}"
end
info(name:"Alice", age:30)
```
## Blocks, Procs & Lambdas
# Anonymous code blocks, stored procedures, lambdas, and yield for passing blocks into methods.
# Block
```ruby
[1,2,3].each do |i|
  puts i
end
```
# Proc
```ruby
p = Proc.new { |x| puts x*2 }
p.call(5)
```
# Lambda
```ruby
l = ->(x) { x*2 }
puts l.call(5)
```
# Yield
```ruby
def wrapper
  puts "Before"
  yield
  puts "After"
end
wrapper { puts "Hello" }
```
## Iterators & Enumerables
# Methods to iterate over collections, transform data, filter, and reduce values.
# each
```ruby
arr = [1,2,3]
arr.each { |x| puts x }
```
# map
```ruby
arr2 = arr.map { |x| x*2 }
puts arr2
```
# select / filter
```ruby
pos = arr.select { |x| x>0 }
puts pos
```
# reject
```ruby
arr2 = arr.reject { |x| x<0 }
puts arr2
```
# inject / reduce
```ruby
sum = arr.inject(0) { |acc, x| acc + x }
puts sum
```
# each_with_index
```ruby
arr = ["a","b","c"]
arr.each_with_index { |v,i| puts "#{i}: #{v}" }
```
## Classes & OOP
# Defining classes, creating instances, inheritance, class methods, and attributes.
# Class & instance
```ruby
class Person
  def initialize(name)
    @name = name
  end
end
p = Person.new("Alice")
```
# Instance methods
```ruby
class Person
  def greet
    puts "Hi #{@name}"
  end
end
p = Person.new("Alice")
p.greet
```
# Inheritance
```ruby
class Employee < Person
  def initialize(name, salary)
    super(name)
    @salary = salary
  end
end
e = Employee.new("Bob",5000)
```
# Class methods
```ruby
class MathUtils
  def self.square(x)
    x*x
  end
end
puts MathUtils.square(5)
```
## Attributes & Accessors
# Use attr_reader, attr_writer, attr_accessor to control access to instance variables
# attr_reader - creates a getter
# attr_writer - creates a setter
# attr_accessor - creates both getter and setter
```ruby
class Person
  # define getters and setters for age
  attr_accessor :age

  # define read-only attribute
  attr_reader :name

  # define write-only attribute
  attr_writer :password

  def initialize(name, age, password)
    @name = name
    @age = age
    @password = password
  end
end

p = Person.new("Alice", 30, "secret")
puts p.name   # read via attr_reader
p.age = 31    # write via attr_accessor
puts p.age    # read via attr_accessor
p.password = "new_secret"  # write via attr_writer
```
## Modules & Mixins
# Modules for grouping reusable code and mixins using include or extend.
# Module
```ruby
module Greetings
  def greet
    puts "Hello"
  end
end
```
# Include
```ruby
class Person
  include Greetings
end
p = Person.new
p.greet
```
# Extend
```ruby
module Utils
  def hello
    puts "Hi"
  end
end
class MyClass
  extend Utils
end
MyClass.hello
```
## Exception Handling
# How to handle errors using begin/rescue/ensure and raising exceptions.
# begin / rescue / ensure
```ruby
begin
  x = 1/0
rescue ZeroDivisionError => e
  puts "Error: #{e}"
ensure
  puts "Done"
end
```
# raise
```ruby
raise ArgumentError, "Invalid argument"
```
## Common Useful Methods
# Frequently used methods for output, input, type conversion, and collection manipulation.
# puts
```ruby
puts "Hello"
```
# p
```ruby
p [1,2,3]
```
# gets
```ruby
name = gets.chomp
puts "Hi #{name}"
```
# Type conversions
```ruby
x = "123"
puts x.to_i + 1
```
# is_a?
```ruby
x = 5
puts x.is_a?(Integer)
```
# respond_to?
```ruby
puts "".respond_to?(:upcase)
```
# range
```ruby
(1..5).each { |i| puts i }
```
# array methods
```ruby
arr = [1,2,3]
arr.push(4)
arr.pop
arr.shift
arr.unshift(0)
```
