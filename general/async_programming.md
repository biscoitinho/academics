# Asynchronous Programming

Handling operations that don't complete immediately without blocking.

## The Problem: Blocking vs Non-Blocking

### Blocking (Synchronous)

```python
# Python - Blocking
import time

def fetch_data():
    time.sleep(2)  # Wait 2 seconds
    return "data"

start = time.time()
data1 = fetch_data()  # Blocks for 2s
data2 = fetch_data()  # Blocks for 2s
data3 = fetch_data()  # Blocks for 2s
end = time.time()

print(f"Total time: {end - start}s")  # ~6 seconds
```

**Problem**: While waiting for I/O, CPU sits idle.

### Non-Blocking (Asynchronous)

```python
# Python - Async
import asyncio

async def fetch_data():
    await asyncio.sleep(2)  # Don't block
    return "data"

async def main():
    start = asyncio.get_event_loop().time()

    # Run concurrently
    results = await asyncio.gather(
        fetch_data(),
        fetch_data(),
        fetch_data()
    )

    end = asyncio.get_event_loop().time()
    print(f"Total time: {end - start}s")  # ~2 seconds

asyncio.run(main())
```

**Benefit**: All three run concurrently, total time ~2s instead of ~6s.

## Approaches to Async

### 1. Callbacks

**Oldest approach** - Pass function to be called when operation completes.

```python
# Python - Callbacks
def fetch_data(url, callback):
    # Simulated async operation
    import threading
    def do_fetch():
        time.sleep(1)
        callback(f"Data from {url}")

    thread = threading.Thread(target=do_fetch)
    thread.start()

def process_data(data):
    print(f"Got: {data}")

fetch_data("http://api.com", process_data)
# Continues immediately, callback runs later
```

```ruby
# Ruby - Callbacks with EventMachine
require 'eventmachine'

EM.run do
  http = EM::HttpRequest.new('http://api.com').get

  http.callback {
    puts "Success: #{http.response}"
  }

  http.errback {
    puts "Error!"
  }
end
```

**Problem - Callback Hell**:
```javascript
// JavaScript callback hell
getData(function(a) {
    getMoreData(a, function(b) {
        getMoreData(b, function(c) {
            getMoreData(c, function(d) {
                getMoreData(d, function(e) {
                    // Deep nesting!
                })
            })
        })
    })
})
```

### 2. Promises (Futures)

**Better than callbacks** - Represent future value.

```python
# Python - Futures (concurrent.futures)
from concurrent.futures import ThreadPoolExecutor
import time

def fetch_data(url):
    time.sleep(1)
    return f"Data from {url}"

with ThreadPoolExecutor() as executor:
    # Submit tasks, get futures
    future1 = executor.submit(fetch_data, "url1")
    future2 = executor.submit(fetch_data, "url2")

    # Wait for results
    result1 = future1.result()  # Blocks until ready
    result2 = future2.result()
```

```ruby
# Ruby - Promises with concurrent-ruby
require 'concurrent'

promise = Concurrent::Promise.execute {
  sleep 1
  "Data"
}

promise.then { |result|
  puts "Got: #{result}"
}.rescue { |error|
  puts "Error: #{error}"
}

promise.wait  # Block until complete
```

**Better chaining**:
```javascript
// JavaScript Promises
fetch('http://api.com')
  .then(response => response.json())
  .then(data => processData(data))
  .then(result => saveResult(result))
  .catch(error => console.error(error));
```

### 3. Async/Await

**Most modern** - Write async code like sync code.

```python
# Python - async/await
import asyncio
import aiohttp

async def fetch_data(url):
    async with aiohttp.ClientSession() as session:
        async with session.get(url) as response:
            return await response.text()

async def main():
    # Sequential
    data1 = await fetch_data("url1")
    data2 = await fetch_data("url2")

    # Concurrent
    data1, data2 = await asyncio.gather(
        fetch_data("url1"),
        fetch_data("url2")
    )

asyncio.run(main())
```

```ruby
# Ruby - async with async gem
require 'async'
require 'async/http/internet'

Async do
  internet = Async::HTTP::Internet.new

  # Concurrent requests
  responses = Async::Barrier.new

  responses.async do
    internet.get("https://api1.com")
  end

  responses.async do
    internet.get("https://api2.com")
  end

  results = responses.wait
end
```

