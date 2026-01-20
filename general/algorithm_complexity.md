# Algorithm Complexity (Big O Notation)

## What is Big O?

Big O describes how runtime or memory usage grows as input size increases. It focuses on worst-case scenarios.

```
O(1) - Constant: Same time regardless of input size
O(log n) - Logarithmic: Grows slowly
O(n) - Linear: Proportional to input size
O(n log n) - Log-linear: Common in efficient sorting
O(n²) - Quadratic: Nested loops
O(2ⁿ) - Exponential: Doubles with each addition
O(n!) - Factorial: Extremely slow
```

## O(1) - Constant Time

```python
# Array access
def get_first(arr):
    return arr[0]  # Always 1 operation

# Hash lookup
def get_user(users, id):
    return users[id]  # O(1) with hash table
```

```ruby
# Array access
def get_first(arr)
  arr[0]
end

# Hash lookup
def get_user(users, id)
  users[id]
end
```

## O(log n) - Logarithmic Time

```python
# Binary search
def binary_search(arr, target):
    left, right = 0, len(arr) - 1

    while left <= right:
        mid = (left + right) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return -1

# Example: Search in [1,2,3,4,5,6,7,8]
# Step 1: Check middle (4)
# Step 2: Check middle of right half (6)
# Step 3: Found or not found
# 8 elements = 3 steps (log₂ 8 = 3)
```

```ruby
# Binary search
def binary_search(arr, target)
  left, right = 0, arr.length - 1

  while left <= right
    mid = (left + right) / 2
    if arr[mid] == target
      return mid
    elsif arr[mid] < target
      left = mid + 1
    else
      right = mid - 1
    end
  end
  -1
end
```

## O(n) - Linear Time

```python
# Loop through array
def find_max(arr):
    max_val = arr[0]
    for num in arr:  # Visits each element once
        if num > max_val:
            max_val = num
    return max_val

# Sum array
def sum_array(arr):
    total = 0
    for num in arr:
        total += num
    return total
```

```ruby
# Loop through array
def find_max(arr)
  max_val = arr[0]
  arr.each do |num|
    max_val = num if num > max_val
  end
  max_val
end
```

## O(n log n) - Log-Linear Time

```python
# Merge sort
def merge_sort(arr):
    if len(arr) <= 1:
        return arr

    mid = len(arr) // 2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])

    return merge(left, right)

def merge(left, right):
    result = []
    i = j = 0

    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1

    result.extend(left[i:])
    result.extend(right[j:])
    return result

# Built-in sort (most languages)
sorted_arr = sorted([3, 1, 4, 1, 5, 9])  # O(n log n)
```

```ruby
# Built-in sort
sorted_arr = [3, 1, 4, 1, 5, 9].sort  # O(n log n)
```

## O(n²) - Quadratic Time

```python
# Nested loop - compare all pairs
def find_duplicates(arr):
    for i in range(len(arr)):
        for j in range(i + 1, len(arr)):
            if arr[i] == arr[j]:
                return True
    return False

# Bubble sort
def bubble_sort(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n - i - 1):
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
    return arr
```

```ruby
# Nested loop
def find_duplicates(arr)
  arr.each_with_index do |val, i|
    arr[(i+1)..-1].each do |other|
      return true if val == other
    end
  end
  false
end
```

## O(2ⁿ) - Exponential Time

```python
# Recursive fibonacci (inefficient)
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

# fibonacci(5) calls:
# fib(5) -> fib(4) + fib(3)
# fib(4) -> fib(3) + fib(2)
# fib(3) -> fib(2) + fib(1)
# ... exponential growth

# Better: O(n) with memoization
def fibonacci_memo(n, memo={}):
    if n in memo:
        return memo[n]
    if n <= 1:
        return n
    memo[n] = fibonacci_memo(n - 1, memo) + fibonacci_memo(n - 2, memo)
    return memo[n]
```

```ruby
# Recursive fibonacci
def fibonacci(n)
  return n if n <= 1
  fibonacci(n - 1) + fibonacci(n - 2)
end

# With memoization
def fibonacci_memo(n, memo = {})
  return memo[n] if memo[n]
  return n if n <= 1
  memo[n] = fibonacci_memo(n - 1, memo) + fibonacci_memo(n - 2, memo)
end
```

## O(n!) - Factorial Time

```python
# Generate all permutations
def permutations(arr):
    if len(arr) <= 1:
        return [arr]

    result = []
    for i in range(len(arr)):
        rest = arr[:i] + arr[i+1:]
        for p in permutations(rest):
            result.append([arr[i]] + p)
    return result

# Example: [1,2,3] has 3! = 6 permutations
# [1,2,3], [1,3,2], [2,1,3], [2,3,1], [3,1,2], [3,2,1]
```

## Space Complexity

```python
# O(1) space - no extra space needed
def sum_array(arr):
    total = 0
    for num in arr:
        total += num
    return total

# O(n) space - creates new array
def double_array(arr):
    result = []
    for num in arr:
        result.append(num * 2)
    return result

# O(n) space - recursive call stack
def factorial(n):
    if n <= 1:
        return 1
    return n * factorial(n - 1)  # n recursive calls on stack
```

## Common Operations Complexity

### Arrays/Lists

```python
arr = [1, 2, 3, 4, 5]

arr[0]           # O(1) - access by index
arr.append(6)    # O(1) - add to end
arr.insert(0, 0) # O(n) - insert at start
arr.remove(3)    # O(n) - remove element
arr.pop()        # O(1) - remove last
3 in arr         # O(n) - search
```

