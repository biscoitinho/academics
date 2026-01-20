# Concurrency

## Concepts

**Concurrency**: Multiple tasks making progress (not necessarily simultaneously)
**Parallelism**: Multiple tasks executing simultaneously (requires multiple CPU cores)

```
Concurrency: Taking turns on one core
Parallelism: Actually running at the same time on multiple cores
```

## Processes vs Threads

### Process

- Independent execution unit
- Own memory space
- Heavyweight
- IPC (Inter-Process Communication) needed

### Thread

- Lightweight process
- Shares memory with other threads
- Same process
- Easier communication but needs synchronization

## Python Threading

```python
import threading
import time

def worker(name):
    print(f"{name} starting")
    time.sleep(2)
    print(f"{name} finished")

# Create threads
t1 = threading.Thread(target=worker, args=("Thread-1",))
t2 = threading.Thread(target=worker, args=("Thread-2",))

# Start threads
t1.start()
t2.start()

# Wait for completion
t1.join()
t2.join()

print("All threads completed")

# Output:
# Thread-1 starting
# Thread-2 starting
# (2 seconds pause)
# Thread-1 finished
# Thread-2 finished
# All threads completed
```

### Threading with Shared State

```python
import threading

counter = 0
lock = threading.Lock()

def increment():
    global counter
    for _ in range(100000):
        with lock:  # Acquire lock
            counter += 1
        # Lock released automatically

threads = []
for _ in range(10):
    t = threading.Thread(target=increment)
    t.start()
    threads.append(t)

for t in threads:
    t.join()

print(f"Counter: {counter}")  # 1000000 (correct with lock)
```

## Ruby Threading

```ruby
require 'thread'

def worker(name)
  puts "#{name} starting"
  sleep 2
  puts "#{name} finished"
end

# Create threads
t1 = Thread.new { worker("Thread-1") }
t2 = Thread.new { worker("Thread-2") }

# Wait for completion
t1.join
t2.join

puts "All threads completed"
```

```ruby
# With shared state
counter = 0
mutex = Mutex.new

threads = 10.times.map do
  Thread.new do
    100_000.times do
      mutex.synchronize do
        counter += 1
      end
    end
  end
end

threads.each(&:join)
puts "Counter: #{counter}"
```

## Python Multiprocessing

```python
from multiprocessing import Process
import os

def worker(name):
    print(f"{name} in process {os.getpid()}")

if __name__ == '__main__':
    processes = []
    for i in range(4):
        p = Process(target=worker, args=(f"Process-{i}",))
        p.start()
        processes.append(p)

    for p in processes:
        p.join()

# Output (process IDs will vary):
# Process-0 in process 12345
# Process-1 in process 12346
# Process-2 in process 12347
# Process-3 in process 12348
```

### Process Pool

```python
from multiprocessing import Pool

def square(n):
    return n * n

if __name__ == '__main__':
    with Pool(processes=4) as pool:
        results = pool.map(square, [1, 2, 3, 4, 5])
        print(results)  # [1, 4, 9, 16, 25]
```

## Async/Await (Python)

```python
import asyncio

async def fetch_data(id):
    print(f"Fetching {id}")
    await asyncio.sleep(2)  # Simulate I/O
    print(f"Fetched {id}")
    return f"Data {id}"

async def main():
    # Run concurrently
    results = await asyncio.gather(
        fetch_data(1),
        fetch_data(2),
        fetch_data(3)
    )
    print(results)

asyncio.run(main())

# Output:
# Fetching 1
# Fetching 2
# Fetching 3
# (2 seconds pause - all waiting together)
# Fetched 1
# Fetched 2
# Fetched 3
# ['Data 1', 'Data 2', 'Data 3']
```

### Async HTTP Requests

