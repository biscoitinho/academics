# Programming Paradigms

Different approaches to writing and organizing code.

## What is a Programming Paradigm?

A programming paradigm is a fundamental style or approach to programming. Different paradigms provide different ways to structure and think about code.

**Most languages support multiple paradigms** (multi-paradigm languages):
- Python: Imperative, OOP, Functional
- Ruby: Imperative, OOP, Functional
- JavaScript: Imperative, OOP, Functional, Event-driven

## Main Paradigms

### 1. Imperative Programming

**What**: Code as a sequence of statements that change program state.

**How**: Step-by-step instructions telling the computer *how* to do something.

```python
# Python - Imperative
total = 0
numbers = [1, 2, 3, 4, 5]
for num in numbers:
    total = total + num
print(total)  # 15
```

```ruby
# Ruby - Imperative
total = 0
numbers = [1, 2, 3, 4, 5]
numbers.each do |num|
  total = total + num
end
puts total  # 15
```

**Characteristics**:
- Step-by-step instructions
- Variables can be modified
- Control flow (if, for, while)
- Focuses on *how* to achieve result

**When to use**:
- Simple scripts
- System programming
- When performance is critical
- When you need fine control

### 2. Procedural Programming

**What**: Imperative programming with procedures/functions.

**How**: Group instructions into reusable procedures.

```python
# Python - Procedural
def calculate_sum(numbers):
    total = 0
    for num in numbers:
        total += num
    return total

def calculate_average(numbers):
    return calculate_sum(numbers) / len(numbers)

nums = [1, 2, 3, 4, 5]
avg = calculate_average(nums)
print(avg)  # 3.0
```

```ruby
# Ruby - Procedural
def calculate_sum(numbers)
  total = 0
  numbers.each { |num| total += num }
  total
end

def calculate_average(numbers)
  calculate_sum(numbers) / numbers.length.to_f
end

nums = [1, 2, 3, 4, 5]
avg = calculate_average(nums)
puts avg  # 3.0
```

**Characteristics**:
- Functions/procedures as main building blocks
- Data and functions are separate
- Code reuse through functions
- Top-down design

**When to use**:
- Scripts with reusable logic
- C programming
- When OOP is overkill

### 3. Object-Oriented Programming (OOP)

**What**: Code organized around objects that contain both data and behavior.

**How**: Define classes that bundle data (attributes) and operations (methods).

```python
# Python - OOP
class BankAccount:
    def __init__(self, balance=0):
        self._balance = balance

    def deposit(self, amount):
        if amount > 0:
            self._balance += amount

    def withdraw(self, amount):
        if amount <= self._balance:
            self._balance -= amount

    def get_balance(self):
        return self._balance

account = BankAccount(100)
account.deposit(50)
account.withdraw(30)
print(account.get_balance())  # 120
```

```ruby
# Ruby - OOP
class BankAccount
  def initialize(balance = 0)
    @balance = balance
  end

  def deposit(amount)
    @balance += amount if amount > 0
  end

  def withdraw(amount)
    @balance -= amount if amount <= @balance
  end

  def balance
    @balance
  end
end

account = BankAccount.new(100)
account.deposit(50)
account.withdraw(30)
puts account.balance  # 120
```

**Core Principles**:
- **Encapsulation** - Hide internal details
- **Inheritance** - Reuse through parent classes
- **Polymorphism** - Same interface, different implementations
- **Abstraction** - Simplify complex reality

**When to use**:
- Large applications
- When modeling real-world entities
- When you need inheritance
- Team projects with clear boundaries

**Pros**:
- Code organization
- Reusability
- Maintainability

**Cons**:
- Can be overkill for simple tasks
- More verbose
- Harder to reason about state

### 4. Functional Programming (FP)

**What**: Code as composition of pure functions, avoiding shared state and mutable data.

**How**: Functions as first-class citizens, data transformations.

