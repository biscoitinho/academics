## Method overloading

Method overloading is the ability to have multiple methods
with the same name but a different number of parameters.

**Python does not support method overloading**

Code below renders error:

```python
class ParentClass:
    def hello(self):
        print("America")

class ChildClass(ParentClass):
    def hello(self, a):
        print("Australia")

child = ChildClass()
child.hello()
```

## Method overriding

Changing the method behavior defined in the parent class is possible.
Simply done by defining a new method with the same name and the same number
of parameters in the child class.

```python
class ParentClass:
    def info(self):  # Old method
        print("Parent Class")

class ChildClass(ParentClass):
    def info(self):  # New method
        print("Child Class")

obj = ChildClass()
obj.info()
```
