"""Demonstrates Pydantic models for static typing and JSON serialization."""

from __future__ import annotations

from pydantic import BaseModel, EmailStr, Field, ValidationError


class User(BaseModel):
    """User model with validation."""

    id: int = Field(..., gt=0, description="User ID must be positive")
    name: str = Field(..., min_length=1, description="User name")
    email: EmailStr


def get_user_data() -> User:
    """Create and return a sample user."""
    return User(id=1, name="Jan", email="jan@example.com")


if __name__ == "__main__":
    # Valid user
    user = get_user_data()
    print(user.model_dump())  # {'id': 1, 'name': 'Jan', 'email': 'jan@example.com'}
    print(user.model_dump_json())  # JSON string
    print(user.email)  # jan@example.com

    # Validation example
    try:
        invalid_user = User(id=-1, name="", email="invalid-email")
    except ValidationError as e:
        print(f"\nValidation error:\n{e}")

