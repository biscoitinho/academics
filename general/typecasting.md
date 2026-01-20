# Typecasting and Type Conversion

## Concepts

**Type Casting**: Explicit conversion between types
**Type Coercion**: Implicit/automatic conversion
**Type Conversion**: General term for changing types

## Python Type Conversion

### String to Number

```python
# String to int
s = "123"
n = int(s)
print(n)  # 123
print(type(n))  # <class 'int'>

# String to float
s = "3.14"
f = float(s)
print(f)  # 3.14

# Invalid conversion
try:
    n = int("abc")
except ValueError as e:
    print(f"Error: {e}")  # invalid literal for int()

# With base
binary = "1010"
n = int(binary, 2)
print(n)  # 10

hex_str = "FF"
n = int(hex_str, 16)
print(n)  # 255
```

### Number to String

```python
# Int to string
n = 123
s = str(n)
print(s)  # "123"
print(type(s))  # <class 'str'>

# Float to string
f = 3.14
s = str(f)
print(s)  # "3.14"

# Formatting
n = 42
s = f"The answer is {n}"
print(s)  # "The answer is 42"

# Number bases
n = 255
print(bin(n))  # "0b11111111"
print(oct(n))  # "0o377"
print(hex(n))  # "0xff"
```

### Float to Int

```python
# Truncates (removes decimal)
f = 3.14
n = int(f)
print(n)  # 3

f = 3.99
n = int(f)
print(n)  # 3 (not 4!)

# Rounding
import math

print(round(3.14))  # 3
print(round(3.5))   # 4
print(round(3.6))   # 4

print(math.floor(3.9))  # 3
print(math.ceil(3.1))   # 4
```

### Int to Float

```python
n = 42
f = float(n)
print(f)  # 42.0
print(type(f))  # <class 'float'>
```

### Boolean Conversion

```python
# To boolean
print(bool(0))      # False
print(bool(1))      # True
print(bool(-1))     # True
print(bool(""))     # False
print(bool("text")) # True
print(bool([]))     # False
print(bool([1]))    # True
print(bool(None))   # False

# From boolean
print(int(True))   # 1
print(int(False))  # 0
print(str(True))   # "True"
```

### List/Tuple/Set Conversion

```python
# List to tuple
lst = [1, 2, 3]
tpl = tuple(lst)
print(tpl)  # (1, 2, 3)

# Tuple to list
tpl = (1, 2, 3)
lst = list(tpl)
print(lst)  # [1, 2, 3]

# List to set (removes duplicates)
lst = [1, 2, 2, 3, 3, 3]
s = set(lst)
print(s)  # {1, 2, 3}

# Set to list
s = {3, 1, 2}
lst = list(s)
print(lst)  # [1, 2, 3] (sorted)

# String to list
s = "hello"
lst = list(s)
print(lst)  # ['h', 'e', 'l', 'l', 'o']

# List to string
lst = ['h', 'e', 'l', 'l', 'o']
s = ''.join(lst)
print(s)  # "hello"
```

### Dictionary Conversion

```python
# List of tuples to dict
pairs = [('a', 1), ('b', 2)]
d = dict(pairs)
print(d)  # {'a': 1, 'b': 2}

# Dict to list of tuples
d = {'a': 1, 'b': 2}
pairs = list(d.items())
print(pairs)  # [('a', 1), ('b', 2)]

# Keys/values to list
keys = list(d.keys())    # ['a', 'b']
values = list(d.values()) # [1, 2]
```

### Bytes Conversion

```python
# String to bytes
s = "hello"
b = s.encode('utf-8')
print(b)  # b'hello'
print(type(b))  # <class 'bytes'>

# Bytes to string
b = b'hello'
s = b.decode('utf-8')
print(s)  # "hello"

# Int to bytes
n = 255
b = n.to_bytes(2, byteorder='big')
print(b)  # b'\x00\xff'

# Bytes to int
b = b'\x00\xff'
n = int.from_bytes(b, byteorder='big')
print(n)  # 255
```

## Ruby Type Conversion

### String to Number

```ruby
# String to integer
s = "123"
n = s.to_i
puts n  # 123
puts n.class  # Integer

# String to float
s = "3.14"
f = s.to_f
puts f  # 3.14

# Invalid conversion
s = "abc"
n = s.to_i
puts n  # 0 (doesn't raise error!)

# With base
binary = "1010"
n = binary.to_i(2)
puts n  # 10

hex_str = "FF"
n = hex_str.to_i(16)
puts n  # 255
```

### Number to String

