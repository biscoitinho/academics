generator function:

```
def myfunc():
    yield value
```

generator expression:

```
nums_squered_gc = ( i**2 for i in range(5))
```

Generator will stop every time on a yield statement and will remember it's state when nexr time called.
To use the genereator `next(nums_squered_gc)`
Generators are iterable objects
Save computer memory with a cost of being slower then standard iterators.

Usecase:

Very big files or data streams:

```
def csv_reader(file_name):
    for row in open(file_name, "r"):
        yield row
```

`.send()` - sends a value to a generator
`.throw()` - ability to throw an error like na 'except'
`.close()` - shutdown a generator

Data pipelines allows to string together code to process large datasets or streams of data
without maxing out your machine’s memory.
Data piplines can be done with generators (csv examples glued together)

