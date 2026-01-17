The super()

Function returns a temporary object that represents the parent class.
This is used to access the parent class methods and attributes.
With the help of super(), we can also access the overridden methods.

```
class ParentClass:
    def info(self): # Old method
        print("Parent Class")
class ChildClass(ParentClass):
    def info(self): # New method
        print("Child Class")
    def parent_info(self):
        super().info()
obj = ChildClass()
obj.parent_info()
```
