## Generators

### Generator function

```python
def myfunc():
    yield value
```

### Generator expression

```python
nums_squared_gc = (i**2 for i in range(5))
```

Generator will stop every time on a yield statement and will remember its state when next time called.

To use the generator: `next(nums_squared_gc)`

Generators are iterable objects.

Save computer memory with a cost of being slower than standard iterators.

### Usecase

Very big files or data streams:

```python
def csv_reader(file_name):
    for row in open(file_name, "r"):
        yield row
```

### Generator methods

- `.send()` - sends a value to a generator
- `.throw()` - ability to throw an error like an 'except'
- `.close()` - shutdown a generator

### Data pipelines

Data pipelines allow to string together code to process large datasets or streams of data
without maxing out your machine's memory.

Data pipelines can be done with generators (csv examples glued together).
