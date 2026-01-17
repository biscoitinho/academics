## Slicing

Extract portions of sequences (lists, strings, tuples).

### Basic syntax

```python
sequence[start:end:step]
```

- `start`: Index to start from (inclusive)
- `end`: Index to end at (exclusive)
- `step`: Increment between indices

### Basic slicing

```python
numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

# Get items from index 2 to 5
print(numbers[2:5])    # [2, 3, 4]

# From beginning to index 5
print(numbers[:5])     # [0, 1, 2, 3, 4]

# From index 5 to end
print(numbers[5:])     # [5, 6, 7, 8, 9]

# Entire list (copy)
print(numbers[:])      # [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
```

### Negative indices

```python
numbers = [0, 1, 2, 3, 4, 5]

# Last item
print(numbers[-1])     # 5

# Last 3 items
print(numbers[-3:])    # [3, 4, 5]

# All except last 2
print(numbers[:-2])    # [0, 1, 2, 3]

# From index 2 to second-to-last
print(numbers[2:-1])   # [2, 3, 4]
```

### Step parameter

```python
numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

# Every second item
print(numbers[::2])    # [0, 2, 4, 6, 8]

# Every third item
print(numbers[::3])    # [0, 3, 6, 9]

# Every second item from index 1
print(numbers[1::2])   # [1, 3, 5, 7, 9]

# Reverse the list
print(numbers[::-1])   # [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

# Reverse from index 2 to 8
print(numbers[2:8][::-1])  # [7, 6, 5, 4, 3, 2]
```

### String slicing

```python
text = "Python Programming"

# First 6 characters
print(text[:6])        # Python

# Last word
print(text[7:])        # Programming

# Every other character
print(text[::2])       # Pto rgamn

# Reverse string
print(text[::-1])      # gnimmargorP nohtyP
```

### Tuple slicing

```python
coords = (1, 2, 3, 4, 5)

# Same as lists
print(coords[1:4])     # (2, 3, 4)
print(coords[::-1])    # (5, 4, 3, 2, 1)
```

### Modifying with slices

```python
numbers = [0, 1, 2, 3, 4, 5]

# Replace slice
numbers[1:4] = [10, 20, 30]
print(numbers)  # [0, 10, 20, 30, 4, 5]

# Insert elements
numbers[2:2] = [100, 200]
print(numbers)  # [0, 10, 100, 200, 20, 30, 4, 5]

# Delete slice
numbers[2:5] = []
print(numbers)  # [0, 10, 30, 4, 5]

# Delete using del
del numbers[1:3]
print(numbers)  # [0, 4, 5]
```

### Common patterns

**Get first n items:**
```python
first_three = numbers[:3]
```

**Get last n items:**
```python
last_three = numbers[-3:]
```

**Remove first n items:**
```python
without_first_two = numbers[2:]
```

**Remove last n items:**
```python
without_last_two = numbers[:-2]
```

**Reverse a sequence:**
```python
reversed_list = numbers[::-1]
```

**Copy a list:**
```python
copy = numbers[:]
# or
copy = numbers[::]
```

**Check palindrome:**
```python
word = "racecar"
is_palindrome = word == word[::-1]
print(is_palindrome)  # True
```

**Alternate items (odd/even positions):**
```python
numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
even_positions = numbers[::2]   # [0, 2, 4, 6, 8]
odd_positions = numbers[1::2]   # [1, 3, 5, 7, 9]
```

### Out of bounds slicing

Unlike indexing, slicing never raises an error:

```python
numbers = [1, 2, 3]

# This is fine
print(numbers[0:100])  # [1, 2, 3]

# But this raises IndexError
# print(numbers[100])
```
