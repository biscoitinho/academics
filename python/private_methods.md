In Python, there three types of Python Private Method used in class:

Private
Protected
Public

Private

Double underscores, accessible only within class

```
class Detail:
def __init__(self,FN,LN):
self.__firstname = FN
self.__lastname = LN
print("Done!")
d1=Detail("Rea","Messi")
print(d1.__firstname)
print(d1.__lastname)
```

=> `AttributeError 'Detail' object has no attribute '__firstname'`


Protected

Single underscore methods accesssible within class and it's sub-classes.
Protected data members are used when you implement inheritance
and want to allow data members access to only child classes.

```
class Detail:
def __init__(self,FN,LN):
self._firstname = FN
self._lastname = LN
print("Done!")
d1=Detail("Rea","Messi")
print(d1._firstname)
print(d1._lastname)
```

=> Executes without errors


Access the private members outside the class:

`"__<className>_<attributeName>"`

Known as name mingling

```
class DataScience:
    def PrintMe(self):
        return 'Printed'

    def __PrintMeNot(self):
        return 'Not Printed'

DS = DataScience()
print(DS.PrintMe())
print(DS._DataScience__PrintMeNot() )
```

Public variable
Accessible from anywhere

Public method
Accessible from anywhere

Private variable
It is represented with two underscores at the start.
It is accessible within the class.

Private method
This is also represented by two underscores at the start.
It is accessible within the class.
