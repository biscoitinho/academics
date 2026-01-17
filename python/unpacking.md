Dictionary unpacking in Python refers to the method of extracting
key-value pairs from a dictionary and using them as arguments
in a function or as elements in expressions.
It is accomplished using the double asterisk ** operator.
This operator unpacks the contents of a dictionary,
allowing its items to be passed as keyword arguments to a function.

```python
#list unpacking

data = [1, 2, 3]
a, b, c = data
print(a, b, c)  # Output: 1 2 3
print(a)  # Output 1

#passing as keyword arguments to a function

def func(a=0, b=0):
    return a + b

    my_dict = {'a': 2, 'b': 3}
    result = func(**my_dict)

#Function output: 5

#merging dictionaries

dict1 = {'a': 1, 'b': 2}
dict2 = {'b': 3, 'c': 4}
merged_dict = {**dict1, **dict2}

#Output: {'a': 1, 'b': 3, 'c': 4}
```
