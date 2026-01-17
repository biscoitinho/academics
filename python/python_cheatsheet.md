# Python Language Cheatsheet

Quick reference for Python fundamentals.

## Variables and Data Types

```python
# Variables (no declaration needed)
name = "Alice"
age = 30
height = 5.6
is_student = True

# Multiple assignment
x, y, z = 1, 2, 3
a = b = c = 0

# Type checking
type(age)           # <class 'int'>
isinstance(age, int)  # True

# Type conversion
int("42")           # 42
float("3.14")       # 3.14
str(100)            # "100"
bool(1)             # True
```

## Basic Data Types

```python
# Numbers
x = 5               # int
y = 3.14            # float
z = 1 + 2j          # complex

# Strings
s = "hello"
s = 'world'
s = """multi
line"""

# Boolean
is_valid = True
is_valid = False

# None
x = None
```

## Operators

```python
# Arithmetic
+  -  *  /  //  %  **

10 + 5              # 15
10 - 5              # 5
10 * 5              # 50
10 / 5              # 2.0
10 // 3             # 3 (floor division)
10 % 3              # 1 (modulo)
2 ** 3              # 8 (power)

# Comparison
==  !=  >  <  >=  <=

# Logical
and  or  not

# Identity
is  is not

# Membership
in  not in

# Assignment
=  +=  -=  *=  /=  //=  %=  **=
```

## Strings

```python
# Creating
s = "Hello World"
s = 'Hello World'

# Indexing
s[0]                # 'H'
s[-1]               # 'd'

# Slicing
s[0:5]              # 'Hello'
s[:5]               # 'Hello'
s[6:]               # 'World'
s[::-1]             # 'dlroW olleH' (reverse)

# Methods
s.upper()           # 'HELLO WORLD'
s.lower()           # 'hello world'
s.strip()           # Remove whitespace
s.replace('H', 'J') # 'Jello World'
s.split()           # ['Hello', 'World']
s.startswith('He')  # True
s.endswith('ld')    # True
len(s)              # 11

# Formatting
name = "Alice"
age = 30
f"Hello {name}"                    # f-string
"Hello {}".format(name)            # .format()
"Name: %s, Age: %d" % (name, age)  # % formatting

# Concatenation
"Hello" + " " + "World"            # 'Hello World'
" ".join(['Hello', 'World'])       # 'Hello World'
```

## Lists

```python
# Creating
fruits = ['apple', 'banana', 'cherry']
numbers = [1, 2, 3, 4, 5]
mixed = [1, 'hello', True, 3.14]
empty = []

# Accessing
fruits[0]           # 'apple'
fruits[-1]          # 'cherry'
fruits[1:3]         # ['banana', 'cherry']

# Methods
fruits.append('orange')      # Add to end
fruits.insert(1, 'grape')    # Insert at index
fruits.remove('banana')      # Remove by value
fruits.pop()                 # Remove and return last
fruits.pop(0)                # Remove and return at index
fruits.clear()               # Remove all
fruits.sort()                # Sort in place
fruits.reverse()             # Reverse in place
fruits.count('apple')        # Count occurrences
fruits.index('cherry')       # Find index

# Operations
len(fruits)         # Length
'apple' in fruits   # Membership
fruits + ['kiwi']   # Concatenate
fruits * 2          # Repeat

# List comprehension
[x**2 for x in range(5)]              # [0, 1, 4, 9, 16]
[x for x in range(10) if x % 2 == 0]  # [0, 2, 4, 6, 8]
```

## Tuples

```python
# Creating (immutable)
coords = (1, 2, 3)
single = (1,)       # Note the comma
coords = 1, 2, 3    # Parentheses optional

# Accessing
coords[0]           # 1
coords[1:3]         # (2, 3)

# Unpacking
x, y, z = coords
```

## Sets

```python
# Creating (unique, unordered)
fruits = {'apple', 'banana', 'cherry'}
empty = set()

# Methods
fruits.add('orange')         # Add item
fruits.remove('banana')      # Remove (error if not found)
fruits.discard('banana')     # Remove (no error)
fruits.clear()               # Remove all

# Operations
set1 | set2         # Union
set1 & set2         # Intersection
set1 - set2         # Difference
set1 ^ set2         # Symmetric difference

# Set comprehension
{x**2 for x in range(5)}
```

## Dictionaries

```python
# Creating
person = {'name': 'Alice', 'age': 30}
person = dict(name='Alice', age=30)
empty = {}

# Accessing
person['name']              # 'Alice'
person.get('name')          # 'Alice'
person.get('city', 'NYC')   # 'NYC' (default)

# Modifying
person['age'] = 31          # Update
person['city'] = 'NYC'      # Add new
del person['age']           # Delete

# Methods
person.keys()               # dict_keys(['name', 'age'])
person.values()             # dict_values(['Alice', 30])
person.items()              # dict_items([('name', 'Alice'), ...])
person.pop('age')           # Remove and return
person.update({'city': 'LA'})  # Update multiple

# Dict comprehension
{x: x**2 for x in range(5)}
```

## Control Flow

