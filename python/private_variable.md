Python doesn’t have anything called private member variable in Python.
However, adding two underscores at the beginning makes a variable or a method private
is the convention used by most python code.

```
class myClass:
   __privateVar = 27;
   def __privMeth(self):
      print("I'm inside class myClass")
   def hello(self):
      print("Private Variable value: ",myClass.__privateVar)
foo = myClass()
foo.hello()
foo.__privateMeth
```

=> Private Variable value: 27
=> AttributeError: 'myClass' object has no attribute '__privateMeth'