## Event Loop

Heart of async programming - manages async operations.

```
┌───────────────────────────┐
│    Event Loop (single thread)    │
├───────────────────────────┤
│ 1. Check for completed I/O │
│ 2. Run callbacks           │
│ 3. Check for new tasks     │
│ 4. Repeat                  │
└───────────────────────────┘
```

**Key insight**: While waiting for I/O, event loop runs other tasks.

```python
# Python - Event loop example
import asyncio

async def task1():
    print("Task 1 start")
    await asyncio.sleep(1)  # Yields control
    print("Task 1 end")

async def task2():
    print("Task 2 start")
    await asyncio.sleep(0.5)  # Yields control
    print("Task 2 end")

async def main():
    await asyncio.gather(task1(), task2())

# Output:
# Task 1 start
# Task 2 start
# Task 2 end  (after 0.5s)
# Task 1 end  (after 1s)

asyncio.run(main())
```

## When to Use Async

### Good Use Cases (I/O-Bound)

✅ **Web requests** - Waiting for HTTP responses
```python
async def fetch_multiple_apis():
    async with aiohttp.ClientSession() as session:
        tasks = [fetch_url(session, url) for url in urls]
        return await asyncio.gather(*tasks)
```

✅ **Database queries** - Waiting for DB responses
```python
async def get_users():
    async with async_db.connect() as conn:
        return await conn.fetch("SELECT * FROM users")
```

✅ **File I/O** - Reading/writing files
```python
async def read_files():
    async with aiofiles.open('file.txt') as f:
        return await f.read()
```

✅ **Network operations** - Sockets, messaging

### Bad Use Cases (CPU-Bound)

❌ **Heavy computation** - Use threading/multiprocessing instead
```python
# DON'T use async for CPU-bound
async def compute():
    result = 0
    for i in range(10000000):  # CPU intensive
        result += i
    return result  # Async provides no benefit!
```

❌ **Image processing**
❌ **Video encoding**
❌ **Mathematical calculations**
❌ **Data encryption**

**Rule**: Async helps when waiting, not when computing.

## Async Patterns

### 1. Gather - Run Multiple Tasks

```python
# Python
import asyncio

async def main():
    results = await asyncio.gather(
        fetch_data("url1"),
        fetch_data("url2"),
        fetch_data("url3")
    )
    # Returns [result1, result2, result3]
```

### 2. As Completed - Process Results as They Arrive

```python
# Python
async def main():
    tasks = [fetch_data(url) for url in urls]

    for coro in asyncio.as_completed(tasks):
        result = await coro
        print(f"Got result: {result}")
        # Process immediately, don't wait for all
```

### 3. Timeout - Don't Wait Forever

```python
# Python
async def main():
    try:
        result = await asyncio.wait_for(
            fetch_data("slow_url"),
            timeout=5.0
        )
    except asyncio.TimeoutError:
        print("Too slow!")
```

### 4. Semaphore - Limit Concurrency

```python
# Python - Max 5 concurrent requests
sem = asyncio.Semaphore(5)

async def fetch_with_limit(url):
    async with sem:
        return await fetch_data(url)

async def main():
    tasks = [fetch_with_limit(url) for url in urls]
    await asyncio.gather(*tasks)
```

### 5. Queue - Producer/Consumer

```python
# Python
import asyncio

async def producer(queue):
    for i in range(10):
        await queue.put(i)
        await asyncio.sleep(0.1)

async def consumer(queue):
    while True:
        item = await queue.get()
        print(f"Processing {item}")
        queue.task_done()

async def main():
    queue = asyncio.Queue()

    await asyncio.gather(
        producer(queue),
        consumer(queue),
        consumer(queue)  # Multiple consumers
    )
```

## Async Web Frameworks

### Python - FastAPI

```python
from fastapi import FastAPI
import httpx

app = FastAPI()

@app.get("/users/{user_id}")
async def get_user(user_id: int):
    # Async HTTP request
    async with httpx.AsyncClient() as client:
        response = await client.get(f"https://api.com/users/{user_id}")
        return response.json()

# Handles many concurrent requests efficiently
```

### Ruby - Async Sinatra

```ruby
require 'sinatra/base'
require 'async'

class AsyncApp < Sinatra::Base
  get '/data' do
    Async do
      # Async operations
      data = async_fetch_data
      json data: data
    end
  end
end
```

