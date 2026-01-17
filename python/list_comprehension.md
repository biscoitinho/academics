## List Comprehension

Basic syntax:

```python
new_list = [expression for member in iterable]
```

Or with conditional statement:
```python
new_list = [expression for member in iterable if conditional]
```

### For loop example

```python
arr = [1, 2, 3, 4, 5]

for _ in arr:
    print(_**_)
```

### List comprehension

```python
[n**n for n in arr]
```

### Map

```python
list(map(lambda n: n**n, arr))
```

### List comprehension with conditional

```python
[n**n for n in arr if n > 0]
```

### With a function

```python
def make_it_big(num):
    return num**num

[make_it_big(n) for n in arr]
```

### Set/Dict comprehensions

**Set:**
```python
{n**n for n in arr}
```

**Dict:**
```python
{n: n**n for n in arr}
```

### Matrix

```python
[[n for n in range(3)] for i in range(3)]
```

Output:
```python
[
    [0, 1, 2],
    [0, 1, 2],
    [0, 1, 2]
]
```
