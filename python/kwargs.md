## *args and **kwargs

### *args - argument collector

Ability to pass n number of arguments in a function.

```python
def my_func(*args):
    for arg in args:
        print(arg)

my_func(1, 2, 3, 4)
# 1
# 2
# 3
# 4
```

### **kwargs - keyword arguments collector

Ability to pass n number of key-value pair arguments in a function.

```python
def my_func(**kwargs):
    for key, value in kwargs.items():
        print(f"{key} = {value}")

my_func(name="Alice", age=30, city="NYC")
# name = Alice
# age = 30
# city = NYC
```

### Using both together

```python
def my_func(*args, **kwargs):
    print("Positional arguments:", args)
    print("Keyword arguments:", kwargs)

my_func(1, 2, 3, name="Alice", age=30)
# Positional arguments: (1, 2, 3)
# Keyword arguments: {'name': 'Alice', 'age': 30}
```

### With regular parameters

Order matters: regular params, *args, **kwargs

```python
def my_func(required, *args, **kwargs):
    print("Required:", required)
    print("Args:", args)
    print("Kwargs:", kwargs)

my_func("hello", 1, 2, 3, name="Alice")
# Required: hello
# Args: (1, 2, 3)
# Kwargs: {'name': 'Alice'}
```

### Unpacking with * and **

```python
def add(a, b, c):
    return a + b + c

numbers = [1, 2, 3]
print(add(*numbers))  # Unpacks list: add(1, 2, 3)

person = {'name': 'Alice', 'age': 30}
def greet(name, age):
    print(f"Hello {name}, age {age}")

greet(**person)  # Unpacks dict: greet(name='Alice', age=30)
```