```python
# If/elif/else
if x > 0:
    print("Positive")
elif x < 0:
    print("Negative")
else:
    print("Zero")

# Ternary operator
result = "Even" if x % 2 == 0 else "Odd"

# For loop
for item in [1, 2, 3]:
    print(item)

for i in range(5):          # 0 to 4
    print(i)

for i in range(1, 6):       # 1 to 5
    print(i)

for i in range(0, 10, 2):   # 0, 2, 4, 6, 8
    print(i)

# While loop
i = 0
while i < 5:
    print(i)
    i += 1

# Break and continue
for i in range(10):
    if i == 5:
        break           # Exit loop
    if i % 2 == 0:
        continue        # Skip to next iteration
    print(i)

# Pass (do nothing)
if x > 0:
    pass                # Placeholder
```

## Functions

```python
# Basic function
def greet(name):
    return f"Hello, {name}!"

# Default parameters
def greet(name="Guest"):
    return f"Hello, {name}!"

# Multiple parameters
def add(a, b):
    return a + b

# Multiple return values
def get_coordinates():
    return 10, 20

x, y = get_coordinates()

# *args and **kwargs
def my_func(*args, **kwargs):
    print(args)         # Tuple of positional args
    print(kwargs)       # Dict of keyword args

# Lambda (anonymous function)
square = lambda x: x**2
add = lambda x, y: x + y
```

## Built-in Functions

```python
# Type conversion
int(), float(), str(), bool(), list(), tuple(), set(), dict()

# Math
abs(-5)             # 5
round(3.14159, 2)   # 3.14
min(1, 2, 3)        # 1
max(1, 2, 3)        # 3
sum([1, 2, 3])      # 6
pow(2, 3)           # 8

# Iteration
len([1, 2, 3])                      # 3
range(5)                            # 0, 1, 2, 3, 4
enumerate(['a', 'b'])               # [(0, 'a'), (1, 'b')]
zip([1, 2], ['a', 'b'])             # [(1, 'a'), (2, 'b')]
reversed([1, 2, 3])                 # [3, 2, 1]
sorted([3, 1, 2])                   # [1, 2, 3]

# Functional
map(lambda x: x**2, [1, 2, 3])      # [1, 4, 9]
filter(lambda x: x > 0, [-1, 0, 1]) # [1]

# Boolean
any([False, True, False])           # True
all([True, True, True])             # True

# Other
print()             # Output
input()             # User input
type()              # Get type
isinstance()        # Check type
```

## File I/O

```python
# Read file
with open('file.txt', 'r') as f:
    content = f.read()          # Read entire file
    lines = f.readlines()       # List of lines
    for line in f:              # Iterate lines
        print(line)

# Write file
with open('file.txt', 'w') as f:
    f.write('Hello\n')
    f.writelines(['Line1\n', 'Line2\n'])

# Append to file
with open('file.txt', 'a') as f:
    f.write('More content\n')

# File modes
'r'  # Read (default)
'w'  # Write (overwrites)
'a'  # Append
'r+' # Read and write
'b'  # Binary mode
```

## Exception Handling

```python
# Basic try/except
try:
    result = 10 / 0
except ZeroDivisionError:
    print("Cannot divide by zero")

# Multiple exceptions
try:
    x = int("abc")
except (ValueError, TypeError) as e:
    print(f"Error: {e}")

# Finally (always runs)
try:
    f = open('file.txt')
except FileNotFoundError:
    print("File not found")
finally:
    print("Cleanup")

# Raise exception
raise ValueError("Invalid value")
```

## Classes

```python
# Basic class
class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age
    
    def greet(self):
        return f"Hello, I'm {self.name}"

# Create instance
person = Person("Alice", 30)
print(person.greet())

# Inheritance
class Student(Person):
    def __init__(self, name, age, grade):
        super().__init__(name, age)
        self.grade = grade
```

## Imports

```python
# Import module
import math
math.sqrt(16)

# Import specific items
from math import sqrt, pi
sqrt(16)

# Import with alias
import numpy as np
from pandas import DataFrame as df

# Import all (not recommended)
from math import *
```

## Common Patterns

```python
# Swap variables
a, b = b, a

# Check if empty
if not my_list:
    print("Empty")

# Get with default
value = dictionary.get('key', 'default')

# Combine dictionaries (Python 3.9+)
combined = dict1 | dict2

# List to string
','.join(['a', 'b', 'c'])  # 'a,b,c'

# String to list
'a,b,c'.split(',')         # ['a', 'b', 'c']

# Remove duplicates
unique = list(set(my_list))

# Flatten list
flat = [item for sublist in nested_list for item in sublist]

# Count occurrences
from collections import Counter
Counter([1, 1, 2, 3, 3, 3])  # {3: 3, 1: 2, 2: 1}
```

## Useful One-liners

```python
# Reverse string
s[::-1]

# Check palindrome
s == s[::-1]

# Factorial
from math import factorial
factorial(5)

# Fibonacci
fib = lambda n: n if n <= 1 else fib(n-1) + fib(n-2)

# Prime check
is_prime = lambda n: n > 1 and all(n % i for i in range(2, int(n**0.5) + 1))

# Read file in one line
content = open('file.txt').read()

# Write to file in one line
open('file.txt', 'w').write('content')
```
