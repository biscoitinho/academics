# Memory Management

## Stack vs Heap

```
Stack:
- Fast allocation
- Fixed size
- LIFO order
- Local variables
- Automatic cleanup

Heap:
- Slower allocation
- Dynamic size
- Manual management (or GC)
- Objects, arrays
- Must be freed
```

## Python Memory

### Reference Counting

```python
import sys

a = []
print(sys.getrefcount(a))  # 2 (a + getrefcount)

b = a  # Reference count increases
print(sys.getrefcount(a))  # 3

del b  # Reference count decreases
print(sys.getrefcount(a))  # 2
```

### Garbage Collection

```python
import gc

# Trigger collection
gc.collect()

# Get stats
stats = gc.get_stats()
print(stats)

# Disable (not recommended)
gc.disable()

# Enable
gc.enable()
```

### Memory Usage

```python
import sys

# Object size
a = [1, 2, 3]
print(sys.getsizeof(a))  # Bytes

# Process memory
import psutil
import os

process = psutil.Process(os.getpid())
print(f"Memory: {process.memory_info().rss / 1024 / 1024:.2f} MB")
```

### Memory Profiling

```python
# memory_profiler
from memory_profiler import profile

@profile
def memory_intensive():
    big_list = [i for i in range(1000000)]
    return sum(big_list)

memory_intensive()

# Run: python -m memory_profiler script.py
```

## Ruby Memory

```ruby
# Object space
require 'objspace'

# Object size
obj = [1, 2, 3]
puts ObjectSpace.memsize_of(obj)

# Total objects
puts ObjectSpace.count_objects[:TOTAL]

# GC stats
puts GC.stat

# Trigger GC
GC.start
```

## Memory Leaks

### Python

```python
# ❌ Leak: Circular reference
class Node:
    def __init__(self):
        self.ref = self  # Circular!

# ✅ Fix: Break cycle or use weak references
import weakref

class Node:
    def __init__(self):
        self.ref = weakref.ref(self)

# ❌ Leak: Global cache never cleared
cache = {}
def store(key, value):
    cache[key] = value  # Grows forever!

# ✅ Fix: Limit cache size or use weak references
from functools import lru_cache

@lru_cache(maxsize=100)
def cached_function(n):
    return n * 2
```

### Detection

```python
import tracemalloc

# Start tracing
tracemalloc.start()

# Code that might leak
for i in range(1000):
    create_large_object()

# Get current memory
current, peak = tracemalloc.get_traced_memory()
print(f"Current: {current / 1024 / 1024:.2f} MB")
print(f"Peak: {peak / 1024 / 1024:.2f} MB")

# Stop tracing
tracemalloc.stop()
```

## Optimization Techniques

### Generators (Lazy Evaluation)

```python
# ❌ Loads everything in memory
def read_file(filename):
    with open(filename) as f:
        return f.readlines()  # All lines in memory!

# ✅ Generator (one line at a time)
def read_file(filename):
    with open(filename) as f:
        for line in f:
            yield line.strip()
```

### Use __slots__

```python
# ❌ Regular class (uses __dict__)
class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

# ✅ Slots (less memory)
class Point:
    __slots__ = ['x', 'y']
    def __init__(self, x, y):
        self.x = x
        self.y = y

# Memory savings significant for many objects
```

### Weak References

```python
import weakref

# Regular reference (prevents GC)
obj = SomeObject()
cache = [obj]  # obj won't be collected

# Weak reference (allows GC)
obj = SomeObject()
cache = [weakref.ref(obj)]
# obj can be collected if no other references
```

### Reuse Objects

```python
# ❌ Creates many objects
for i in range(1000000):
    result = [0] * 100  # New list each time!

# ✅ Reuse
result = [0] * 100
for i in range(1000000):
    # Reuse result
    result[i % 100] = i
```

## Memory Pools

```python
# Preallocate memory
pool = [None] * 1000
for i in range(1000):
    pool[i] = create_object()

# Reuse from pool
obj = pool.pop()
# Use obj
pool.append(obj)
```

## String Interning

