"""Demonstrates functional programming with map, filter, reduce, and alternatives."""

from __future__ import annotations

from functools import reduce
from typing import Callable


# Lambda example
def standard_func(a: int, b: int) -> int:
    """Standard function to add two numbers."""
    return a + b


add: Callable[[int, int], int] = lambda a, b: a + b

print(f"Standard function: {standard_func(1, 2)}")
print(f"Lambda function: {add(1, 2)}")

# Sample data
numbers = [1, 2, 3, 4, 5]

# Map - applies a function to each element
print("\n--- Map ---")
mapped = map(lambda x: x + 1, numbers)
print(f"map result: {list(mapped)}")

# List comprehension alternative (more Pythonic)
list_comp = [x + 1 for x in numbers]
print(f"List comprehension: {list_comp}")

# Filter - creates a list of elements for which the function returns True
print("\n--- Filter ---")
filtered = filter(lambda x: x > 1, numbers)
print(f"filter result: {list(filtered)}")

# List comprehension alternative
filtered_comp = [x for x in numbers if x > 1]
print(f"List comprehension: {filtered_comp}")

# Reduce - performs a rolling computation to sequential pairs of values
print("\n--- Reduce ---")
# Useful for performing computation on a list and returning the result
product = reduce(lambda x, y: x * y, numbers)
print(f"reduce result (product): {product}")

# Alternative using a loop (more readable for simple cases)
product_loop = 1
for num in numbers:
    product_loop *= num
print(f"Loop alternative: {product_loop}")

# Additional reduce examples
sum_result = reduce(lambda x, y: x + y, numbers)
print(f"reduce sum: {sum_result}")
print(f"Built-in sum: {sum(numbers)}")
