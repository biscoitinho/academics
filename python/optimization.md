# Python Optimization

Basic optimization principles and techniques for Python code.

## Rule #1: Profile First

Always measure before optimizing. Use profiling tools to find bottlenecks.

```python
import cProfile
import time

def slow_function():
    time.sleep(0.1)
    return sum(range(1000))

# Profile the function
cProfile.run('slow_function()')
```

## Use Built-in Functions

Built-in functions are implemented in C and much faster than Python loops.

```python
# Slow - manual loop
total = 0
for i in range(1000000):
    total += i

# Fast - built-in function
total = sum(range(1000000))

# Fast - built-in min/max
numbers = [5, 2, 8, 1, 9]
minimum = min(numbers)
maximum = max(numbers)
```

## List Comprehensions vs Loops

List comprehensions are faster than equivalent for loops.

```python
# Slower - for loop
squares = []
for x in range(1000):
    squares.append(x * x)

# Faster - list comprehension
squares = [x * x for x in range(1000)]

# Filter with condition
evens = [x for x in range(1000) if x % 2 == 0]
```

## Use Generators for Large Data

Generators use lazy evaluation and save memory.

```python
# Memory intensive - creates full list
def get_numbers():
    return [i for i in range(1000000)]

# Memory efficient - yields one at a time
def get_numbers():
    for i in range(1000000):
        yield i

# Generator expression
squares = (x * x for x in range(1000000))

# Process one item at a time
for square in squares:
    if square > 100:
        break
```

## String Concatenation

Use join() for multiple string concatenations.

```python
# Slow - repeated concatenation
result = ""
for i in range(1000):
    result += str(i) + ","

# Fast - join with list
parts = [str(i) for i in range(1000)]
result = ",".join(parts)

# Fast - join with generator
result = ",".join(str(i) for i in range(1000))
```

## Local Variable Lookups

Local variables are faster to access than global or attribute lookups.

```python
import math

# Slower - repeated attribute lookup
def calculate_slow(numbers):
    result = []
    for n in numbers:
        result.append(math.sqrt(n))
    return result

# Faster - local variable
def calculate_fast(numbers):
    sqrt = math.sqrt  # Cache the function
    return [sqrt(n) for n in numbers]
```

## Use Sets for Membership Testing

Sets use hash tables and have O(1) lookup vs O(n) for lists.

```python
# Slow - O(n) lookup in list
valid_ids = [1, 2, 3, 4, 5, 100, 200, 300]
if user_id in valid_ids:  # Checks each item
    pass

# Fast - O(1) lookup in set
valid_ids = {1, 2, 3, 4, 5, 100, 200, 300}
if user_id in valid_ids:  # Hash lookup
    pass

# Remove duplicates
numbers = [1, 2, 2, 3, 3, 3, 4]
unique = list(set(numbers))
```

## Dictionary Optimizations

Use dict.get() and setdefault() to avoid repeated lookups.

```python
# Slower - multiple lookups
counts = {}
for word in words:
    if word in counts:
        counts[word] = counts[word] + 1
    else:
        counts[word] = 1

# Faster - single lookup with get()
counts = {}
for word in words:
    counts[word] = counts.get(word, 0) + 1

# Even better - use Counter
from collections import Counter
counts = Counter(words)
```

## Use Appropriate Data Structures

Choose the right tool for the job.

```python
from collections import deque, defaultdict

# Fast queue operations - O(1) append/pop at both ends
queue = deque([1, 2, 3])
queue.append(4)        # Add to right
queue.appendleft(0)    # Add to left
queue.pop()            # Remove from right
queue.popleft()        # Remove from left

# Avoid KeyError with defaultdict
word_lists = defaultdict(list)
word_lists['a'].append('apple')  # No need to check if 'a' exists

# Count occurrences
counts = defaultdict(int)
for item in items:
    counts[item] += 1  # No need to initialize
```

## Avoid Repeated Calculations

Cache results that don't change.

