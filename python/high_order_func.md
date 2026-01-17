High order function:

Function which accepts function as an argument or returns a function.


```
def loud(text):
    return text.upper()

def quiet(text):
    return text.lower()

def hello(func):
    text = func("hello")
    print(text)

hello(loud)
```

```
def divisor(x):
    def dividend(y):
        return y / x
    return dividend

divide = devisor(2)
print(divide(10))
```



