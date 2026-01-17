## Mixin

A Mixin is a set of properties and methods that can be used in different classes,
which don't come from a base class.

Mixins provide reusable functionality without using inheritance.

### Basic inheritance (without mixin)

```python
class Vehicle:
    """A generic vehicle class."""

    def __init__(self, position):
        self.position = position

    def travel(self, destination):
        route = calculate_route(from_=self.position, to=destination)
        self.move_along(route)

class Car(Vehicle):
    pass

class Boat(Vehicle):
    pass

class Plane(Vehicle):
    pass
```

### Inheritance with a mixin

```python
class RadioUserMixin:
    def __init__(self):
        self.radio = Radio()
    
    def play_song_on_station(self, station):
        self.radio.set_station(station)
        self.radio.play_song()

class Car(Vehicle, RadioUserMixin):
    pass

class Clock(RadioUserMixin):
    pass

# Usage
car = Car()
car.play_song_on_station(98.7)
```

### Multiple mixins

```python
class TimestampMixin:
    def get_timestamp(self):
        return datetime.now()

class LoggingMixin:
    def log(self, message):
        print(f"[LOG] {message}")

class TrackedCar(Vehicle, TimestampMixin, LoggingMixin):
    def travel(self, destination):
        self.log(f"Starting journey to {destination}")
        super().travel(destination)
        print(f"Arrived at {self.get_timestamp()}")
```

### When to use mixins

- Add common functionality to unrelated classes
- Avoid deep inheritance hierarchies
- Keep classes focused on single responsibility
- Enable code reuse without tight coupling
