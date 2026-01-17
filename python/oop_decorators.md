## @classmethod
Can only access the class object
Can't modify object instance state
Can modify class state

```python
class My_class:
    @classmethod
    def method(cls):
        return 'class method called', cls
```

Class method can be used as a factory function:

```python
class Pizza:
    def __init__(self, ingredients):
        self.ingredients = ingredients

    @classmethod
    def margherita(cls):
        return cls(['cheese', 'tomatoes'])

Pizza.margherita()
```

Returns a Pizza object with margherita ingredients

Used for custom inits in class

## @staticmethod
Can't modify object instance state
Can't modify class state

```python
class My_class:
    @staticmethod
    def method():
        return 'static method called'
```

## Plain method
Within method we can modify and read objects on an instance of a class
Can modify object instance state
Can modify class state

```python
class My_class:
    def method(self):
        return 'instance method called', self
```
