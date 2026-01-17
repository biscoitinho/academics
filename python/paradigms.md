There are two primary programming paradigms, an imperative and a declarative,
and there are several paradigms that are influenced by these two types.


# Imperative:
The hardware implementation of almost all computers is imperative.

Suppose you are in the restaurant, and while ordering your food,
you don’t just choose the dish, but you also give instructions
to the chef on how to prepare the dish.

The steps and sequences are explicitly given in the imperative type of paradigm.

Language example: Assembly

# Declarative:
Declarative programming expresses the logic of a computation without
describing its control flow.

Language example: SQL


# Structured Programming:
programming paradigm that uses structured control flow(without goto)
to improve code clarity and quality.

Paradigm makes extensive use of the block structures (sequencing),
if/else(selection), and while or for loop(repetition).
Creator: Edsger W. Dijkstra

Language example: C


# Procedural Programming:
It is based on the concept of the procedure call.
Procedures are also known as routines, subroutines, methods, or functions.

A Procedure contains a series of instructions coupled together.
We can call any procedure at any point during a program’s execution.

Computer processors provide hardware support for procedural programming
through a stack register and instructions for calling procedures
and returning from them.

Language example: C. C++


# Object oriented Programming:
An object-oriented programming paradigm is based on the concept of objects.
An object can be any real-world entity. An object has data(properties, variables)
and behavior (methods). Object-Oriented paradigm is supporting features like
abstraction, encapsulation, inheritance, polymorphism.

## Types of OOP:

### Class based OOP

In class-based languages, the classes are defined beforehand,
and the objects are instantiated based on the classes.
For example, If we want to create two new objects, one to represent an apple
and another for orange, then first we need to create a class Fruit.
Then we can create two instances(objects) of fruit class,
one for apple and another for orange.

Example: Python

### Prototype based OOP

In prototype-based languages, the objects are the primary entities,
and class doesn’t exist in it. We create new objects based on
the already existing objects.
These already existing objects act as a prototype for new objects.
For example, If we want to create two new objects,
one to represent an apple and another for orange,
then first we need to create a fruit object.
Then we can create two objects from the fruit object.
Here the fruit object acts as a prototype for apple and orange objects.
Delegation is a language feature that supports prototype-based programming.

Example: JavaScript

## Advantages of Object-Oriented Programming:

### Abstraction:
hide the implementation details. Generally, abstraction is achieved
through abstract classes and interfaces.

### Encapsulation:
It is about wrapping the implementation (code) and the data
it manipulates (variables) within the same class.
It is achieved using access modifiers like public, private, and protected.

### Inheritance:
It is a way of creating a new class(child) from the existing class
(base or parent).
This mechanism enables the code reusability.
As a derived class gets all the features of the base class,
and it also allows to extend the functionality of a base class
without modifying the existing source code.

### Polymorphism:
We can have a method which has different behaviors based on the context
in which it is used. We can achieve this using method overloading
and method overriding.


# Functional Programming:

Functional programming languages remove the imperative elements
of procedural programming. Functional programming doesn’t recommend
the use of an assignment operator and accessing the variables outside
of function scope.
Coding without assignment operator.

Language example: Haskell
