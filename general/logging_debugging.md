# Logging and Debugging

## Logging Basics

### Python

```python
import logging

# Basic config
logging.basicConfig(level=logging.DEBUG)

# Log levels (lowest to highest)
logging.debug('Debug message')
logging.info('Info message')
logging.warning('Warning message')
logging.error('Error message')
logging.critical('Critical message')

# With formatting
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

logging.info('User logged in')
# 2024-01-15 10:30:00,123 - root - INFO - User logged in
```

### Ruby

```ruby
require 'logger'

logger = Logger.new(STDOUT)

# Log levels
logger.debug('Debug message')
logger.info('Info message')
logger.warn('Warning message')
logger.error('Error message')
logger.fatal('Fatal message')

# Set level
logger.level = Logger::INFO

# Format
logger.formatter = proc do |severity, datetime, progname, msg|
  "#{datetime}: #{severity} - #{msg}\n"
end
```

## Log Levels

```
DEBUG:    Detailed info for diagnosing
INFO:     Confirmation things are working
WARNING:  Something unexpected, but working
ERROR:    Serious problem
CRITICAL: Very serious problem

Development:   DEBUG
Production:    INFO or WARNING
```

## File Logging

### Python

```python
import logging

# Log to file
logging.basicConfig(
    filename='app.log',
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

logging.info('Application started')

# Rotating log files
from logging.handlers import RotatingFileHandler

handler = RotatingFileHandler(
    'app.log',
    maxBytes=1024*1024,  # 1MB
    backupCount=5
)

logger = logging.getLogger()
logger.addHandler(handler)
```

### Ruby

```ruby
# Log to file
logger = Logger.new('app.log')

# Daily rotation
logger = Logger.new('app.log', 'daily')

# Size-based rotation
logger = Logger.new('app.log', 10, 1024000)  # 10 files, 1MB each
```

## Structured Logging

### Python

```python
import logging
import json

class JSONFormatter(logging.Formatter):
    def format(self, record):
        log_data = {
            'timestamp': self.formatTime(record),
            'level': record.levelname,
            'message': record.getMessage(),
            'module': record.module
        }
        return json.dumps(log_data)

handler = logging.StreamHandler()
handler.setFormatter(JSONFormatter())

logger = logging.getLogger()
logger.addHandler(handler)

logger.info('User logged in', extra={'user_id': 123})
# {"timestamp": "2024-01-15 10:30:00", "level": "INFO", "message": "User logged in", "module": "main"}
```

## Multiple Loggers

```python
# Create named logger
logger = logging.getLogger('myapp')
logger.setLevel(logging.DEBUG)

# Different loggers for different modules
auth_logger = logging.getLogger('myapp.auth')
db_logger = logging.getLogger('myapp.database')

auth_logger.info('User authenticated')
db_logger.debug('Query executed')
```

## Logging Best Practices

```python
# 1. Use appropriate levels
logger.debug('Variable x = %s', x)  # Development
logger.info('User login successful')  # Production events
logger.warning('Disk space low')  # Potential issues
logger.error('Failed to connect', exc_info=True)  # Errors
logger.critical('System shutdown')  # Critical failures

# 2. Use lazy formatting
# ❌ Bad
logger.info('User %s logged in' % username)
# ✅ Good
logger.info('User %s logged in', username)

# 3. Don't log sensitive data
# ❌ Bad
logger.info(f'Password: {password}')
# ✅ Good
logger.info('User authentication attempted')

# 4. Add context
logger.info('Order processed', extra={
    'order_id': 123,
    'user_id': 456,
    'amount': 99.99
})

# 5. Log exceptions with traceback
try:
    risky_operation()
except Exception as e:
    logger.error('Operation failed', exc_info=True)
```

## Debugging with pdb (Python)

```python
import pdb

def buggy_function(x, y):
    result = x + y
    pdb.set_trace()  # Debugger stops here
    return result * 2

# Commands:
# n - next line
# s - step into function
# c - continue
# l - list code
# p variable - print variable
# q - quit

# Python 3.7+
breakpoint()  # Same as pdb.set_trace()
```

## Debugging with byebug (Ruby)

```ruby
require 'byebug'

def buggy_method(x, y)
  result = x + y
  byebug  # Debugger stops here
  result * 2
end

# Commands:
# n - next
# s - step
# c - continue
# l - list
# p variable - print
# q - quit
```

## Print Debugging

```python
# Quick debugging (remove before production)
print(f'x = {x}, y = {y}')
print(f'Type: {type(variable)}')
print(f'Length: {len(collection)}')

# Pretty print
import pprint
pprint.pprint(complex_data)

# Inspect object
print(dir(obj))  # List attributes
print(vars(obj))  # Object's __dict__
```

```ruby
# Ruby
puts "x = #{x}, y = #{y}"
puts variable.inspect
pp complex_data  # Pretty print

# Object inspection
puts obj.methods
puts obj.instance_variables
```

## Assertions

```python
# Check assumptions
assert x > 0, "x must be positive"
assert len(items) > 0, "items cannot be empty"

# Disable in production with -O flag
# python -O script.py
```

## Logging Exceptions

```python
import logging

logger = logging.getLogger(__name__)

try:
    result = 10 / 0
except ZeroDivisionError:
    logger.exception('Division by zero')
    # Automatically includes traceback

# Or manually
except Exception as e:
    logger.error('Error occurred', exc_info=True)
    logger.error(f'Error: {str(e)}', exc_info=True)
```

## Debugging Tools

### Python

