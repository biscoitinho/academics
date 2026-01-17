"""Demonstrates @classmethod and @staticmethod decorators in Python classes."""

from __future__ import annotations

from typing import ClassVar


class Pizza:
    """Pizza class demonstrating class methods and static methods."""

    # Class variable
    store_name: ClassVar[str] = "Python Pizza"

    def __init__(self, ingredients: list[str]) -> None:
        """Initialize pizza with ingredients."""
        self.ingredients = ingredients

    def __repr__(self) -> str:
        """Return string representation of the pizza."""
        return f'Pizza({self.ingredients!r})'

    @classmethod
    def margherita(cls) -> Pizza:
        """Factory method to create a Margherita pizza.

        Returns:
            A Pizza instance with margherita ingredients.
        """
        return cls(['mozzarella', 'tomatoes'])

    @classmethod
    def prosciutto(cls) -> Pizza:
        """Factory method to create a Prosciutto pizza.

        Returns:
            A Pizza instance with prosciutto ingredients.
        """
        return cls(['mozzarella', 'tomatoes', 'ham'])

    @staticmethod
    def is_vegetarian(ingredients: list[str]) -> bool:
        """Check if pizza is vegetarian (static method - no access to instance/class).

        Args:
            ingredients: List of pizza ingredients.

        Returns:
            True if vegetarian, False otherwise.
        """
        meat_products = {'ham', 'pepperoni', 'sausage', 'bacon', 'chicken'}
        return not any(ingredient in meat_products for ingredient in ingredients)

    def show(self) -> list[str]:
        """Return the list of ingredients."""
        return self.ingredients

    def describe(self) -> str:
        """Describe the pizza."""
        veg_status = "vegetarian" if self.is_vegetarian(self.ingredients) else "non-vegetarian"
        return f"{self.store_name} - {veg_status} pizza with: {', '.join(self.ingredients)}"


if __name__ == "__main__":
    # Using class methods as factory methods
    print("--- Class Methods ---")
    margherita = Pizza.margherita()
    print(margherita)
    print(margherita.describe())

    prosciutto = Pizza.prosciutto()
    print(prosciutto)
    print(prosciutto.describe())

    # Using static method
    print("\n--- Static Method ---")
    custom_pizza = Pizza(['mozzarella', 'mushrooms', 'olives'])
    print(f"Is vegetarian? {Pizza.is_vegetarian(custom_pizza.ingredients)}")
    print(f"Is vegetarian? {Pizza.is_vegetarian(['pepperoni', 'cheese'])}")