```ruby
# Integer to string
n = 123
s = n.to_s
puts s  # "123"
puts s.class  # String

# Float to string
f = 3.14
s = f.to_s
puts s  # "3.14"

# String interpolation
n = 42
s = "The answer is #{n}"
puts s  # "The answer is 42"

# Number bases
n = 255
puts n.to_s(2)   # "11111111"
puts n.to_s(8)   # "377"
puts n.to_s(16)  # "ff"
```

### Float to Int

```ruby
# Truncates
f = 3.14
n = f.to_i
puts n  # 3

f = 3.99
n = f.to_i
puts n  # 3

# Rounding
puts 3.14.round  # 3
puts 3.5.round   # 4
puts 3.6.round   # 4

puts 3.9.floor   # 3
puts 3.1.ceil    # 4
```

### Int to Float

```ruby
n = 42
f = n.to_f
puts f  # 42.0
puts f.class  # Float
```

### Array/Hash Conversion

```ruby
# Array to set
arr = [1, 2, 2, 3]
require 'set'
s = arr.to_set
puts s.inspect  # #<Set: {1, 2, 3}>

# Hash to array
h = {a: 1, b: 2}
arr = h.to_a
puts arr.inspect  # [[:a, 1], [:b, 2]]

# Array to hash
arr = [[:a, 1], [:b, 2]]
h = arr.to_h
puts h.inspect  # {:a=>1, :b=>2}
```

### Symbol Conversion

```ruby
# String to symbol
s = "hello"
sym = s.to_sym
puts sym.inspect  # :hello

# Symbol to string
sym = :hello
s = sym.to_s
puts s  # "hello"
```

## Type Coercion (Implicit Conversion)

### JavaScript (for comparison)

```javascript
// JavaScript has aggressive type coercion
"5" + 3      // "53" (string concatenation)
"5" - 3      // 2 (numeric subtraction)
"5" * "2"    // 10 (numeric multiplication)
true + 1     // 2
false + 1    // 1
```

### Python (Explicit Only)

```python
# Python requires explicit conversion
"5" + 3  # TypeError!
int("5") + 3  # 8 (correct)

# Some automatic coercion
1 + 2.5  # 3.5 (int promoted to float)
True + 1  # 2 (bool is subclass of int)
```

### Ruby (Some Coercion)

```ruby
# Ruby requires explicit conversion
"5" + 3  # TypeError!
"5".to_i + 3  # 8

# Automatic coercion
1 + 2.5  # 3.5 (int to float)
```

## Type Checking

### Python

```python
# Check type
x = 42
print(type(x))  # <class 'int'>
print(isinstance(x, int))  # True

# Multiple types
print(isinstance(x, (int, float)))  # True

# Check if numeric
import numbers
print(isinstance(42, numbers.Number))  # True
print(isinstance(3.14, numbers.Number))  # True
```

### Ruby

```ruby
# Check type
x = 42
puts x.class  # Integer
puts x.is_a?(Integer)  # true
puts x.kind_of?(Numeric)  # true

# Multiple types
puts x.is_a?(Integer) || x.is_a?(Float)  # true
```

## Safe Conversion

### Python

```python
# Try-except for safe conversion
def safe_int(value, default=0):
    try:
        return int(value)
    except (ValueError, TypeError):
        return default

print(safe_int("123"))    # 123
print(safe_int("abc"))    # 0
print(safe_int("abc", -1))  # -1
```

```ruby
# Ruby with rescue
def safe_int(value, default = 0)
  Integer(value)
rescue ArgumentError, TypeError
  default
end

puts safe_int("123")  # 123
puts safe_int("abc")  # 0
```

## Parsing Complex Strings

### Python

```python
import json

# JSON string to dict
json_str = '{"name": "John", "age": 30}'
data = json.loads(json_str)
print(data)  # {'name': 'John', 'age': 30}

# Dict to JSON string
data = {'name': 'John', 'age': 30}
json_str = json.dumps(data)
print(json_str)  # '{"name": "John", "age": 30}'

# CSV
import csv
import io

csv_str = "name,age\nJohn,30\nAlice,25"
reader = csv.DictReader(io.StringIO(csv_str))
for row in reader:
    print(row)  # {'name': 'John', 'age': '30'}
```

### Ruby

```ruby
require 'json'

# JSON string to hash
json_str = '{"name": "John", "age": 30}'
data = JSON.parse(json_str)
puts data.inspect  # {"name"=>"John", "age"=>30}

# Hash to JSON string
data = {name: "John", age: 30}
json_str = JSON.generate(data)
puts json_str  # '{"name":"John","age":30}'
```

