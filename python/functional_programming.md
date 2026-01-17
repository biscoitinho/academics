## Functional Programming

Declarative approach instead of imperative

### Writing a function

- Must be deterministic
- Free of side effects
  - Side effect is when function alters some external variable
  - Goal is to minimize, not eliminate side effects

Example **WITH** side effects:

```python
ans = 0

def add(x, y):
    ans = x + y
```

Example **WITHOUT** side effects:

```python
ans = 0

def add(x, y):
    return x + y

ans = add(x, y)
```

- Function should always have all parameters passed and should not rely on the global state
- Recursion instead of loops
- Passing functions as arguments to other functions ("functions as first class citizens")

```python
def add(x, y):
    return x + y

def times3(a, b, function):
    return 3 * function(a, b)

add_times3 = times3(2, 4, add)
```
