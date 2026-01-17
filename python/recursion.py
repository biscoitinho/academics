"""
Demonstrates recursion patterns and optimization techniques.

Basic recursion pattern:
    def fn():
        if condition:
            return base_case  # Stop calling itself
        else:
            return fn()  # Recursive call
"""

from __future__ import annotations

from functools import lru_cache


# Basic recursion example - countdown
def counter(start: int) -> None:
    """Recursively count down from start to 1."""
    print(start)
    next_value = start - 1
    if next_value > 0:
        counter(next_value)


print("--- Countdown ---")
counter(3)

# Sum of a sequence
def adder(n: int) -> int:
    """Recursively sum all numbers from n down to 0."""
    if n > 0:
        return n + adder(n - 1)
    return 0


print(f"\n--- Sum of sequence ---")
print(f"Sum 1 to 10: {adder(10)}")

# Fibonacci - demonstrating inefficiency without memoization
def fibonacci_slow(n: int) -> int:
    """Calculate nth Fibonacci number (slow without memoization)."""
    if n <= 1:
        return n
    return fibonacci_slow(n - 1) + fibonacci_slow(n - 2)


# Fibonacci with memoization using lru_cache
@lru_cache(maxsize=None)
def fibonacci_fast(n: int) -> int:
    """Calculate nth Fibonacci number with memoization for efficiency."""
    if n <= 1:
        return n
    return fibonacci_fast(n - 1) + fibonacci_fast(n - 2)


print(f"\n--- Fibonacci ---")
print(f"Fibonacci(10) without cache: {fibonacci_slow(10)}")
print(f"Fibonacci(30) with @lru_cache: {fibonacci_fast(30)}")

# Factorial example
@lru_cache(maxsize=None)
def factorial(n: int) -> int:
    """Calculate factorial of n using recursion with memoization."""
    if n <= 1:
        return 1
    return n * factorial(n - 1)


print(f"\n--- Factorial ---")
print(f"Factorial(5): {factorial(5)}")
print(f"Factorial(10): {factorial(10)}")