### Hash Tables/Dictionaries

```python
d = {'a': 1, 'b': 2}

d['a']           # O(1) - access
d['c'] = 3       # O(1) - insert
del d['b']       # O(1) - delete
'a' in d         # O(1) - search
```

### Sets

```python
s = {1, 2, 3, 4, 5}

s.add(6)         # O(1) - insert
s.remove(3)      # O(1) - delete
3 in s           # O(1) - search
s1 | s2          # O(len(s1) + len(s2)) - union
```

## Comparing Complexities

```
Input size: n = 100

O(1):       1 operation
O(log n):   ~7 operations (log₂ 100)
O(n):       100 operations
O(n log n): ~700 operations
O(n²):      10,000 operations
O(2ⁿ):      1,267,650,600,228,229,401,496,703,205,376 operations
O(n!):      impossible to compute

Input size: n = 1,000,000

O(1):       1 operation
O(log n):   ~20 operations
O(n):       1,000,000 operations
O(n log n): ~20,000,000 operations
O(n²):      1,000,000,000,000 operations (too slow!)
```

## Rules for Calculating Big O

### 1. Drop Constants

```python
# O(2n) = O(n)
def print_twice(arr):
    for x in arr:    # O(n)
        print(x)
    for x in arr:    # O(n)
        print(x)
# Total: O(2n) → simplified to O(n)
```

### 2. Drop Non-Dominant Terms

```python
# O(n² + n) = O(n²)
def process(arr):
    # First loop: O(n)
    for x in arr:
        print(x)

    # Nested loop: O(n²)
    for x in arr:
        for y in arr:
            print(x, y)
# Total: O(n + n²) → O(n²) dominates
```

### 3. Different Inputs = Different Variables

```python
# O(a + b), not O(n)
def process_two(arr1, arr2):
    for x in arr1:  # O(a)
        print(x)
    for y in arr2:  # O(b)
        print(y)

# O(a * b), not O(n²)
def nested_two(arr1, arr2):
    for x in arr1:      # O(a)
        for y in arr2:  # O(b)
            print(x, y)
```

## Optimizing Code

### Example 1: Find Duplicates

```python
# ❌ Bad: O(n²)
def has_duplicates_slow(arr):
    for i in range(len(arr)):
        for j in range(i + 1, len(arr)):
            if arr[i] == arr[j]:
                return True
    return False

# ✅ Good: O(n)
def has_duplicates_fast(arr):
    seen = set()
    for num in arr:
        if num in seen:
            return True
        seen.add(num)
    return False
```

### Example 2: Two Sum

```python
# ❌ Bad: O(n²)
def two_sum_slow(arr, target):
    for i in range(len(arr)):
        for j in range(i + 1, len(arr)):
            if arr[i] + arr[j] == target:
                return [i, j]
    return None

# ✅ Good: O(n)
def two_sum_fast(arr, target):
    seen = {}
    for i, num in enumerate(arr):
        complement = target - num
        if complement in seen:
            return [seen[complement], i]
        seen[num] = i
    return None
```

## Common Patterns

```python
# Halving input = O(log n)
while n > 0:
    n = n // 2

# Single loop = O(n)
for i in range(n):
    pass

# Two separate loops = O(n)
for i in range(n):
    pass
for j in range(n):
    pass

# Nested loops = O(n²)
for i in range(n):
    for j in range(n):
        pass

# Loop + nested loop inside = O(n²)
for i in range(n):
    for j in range(i, n):
        pass

# Sorting + loop = O(n log n)
arr.sort()
for x in arr:
    pass
```

## Amortized Analysis

```python
# Dynamic array append
arr = []
for i in range(n):
    arr.append(i)  # Usually O(1), occasionally O(n) when resizing

# Amortized: O(1) per append
# Total cost: O(n) for n appends
# Average per operation: O(n)/n = O(1)
```

## Best, Average, Worst Case

```python
# Quick sort:
# Best case: O(n log n) - good pivot selection
# Average case: O(n log n)
# Worst case: O(n²) - already sorted with bad pivot

# Linear search:
# Best case: O(1) - found at first position
# Average case: O(n/2) = O(n)
# Worst case: O(n) - found at last position or not found
```

## Practical Tips

```python
# 1. Use appropriate data structure
# Set lookup: O(1)
# List lookup: O(n)
if num in my_set:  # O(1) - ✅ Good
    pass
if num in my_list:  # O(n) - ❌ Slow for large lists
    pass

# 2. Avoid nested loops when possible
# Use hash maps instead

# 3. Consider trade-offs
# More space can mean less time
# Pre-compute when possible

# 4. Don't optimize prematurely
# Write correct code first
# Optimize only if needed
```

## Quiz

```python
# What's the complexity?

# 1.
def mystery1(arr):
    return arr[len(arr) // 2]
# Answer: O(1) - array access

# 2.
def mystery2(arr):
    for i in range(len(arr) // 2):
        print(arr[i])
# Answer: O(n) - still iterates proportionally to n

# 3.
def mystery3(arr):
    for i in range(len(arr)):
        for j in range(1000):
            print(arr[i])
# Answer: O(n) - inner loop is constant

# 4.
def mystery4(arr1, arr2):
    for x in arr1:
        for y in arr2:
            if x == y:
                return True
    return False
# Answer: O(n * m) - two different inputs
```
