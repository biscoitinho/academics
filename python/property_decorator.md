## @property Decorator

Python's built-in decorator to create managed attributes.
Better alternative to getter/setter methods.

### Basic usage

```python
class Circle:
    def __init__(self, radius):
        self._radius = radius
    
    @property
    def radius(self):
        """Get the radius."""
        return self._radius
    
    @property
    def diameter(self):
        """Calculate diameter on the fly."""
        return self._radius * 2
    
    @property
    def area(self):
        """Calculate area on the fly."""
        return 3.14159 * self._radius ** 2

c = Circle(5)
print(c.radius)    # 5
print(c.diameter)  # 10
print(c.area)      # 78.53975
```

### With setter and deleter

```python
class Temperature:
    def __init__(self, celsius):
        self._celsius = celsius
    
    @property
    def celsius(self):
        """Get temperature in Celsius."""
        return self._celsius
    
    @celsius.setter
    def celsius(self, value):
        """Set temperature with validation."""
        if value < -273.15:
            raise ValueError("Temperature below absolute zero!")
        self._celsius = value
    
    @celsius.deleter
    def celsius(self):
        """Delete the temperature."""
        print("Deleting temperature")
        del self._celsius
    
    @property
    def fahrenheit(self):
        """Convert to Fahrenheit."""
        return self._celsius * 9/5 + 32

temp = Temperature(25)
print(temp.celsius)     # 25
print(temp.fahrenheit)  # 77.0

temp.celsius = 30       # Uses setter
print(temp.celsius)     # 30

del temp.celsius        # Uses deleter
```

### Why use @property?

- Clean syntax: `obj.attribute` instead of `obj.get_attribute()`
- Computed attributes (calculated on access)
- Validation when setting values
- Backward compatibility (can change implementation without breaking API)
- Read-only attributes (property without setter)