```python
import asyncio
import aiohttp

async def fetch_url(session, url):
    async with session.get(url) as response:
        return await response.text()

async def main():
    urls = [
        'https://api.github.com/users/octocat',
        'https://api.github.com/users/torvalds',
        'https://api.github.com/users/gvanrossum'
    ]

    async with aiohttp.ClientSession() as session:
        tasks = [fetch_url(session, url) for url in urls]
        results = await asyncio.gather(*tasks)
        print(f"Fetched {len(results)} URLs")

asyncio.run(main())
```

## Locks

### Mutex (Mutual Exclusion)

```python
import threading

lock = threading.Lock()

# Method 1: with statement
with lock:
    # Critical section
    pass

# Method 2: explicit
lock.acquire()
try:
    # Critical section
    pass
finally:
    lock.release()
```

```ruby
mutex = Mutex.new

mutex.synchronize do
  # Critical section
end
```

### Reentrant Lock (RLock)

```python
import threading

lock = threading.RLock()

def recursive_function(n):
    with lock:
        if n > 0:
            print(n)
            recursive_function(n - 1)  # Can acquire lock again

recursive_function(5)
```

## Semaphores

Allows N threads to access resource simultaneously.

```python
import threading
import time

# Allow max 3 concurrent connections
semaphore = threading.Semaphore(3)

def access_resource(id):
    print(f"{id} waiting")
    with semaphore:
        print(f"{id} acquired")
        time.sleep(2)  # Use resource
        print(f"{id} released")

threads = []
for i in range(10):
    t = threading.Thread(target=access_resource, args=(f"Thread-{i}",))
    t.start()
    threads.append(t)

for t in threads:
    t.join()

# Only 3 threads access resource at a time
```

```ruby
require 'thread'

semaphore = Mutex.new
counter = 0
max_concurrent = 3

threads = 10.times.map do |i|
  Thread.new do
    semaphore.synchronize do
      if counter < max_concurrent
        counter += 1
      end
    end
    puts "Thread-#{i} working"
    sleep 2
    semaphore.synchronize { counter -= 1 }
  end
end

threads.each(&:join)
```

## Race Condition

```python
# ❌ Race condition (incorrect)
import threading

counter = 0

def increment():
    global counter
    for _ in range(100000):
        counter += 1  # Not atomic!

threads = [threading.Thread(target=increment) for _ in range(10)]
for t in threads:
    t.start()
for t in threads:
    t.join()

print(f"Counter: {counter}")  # Less than 1000000!

# ✅ Fixed with lock
lock = threading.Lock()

def increment_safe():
    global counter
    for _ in range(100000):
        with lock:
            counter += 1

# Now counter will be exactly 1000000
```

## Deadlock

```python
# ❌ Deadlock example
import threading
import time

lock1 = threading.Lock()
lock2 = threading.Lock()

def thread1():
    with lock1:
        print("Thread 1: lock1 acquired")
        time.sleep(0.1)
        with lock2:  # Waits for lock2
            print("Thread 1: lock2 acquired")

def thread2():
    with lock2:
        print("Thread 2: lock2 acquired")
        time.sleep(0.1)
        with lock1:  # Waits for lock1
            print("Thread 2: lock1 acquired")

# DEADLOCK: Thread 1 has lock1, waits for lock2
#           Thread 2 has lock2, waits for lock1

# ✅ Fix: Always acquire locks in same order
def thread1_fixed():
    with lock1:
        with lock2:
            print("Thread 1: both locks acquired")

def thread2_fixed():
    with lock1:  # Same order
        with lock2:
            print("Thread 2: both locks acquired")
```

## Thread-Safe Queue

```python
from queue import Queue
import threading
import time

# Producer-consumer pattern
queue = Queue()

def producer():
    for i in range(5):
        item = f"Item {i}"
        queue.put(item)
        print(f"Produced {item}")
        time.sleep(0.5)

def consumer():
    while True:
        item = queue.get()
        if item is None:
            break
        print(f"Consumed {item}")
        queue.task_done()
        time.sleep(1)

# Start producer and consumer
p = threading.Thread(target=producer)
c = threading.Thread(target=consumer)

p.start()
c.start()

p.join()
queue.put(None)  # Signal consumer to stop
c.join()
```

