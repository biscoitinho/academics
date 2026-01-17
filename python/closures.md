## Closures

A closure is a function that remembers values from its enclosing scope, even after that scope has finished executing.

### Basic closure

```python
def outer_function(message):
    # This is the enclosing scope
    
    def inner_function():
        # inner_function can access 'message'
        print(message)
    
    return inner_function

# Create a closure
say_hello = outer_function("Hello!")
say_hello()  # Hello!

say_goodbye = outer_function("Goodbye!")
say_goodbye()  # Goodbye!

# Each closure remembers its own 'message'
```

### Why closures are useful

**Creating function factories:**
```python
def multiplier(n):
    def multiply(x):
        return x * n
    return multiply

times_two = multiplier(2)
times_three = multiplier(3)

print(times_two(5))    # 10
print(times_three(5))  # 15
```

**Data encapsulation:**
```python
def counter():
    count = 0
    
    def increment():
        nonlocal count  # Modify enclosing scope variable
        count += 1
        return count
    
    return increment

counter1 = counter()
print(counter1())  # 1
print(counter1())  # 2
print(counter1())  # 3

counter2 = counter()
print(counter2())  # 1 (separate closure)
```

### Closure with multiple functions

```python
def bank_account(initial_balance):
    balance = initial_balance
    
    def deposit(amount):
        nonlocal balance
        balance += amount
        return balance
    
    def withdraw(amount):
        nonlocal balance
        if amount > balance:
            return "Insufficient funds"
        balance -= amount
        return balance
    
    def get_balance():
        return balance
    
    return deposit, withdraw, get_balance

# Create account
deposit, withdraw, get_balance = bank_account(100)

print(get_balance())   # 100
print(deposit(50))     # 150
print(withdraw(30))    # 120
print(get_balance())   # 120
```

### Practical example: Logger

```python
def create_logger(prefix):
    def log(message):
        print(f"[{prefix}] {message}")
    return log

error_log = create_logger("ERROR")
info_log = create_logger("INFO")

error_log("Something went wrong")  # [ERROR] Something went wrong
info_log("Process started")        # [INFO] Process started
```

### Closure in decorators

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
    print(f"Hello, {name}!")

greet("Alice")
# Hello, Alice!
# Hello, Alice!
# Hello, Alice!
```

### Closure vs Class

Closures and classes can solve similar problems:

**Using closure:**
```python
def create_person(name):
    age = 0
    
    def get_age():
        return age
    
    def set_age(new_age):
        nonlocal age
        age = new_age
    
    def info():
        return f"{name} is {age} years old"
    
    return {'get_age': get_age, 'set_age': set_age, 'info': info}

person = create_person("Alice")
person['set_age'](30)
print(person['info']())  # Alice is 30 years old
```

**Using class:**
```python
class Person:
    def __init__(self, name):
        self.name = name
        self.age = 0
    
    def set_age(self, age):
        self.age = age
    
    def info(self):
        return f"{self.name} is {self.age} years old"

person = Person("Alice")
person.set_age(30)
print(person.info())  # Alice is 30 years old
```

### Lambda closures

```python
def create_adder(n):
    return lambda x: x + n

add_5 = create_adder(5)
add_10 = create_adder(10)

print(add_5(3))   # 8
print(add_10(3))  # 13
```

### Common pitfall: Loop closures

```python
# Problem: All closures reference same variable
functions = []
for i in range(3):
    functions.append(lambda: i)

for f in functions:
    print(f())  # 2, 2, 2 (all print 2!)

# Solution: Use default argument
functions = []
for i in range(3):
    functions.append(lambda i=i: i)

for f in functions:
    print(f())  # 0, 1, 2 (correct!)
```

### When to use closures

- Creating function factories
- Data hiding and encapsulation
- Callback functions that need to remember state
- Decorators
- Replacing simple classes with just one method
