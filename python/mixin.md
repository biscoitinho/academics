Mixin

A Mixin is a set of properties and methods that can be used in diﬀerent classes,
which don’t come from a base class.

Below basic inheritance:

```
class Vehicle(object):
    """A generic vehicle class."""

    def init(self, position):
        self.position = position

    def travel(self, destination):
        route = calculate_route(from=self.position, to=destination)
        self.move_along(route)

class Car(Vehicle):
…
class Boat(Vehicle):
…
class Plane(Vehicle):
…
```

Inheritance with a mixin:

```
class RadioUserMixin(object):
    def init(self):
        self.radio = Radio()
    def play_song_on_station(self, station):
        self.radio.set_station(station)
        self.radio.play_song()

class Car(Vehicle, RadioUserMixin):
…
class Clock(Vehicle, RadioUserMixin):
…
```

`car.play_song_on_station(98.7)`