```python
# Python interns small strings automatically
a = "hello"
b = "hello"
print(a is b)  # True (same object)

# Manual interning
import sys
s1 = sys.intern("large string" * 100)
s2 = sys.intern("large string" * 100)
print(s1 is s2)  # True (saves memory if many duplicates)
```

## Array vs List

```python
# List (flexible, more memory)
lst = [1, 2, 3, 4, 5]

# Array (fixed type, less memory)
from array import array
arr = array('i', [1, 2, 3, 4, 5])  # Integers only
```

## NumPy Arrays

```python
import numpy as np

# Python list (inefficient)
lst = [i for i in range(1000000)]

# NumPy array (efficient)
arr = np.arange(1000000)
# Much less memory, faster operations
```

## Delete Unused Objects

```python
# Delete when done
large_object = create_large_object()
process(large_object)
del large_object  # Free memory

# Or let it go out of scope
def process_data():
    large_object = create_large_object()
    result = process(large_object)
    return result
# large_object freed automatically
```

## Context Managers

```python
# Automatic cleanup
with open('large_file.txt') as f:
    data = f.read()
# File closed, resources freed

# Custom context manager
class ManagedResource:
    def __enter__(self):
        self.resource = allocate_resource()
        return self.resource

    def __exit__(self, exc_type, exc_val, exc_tb):
        free_resource(self.resource)

with ManagedResource() as resource:
    use(resource)
# Automatically freed
```

## Memory-Mapped Files

```python
import mmap

# Don't load entire file
with open('large_file.bin', 'r+b') as f:
    with mmap.mmap(f.fileno(), 0) as m:
        # Access file as if in memory
        data = m[0:100]  # Read bytes 0-100
        m[0:5] = b'hello'  # Write
```

## Common Memory Issues

```python
# 1. Keeping references to large objects
# ❌ Bad
cache = {}
def store_result(key, value):
    cache[key] = value  # Never freed!

# ✅ Good
from functools import lru_cache
@lru_cache(maxsize=100)  # Limited size
def cached_function(n):
    return expensive_computation(n)

# 2. Growing lists
# ❌ Bad
results = []
for i in range(1000000):
    results.append(process(i))  # Grows large!

# ✅ Good (if don't need all at once)
for i in range(1000000):
    result = process(i)
    save_to_disk(result)

# 3. Circular references
# ❌ Bad
class Parent:
    def __init__(self):
        self.child = Child(self)

class Child:
    def __init__(self, parent):
        self.parent = parent  # Circular!

# ✅ Good
import weakref
class Child:
    def __init__(self, parent):
        self.parent = weakref.ref(parent)

# 4. Unclosed files/connections
# ❌ Bad
f = open('file.txt')
# File never closed!

# ✅ Good
with open('file.txt') as f:
    pass  # Automatically closed
```

## Monitoring

```python
import psutil
import os

def print_memory():
    process = psutil.Process(os.getpid())
    mem = process.memory_info().rss / 1024 / 1024
    print(f"Memory: {mem:.2f} MB")

print_memory()  # Before
large_data = [i for i in range(1000000)]
print_memory()  # After
del large_data
print_memory()  # After deletion
```

## Best Practices

```python
# 1. Use generators for large datasets
def read_large_file(filename):
    with open(filename) as f:
        for line in f:
            yield line

# 2. Delete when done
del large_object

# 3. Use context managers
with resource:
    use(resource)

# 4. Limit cache size
@lru_cache(maxsize=100)

# 5. Use appropriate data structures
# array, deque, set, etc.

# 6. Profile memory usage
# memory_profiler, tracemalloc

# 7. Watch for circular references

# 8. Close files/connections
# Use with statement

# 9. Avoid global state
# Keep scope local

# 10. Use __slots__ for many objects
```

## Tools

```bash
# Python
pip install memory_profiler
python -m memory_profiler script.py

pip install pympler
pip install guppy3

# System tools
top  # Linux/Mac
htop  # Enhanced top
ps aux | grep python

# Valgrind (memory debugging)
valgrind --leak-check=full python script.py
```
