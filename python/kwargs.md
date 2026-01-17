`*args` -` argument collector
Ability to pass n number of arguments in a function

`**kwargs` - keyword arguments collector
Ability to pass n number of key value pair arguments in a function

Example:

```
my_func(*args, **kwargs):
        print("hello world", args, kwargs)

my_func("abc", abc=123)
```
