# Testing

## Types of Tests

```
Unit Tests: Test individual functions/methods
Integration Tests: Test components working together
End-to-End (E2E): Test entire application flow
Functional Tests: Test specific features
Performance Tests: Test speed/load
```

## Unit Testing (Python)

### pytest

```python
# test_calculator.py
def add(a, b):
    return a + b

def test_add():
    assert add(2, 3) == 5
    assert add(-1, 1) == 0
    assert add(0, 0) == 0

def test_add_floats():
    assert add(0.1, 0.2) == pytest.approx(0.3)

# Run: pytest test_calculator.py
```

### unittest

```python
import unittest

class TestCalculator(unittest.TestCase):
    def test_add(self):
        self.assertEqual(add(2, 3), 5)
        self.assertEqual(add(-1, 1), 0)

    def test_add_negative(self):
        self.assertEqual(add(-2, -3), -5)

    def setUp(self):
        # Run before each test
        print("Setting up")

    def tearDown(self):
        # Run after each test
        print("Tearing down")

if __name__ == '__main__':
    unittest.main()
```

## Unit Testing (Ruby)

### RSpec

```ruby
# calculator_spec.rb
require 'rspec'

def add(a, b)
  a + b
end

describe 'Calculator' do
  describe '#add' do
    it 'adds two positive numbers' do
      expect(add(2, 3)).to eq(5)
    end

    it 'adds negative numbers' do
      expect(add(-2, -3)).to eq(-5)
    end

    it 'adds zero' do
      expect(add(0, 0)).to eq(0)
    end
  end
end

# Run: rspec calculator_spec.rb
```

### Minitest

```ruby
require 'minitest/autorun'

class TestCalculator < Minitest::Test
  def test_add
    assert_equal 5, add(2, 3)
    assert_equal 0, add(-1, 1)
  end

  def test_add_negative
    assert_equal -5, add(-2, -3)
  end
end
```

## Assertions

### Python (pytest)

```python
# Equality
assert result == expected
assert result != unexpected

# Boolean
assert condition
assert not condition

# Exceptions
import pytest
with pytest.raises(ValueError):
    int('abc')

with pytest.raises(ValueError, match='invalid'):
    raise ValueError('invalid literal')

# Collections
assert item in collection
assert item not in collection

# None
assert value is None
assert value is not None

# Approximate (floats)
assert result == pytest.approx(0.3)
```

### Ruby (RSpec)

```ruby
# Equality
expect(result).to eq(expected)
expect(result).not_to eq(unexpected)

# Boolean
expect(condition).to be true
expect(condition).to be false

# Exceptions
expect { int('abc') }.to raise_error(ArgumentError)
expect { raise 'Error' }.to raise_error(/Error/)

# Collections
expect(collection).to include(item)
expect(array).to contain_exactly(1, 2, 3)

# Nil
expect(value).to be_nil
expect(value).not_to be_nil
```

## Test Fixtures

```python
# pytest
import pytest

@pytest.fixture
def sample_user():
    return {'name': 'Alice', 'age': 30}

def test_user_name(sample_user):
    assert sample_user['name'] == 'Alice'

# Setup/teardown
@pytest.fixture
def database():
    db = setup_database()
    yield db
    teardown_database(db)

def test_query(database):
    result = database.query('SELECT 1')
    assert result == 1
```

```ruby
# RSpec
RSpec.describe 'User' do
  let(:user) { User.new('Alice', 30) }

  it 'has a name' do
    expect(user.name).to eq('Alice')
  end

  before(:each) do
    # Setup before each test
    @db = setup_database
  end

  after(:each) do
    # Teardown after each test
    @db.close
  end
end
```

## Mocking

### Python

```python
from unittest.mock import Mock, patch

# Mock object
def test_api_call():
    mock_api = Mock()
    mock_api.get_user.return_value = {'name': 'Alice'}

    result = mock_api.get_user(1)
    assert result['name'] == 'Alice'
    mock_api.get_user.assert_called_once_with(1)

# Patch
def get_weather():
    import requests
    response = requests.get('http://api.weather.com')
    return response.json()

@patch('requests.get')
def test_get_weather(mock_get):
    mock_response = Mock()
    mock_response.json.return_value = {'temp': 72}
    mock_get.return_value = mock_response

    result = get_weather()
    assert result['temp'] == 72
```

