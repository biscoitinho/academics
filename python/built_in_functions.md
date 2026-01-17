## Useful Built-in Functions

Python's most commonly used built-in functions.

### enumerate()

Get index and value while iterating.

```python
fruits = ['apple', 'banana', 'cherry']

# Without enumerate
for i in range(len(fruits)):
    print(i, fruits[i])

# With enumerate - better
for i, fruit in enumerate(fruits):
    print(i, fruit)

# Start from different index
for i, fruit in enumerate(fruits, start=1):
    print(i, fruit)  # 1 apple, 2 banana, 3 cherry
```

### zip()

Combine multiple iterables together.

```python
names = ['Alice', 'Bob', 'Charlie']
ages = [25, 30, 35]
cities = ['NYC', 'LA', 'Chicago']

# Zip them together
for name, age, city in zip(names, ages, cities):
    print(f"{name}, {age}, from {city}")

# Create dict from two lists
person_dict = dict(zip(names, ages))
print(person_dict)  # {'Alice': 25, 'Bob': 30, 'Charlie': 35}

# Unzip using zip with *
pairs = [(1, 'a'), (2, 'b'), (3, 'c')]
numbers, letters = zip(*pairs)
print(numbers)  # (1, 2, 3)
print(letters)  # ('a', 'b', 'c')
```

### any() and all()

Check if any or all elements are truthy.

```python
numbers = [0, 1, 2, 3]

# any() - True if at least one is truthy
print(any(numbers))  # True

# all() - True only if all are truthy
print(all(numbers))  # False (because of 0)

numbers = [1, 2, 3]
print(all(numbers))  # True

# Check if any number is even
print(any(n % 2 == 0 for n in numbers))

# Check if all numbers are positive
print(all(n > 0 for n in numbers))
```

### sorted()

Return sorted version without modifying original.

```python
numbers = [3, 1, 4, 1, 5, 9, 2]

# Sort ascending
sorted_nums = sorted(numbers)
print(sorted_nums)  # [1, 1, 2, 3, 4, 5, 9]

# Sort descending
sorted_desc = sorted(numbers, reverse=True)
print(sorted_desc)  # [9, 5, 4, 3, 2, 1, 1]

# Sort by custom key
words = ['banana', 'pie', 'Washington', 'book']
sorted_words = sorted(words, key=len)
print(sorted_words)  # ['pie', 'book', 'banana', 'Washington']

# Sort ignoring case
sorted_words = sorted(words, key=str.lower)
print(sorted_words)  # ['banana', 'book', 'pie', 'Washington']
```

### reversed()

Reverse an iterable.

```python
numbers = [1, 2, 3, 4, 5]

# Returns an iterator
for n in reversed(numbers):
    print(n)  # 5, 4, 3, 2, 1

# Convert to list
reversed_list = list(reversed(numbers))
```

### range()

Generate sequence of numbers.

```python
# range(stop)
for i in range(5):
    print(i)  # 0, 1, 2, 3, 4

# range(start, stop)
for i in range(2, 5):
    print(i)  # 2, 3, 4

# range(start, stop, step)
for i in range(0, 10, 2):
    print(i)  # 0, 2, 4, 6, 8

# Reverse range
for i in range(5, 0, -1):
    print(i)  # 5, 4, 3, 2, 1

# Convert to list
numbers = list(range(5))
print(numbers)  # [0, 1, 2, 3, 4]
```

### sum(), min(), max()

Aggregate functions.

```python
numbers = [1, 2, 3, 4, 5]

print(sum(numbers))    # 15
print(min(numbers))    # 1
print(max(numbers))    # 5

# sum() with start value
print(sum(numbers, 10))  # 25

# min/max with key
words = ['a', 'abc', 'ab']
print(max(words, key=len))  # 'abc'
```

### isinstance() and type()

Check object types.

```python
# isinstance() - recommended
x = 5
print(isinstance(x, int))     # True
print(isinstance(x, (int, float)))  # True (either)

# type()
print(type(x))                # <class 'int'>
print(type(x) == int)         # True
```

### len()

Get length of sequences.

```python
print(len([1, 2, 3]))       # 3
print(len("hello"))          # 5
print(len({'a': 1, 'b': 2})) # 2
```

### map()

Apply function to all items.

```python
numbers = [1, 2, 3, 4, 5]

# Square all numbers
squared = map(lambda x: x**2, numbers)
print(list(squared))  # [1, 4, 9, 16, 25]

# Convert strings to ints
strings = ['1', '2', '3']
integers = list(map(int, strings))
print(integers)  # [1, 2, 3]

# Map with multiple iterables
a = [1, 2, 3]
b = [4, 5, 6]
result = map(lambda x, y: x + y, a, b)
print(list(result))  # [5, 7, 9]
```

### filter()

Filter items based on condition.

```python
numbers = [1, 2, 3, 4, 5, 6]

# Get even numbers
evens = filter(lambda x: x % 2 == 0, numbers)
print(list(evens))  # [2, 4, 6]

# Filter None values
values = [1, None, 2, None, 3]
filtered = filter(None, values)
print(list(filtered))  # [1, 2, 3]
```

### abs(), round(), pow()

Math functions.

```python
print(abs(-5))           # 5
print(round(3.14159, 2)) # 3.14
print(pow(2, 3))         # 8 (2^3)
```

### input()

Get user input.

```python
name = input("Enter your name: ")
print(f"Hello, {name}!")

# Convert to int
age = int(input("Enter your age: "))
```

### dir() and help()

Inspect objects.

```python
# List all attributes/methods
print(dir([]))

# Get help about object
help(list)
```