```ruby
require 'thread'

queue = Queue.new

# Producer
producer = Thread.new do
  5.times do |i|
    queue << "Item #{i}"
    puts "Produced Item #{i}"
    sleep 0.5
  end
end

# Consumer
consumer = Thread.new do
  loop do
    item = queue.pop
    break if item.nil?
    puts "Consumed #{item}"
    sleep 1
  end
end

producer.join
queue << nil
consumer.join
```

## Thread Pool

```python
from concurrent.futures import ThreadPoolExecutor
import time

def task(n):
    print(f"Processing {n}")
    time.sleep(1)
    return n * 2

with ThreadPoolExecutor(max_workers=3) as executor:
    # Submit tasks
    futures = [executor.submit(task, i) for i in range(10)]

    # Get results
    for future in futures:
        result = future.result()
        print(f"Result: {result}")
```

### Process Pool

```python
from concurrent.futures import ProcessPoolExecutor

def cpu_intensive_task(n):
    return sum(i*i for i in range(n))

if __name__ == '__main__':
    with ProcessPoolExecutor(max_workers=4) as executor:
        results = executor.map(cpu_intensive_task, [1000000, 2000000, 3000000])
        for result in results:
            print(result)
```

## Event

```python
import threading
import time

event = threading.Event()

def waiter():
    print("Waiting for event")
    event.wait()  # Block until event is set
    print("Event received!")

def setter():
    time.sleep(2)
    print("Setting event")
    event.set()

t1 = threading.Thread(target=waiter)
t2 = threading.Thread(target=setter)

t1.start()
t2.start()

t1.join()
t2.join()
```

## Condition Variable

```python
import threading
import time

condition = threading.Condition()
items = []

def consumer():
    with condition:
        while not items:
            print("Consumer waiting")
            condition.wait()  # Wait for notification
        item = items.pop(0)
        print(f"Consumed {item}")

def producer():
    time.sleep(1)
    with condition:
        items.append("Item 1")
        print("Produced Item 1")
        condition.notify()  # Wake up waiting thread

c = threading.Thread(target=consumer)
p = threading.Thread(target=producer)

c.start()
p.start()

c.join()
p.join()
```

## GIL (Global Interpreter Lock) - Python

Python's GIL prevents true parallelism for CPU-bound tasks.

```python
# CPU-bound: Use multiprocessing
from multiprocessing import Pool

def cpu_task(n):
    return sum(i*i for i in range(n))

with Pool(4) as pool:
    results = pool.map(cpu_task, [1000000] * 4)

# I/O-bound: Use threading or async
import threading

def io_task():
    # Network request, file I/O, etc.
    pass

threads = [threading.Thread(target=io_task) for _ in range(10)]
for t in threads:
    t.start()
for t in threads:
    t.join()
```

## Atomic Operations

```python
import threading

# ❌ Not atomic
counter = 0
counter += 1  # Read, increment, write (3 operations)

# ✅ Use lock
lock = threading.Lock()
with lock:
    counter += 1

# ✅ Or use atomic types (from libraries)
from threading import Lock

class AtomicCounter:
    def __init__(self):
        self._value = 0
        self._lock = Lock()

    def increment(self):
        with self._lock:
            self._value += 1
            return self._value

    def value(self):
        with self._lock:
            return self._value
```

## Thread Local Storage

```python
import threading

thread_local = threading.local()

def worker(value):
    thread_local.data = value
    print(f"Thread {threading.current_thread().name}: {thread_local.data}")

threads = []
for i in range(3):
    t = threading.Thread(target=worker, args=(i,), name=f"T{i}")
    t.start()
    threads.append(t)

for t in threads:
    t.join()

# Each thread has its own copy of thread_local.data
```

## Async Context Manager

