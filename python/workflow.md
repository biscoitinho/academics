# Python Workflow

How a generic development workflow looks when working with Python.

## Project Setup

### 1. Create Project Structure

```
myproject/
├── mypackage/
│   ├── __init__.py
│   ├── main.py
│   └── utils.py
├── tests/
│   ├── __init__.py
│   ├── test_main.py
│   └── test_utils.py
├── pyproject.toml
├── requirements.txt (or poetry.lock)
├── .gitignore
└── .venv/
```

### 2. Set Up Environment

```bash
# Set Python version
pyenv local 3.12.0

# Create virtual environment
python -m venv .venv
source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt
# or
poetry install
```

### 3. Configure Tooling

A minimal `pyproject.toml`:
```toml
[project]
name = "mypackage"
version = "0.1.0"
requires-python = ">=3.10"

[tool.ruff]
line-length = 88

[tool.mypy]
python_version = "3.12"
disallow_untyped_defs = true

[tool.pytest.ini_options]
testpaths = ["tests"]
```

## Development Cycle

### Write Code
1. Activate the virtual environment
2. Write or modify code
3. Run the code to verify behavior
4. Write or update tests

### Run Tests

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=mypackage

# Run specific test
pytest tests/test_main.py::test_specific_function -v
```

### Lint and Format

```bash
# Format code
ruff format .

# Lint and auto-fix
ruff check --fix .

# Type check
mypy mypackage/
```

### Typical Cycle
```
write code -> run tests -> lint/format -> type check -> commit
```

## Best Practices

### Project Organization
- One module per file, one concern per module
- Keep `__init__.py` files minimal (just imports for public API)
- Separate configuration from code (use environment variables or config files)
- Use `src/` layout for packages you plan to distribute

### Code Style
- Follow PEP 8 (enforced automatically by ruff/black)
- Use type hints for function signatures and complex variables
- Write docstrings for public functions and classes
- Use f-strings for string formatting
- Prefer pathlib over os.path for file operations

### Dependencies
- Always use a virtual environment, never install into system Python
- Pin dependencies with exact versions in lock files
- Separate dev dependencies from production dependencies
- Audit dependencies periodically for security issues

### Testing
- Write tests alongside code, not as an afterthought
- Use pytest fixtures for shared setup
- Mock external services (APIs, databases) in unit tests
- Aim for meaningful coverage, not 100% for its own sake
- Name tests descriptively: `test_user_creation_with_invalid_email_raises_error`

### Error Handling
- Catch specific exceptions, never bare `except:`
- Use custom exceptions for domain-specific errors
- Let unexpected errors propagate (don't silently swallow them)
- Use logging instead of print for anything beyond quick debugging

### Imports
- Standard library first, then third-party, then local (ruff/isort handles this)
- Avoid wildcard imports (`from module import *`)
- Use absolute imports over relative imports in most cases

## What to Avoid

### Common Anti-Patterns
- **Mutable default arguments**: `def func(items=[])` is a bug. Use `def func(items=None)` instead.
- **Global state**: Avoid module-level mutable variables. Pass state explicitly or use classes.
- **Circular imports**: Restructure code or use local imports if needed.
- **Mega-functions**: If a function is over 30-40 lines, it probably does too much.
- **Stringly-typed code**: Use enums, dataclasses, or typed dicts instead of passing raw strings and dicts everywhere.

### Dependency Anti-Patterns
- Don't `pip install` without a virtual environment
- Don't use `pip freeze > requirements.txt` as your only dependency management (it mixes direct and transitive deps)
- Don't pin to exact versions in libraries (only in applications)

### Testing Anti-Patterns
- Don't test implementation details (private methods, internal state)
- Don't write tests that depend on execution order
- Don't ignore flaky tests - fix them
- Don't mock everything - sometimes integration tests are more valuable

### Performance Anti-Patterns
- Don't optimize before profiling (`python -m cProfile script.py`)
- Don't concatenate strings in loops (use `"".join()`)
- Don't load entire large files into memory (use generators/iterators)
- Don't use `+` to build SQL queries (use parameterized queries)

## Debugging Workflow

1. **Reproduce the bug** with a minimal example
2. **Read the traceback** carefully, bottom to top
3. **Add a breakpoint** (`breakpoint()`) near the suspected issue
4. **Inspect state** in the debugger (variables, types, values)
5. **Write a failing test** that captures the bug
6. **Fix the bug** and verify the test passes
7. **Check for similar bugs** elsewhere in the codebase

## Packaging and Distribution

```bash
# Build package
python -m build

# Upload to PyPI (or TestPyPI)
python -m twine upload dist/*

# Install locally in editable mode (for development)
pip install -e .
```

## Environment Variables

Use `python-dotenv` or `environs` for managing environment-specific configuration:

```bash
# .env file (never commit this)
DATABASE_URL=postgresql://localhost/mydb
DEBUG=true
SECRET_KEY=...
```

```python
from dotenv import load_dotenv
import os

load_dotenv()
db_url = os.getenv("DATABASE_URL")
```
