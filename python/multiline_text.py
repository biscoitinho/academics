"""Demonstrates multiline text and ASCII art generation with pyfiglet."""

from __future__ import annotations

import pyfiglet


def main() -> None:
    """Demonstrate multiline strings and ASCII art generation."""
    multiline_text = """
multi
line
      text
"""
    print(multiline_text)

    ascii_art = pyfiglet.figlet_format("python is awesome", font="cybermedium")
    print(ascii_art)


if __name__ == "__main__":
    main()
