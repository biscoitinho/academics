# Functional Programming Concepts

Core principles of functional programming across languages.

## Pure Functions

**Definition**: Same input always returns same output, no side effects.

```python
# Pure function
def add(a, b):
    return a + b  # No side effects, deterministic

# Impure function
counter = 0
def add_impure(a, b):
    global counter
    counter += 1  # Side effect!
    return a + b
```

```ruby
# Pure
def add(a, b)
  a + b
end

# Impure
$counter = 0
def add_impure(a, b)
  $counter += 1  # Side effect!
  a + b
end
```

**Benefits**:
- Easy to test
- Easy to reason about
- Can be parallelized
- Cacheable (memoization)

## Immutability

**Data cannot be changed after creation**.

```python
# Mutable (avoid in FP)
list1 = [1, 2, 3]
list1.append(4)  # Changes original

# Immutable (FP way)
tuple1 = (1, 2, 3)
tuple2 = tuple1 + (4,)  # New tuple

# Immutable operations
original = [1, 2, 3]
doubled = [x * 2 for x in original]  # New list
```

```ruby
# Mutable
arr = [1, 2, 3]
arr << 4  # Modifies original

# Immutable
arr = [1, 2, 3].freeze
doubled = arr.map { |x| x * 2 }  # New array
```

## First-Class Functions

**Functions are values** - can be passed, returned, assigned.

```python
# Assign to variable
multiply = lambda x, y: x * y

# Pass as argument
def apply(func, x, y):
    return func(x, y)

apply(multiply, 3, 4)  # 12

# Return function
def make_multiplier(n):
    return lambda x: x * n

times_three = make_multiplier(3)
times_three(5)  # 15
```

## Higher-Order Functions

**Functions that take or return functions**.

```python
# Map - transform each element
numbers = [1, 2, 3, 4]
doubled = list(map(lambda x: x * 2, numbers))  # [2, 4, 6, 8]

# Filter - keep matching elements
evens = list(filter(lambda x: x % 2 == 0, numbers))  # [2, 4]

# Reduce - combine to single value
from functools import reduce
total = reduce(lambda x, y: x + y, numbers)  # 10
```

```ruby
numbers = [1, 2, 3, 4]

# Map
doubled = numbers.map { |x| x * 2 }  # [2, 4, 6, 8]

# Select (filter)
evens = numbers.select { |x| x.even? }  # [2, 4]

# Reduce
total = numbers.reduce { |sum, x| sum + x }  # 10
# Or: numbers.reduce(:+)
```

## Function Composition

**Build complex functions from simple ones**.

```python
# Composition
def compose(f, g):
    return lambda x: f(g(x))

double = lambda x: x * 2
square = lambda x: x * x

double_then_square = compose(square, double)
double_then_square(3)  # (3*2)^2 = 36
```

```ruby
# Composition
double = ->(x) { x * 2 }
square = ->(x) { x * x }

double_then_square = ->(x) { square.call(double.call(x)) }
double_then_square.call(3)  # 36
```

## Recursion

**Function calls itself** - FP alternative to loops.

```python
# Factorial
def factorial(n):
    if n <= 1:
        return 1
    return n * factorial(n - 1)

factorial(5)  # 120

# List sum
def sum_list(lst):
    if not lst:
        return 0
    return lst[0] + sum_list(lst[1:])
```

```ruby
# Factorial
def factorial(n)
  return 1 if n <= 1
  n * factorial(n - 1)
end

# List sum
def sum_list(arr)
  return 0 if arr.empty?
  arr.first + sum_list(arr.drop(1))
end
```

## Currying

**Transform multi-argument function into sequence of single-argument functions**.

```python
# Manual currying
def add(x):
    def add_x(y):
        return x + y
    return add_x

add_five = add(5)
add_five(3)  # 8

# Using functools
from functools import partial
def multiply(x, y, z):
    return x * y * z

times_2 = partial(multiply, 2)
times_2(3, 4)  # 24
```

```ruby
# Currying
add = ->(x) { ->(y) { x + y } }
add_five = add.call(5)
add_five.call(3)  # 8

# Ruby curry method
multiply = ->(x, y, z) { x * y * z }
times_2 = multiply.curry.call(2)
times_2.call(3, 4)  # 24
```

## Partial Application

**Fix some arguments of a function**.

