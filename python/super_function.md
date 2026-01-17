## The super() Function

Function returns a temporary object that represents the parent class.
This is used to access the parent class methods and attributes.
With the help of super(), we can also access the overridden methods.

### Basic usage

```python
class ParentClass:
    def info(self):  # Old method
        print("Parent Class")

class ChildClass(ParentClass):
    def info(self):  # New method
        print("Child Class")
    
    def parent_info(self):
        super().info()

obj = ChildClass()
obj.info()         # Child Class
obj.parent_info()  # Parent Class
```

### In __init__

```python
class Animal:
    def __init__(self, name):
        self.name = name

class Dog(Animal):
    def __init__(self, name, breed):
        super().__init__(name)  # Call parent's __init__
        self.breed = breed

dog = Dog("Buddy", "Golden Retriever")
print(dog.name)   # Buddy
print(dog.breed)  # Golden Retriever
```

### Multiple inheritance

```python
class A:
    def method(self):
        print("A")

class B(A):
    def method(self):
        print("B")
        super().method()

class C(A):
    def method(self):
        print("C")
        super().method()

class D(B, C):
    def method(self):
        print("D")
        super().method()

d = D()
d.method()
# D
# B
# C
# A
```

### Method Resolution Order (MRO)

```python
class D(B, C):
    pass

# Check the order Python will search for methods
print(D.mro())
# or
print(D.__mro__)
```

### Why use super()?

- Maintains proper method resolution order
- Makes code more maintainable
- Supports multiple inheritance correctly
- Allows parent class to change without updating child