## Async Database Access

### Python - asyncpg (PostgreSQL)

```python
import asyncpg

async def get_users():
    conn = await asyncpg.connect('postgresql://...')

    # Async query
    rows = await conn.fetch('SELECT * FROM users')

    await conn.close()
    return rows
```

### Python - SQLAlchemy async

```python
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession

engine = create_async_engine('postgresql+asyncpg://...')

async def get_users():
    async with AsyncSession(engine) as session:
        result = await session.execute(
            select(User).where(User.age > 18)
        )
        return result.scalars().all()
```

## Common Pitfalls

### 1. Blocking in Async Function

```python
# ❌ Bad - blocks event loop
async def bad():
    import time
    time.sleep(1)  # BLOCKS!
    return "done"

# ✅ Good - non-blocking
async def good():
    await asyncio.sleep(1)  # Async sleep
    return "done"
```

### 2. Not Awaiting Coroutines

```python
# ❌ Bad - doesn't actually run
async def fetch():
    return "data"

async def bad():
    result = fetch()  # Returns coroutine object, doesn't run!
    print(result)  # <coroutine object>

# ✅ Good - await the coroutine
async def good():
    result = await fetch()  # Actually runs
    print(result)  # "data"
```

### 3. Mixing Sync and Async

```python
# ❌ Bad - can't call async from sync
def sync_function():
    result = await async_function()  # SyntaxError!

# ✅ Good - use asyncio.run
def sync_function():
    result = asyncio.run(async_function())
```

### 4. Forgetting to Close Resources

```python
# ❌ Bad - connection leak
async def bad():
    conn = await asyncpg.connect('...')
    data = await conn.fetch('...')
    return data  # Connection not closed!

# ✅ Good - use context manager
async def good():
    async with asyncpg.connect('...') as conn:
        return await conn.fetch('...')
    # Automatically closed
```

## Async vs Threading vs Multiprocessing

```python
import asyncio
import threading
import multiprocessing
import time

# I/O-bound task
def io_task():
    time.sleep(1)
    return "done"

# CPU-bound task
def cpu_task():
    total = sum(i * i for i in range(10000000))
    return total

# Async - Best for I/O-bound
async def async_io():
    await asyncio.sleep(1)
    return "done"

# Threading - OK for I/O-bound, not for CPU-bound (GIL)
def threaded_io():
    threads = [threading.Thread(target=io_task) for _ in range(10)]
    for t in threads:
        t.start()
    for t in threads:
        t.join()

# Multiprocessing - Best for CPU-bound
def multiprocess_cpu():
    with multiprocessing.Pool(4) as pool:
        results = pool.map(cpu_task, range(4))
```

**Summary**:
- **Async** - I/O-bound, single thread, many concurrent operations
- **Threading** - I/O-bound, true concurrency, but GIL limits CPU
- **Multiprocessing** - CPU-bound, true parallelism, heavy overhead

## Real-World Example - Web Scraper

```python
# Python - Async web scraper
import asyncio
import aiohttp
from bs4 import BeautifulSoup

async def fetch_page(session, url):
    async with session.get(url) as response:
        return await response.text()

async def parse_page(html):
    soup = BeautifulSoup(html, 'html.parser')
    return soup.find_all('a')

async def scrape_urls(urls):
    async with aiohttp.ClientSession() as session:
        tasks = [fetch_page(session, url) for url in urls]
        pages = await asyncio.gather(*tasks)

        parse_tasks = [parse_page(page) for page in pages]
        results = await asyncio.gather(*parse_tasks)

        return results

# Scrape 100 URLs concurrently
urls = [f"http://example.com/page{i}" for i in range(100)]
results = asyncio.run(scrape_urls(urls))
```

## Key Takeaways

1. **Async is for I/O-bound** - Waiting for network, disk, database
2. **Don't block event loop** - Use `await`, not `time.sleep()`
3. **Always await coroutines** - Otherwise they don't run
4. **Use context managers** - Properly close async resources
5. **Limit concurrency** - Use semaphores to avoid overwhelming servers
6. **Handle errors** - Use try/except around await calls
7. **Choose right tool** - Async vs threading vs multiprocessing

**Remember**: Async makes I/O operations faster by doing other work while waiting. It doesn't speed up CPU-intensive tasks!
