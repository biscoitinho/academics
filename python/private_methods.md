In Python, there are three types of Python Private Method used in class:

- Private
- Protected
- Public

## Private

Double underscores, accessible only within class

```python
class Detail:
    def __init__(self, FN, LN):
        self.__firstname = FN
        self.__lastname = LN
        print("Done!")

d1 = Detail("Rea", "Messi")
print(d1.__firstname)
print(d1.__lastname)
```

Output: `AttributeError 'Detail' object has no attribute '__firstname'`

## Protected

Single underscore methods accessible within class and its sub-classes.
Protected data members are used when you implement inheritance
and want to allow data members access to only child classes.

```python
class Detail:
    def __init__(self, FN, LN):
        self._firstname = FN
        self._lastname = LN
        print("Done!")

d1 = Detail("Rea", "Messi")
print(d1._firstname)
print(d1._lastname)
```

Output: Executes without errors

## Access the private members outside the class

Pattern: `"__<className>_<attributeName>"`

Known as name mangling

```python
class DataScience:
    def PrintMe(self):
        return 'Printed'

    def __PrintMeNot(self):
        return 'Not Printed'

DS = DataScience()
print(DS.PrintMe())
print(DS._DataScience__PrintMeNot())
```

## Summary

**Public variable**: Accessible from anywhere

**Public method**: Accessible from anywhere

**Private variable**: Represented with two underscores at the start, accessible within the class only

**Private method**: Represented with two underscores at the start, accessible within the class only
