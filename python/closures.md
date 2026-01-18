## Closures

A function that remembers values from its enclosing scope.

### Basic Closure

```python
def outer(x):
    def inner(y):
        return x + y
    return inner

add_five = outer(5)
add_five(3)        # 8
add_five(10)       # 15
```

### Use Cases

```python
# Factory functions
def multiplier(n):
    def multiply(x):
        return x * n
    return multiply

double = multiplier(2)
triple = multiplier(3)

double(5)          # 10
triple(5)          # 15

# Counters
def make_counter():
    count = 0
    def counter():
        nonlocal count
        count += 1
        return count
    return counter

c = make_counter()
c()                # 1
c()                # 2
c()                # 3
```

### nonlocal Keyword

```python
def outer():
    x = 0
    def inner():
        nonlocal x  # Modify outer variable
        x += 1
        return x
    return inner

inc = outer()
inc()              # 1
inc()              # 2
```

### Decorators with Closures

```python
def repeat(times):
    def decorator(func):
        def wrapper(*args, **kwargs):
            for _ in range(times):
                result = func(*args, **kwargs)
            return result
        return wrapper
    return decorator

@repeat(3)
def greet(name):
    print(f"Hello {name}")

greet("Alice")     # Prints 3 times
```

### State Retention

```python
def make_averager():
    series = []
    def averager(value):
        series.append(value)
        return sum(series) / len(series)
    return averager

avg = make_averager()
avg(10)            # 10.0
avg(11)            # 10.5
avg(12)            # 11.0
```
