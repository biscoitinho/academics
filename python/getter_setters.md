## Getters and Setters in Python

To implement proper encapsulation in Python, we need to use setters and getters.
The primary purpose of using getters and setters in object-oriented programs
is to ensure data encapsulation. Use the getter method to access data members
and the setter methods to modify the data members.

In Python, private variables are not hidden fields like in other programming languages.

The getters and setters methods are often used when:
- We want to avoid direct access to private variables
- To add validation logic for setting a value

### Basic example

```python
class Student:
    def __init__(self, name, age):
        # private member
        self.name = name
        self.__age = age

    # getter method
    def get_age(self):
        return self.__age

    # setter method
    def set_age(self, age):
        self.__age = age

stud = Student('Jessa', 14)

# retrieving age using getter
print('Name:', stud.name, stud.get_age())

# changing age using setter
stud.set_age(16)

# retrieving age using getter
print('Name:', stud.name, stud.get_age())
```

Output:
```
Name: Jessa 14
Name: Jessa 16
```

### Better approach: Use @property

See `property_decorator.md` for the modern, Pythonic way to implement getters and setters.
