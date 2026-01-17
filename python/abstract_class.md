Abstract class

By defining an abstract base class, you can define a common
Application Program Interface(API) for a set of subclasses.
To be treated as a Blueprint for other classes.
Or an interface in different languages.
Prevents a user from creating an object of that class
Compels a user to override a abstract methods in a child class

```python
from abc import ABC, abstractmethod
class Animal(ABC):
    @abstractmethod
    def move(self):
        pass

class Human(Animal):

    def move(self):
        print("I can walk and run")

class Snake(Animal):

    def move(self):
        print("I can crawl")
```
