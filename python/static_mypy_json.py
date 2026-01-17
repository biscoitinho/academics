"""Demonstrates static typing with mypy using TypedDict for better type safety."""

from __future__ import annotations

import json
from typing import TypedDict


class UserDict(TypedDict):
    """Typed dictionary for user data with strict key-value type checking."""

    id: int
    name: str
    email: str


def get_user_data() -> UserDict:
    """Return user data as a typed dictionary.

    Returns:
        UserDict with id, name, and email fields.
    """
    return {
        "id": 1,
        "name": "Jan",
        "email": "jan@example.com"
    }


def process_user(user: UserDict) -> None:
    """Process user data with type safety.

    Args:
        user: User data dictionary with type checking.
    """
    print(f"User ID: {user['id']}")
    print(f"Name: {user['name']}")
    print(f"Email: {user['email']}")
    print(f"JSON: {json.dumps(user, indent=2)}")


if __name__ == "__main__":
    user = get_user_data()
    process_user(user)

