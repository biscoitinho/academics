"""
Decorator is a function that takes another function and extends the behavior
of the latter function without explicitly modifying it.
"""

from __future__ import annotations

import time
from functools import wraps
from typing import Any, Callable, TypeVar

F = TypeVar('F', bound=Callable[..., Any])


def timer(func: F) -> F:
    """Decorator that measures and prints the execution time of a function."""
    @wraps(func)
    def wrapper(*args: Any, **kwargs: Any) -> Any:
        t1 = time.time()
        result = func(*args, **kwargs)
        t2 = time.time() - t1
        print(f'It took {t2:.4f} seconds')
        return result
    return wrapper  # type: ignore[return-value]


@timer
def sleeper() -> None:
    """Example function that sleeps for 1.3 seconds."""
    time.sleep(1.3)


if __name__ == "__main__":
    sleeper()
    print('done')

