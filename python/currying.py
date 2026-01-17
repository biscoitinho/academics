"""
Currying is a process of transforming a function that takes multiple arguments
into a series of functions that each take a single argument - nesting functions.
"""

from __future__ import annotations

from functools import partial


def multiply(a: int, b: int, c: int) -> int:
    """Multiply three numbers together."""
    return a * b * c


# Curried version using nested functions
def curried_multiply(a: int) -> callable:
    """Curried version of multiply using nested functions."""
    def next_b(b: int) -> callable:
        def final_c(c: int) -> int:
            return a * b * c
        return final_c
    return next_b


# Using functools.partial as an alternative to manual currying
def multiply_with_partial(a: int) -> partial[int]:
    """Create a partially applied multiply function."""
    return partial(multiply, a)


if __name__ == "__main__":
    # Standard function
    print(f"Standard multiply: {multiply(2, 3, 4)}")

    # Curried version
    print(f"Curried multiply: {curried_multiply(2)(3)(4)}")

    # Using partial application
    multiply_by_2 = multiply_with_partial(2)
    multiply_by_2_and_3 = partial(multiply_by_2, 3)
    print(f"Partial multiply: {multiply_by_2_and_3(4)}")