### Ruby

```ruby
# RSpec mocks
describe 'API' do
  it 'calls external service' do
    api = double('API')
    allow(api).to receive(:get_user).and_return({name: 'Alice'})

    result = api.get_user(1)
    expect(result[:name]).to eq('Alice')
    expect(api).to have_received(:get_user).with(1)
  end
end
```

## Test Coverage

```python
# Install: pip install pytest-cov

# Run with coverage
# pytest --cov=myapp tests/

# HTML report
# pytest --cov=myapp --cov-report=html tests/

# Coverage.py directly
import coverage

cov = coverage.Coverage()
cov.start()

# Run code
add(2, 3)

cov.stop()
cov.save()
cov.report()
```

```ruby
# SimpleCov
require 'simplecov'
SimpleCov.start

# Run tests
# Coverage report generated in coverage/index.html
```

## Parameterized Tests

```python
import pytest

@pytest.mark.parametrize("a,b,expected", [
    (2, 3, 5),
    (-1, 1, 0),
    (0, 0, 0),
    (10, -5, 5)
])
def test_add(a, b, expected):
    assert add(a, b) == expected
```

```ruby
# RSpec shared examples
RSpec.shared_examples 'addition' do |a, b, expected|
  it "adds #{a} and #{b}" do
    expect(add(a, b)).to eq(expected)
  end
end

describe 'Calculator' do
  include_examples 'addition', 2, 3, 5
  include_examples 'addition', -1, 1, 0
  include_examples 'addition', 0, 0, 0
end
```

## Integration Testing

```python
# Test API endpoint
import requests

def test_api_endpoint():
    response = requests.get('http://localhost:5000/users/1')
    assert response.status_code == 200
    data = response.json()
    assert 'name' in data

# Test database
import sqlite3

def test_database():
    conn = sqlite3.connect(':memory:')
    cursor = conn.cursor()
    cursor.execute('CREATE TABLE users (id INT, name TEXT)')
    cursor.execute('INSERT INTO users VALUES (1, "Alice")')

    cursor.execute('SELECT name FROM users WHERE id = 1')
    result = cursor.fetchone()
    assert result[0] == 'Alice'
```

## Test Doubles

```python
# Stub: Returns predefined values
mock_api = Mock()
mock_api.get_user.return_value = {'name': 'Alice'}

# Spy: Records interactions
mock_api = Mock()
mock_api.get_user(1)
mock_api.get_user.assert_called_with(1)

# Fake: Working implementation (simpler)
class FakeDatabase:
    def __init__(self):
        self.users = {}

    def save(self, user):
        self.users[user.id] = user

    def get(self, user_id):
        return self.users.get(user_id)
```

## TDD (Test-Driven Development)

```python
# 1. Write failing test
def test_multiply():
    assert multiply(2, 3) == 6  # Function doesn't exist yet

# 2. Write minimal code to pass
def multiply(a, b):
    return a * b

# 3. Refactor
def multiply(a, b):
    """Multiply two numbers."""
    if not isinstance(a, (int, float)) or not isinstance(b, (int, float)):
        raise TypeError("Arguments must be numbers")
    return a * b

# 4. Run tests again
```

## Testing Best Practices

```python
# 1. One assertion per test (when possible)
def test_user_name():
    user = User('Alice')
    assert user.name == 'Alice'

def test_user_age():
    user = User('Alice', age=30)
    assert user.age == 30

# 2. Descriptive test names
def test_user_creation_with_valid_name():
    pass

# 3. AAA pattern: Arrange, Act, Assert
def test_transfer_money():
    # Arrange
    account1 = Account(100)
    account2 = Account(50)

    # Act
    account1.transfer(account2, 30)

    # Assert
    assert account1.balance == 70
    assert account2.balance == 80

# 4. Test edge cases
def test_divide_by_zero():
    with pytest.raises(ZeroDivisionError):
        divide(10, 0)

# 5. Keep tests independent
# Each test should run in isolation

# 6. Fast tests
# Unit tests should be quick (<100ms)

# 7. Don't test implementation details
# Test behavior, not internals
```

## Test Organization

```python
# File structure
tests/
    test_calculator.py
    test_user.py
    test_api.py
    conftest.py  # Shared fixtures

# Naming
# test_<module>.py
# test_<function_name>
# test_<class>_<method>

# Grouping
class TestUserAuthentication:
    def test_login_success(self):
        pass

    def test_login_failure(self):
        pass

    def test_logout(self):
        pass
```