```python
# Slow - recalculates every time
class Circle:
    def __init__(self, radius):
        self.radius = radius

    def area(self):
        return 3.14159 * self.radius ** 2

# Fast - calculate once
class Circle:
    def __init__(self, radius):
        self.radius = radius
        self._area = 3.14159 * radius ** 2

    @property
    def area(self):
        return self._area

# Memoization with lru_cache
from functools import lru_cache

@lru_cache(maxsize=128)
def fibonacci(n):
    if n < 2:
        return n
    return fibonacci(n-1) + fibonacci(n-2)
```

## Use Multiple Assignment

Python allows efficient multiple assignments.

```python
# Slower
temp = a
a = b
b = temp

# Faster - no temp variable needed
a, b = b, a

# Unpack values
x, y, z = coordinates
first, *rest, last = items
```

## List Operations

Use appropriate methods for list operations.

```python
# Extend vs append for multiple items
numbers = [1, 2, 3]

# Slower - multiple append calls
for item in [4, 5, 6]:
    numbers.append(item)

# Faster - single extend call
numbers.extend([4, 5, 6])

# List slicing instead of copying
original = [1, 2, 3, 4, 5]
copy = original[:]  # Faster than list(original)
```

## Avoid Global Variables

Global variable lookup is slower than local.

```python
CONSTANT = 42

# Slower - global lookup in loop
def process_slow(items):
    result = []
    for item in items:
        result.append(item + CONSTANT)
    return result

# Faster - use local variable
def process_fast(items):
    constant = CONSTANT
    return [item + constant for item in items]
```

## Use enumerate() Instead of range(len())

More pythonic and slightly faster.

```python
items = ['a', 'b', 'c']

# Slower and less readable
for i in range(len(items)):
    print(i, items[i])

# Faster and more readable
for i, item in enumerate(items):
    print(i, item)
```

## String Formatting

Modern f-strings are fastest for formatting.

```python
name = "Alice"
age = 30

# Slower - concatenation
msg = "Name: " + name + ", Age: " + str(age)

# Slower - % formatting
msg = "Name: %s, Age: %d" % (name, age)

# Faster - str.format()
msg = "Name: {}, Age: {}".format(name, age)

# Fastest - f-strings (Python 3.6+)
msg = f"Name: {name}, Age: {age}"
```

## Use map() and filter() with Built-ins

map() and filter() can be faster with built-in functions.

```python
# Using built-in functions
numbers = ['1', '2', '3', '4', '5']

# Fast with map
integers = list(map(int, numbers))
squares = list(map(lambda x: x**2, range(1000)))

# Fast with filter
evens = list(filter(lambda x: x % 2 == 0, range(1000)))

# But list comprehensions are often clearer
integers = [int(n) for n in numbers]
evens = [x for x in range(1000) if x % 2 == 0]
```

## Context Managers for Resources

Always use context managers for file operations.

```python
# Bad - manual close (slower and error-prone)
f = open('file.txt')
data = f.read()
f.close()

# Good - automatic cleanup
with open('file.txt') as f:
    data = f.read()

# Multiple context managers
with open('input.txt') as infile, open('output.txt', 'w') as outfile:
    outfile.write(infile.read())
```

## NumPy for Numerical Operations

Use NumPy for numerical computations on large arrays.

```python
import numpy as np

# Slow - Python list operations
numbers = list(range(1000000))
result = [x * 2 for x in numbers]

# Fast - NumPy vectorized operations
numbers = np.arange(1000000)
result = numbers * 2  # Much faster

# NumPy aggregations
mean = numbers.mean()
total = numbers.sum()
```

## Key Takeaways

1. **Profile first** - Don't guess where bottlenecks are
2. **Use built-ins** - They're optimized in C
3. **Choose right data structure** - Set for membership, deque for queues
4. **Avoid premature optimization** - Readable code first, optimize if needed
5. **Cache expensive operations** - Use memoization when appropriate
6. **Use generators** - For large datasets to save memory
7. **Local > Global** - Local variable access is faster
8. **Test performance** - Measure actual improvements
