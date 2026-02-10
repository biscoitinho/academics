# Python Tooling

Recommended tools for working with Python.

## Version Management

### pyenv
The standard tool for managing multiple Python versions on a single machine.

```bash
# Install a Python version
pyenv install 3.12.0

# Set global version
pyenv global 3.12.0

# Set local version (per project)
pyenv local 3.11.5

# List installed versions
pyenv versions

# List available versions
pyenv install --list
```

**Why use it**: System Python should not be used for development. pyenv lets you install and switch between versions without affecting the system.

## Virtual Environments

### venv (Built-in)
Standard library module for creating isolated environments. Should be used for every project.

```bash
# Create a virtual environment
python -m venv .venv

# Activate
source .venv/bin/activate    # Linux/macOS
.venv\Scripts\activate       # Windows

# Deactivate
deactivate
```

### virtualenv
Third-party alternative, faster than venv and supports older Python versions.

```bash
pip install virtualenv
virtualenv .venv
```

### conda
Popular in data science. Manages both Python versions and non-Python dependencies (C libraries, etc.).

```bash
# Create environment
conda create -n myproject python=3.12

# Activate
conda activate myproject

# Install packages
conda install numpy pandas
```

**When to use conda**: When you need scientific packages with compiled C/Fortran dependencies (NumPy, SciPy, etc.) or need to manage non-Python dependencies.

## Dependency Management

### pip + requirements.txt
The simplest approach. Works everywhere.

```bash
# Install packages
pip install requests flask

# Freeze current environment
pip freeze > requirements.txt

# Install from file
pip install -r requirements.txt
```

### pip-tools
Adds deterministic builds on top of pip. Separates direct dependencies from the full dependency tree.

```bash
pip install pip-tools

# Write your direct dependencies in requirements.in
# Then compile the full locked dependency tree
pip-compile requirements.in

# Install from compiled file
pip-sync requirements.txt
```

### poetry
All-in-one tool: dependency management, virtual environments, building, and publishing.

```bash
# New project
poetry new myproject

# Add dependency
poetry add requests
poetry add --group dev pytest

# Install all dependencies
poetry install

# Run inside the virtual environment
poetry run python main.py
poetry shell
```

Uses `pyproject.toml` for configuration and `poetry.lock` for deterministic installs.

### uv
Fast Rust-based replacement for pip, pip-tools, and virtualenv. Drop-in compatible.

```bash
# Install packages (much faster than pip)
uv pip install requests

# Create virtual environment
uv venv

# Compile requirements
uv pip compile requirements.in -o requirements.txt
```

## Linting and Formatting

### ruff
Extremely fast linter and formatter written in Rust. Replaces flake8, isort, and many other tools.

```bash
pip install ruff

# Lint
ruff check .

# Fix auto-fixable issues
ruff check --fix .

# Format code
ruff format .
```

Configuration in `pyproject.toml`:
```toml
[tool.ruff]
line-length = 88
target-version = "py312"

[tool.ruff.lint]
select = ["E", "F", "I", "N", "W", "UP"]
```

### black
The opinionated code formatter. Minimal configuration by design.

```bash
pip install black

# Format files
black .

# Check without changing
black --check .
```

### pylint
Most thorough linter. Slower but catches more issues including code smells and design problems.

```bash
pip install pylint
pylint mypackage/
```

### isort
Sorts imports alphabetically and by section. Also covered by ruff.

```bash
pip install isort
isort .
```

## Type Checking

### mypy
The standard static type checker for Python.

```bash
pip install mypy

# Check a package
mypy mypackage/

# Strict mode
mypy --strict mypackage/
```

Configuration in `pyproject.toml`:
```toml
[tool.mypy]
python_version = "3.12"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
```

### pyright
Microsoft's type checker. Faster than mypy, used by Pylance in VS Code.

```bash
pip install pyright
pyright
```

## Security

### bandit
Static analysis for finding common security issues.

```bash
pip install bandit
bandit -r mypackage/
```

## Testing

### pytest
The de facto standard testing framework. More features and better output than unittest.

```bash
pip install pytest

# Run all tests
pytest

# Verbose output
pytest -v

# Run specific test file
pytest tests/test_users.py

# Run specific test
pytest tests/test_users.py::test_create_user

# Run tests matching a pattern
pytest -k "test_create"

# Stop on first failure
pytest -x
```

Common plugins:
- `pytest-cov` - Coverage reporting
- `pytest-mock` - Mocking utilities
- `pytest-xdist` - Parallel test execution
- `pytest-asyncio` - Async test support

### unittest
Built-in testing framework. No installation needed but more verbose than pytest.

```python
import unittest

class TestMath(unittest.TestCase):
    def test_add(self):
        self.assertEqual(1 + 1, 2)
```

### coverage
Measures code coverage of tests.

```bash
pip install coverage

# Run with coverage
coverage run -m pytest
coverage report
coverage html  # Generate HTML report
```

## Debugging

### pdb (Built-in)
Python's built-in debugger.

```python
# Insert breakpoint in code
breakpoint()  # Python 3.7+

# Or older style
import pdb; pdb.set_trace()
```

Common pdb commands: `n` (next), `s` (step into), `c` (continue), `p` (print), `l` (list), `q` (quit).

### ipdb
Enhanced pdb with IPython features (tab completion, syntax highlighting).

```bash
pip install ipdb
```

```python
import ipdb; ipdb.set_trace()
```

### pysnooper
Decorator-based debugging. Logs every line executed and variable changes.

```python
import pysnooper

@pysnooper.snoop()
def my_function():
    ...
```

### debugpy
Debug adapter for VS Code and other editors. Supports remote debugging.

## Code Metrics and Refactoring

### prospector
Meta-tool that runs multiple linters and analysis tools together (pylint, pycodestyle, mccabe, etc.).

```bash
pip install prospector
prospector
```

### jedi
Autocompletion and static analysis library. Powers many editor plugins.

## CLI Tooling and Output

### rich
Library for rich text, tables, progress bars, and pretty printing in the terminal.

```bash
pip install rich
```

```python
from rich import print
from rich.console import Console
console = Console()
console.print("[bold green]Success![/bold green]")
```

## Build and Packaging

### pyproject.toml
The modern standard for Python project configuration. Replaces setup.py, setup.cfg.

```toml
[build-system]
requires = ["setuptools>=68.0"]
build-backend = "setuptools.backends._legacy:_Backend"

[project]
name = "mypackage"
version = "0.1.0"
requires-python = ">=3.10"
dependencies = ["requests>=2.28"]
```

## Recommended Stack

| Purpose | Tool |
|---------|------|
| Version management | pyenv |
| Virtual environments | venv (built-in) |
| Dependencies | poetry or pip-tools |
| Linting + formatting | ruff |
| Type checking | mypy |
| Security scanning | bandit |
| Testing | pytest + pytest-cov |
| Debugging | pdb / ipdb / pysnooper |
| Code metrics | prospector |
| CLI output | rich |
| Configuration | pyproject.toml |