## Skip/Mark Tests

```python
import pytest

# Skip test
@pytest.mark.skip(reason="Not implemented yet")
def test_future_feature():
    pass

# Skip conditionally
@pytest.mark.skipif(sys.version_info < (3, 8), reason="Requires Python 3.8+")
def test_new_syntax():
    pass

# Mark as expected to fail
@pytest.mark.xfail
def test_known_bug():
    assert buggy_function() == expected

# Custom markers
@pytest.mark.slow
def test_long_running():
    pass

# Run only slow tests: pytest -m slow
# Skip slow tests: pytest -m "not slow"
```

## Testing Async Code

```python
import pytest
import asyncio

@pytest.mark.asyncio
async def test_async_function():
    result = await async_fetch_data()
    assert result == expected

# Or use asyncio directly
def test_async_with_run():
    async def fetch():
        await asyncio.sleep(0.1)
        return 'data'

    result = asyncio.run(fetch())
    assert result == 'data'
```

## Testing Exceptions

```python
# pytest
def test_raises_value_error():
    with pytest.raises(ValueError):
        int('abc')

    with pytest.raises(ValueError, match='invalid'):
        raise ValueError('invalid literal')

# unittest
def test_raises_value_error(self):
    with self.assertRaises(ValueError):
        int('abc')

    with self.assertRaisesRegex(ValueError, 'invalid'):
        raise ValueError('invalid literal')
```

## Database Testing

```python
import pytest
import sqlite3

@pytest.fixture
def db():
    conn = sqlite3.connect(':memory:')
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE users (
            id INTEGER PRIMARY KEY,
            name TEXT
        )
    ''')
    yield conn
    conn.close()

def test_insert_user(db):
    cursor = db.cursor()
    cursor.execute('INSERT INTO users (name) VALUES (?)', ('Alice',))
    db.commit()

    cursor.execute('SELECT name FROM users')
    result = cursor.fetchone()
    assert result[0] == 'Alice'
```

## Testing CLI

```python
from click.testing import CliRunner
import click

@click.command()
@click.argument('name')
def greet(name):
    click.echo(f'Hello {name}')

def test_greet():
    runner = CliRunner()
    result = runner.invoke(greet, ['Alice'])
    assert result.exit_code == 0
    assert 'Hello Alice' in result.output
```

## Continuous Testing

```bash
# Watch for changes and re-run tests

# pytest-watch
pip install pytest-watch
ptw

# Or with pytest-xdist
pip install pytest-xdist
pytest --looponfail
```

## Test Reporting

```bash
# Verbose output
pytest -v

# Show print statements
pytest -s

# Stop on first failure
pytest -x

# Run last failed tests
pytest --lf

# Generate HTML report
pytest --html=report.html
```

## Property-Based Testing

```python
from hypothesis import given
import hypothesis.strategies as st

@given(st.integers(), st.integers())
def test_add_commutative(a, b):
    assert add(a, b) == add(b, a)

@given(st.lists(st.integers()))
def test_sort_idempotent(lst):
    assert sorted(sorted(lst)) == sorted(lst)
```

## Common Patterns

```python
# Test setup/teardown
@pytest.fixture(scope='module')
def setup():
    # Expensive setup (once per module)
    db = create_database()
    yield db
    db.close()

# Temporary files
import tempfile

def test_file_operation():
    with tempfile.NamedTemporaryFile() as f:
        f.write(b'test data')
        f.flush()
        # Test using f.name

# Mock time
from unittest.mock import patch
from datetime import datetime

@patch('datetime.datetime')
def test_with_fixed_time(mock_datetime):
    mock_datetime.now.return_value = datetime(2024, 1, 15)
    # Test time-dependent code
```

## Anti-Patterns

```python
# ❌ Testing implementation details
def test_internal_cache():
    obj = MyClass()
    obj.do_something()
    assert obj._cache == expected  # Don't test private attributes

# ✅ Test behavior
def test_consistent_results():
    obj = MyClass()
    result1 = obj.do_something()
    result2 = obj.do_something()
    assert result1 == result2

# ❌ Overmocking
# ❌ Slow tests
# ❌ Brittle tests (break on small changes)
# ❌ Testing framework code
```