## Date/Time Conversion

### Python

```python
from datetime import datetime

# String to datetime
s = "2024-01-15 10:30:00"
dt = datetime.strptime(s, "%Y-%m-%d %H:%M:%S")
print(dt)

# Datetime to string
dt = datetime.now()
s = dt.strftime("%Y-%m-%d %H:%M:%S")
print(s)  # "2024-01-15 10:30:00"

# Timestamp
timestamp = dt.timestamp()  # Float
dt2 = datetime.fromtimestamp(timestamp)
```

### Ruby

```ruby
require 'time'

# String to time
s = "2024-01-15 10:30:00"
t = Time.parse(s)
puts t

# Time to string
t = Time.now
s = t.strftime("%Y-%m-%d %H:%M:%S")
puts s

# Timestamp
timestamp = t.to_i
t2 = Time.at(timestamp)
```

## Custom Type Conversion

### Python

```python
class Distance:
    def __init__(self, meters):
        self.meters = meters

    def __int__(self):
        return int(self.meters)

    def __float__(self):
        return float(self.meters)

    def __str__(self):
        return f"{self.meters}m"

d = Distance(100.5)
print(int(d))    # 100
print(float(d))  # 100.5
print(str(d))    # "100.5m"
```

### Ruby

```ruby
class Distance
  def initialize(meters)
    @meters = meters
  end

  def to_i
    @meters.to_i
  end

  def to_f
    @meters.to_f
  end

  def to_s
    "#{@meters}m"
  end
end

d = Distance.new(100.5)
puts d.to_i  # 100
puts d.to_f  # 100.5
puts d.to_s  # "100.5m"
```

## Numeric Type Promotion

```python
# Python automatically promotes to prevent data loss
a = 5       # int
b = 2.5     # float
c = a + b   # 7.5 (float)

# Complex numbers
a = 2 + 3j
b = 1 + 0j
c = a + b  # (3+3j)
```

## String Formatting and Conversion

### Python

```python
# F-strings
name = "Alice"
age = 30
s = f"Name: {name}, Age: {age}"

# Format with padding
n = 42
s = f"{n:05d}"  # "00042"

# Float precision
f = 3.14159
s = f"{f:.2f}"  # "3.14"

# Percentage
f = 0.856
s = f"{f:.1%}"  # "85.6%"
```

### Ruby

```ruby
# String interpolation
name = "Alice"
age = 30
s = "Name: #{name}, Age: #{age}"

# Format with padding
n = 42
s = "%05d" % n  # "00042"

# Float precision
f = 3.14159
s = "%.2f" % f  # "3.14"
```

## Common Pitfalls

```python
# 1. Integer division in Python 2 vs 3
# Python 3:
print(5 / 2)   # 2.5 (float)
print(5 // 2)  # 2 (int)

# 2. String + Number
# Python:
"Age: " + str(25)  # Must convert

# 3. Comparing different types
# Python 3:
# 5 < "10"  # TypeError!

# 4. Float precision
print(0.1 + 0.2 == 0.3)  # False!
print(round(0.1 + 0.2, 1) == 0.3)  # True

# 5. None/nil conversion
print(int(None))  # TypeError!
print(bool(None))  # False
```

```ruby
# String + Number
"Age: " + 25.to_s  # Must convert

# Nil conversion
nil.to_i  # 0
nil.to_s  # ""
nil.to_a  # []
```

## Type Annotations (Python 3.5+)

```python
# Type hints (not enforced at runtime)
def greet(name: str) -> str:
    return f"Hello, {name}"

def add(a: int, b: int) -> int:
    return a + b

# Union types
from typing import Union

def process(value: Union[int, str]) -> str:
    if isinstance(value, int):
        return str(value)
    return value

# Optional (can be None)
from typing import Optional

def find_user(id: int) -> Optional[str]:
    if id == 1:
        return "Alice"
    return None
```

## Best Practices

```python
# 1. Be explicit
value = int(input("Enter number: "))  # Clear conversion

# 2. Validate before converting
def safe_convert(value):
    if not isinstance(value, str):
        raise TypeError("Expected string")
    if not value.isdigit():
        raise ValueError("Not a valid number")
    return int(value)

# 3. Use appropriate types
# Don't use string when you need number

# 4. Handle errors
try:
    n = int(user_input)
except ValueError:
    print("Invalid number")

# 5. Document expected types
def calculate_area(width: float, height: float) -> float:
    """Calculate area of rectangle."""
    return width * height
```
