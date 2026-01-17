Inheritance is defined as the capability of one class
to derive or inherit the properties from some other class
and use it whenever needed.

It represents real-world relationships well.

It provides reusability of code.

It is transitive in nature, which means that if class B
inherits from another class A, then all the subclasses
of B would automatically inherit from class A.



4 types of inheritance in Python:

Single inheritance

Single inheritance enables a derived class
to inherit properties from a single parent class

A -> B

Multiple Inheritance

When a class can be derived from more than one base class
this type of inheritance is called multiple inheritance.
In multiple inheritance, all the features of the base classes
are inherited into the derived class.

Father, Mother -> Child

```
class Mother:
    mothername = ""
    def mother(self):
        print(self.mothername)

class Father:
    fathername = ""
    def father(self):
        print(self.fathername)

class Son(Mother, Father):
    def parents(self):
        print("Father :", self.fathername)
        print("Mother :", self.mothername)

s1 = Son()
s1.fathername = "John"
s1.mothername = "Alice"
s1.parents()
```

Multilevel Inheritance
In multilevel inheritance, features of the base class
and the derived class are further inherited into the new derived class.
This is similar to a relationship representing a child and grandfather.

A -> B -> C

```
class Grandfather:

    def __init__(self, grandfathername):
        self.grandfathername = grandfathername

class Father(Grandfather):
    def __init__(self, fathername, grandfathername):
        self.fathername = fathername
        Grandfather.__init__(self, grandfathername)

class Son(Father):
    def __init__(self,sonname, fathername, grandfathername):
        self.sonname = sonname
        Father.__init__(self, fathername, grandfathername)

    def print_name(self):
        print('Grandfather name :', self.grandfathername)
        print("Father name :", self.fathername)
        print("Son name :", self.sonname)

#  Driver code
s1 = Son('Senior', 'Bob', 'Junior')
print(s1.grandfathername)
s1.print_name()
```

Hierarchical Inheritance
When more than one derived classes are created from a single base
this type of inheritance is called hierarchical inheritance.

        A
      / | \
     B  C  D

```
class Parent:
      def func1(self):
          print("This function is in parent class.")

class Child1(Parent):
      def func2(self):
          print("This function is in child 1.")

class Child2(Parent):
      def func3(self):
          print("This function is in child 2.")
```

Hybrid Inheritance
Inheritance consisting of multiple types of inheritance is called hybrid inheritance.

```
class School:
     def func1(self):
         print("This function is in school.")

class Student1(School):
     def func2(self):
         print("This function is in student 1. ")

class Student2(School):
     def func3(self):
         print("This function is in student 2.")

class Student3(Student1, School):
     def func4(self):
         print("This function is in student 3.")
```
