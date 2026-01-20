# Performance Optimization

## Profiling

### Python

```python
# Time measurement
import time

start = time.time()
expensive_function()
elapsed = time.time() - start
print(f"Took {elapsed:.2f}s")

# cProfile
import cProfile
cProfile.run('expensive_function()')

# Line profiler
# pip install line_profiler
# @profile decorator
@profile
def slow_function():
    total = 0
    for i in range(1000000):
        total += i
    return total

# Run: kernprof -l -v script.py
```

### Ruby

```ruby
# Benchmark
require 'benchmark'

time = Benchmark.measure do
  expensive_operation
end
puts time

# Ruby-prof
require 'ruby-prof'
RubyProf.start
expensive_operation
result = RubyProf.stop
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)
```

## Algorithm Optimization

```python
# ❌ O(n²)
def has_duplicates_slow(lst):
    for i in range(len(lst)):
        for j in range(i + 1, len(lst)):
            if lst[i] == lst[j]:
                return True
    return False

# ✅ O(n)
def has_duplicates_fast(lst):
    return len(lst) != len(set(lst))
```

## Data Structure Choice

```python
# ❌ List for lookups
items = [1, 2, 3, 4, 5]
if 3 in items:  # O(n)
    pass

# ✅ Set for lookups
items = {1, 2, 3, 4, 5}
if 3 in items:  # O(1)
    pass
```

## Caching

```python
from functools import lru_cache

# Cache function results
@lru_cache(maxsize=128)
def expensive_function(n):
    # Expensive computation
    return result

# Manual caching
cache = {}
def memoized_function(n):
    if n not in cache:
        cache[n] = expensive_computation(n)
    return cache[n]
```

## Database Optimization

```python
# ❌ N+1 queries
users = User.query.all()
for user in users:
    print(user.posts)  # Query for each user!

# ✅ Eager loading
users = User.query.options(joinedload('posts')).all()
for user in users:
    print(user.posts)  # No extra queries

# Indexing
# CREATE INDEX idx_email ON users(email);

# Limit results
users = User.query.limit(100).all()

# Select only needed columns
users = db.session.query(User.id, User.name).all()
```

## List Comprehensions

```python
# ❌ Slower
result = []
for i in range(1000):
    result.append(i * 2)

# ✅ Faster
result = [i * 2 for i in range(1000)]

# Even faster for large data
result = (i * 2 for i in range(1000))  # Generator
```

## String Concatenation

```python
# ❌ Slow for many strings
result = ""
for s in strings:
    result += s  # Creates new string each time

# ✅ Fast
result = ''.join(strings)
```

## Avoid Repeated Calculations

```python
# ❌ Repeated calculation
for item in items:
    if len(items) > threshold:  # len() called each time!
        process(item)

# ✅ Calculate once
items_len = len(items)
for item in items:
    if items_len > threshold:
        process(item)
```

## Use Built-ins

```python
# ❌ Custom implementation
def my_sum(numbers):
    total = 0
    for n in numbers:
        total += n
    return total

# ✅ Built-in (faster)
total = sum(numbers)

# Other fast built-ins
max(numbers)
min(numbers)
any(conditions)
all(conditions)
```

## Lazy Evaluation

```python
# ❌ Creates entire list
numbers = [expensive_function(i) for i in range(1000000)]
first_five = numbers[:5]

# ✅ Generate on demand
numbers = (expensive_function(i) for i in range(1000000))
first_five = list(itertools.islice(numbers, 5))
```

## Batch Operations

```python
# ❌ Many small queries
for user_id in user_ids:
    user = db.query(User).filter_by(id=user_id).first()
    process(user)

# ✅ Single query
users = db.query(User).filter(User.id.in_(user_ids)).all()
for user in users:
    process(user)
```

## Async for I/O

```python
import asyncio
import aiohttp

# Sequential (slow)
def fetch_all(urls):
    results = []
    for url in urls:
        response = requests.get(url)
        results.append(response.text)
    return results

# Concurrent (fast)
async def fetch_all_async(urls):
    async with aiohttp.ClientSession() as session:
        tasks = [fetch_one(session, url) for url in urls]
        return await asyncio.gather(*tasks)

async def fetch_one(session, url):
    async with session.get(url) as response:
        return await response.text()
```

## Memory Optimization

```python
# ❌ Loads everything
with open('large_file.txt') as f:
    data = f.read()  # All in memory!
    process(data)

# ✅ Process line by line
with open('large_file.txt') as f:
    for line in f:
        process(line)

# Generators
def read_large_file(file_path):
    with open(file_path) as f:
        for line in f:
            yield line.strip()
```

## NumPy for Numerical Operations

```python
# ❌ Python loops
result = []
for i in range(1000000):
    result.append(i * 2 + 1)

# ✅ NumPy (vectorized)
import numpy as np
arr = np.arange(1000000)
result = arr * 2 + 1  # Much faster!
```

## Multiprocessing for CPU

```python
from multiprocessing import Pool

def cpu_intensive_task(n):
    return sum(i * i for i in range(n))

# Sequential
results = [cpu_intensive_task(n) for n in range(10)]

# Parallel
with Pool(4) as pool:
    results = pool.map(cpu_intensive_task, range(10))
```

## Avoid Global Lookups

```python
# ❌ Slower
def process_items(items):
    for item in items:
        result = math.sqrt(item)  # Global lookup each time

# ✅ Faster
def process_items(items):
    sqrt = math.sqrt  # Local reference
    for item in items:
        result = sqrt(item)
```

## Use Slots

```python
# ❌ Regular class (uses __dict__)
class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

# ✅ Slots (less memory, faster access)
class Point:
    __slots__ = ['x', 'y']
    def __init__(self, x, y):
        self.x = x
        self.y = y
```

## Compile Regex

```python
import re

# ❌ Recompile each time
for text in texts:
    if re.match(r'\d+', text):
        pass

# ✅ Compile once
pattern = re.compile(r'\d+')
for text in texts:
    if pattern.match(text):
        pass
```

## Connection Pooling

```python
# ❌ New connection each time
for i in range(100):
    response = requests.get('https://api.example.com/data')

# ✅ Reuse connections
session = requests.Session()
for i in range(100):
    response = session.get('https://api.example.com/data')
```

## Reduce Function Calls

```python
# ❌ Many function calls
result = []
for item in items:
    result.append(process(item))

# ✅ Fewer calls (if process can handle batch)
result = process_batch(items)
```

## Common Bottlenecks

```
1. Database queries (N+1, missing indexes)
2. File I/O (read entire file)
3. Network requests (sequential)
4. Nested loops (O(n²) or worse)
5. Memory allocation (creating many objects)
6. Global interpreter lock (Python threading)
```

## Measurement

```python
# Always measure!
import timeit

# Compare approaches
time1 = timeit.timeit('sum(range(100))', number=10000)
time2 = timeit.timeit('[i for i in range(100)]', number=10000)

print(f"sum: {time1:.4f}s")
print(f"list comprehension: {time2:.4f}s")
```

## Premature Optimization

```
"Premature optimization is the root of all evil" - Donald Knuth

1. Write correct code first
2. Measure performance
3. Find bottlenecks
4. Optimize only what matters
5. Measure again
```

## Optimization Checklist

```
✅ Profile first
✅ Use appropriate data structures
✅ Cache expensive computations
✅ Optimize database queries
✅ Use batch operations
✅ Leverage built-ins
✅ Async for I/O-bound
✅ Multiprocessing for CPU-bound
✅ Minimize memory allocations
✅ Measure improvements
```