```python
import asyncio

class AsyncResource:
    async def __aenter__(self):
        print("Acquiring resource")
        await asyncio.sleep(0.1)
        return self

    async def __aexit__(self, exc_type, exc_val, exc_tb):
        print("Releasing resource")
        await asyncio.sleep(0.1)

    async def query(self):
        print("Querying")
        return "result"

async def main():
    async with AsyncResource() as resource:
        result = await resource.query()
        print(result)

asyncio.run(main())
```

## Async Generators

```python
import asyncio

async def async_range(n):
    for i in range(n):
        await asyncio.sleep(0.1)
        yield i

async def main():
    async for i in async_range(5):
        print(i)

asyncio.run(main())
```

## Concurrent HTTP Requests Comparison

```python
# Sequential (slow)
import requests
import time

start = time.time()
for i in range(10):
    response = requests.get('https://httpbin.org/delay/1')
print(f"Sequential: {time.time() - start:.2f}s")  # ~10s

# Threading (faster)
import threading

def fetch(url):
    requests.get(url)

start = time.time()
threads = [threading.Thread(target=fetch, args=('https://httpbin.org/delay/1',))
           for _ in range(10)]
for t in threads:
    t.start()
for t in threads:
    t.join()
print(f"Threading: {time.time() - start:.2f}s")  # ~1s

# Async (fastest for I/O)
import asyncio
import aiohttp

async def fetch_async(session, url):
    async with session.get(url) as response:
        return await response.text()

async def main():
    async with aiohttp.ClientSession() as session:
        tasks = [fetch_async(session, 'https://httpbin.org/delay/1')
                 for _ in range(10)]
        await asyncio.gather(*tasks)

start = time.time()
asyncio.run(main())
print(f"Async: {time.time() - start:.2f}s")  # ~1s
```

## When to Use What

```
CPU-bound tasks:
  → Multiprocessing (Python)
  → Multiple processes
  Example: Image processing, mathematical computation

I/O-bound tasks:
  → Threading or Async/Await
  Example: HTTP requests, file I/O, database queries

Threading:
  ✅ Simple
  ✅ Shared memory
  ❌ GIL (Python)
  ❌ Race conditions

Async/Await:
  ✅ Efficient for I/O
  ✅ Single thread
  ✅ No race conditions (usually)
  ❌ Need async libraries
  ❌ More complex

Multiprocessing:
  ✅ True parallelism
  ✅ No GIL
  ❌ Memory overhead
  ❌ IPC needed
```

## Common Pitfalls

```python
# 1. Forgetting to join threads
t = threading.Thread(target=work)
t.start()
# Missing t.join() - main thread may exit before worker finishes

# 2. Shared mutable state without locks
counter = 0
def increment():
    global counter
    counter += 1  # Race condition!

# 3. Deadlock from circular wait
with lock1:
    with lock2:  # Thread 1
        pass

with lock2:
    with lock1:  # Thread 2 - deadlock!
        pass

# 4. Not handling exceptions in threads
def worker():
    raise Exception("Error")  # Silently fails

t = threading.Thread(target=worker)
t.start()
t.join()  # No exception raised here!

# Fix: Wrap in try-except or use concurrent.futures

# 5. Blocking the event loop (async)
async def slow():
    time.sleep(10)  # ❌ Blocks everything!
    await asyncio.sleep(10)  # ✅ Correct
```

## Best Practices

```python
# 1. Always use locks for shared mutable state
lock = threading.Lock()
with lock:
    shared_data.modify()

# 2. Prefer queue for thread communication
from queue import Queue
queue = Queue()

# 3. Set daemon threads for background work
t = threading.Thread(target=worker, daemon=True)

# 4. Use context managers
with lock:
    # Automatically released

# 5. Limit thread pool size
with ThreadPoolExecutor(max_workers=10) as executor:
    pass

# 6. Use async for I/O-bound operations
async def fetch_data():
    async with aiohttp.ClientSession() as session:
        async with session.get(url) as response:
            return await response.json()

# 7. Profile before optimizing
# Measure if concurrency actually helps
```