```python
# Python - Functional
from functools import reduce

numbers = [1, 2, 3, 4, 5]

# Pure functions
double = lambda x: x * 2
is_even = lambda x: x % 2 == 0
add = lambda x, y: x + y

# Transformations
doubled = map(double, numbers)        # [2, 4, 6, 8, 10]
evens = filter(is_even, doubled)      # [2, 4, 6, 8, 10]
total = reduce(add, evens)            # 30

print(total)
```

```ruby
# Ruby - Functional
numbers = [1, 2, 3, 4, 5]

# Pure functions
double = ->(x) { x * 2 }
is_even = ->(x) { x.even? }
add = ->(x, y) { x + y }

# Transformations
total = numbers
  .map(&double)
  .select(&is_even)
  .reduce(&add)

puts total  # 30
```

**Key Concepts**:
- **Pure functions** - Same input always gives same output, no side effects
- **Immutability** - Data cannot be changed once created
- **First-class functions** - Functions can be passed as arguments
- **Higher-order functions** - Functions that take/return functions
- **Composition** - Build complex functions from simple ones

**When to use**:
- Data processing pipelines
- Concurrent programming
- When state management is complex
- Mathematical computations

**Pros**:
- Easier to test
- Easier to parallelize
- No side effects
- Predictable

**Cons**:
- Can be less intuitive
- Performance overhead (immutability)
- Steep learning curve

### 5. Declarative Programming

**What**: Describe *what* you want, not *how* to achieve it.

**How**: Express logic without describing control flow.

```python
# Python - Declarative (list comprehension)
numbers = [1, 2, 3, 4, 5]
doubled_evens = [x * 2 for x in numbers if x % 2 == 0]
print(doubled_evens)  # [4, 8]
```

```ruby
# Ruby - Declarative
numbers = [1, 2, 3, 4, 5]
doubled_evens = numbers.select(&:even?).map { |x| x * 2 }
puts doubled_evens.inspect  # [4, 8]
```

**SQL Example** (ultimate declarative):
```sql
-- What you want, not how to get it
SELECT name, age
FROM users
WHERE age > 18
ORDER BY name;
```

**HTML/CSS** (declarative):
```html
<button class="primary">Click Me</button>
```

**When to use**:
- Database queries (SQL)
- UI markup (HTML)
- Configuration (YAML, JSON)
- Data transformations

**Pros**:
- Readable
- Less code
- Optimization left to engine

**Cons**:
- Less control
- May be slower
- Debugging harder

### 6. Event-Driven Programming

**What**: Program flow determined by events (user actions, messages, etc.).

**How**: Register handlers/listeners that respond to events.

```python
# Python - Event-driven (simple example)
class Button:
    def __init__(self):
        self.click_handlers = []

    def on_click(self, handler):
        self.click_handlers.append(handler)

    def click(self):
        for handler in self.click_handlers:
            handler()

def say_hello():
    print("Hello!")

def say_goodbye():
    print("Goodbye!")

button = Button()
button.on_click(say_hello)
button.on_click(say_goodbye)
button.click()
# Output:
# Hello!
# Goodbye!
```

```ruby
# Ruby - Event-driven
class Button
  def initialize
    @click_handlers = []
  end

  def on_click(&handler)
    @click_handlers << handler
  end

  def click
    @click_handlers.each(&:call)
  end
end

button = Button.new
button.on_click { puts "Hello!" }
button.on_click { puts "Goodbye!" }
button.click
# Output:
# Hello!
# Goodbye!
```

**Characteristics**:
- Event loop
- Callbacks/handlers
- Asynchronous
- Non-blocking

**When to use**:
- GUI applications
- Web servers (Node.js)
- Real-time applications
- Message-driven systems

**Pros**:
- Responsive
- Scalable (async)
- Decoupled

**Cons**:
- Callback hell
- Harder to debug
- Complex flow

### 7. Reactive Programming

**What**: Programming with asynchronous data streams.

**How**: Observe and react to data changes.

```python
# Python - Reactive (pseudo-code with RxPY)
from rx import Observable

# Stream of numbers
numbers = Observable.from_([1, 2, 3, 4, 5])

# React to stream
numbers \
    .map(lambda x: x * 2) \
    .filter(lambda x: x > 5) \
    .subscribe(lambda x: print(x))

# Output: 6, 8, 10
```

