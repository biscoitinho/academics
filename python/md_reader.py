"""Renders Markdown files in the terminal using Rich library."""

from __future__ import annotations

import sys
from pathlib import Path

from rich.console import Console
from rich.markdown import Markdown


def render_markdown(file_path: Path) -> None:
    """Read and render a markdown file to the console.

    Args:
        file_path: Path to the markdown file to render.

    Raises:
        FileNotFoundError: If the file doesn't exist.
    """
    console = Console()

    if not file_path.exists():
        console.print(f"[bold red]Error:[/] File '{file_path}' not found.")
        sys.exit(1)

    if not file_path.is_file():
        console.print(f"[bold red]Error:[/] '{file_path}' is not a file.")
        sys.exit(1)

    markdown_content = file_path.read_text(encoding="utf-8")
    markdown = Markdown(markdown_content)
    console.print(markdown)


def main() -> None:
    """Main entry point for the markdown reader."""
    if len(sys.argv) < 2:
        console = Console()
        console.print("[bold red]Error:[/] Please provide a markdown file path.")
        console.print("Usage: python md_reader.py <file.md>")
        sys.exit(1)

    file_path = Path(sys.argv[1])
    render_markdown(file_path)


if __name__ == "__main__":
    main()

