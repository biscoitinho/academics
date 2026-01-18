## Slicing

Access ranges of items in sequences.

### Basic Syntax

```python
seq[start:stop:step]

# Examples
lst = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

lst[2:5]       # [2, 3, 4] (start=2, stop=5)
lst[:5]        # [0, 1, 2, 3, 4] (from beginning)
lst[5:]        # [5, 6, 7, 8, 9] (to end)
lst[:]         # [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] (copy)
lst[::2]       # [0, 2, 4, 6, 8] (every 2nd)
lst[1::2]      # [1, 3, 5, 7, 9] (every 2nd, starting at 1)
```

### Negative Indices

```python
lst = [0, 1, 2, 3, 4]

lst[-1]        # 4 (last item)
lst[-2]        # 3 (second to last)
lst[-3:]       # [2, 3, 4] (last 3 items)
lst[:-2]       # [0, 1, 2] (all except last 2)
```

### Reverse

```python
lst[::-1]      # [9, 8, 7, 6, 5, 4, 3, 2, 1, 0] (reverse)
lst[::-2]      # [9, 7, 5, 3, 1] (reverse, every 2nd)
```

### Assignment

```python
lst = [0, 1, 2, 3, 4]

lst[1:3] = [10, 20]     # [0, 10, 20, 3, 4]
lst[1:3] = []           # [0, 3, 4] (delete)
lst[1:1] = [10, 20]     # [0, 10, 20, 1, 2, 3, 4] (insert)
```

### Strings

```python
s = "Python"

s[0:3]         # "Pyt"
s[::2]         # "Pto"
s[::-1]        # "nohtyP" (reverse)
```

### Examples

```python
# Get first 3
lst[:3]

# Get last 3
lst[-3:]

# Skip first and last
lst[1:-1]

# Every other
lst[::2]

# Reverse
lst[::-1]

# Copy
new_lst = lst[:]
```
