To prevent the subclass from accessing certain attributes
Prefix with double underscore must be added.

```
class Person:
    __name = "John" # Private attribute
class Employee(Person):
    def get_name(self):
        return self.__name
emp = Employee()
print(emp.get_name())
```
