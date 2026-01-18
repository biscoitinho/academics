# Python Cheatsheet

Quick reference for Python fundamentals.

## Basics

```python
# Variables
name = "Alice"
age = 30
x, y = 1, 2

# Types
int, float, str, bool, list, dict, tuple, set

# Type conversion
int("42"), float("3.14"), str(100), bool(1)
```

## Data Structures

```python
# List (mutable)
nums = [1, 2, 3]
nums.append(4)
nums[0] = 10

# Tuple (immutable)
point = (1, 2, 3)

# Dictionary
person = {"name": "Alice", "age": 30}
person["city"] = "NYC"

# Set
unique = {1, 2, 3}
unique.add(4)
```

## Control Flow

```python
# If/elif/else
if x > 0:
    print("positive")
elif x < 0:
    print("negative")
else:
    print("zero")

# For loop
for i in range(5):
    print(i)

for item in [1, 2, 3]:
    print(item)

# While loop
while x < 10:
    x += 1

# Comprehensions
squares = [x**2 for x in range(10)]
evens = [x for x in range(10) if x % 2 == 0]
```

## Functions

```python
# Basic function
def greet(name):
    return f"Hello {name}"

# Default arguments
def greet(name="World"):
    return f"Hello {name}"

# *args and **kwargs
def func(*args, **kwargs):
    print(args, kwargs)

# Lambda
square = lambda x: x**2
```

## Classes

```python
class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def greet(self):
        return f"Hello, I'm {self.name}"

# Inheritance
class Student(Person):
    def __init__(self, name, age, grade):
        super().__init__(name, age)
        self.grade = grade
```

## Common Methods

```python
# String
s.lower(), s.upper(), s.strip()
s.split(","), s.replace("a", "b")
s.startswith("x"), s.endswith("y")

# List
lst.append(x), lst.extend([1,2])
lst.insert(0, x), lst.remove(x)
lst.pop(), lst.sort(), lst.reverse()

# Dict
d.keys(), d.values(), d.items()
d.get("key", default)
d.update({"k": "v"})
```

## File I/O

```python
# Read
with open("file.txt") as f:
    content = f.read()
    lines = f.readlines()

# Write
with open("file.txt", "w") as f:
    f.write("text")
    f.writelines(lines)
```

## Exceptions

```python
try:
    result = 10 / 0
except ZeroDivisionError as e:
    print(f"Error: {e}")
except Exception as e:
    print(f"Unexpected: {e}")
finally:
    print("Cleanup")
```

## Modules

```python
# Import
import math
from datetime import datetime
from pathlib import Path

# Common imports
import os, sys, json, re
from collections import defaultdict, Counter
from itertools import combinations, permutations
```

## Built-in Functions

```python
# Iterables
len([1,2,3])              # 3
sum([1,2,3])              # 6
min([1,2,3])              # 1
max([1,2,3])              # 3
sorted([3,1,2])           # [1,2,3]

# Functional
map(func, iterable)
filter(func, iterable)
zip(list1, list2)
enumerate(iterable)
all([True, True])         # True
any([False, True])        # True
```

## String Formatting

```python
# f-strings (preferred)
name = "Alice"
f"Hello {name}"
f"{value:.2f}"

# format()
"Hello {}".format(name)
"{0} {1}".format(a, b)

# % formatting (old)
"Hello %s" % name
```

## Operators

```python
# Arithmetic: + - * / // % **
# Comparison: == != > < >= <=
# Logical: and or not
# Identity: is is not
# Membership: in not in
# Walrus: := (assignment in expression)
```

## Common Patterns

```python
# List comprehension
[x**2 for x in range(10) if x % 2 == 0]

# Dict comprehension
{k: v**2 for k, v in enumerate(range(5))}

# Generator expression
(x**2 for x in range(10))

# Unpacking
a, b, *rest = [1, 2, 3, 4, 5]

# Slicing
lst[start:stop:step]
lst[::-1]  # Reverse

# Ternary
x if condition else y

# Default dict value
value = d.get("key", "default")
```

## Type Hints

```python
def greet(name: str) -> str:
    return f"Hello {name}"

from typing import List, Dict, Optional, Union

def process(items: List[int]) -> Optional[Dict[str, int]]:
    return {"count": len(items)} if items else None
```

## Decorators

```python
@decorator
def function():
    pass

# Common decorators
@property
@staticmethod
@classmethod
@functools.lru_cache
@dataclass
```

## Context Managers

```python
with open("file.txt") as f:
    content = f.read()

# Multiple
with open("in.txt") as f_in, open("out.txt", "w") as f_out:
    f_out.write(f_in.read())
```
