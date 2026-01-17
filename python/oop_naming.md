## OOP Naming Conventions

### Class names
Use CamelCase (PascalCase) for class names.

```python
class MyClass:
    pass

class UserProfile:
    pass
```

### Method names
Use snake_case for method names.

```python
class MyClass:
    def my_method(self):
        pass

    def calculate_total(self):
        pass
```

### Private methods and attributes
Use single underscore `_` prefix for protected, double underscore `__` for private.

```python
class MyClass:
    def __init__(self):
        self.public_var = "public"
        self._protected_var = "protected"
        self.__private_var = "private"

    def public_method(self):
        pass

    def _protected_method(self):
        pass

    def __private_method(self):
        pass
```

### Constants
Use UPPER_CASE for constants.

```python
MAX_SIZE = 100
DEFAULT_COLOR = "blue"
```
