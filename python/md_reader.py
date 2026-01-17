import sys
from rich.console import Console
from rich.markdown import Markdown

console = Console()
with open(sys.argv[1]) as md:
    markdown = Markdown(md.read())

console.print(markdown)