```python
# 1. pdb - Built-in debugger
import pdb; pdb.set_trace()

# 2. ipdb - Enhanced pdb
import ipdb; ipdb.set_trace()

# 3. pudb - Visual debugger
import pudb; pudb.set_trace()

# 4. traceback
import traceback
try:
    buggy()
except:
    traceback.print_exc()

# 5. sys.settrace (advanced)
import sys

def trace_calls(frame, event, arg):
    if event == 'call':
        print(f'Calling {frame.f_code.co_name}')
    return trace_calls

sys.settrace(trace_calls)
```

### Ruby

```ruby
# 1. byebug
require 'byebug'
byebug

# 2. pry
require 'pry'
binding.pry

# 3. Stacktrace
begin
  risky_code
rescue => e
  puts e.message
  puts e.backtrace
end
```

## Profiling

### Python

```python
# Time execution
import time

start = time.time()
expensive_function()
print(f'Took {time.time() - start:.2f}s')

# cProfile
import cProfile
cProfile.run('expensive_function()')

# Line profiler
# pip install line_profiler
@profile
def function():
    # code
pass

# Memory profiler
# pip install memory_profiler
@profile
def function():
    # code
pass
```

### Ruby

```ruby
# Benchmark
require 'benchmark'

time = Benchmark.measure do
  expensive_operation
end

puts time

# Ruby-prof
require 'ruby-prof'

RubyProf.start
expensive_operation
result = RubyProf.stop

printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)
```

## Stack Traces

```python
import traceback

try:
    func1()
except Exception as e:
    print('Error:', str(e))
    traceback.print_exc()

# Get traceback as string
tb_str = traceback.format_exc()

# Extract stack
import sys
exc_type, exc_value, exc_tb = sys.exc_info()
```

```ruby
begin
  risky_operation
rescue => e
  puts e.message
  puts e.backtrace.join("\n")
end
```

## Remote Logging

### Python (Syslog)

```python
import logging
from logging.handlers import SysLogHandler

logger = logging.getLogger()
handler = SysLogHandler(address=('localhost', 514))
logger.addHandler(handler)
```

### Centralized Logging

```python
# Send logs to external service (e.g., Loggly, Papertrail)
import requests
import logging

class HTTPHandler(logging.Handler):
    def emit(self, record):
        log_entry = self.format(record)
        requests.post('https://logs.example.com/api', data=log_entry)
```

## Conditional Logging

```python
import logging
import os

# Set level from environment
level = os.getenv('LOG_LEVEL', 'INFO')
logging.basicConfig(level=getattr(logging, level))

# Debug mode
DEBUG = os.getenv('DEBUG', 'False') == 'True'
if DEBUG:
    logger.setLevel(logging.DEBUG)
```

## Context Managers for Logging

```python
from contextlib import contextmanager

@contextmanager
def log_execution(name):
    logger.info(f'Starting {name}')
    try:
        yield
    except Exception as e:
        logger.error(f'{name} failed: {e}')
        raise
    else:
        logger.info(f'{name} completed')

with log_execution('data_processing'):
    process_data()
```

## Common Debugging Patterns

### Binary Search

```python
# When bug is in large code section
# Comment out half
# If bug persists, it's in remaining half
# Repeat until found
```

### Rubber Duck Debugging

```
Explain code line-by-line to:
- Rubber duck
- Colleague
- Yourself

Often reveals the problem
```

### Minimal Reproduction

```python
# Simplify code until bug disappears
# Last simplification before it works
# is where the bug is

# Start with full failing code
# Remove unrelated parts
# Keep removing until minimal example
```

### Add Logging

```python
def complex_function(data):
    logger.debug(f'Input: {data}')

    result = step1(data)
    logger.debug(f'After step1: {result}')

    result = step2(result)
    logger.debug(f'After step2: {result}')

    return result
```

## Debugging Tips

```python
# 1. Read error message carefully
# 2. Check recent changes
# 3. Reproduce consistently
# 4. Isolate the problem
# 5. Check assumptions
# 6. Take a break
# 7. Ask for help
# 8. Use version control to bisect

# Git bisect
git bisect start
git bisect bad  # Current commit is bad
git bisect good abc123  # This commit was good
# Test and mark commits until bug found
```

## Production Debugging

```python
# 1. Use log aggregation (ELK, Splunk)
# 2. Add correlation IDs
logger.info('Request started', extra={'request_id': req_id})

# 3. Monitor metrics
# Response time, error rate, etc.

# 4. Use APM tools
# New Relic, Datadog, etc.

# 5. Add health checks
@app.route('/health')
def health():
    return {'status': 'ok', 'db': check_db()}
```

## Error Tracking

```python
# Sentry
import sentry_sdk
sentry_sdk.init("https://...@sentry.io/...")

try:
    risky_operation()
except Exception as e:
    sentry_sdk.capture_exception(e)

# Rollbar
from rollbar import report_exc_info
try:
    risky_operation()
except:
    report_exc_info()
```

## Logging in Tests

```python
import pytest
import logging

def test_with_logs(caplog):
    caplog.set_level(logging.INFO)

    my_function()

    assert 'Expected log message' in caplog.text
    assert len(caplog.records) == 1
```

## Log Analysis

```bash
# grep for errors
grep ERROR app.log

# Count errors
grep ERROR app.log | wc -l

# Recent errors
tail -f app.log | grep ERROR

# Specific time range
awk '/2024-01-15 10:00/,/2024-01-15 11:00/' app.log

# Most common errors
grep ERROR app.log | sort | uniq -c | sort -rn
```

## Best Debugging Practices

```python
# 1. Use version control
git diff  # What changed?

# 2. Write tests
# Easier to reproduce bugs

# 3. Use linters
# Catch errors before runtime
# pylint, flake8, rubocop

# 4. Type hints (Python 3.5+)
def add(x: int, y: int) -> int:
    return x + y

# 5. Code reviews
# Fresh eyes find bugs

# 6. Documentation
# Helps understand expected behavior
```
