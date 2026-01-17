@classmethod
can only access the class object
can't modify object instance state
can modify class state

```
My_class:
    @classmethod
    method(cls):
        return 'class method called', cls
```

class method can be used as a factory function:

```
class Pizza:
    def __init__(self, ingridients):
        self.ingridients = ingridients

    @classmethod
    def margeritha(cls):
        return cls(['cheese', 'tomatos'])

Pizza.margeritha()
```

#=> Pizza object with margeritha ingridients

Used for custom inits in class

@staticmethod
can't modify object instance state
can't modify class state

```
My_class:
    @staticmethod
    method():
        return 'static method called'
```

plain method:
within method we can modify and read objects on an instance of a class
can modify object instance state
can modify class state

```
My_class:
    method(self):
        return 'instance method called', self
```