```python
from functools import partial

def power(base, exponent):
    return base ** exponent

square = partial(power, exponent=2)
cube = partial(power, exponent=3)

square(5)  # 25
cube(5)   # 125
```

## Lazy Evaluation

**Compute only when needed**.

```python
# Generator - lazy
def fibonacci():
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b

# Only computes when requested
fib = fibonacci()
next(fib)  # 0
next(fib)  # 1
next(fib)  # 1

# Lazy list operations
numbers = range(1000000)  # Doesn't create list
evens = (x for x in numbers if x % 2 == 0)  # Generator
first_ten = list(itertools.islice(evens, 10))
```

```ruby
# Lazy enumerator
fib = Enumerator.new do |y|
  a, b = 0, 1
  loop do
    y << a
    a, b = b, a + b
  end
end

fib.take(10)  # [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]

# Lazy operations
(1..Float::INFINITY)
  .lazy
  .select(&:even?)
  .take(5)
  .to_a  # [2, 4, 6, 8, 10]
```

## Functors, Applicatives, Monads

**Patterns for working with wrapped values** (advanced).

```python
# Functor - map over wrapped value
class Maybe:
    def __init__(self, value):
        self.value = value

    def map(self, func):
        if self.value is None:
            return Maybe(None)
        return Maybe(func(self.value))

Maybe(5).map(lambda x: x * 2)  # Maybe(10)
Maybe(None).map(lambda x: x * 2)  # Maybe(None)
```

## Common FP Patterns

### Pipeline/Chain

```python
# Process data through steps
from functools import reduce

def pipeline(*funcs):
    def apply(x):
        return reduce(lambda v, f: f(v), funcs, x)
    return apply

process = pipeline(
    lambda x: x * 2,
    lambda x: x + 1,
    lambda x: x ** 2
)

process(3)  # ((3*2)+1)^2 = 49
```

```ruby
# Method chaining
[1, 2, 3, 4, 5]
  .map { |x| x * 2 }
  .select { |x| x > 5 }
  .reduce(:+)  # 18
```

### Point-Free Style

**Define functions without explicitly mentioning arguments**.

```python
# With points (arguments)
def double_all(numbers):
    return map(lambda x: x * 2, numbers)

# Point-free (compose operations)
from functools import partial
double_all = partial(map, lambda x: x * 2)
```

```ruby
# With block argument
numbers.map { |x| x * 2 }

# Point-free
numbers.map(&:to_s)  # Convert to string
numbers.select(&:even?)  # Filter evens
```

### Tail Recursion Optimization

```python
# Not tail-recursive (stack builds up)
def factorial(n):
    if n <= 1:
        return 1
    return n * factorial(n - 1)  # Multiply after return

# Tail-recursive (Python doesn't optimize, but pattern)
def factorial_tail(n, acc=1):
    if n <= 1:
        return acc
    return factorial_tail(n - 1, n * acc)  # Recursive call is last
```

## Practical FP in Real Code

```python
# Procedural style
def get_active_user_emails(users):
    result = []
    for user in users:
        if user.is_active:
            result.append(user.email.lower())
    return result

# Functional style
def get_active_user_emails(users):
    return list(
        map(lambda u: u.email.lower(),
            filter(lambda u: u.is_active, users))
    )

# Or with comprehension (pythonic FP)
def get_active_user_emails(users):
    return [u.email.lower() for u in users if u.is_active]
```

```ruby
# Procedural
def get_active_user_emails(users)
  result = []
  users.each do |user|
    result << user.email.downcase if user.active?
  end
  result
end

# Functional
def get_active_user_emails(users)
  users
    .select(&:active?)
    .map { |u| u.email.downcase }
end
```

## FP vs OOP

| Aspect | FP | OOP |
|--------|----|----|
| Data | Immutable | Mutable |
| State | Avoid | Encapsulated |
| Code reuse | Composition | Inheritance |
| Focus | What to do | How to structure |
| Side effects | Minimize | Accepted |

**Both have value** - modern languages support both!

## Key Takeaways

1. **Pure functions** - Predictable, testable
2. **Immutability** - Avoid bugs from state changes
3. **First-class functions** - Pass functions around
4. **Higher-order functions** - map, filter, reduce
5. **Composition** - Build complex from simple
6. **Recursion** - Alternative to loops
7. **Lazy evaluation** - Compute only when needed

**Remember**: FP is a tool, not a religion. Use when it makes code clearer!
