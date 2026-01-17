## Context Managers (with statement)

Automatically handle setup and cleanup operations.
Most commonly used for file handling and resource management.

### Basic with statement

```python
# Old way - manual cleanup
file = open("data.txt", "r")
try:
    data = file.read()
finally:
    file.close()

# Better way - automatic cleanup
with open("data.txt", "r") as file:
    data = file.read()
# File automatically closed here, even if error occurs
```

### Multiple context managers

```python
with open("input.txt", "r") as infile, open("output.txt", "w") as outfile:
    data = infile.read()
    outfile.write(data.upper())
```

### Common use cases

**File operations:**
```python
with open("data.txt", "w") as f:
    f.write("Hello World")
```

**Database connections:**
```python
with sqlite3.connect("database.db") as conn:
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users")
```

**Locks (threading):**
```python
from threading import Lock

lock = Lock()
with lock:
    # Critical section - only one thread at a time
    pass
```

### Creating custom context managers

**Using a class:**
```python
class FileManager:
    def __init__(self, filename, mode):
        self.filename = filename
        self.mode = mode
        self.file = None
    
    def __enter__(self):
        """Called when entering 'with' block."""
        self.file = open(self.filename, self.mode)
        return self.file
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        """Called when exiting 'with' block."""
        if self.file:
            self.file.close()
        # Return False to propagate exceptions
        return False

with FileManager("test.txt", "w") as f:
    f.write("Hello!")
```

**Using @contextmanager decorator:**
```python
from contextlib import contextmanager

@contextmanager
def timer():
    import time
    start = time.time()
    yield
    end = time.time()
    print(f"Took {end - start:.2f} seconds")

with timer():
    # Code to measure
    sum([i**2 for i in range(1000000)])
```

### Why use context managers?

- Automatic cleanup (files, connections, locks)
- Exception safety (cleanup happens even if error occurs)
- Cleaner code (no need for try/finally)
- Resource leak prevention