**Characteristics**:
- Data as streams
- Observer pattern
- Functional operators
- Asynchronous

**When to use**:
- Real-time data (stock prices, sensors)
- User interfaces (React, Vue)
- Complex async operations
- Event streams

### 8. Concurrent/Parallel Programming

**What**: Execute multiple tasks simultaneously.

**How**: Threads, processes, async/await.

```python
# Python - Concurrent
import asyncio

async def fetch_data(id):
    await asyncio.sleep(1)  # Simulate I/O
    return f"Data {id}"

async def main():
    results = await asyncio.gather(
        fetch_data(1),
        fetch_data(2),
        fetch_data(3)
    )
    print(results)

asyncio.run(main())
# Output: ['Data 1', 'Data 2', 'Data 3']
# Takes ~1 second, not 3
```

```ruby
# Ruby - Concurrent
require 'async'

def fetch_data(id)
  sleep(1)  # Simulate I/O
  "Data #{id}"
end

Async do
  results = Async::Barrier.new

  3.times do |i|
    results.async do
      fetch_data(i + 1)
    end
  end

  puts results.wait.inspect
end
# Takes ~1 second, not 3
```

**When to use**:
- I/O-bound operations
- Multi-core utilization
- Real-time systems
- High-performance applications

## Paradigm Comparison

| Paradigm | Focus | Main Tool | State | When to Use |
|----------|-------|-----------|-------|-------------|
| **Imperative** | How | Variables | Mutable | Simple scripts |
| **Procedural** | How | Functions | Mutable | Reusable logic |
| **OOP** | Objects | Classes | Encapsulated | Large apps |
| **Functional** | What | Functions | Immutable | Data transformation |
| **Declarative** | What | Expressions | N/A | Config, queries |
| **Event-driven** | Events | Handlers | Event loop | GUIs, servers |
| **Reactive** | Streams | Observables | Stream-based | Real-time data |

## Mixing Paradigms (Real World)

Most applications use multiple paradigms:

```python
# Python - Mixed paradigms

# OOP for structure
class DataProcessor:
    def __init__(self, data):
        self.data = data

    # Functional for transformations
    def process(self):
        return (
            self.data
            .map(lambda x: x * 2)      # Functional
            .filter(lambda x: x > 10)   # Functional
        )

    # Imperative for control
    def save(self, filename):
        with open(filename, 'w') as f:
            for item in self.data:     # Imperative
                f.write(str(item) + '\n')

# Event-driven for handling
processor = DataProcessor([1, 2, 3, 4, 5])
processor.on_complete(lambda: print("Done!"))
```

## Choosing a Paradigm

**Questions to ask**:

1. **What's the problem domain?**
   - Data transformation → Functional
   - Real-world modeling → OOP
   - User interaction → Event-driven

2. **What's the scale?**
   - Small script → Procedural
   - Large application → OOP
   - Microservices → Functional/Event-driven

3. **What's the team familiar with?**
   - Use what the team knows

4. **What does the language support well?**
   - Python: OOP + Functional
   - Ruby: OOP + Functional
   - Haskell: Purely Functional
   - Java: Primarily OOP

5. **What are the performance requirements?**
   - High performance → Imperative
   - I/O-bound → Event-driven/Async

## Common Combinations

### Web Application
```
- OOP for business logic (models, services)
- Functional for data transformations
- Event-driven for HTTP handling
- Declarative for templates/queries
```

### Data Pipeline
```
- Functional for transformations
- Procedural for orchestration
- Declarative for config
```

### Game
```
- OOP for game entities
- Imperative for game loop
- Event-driven for input
- Functional for calculations
```

## Key Takeaways

1. **No "best" paradigm** - Different problems need different approaches
2. **Most languages are multi-paradigm** - Use the right tool for the job
3. **Paradigms can be mixed** - Real applications use multiple paradigms
4. **Learn multiple paradigms** - Makes you a better programmer
5. **Start simple** - Begin with imperative/procedural, add complexity as needed

**Remember**: The goal is to write maintainable, working code. The paradigm is just a tool to help you get there!
