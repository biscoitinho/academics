## Minitest - Ruby Testing Framework

Minitest is a lightweight testing framework included with Ruby.

### Setup

```ruby
require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_something
    assert_equal 4, 2 + 2
  end
end
```

### Basic assertions

```ruby
class CalculatorTest < Minitest::Test
  def test_addition
    assert_equal 4, 2 + 2
  end
  
  def test_subtraction
    assert_equal 0, 2 - 2
  end
  
  def test_multiplication
    result = 2 * 3
    assert_equal 6, result
  end
end
```

### Common assertions

```ruby
class AssertionsTest < Minitest::Test
  def test_equality
    assert_equal 5, 5          # Equal
    refute_equal 5, 4          # Not equal
  end
  
  def test_nil
    assert_nil nil             # Is nil
    refute_nil "hello"         # Not nil
  end
  
  def test_truthiness
    assert true                # Is truthy
    refute false               # Is falsy
  end
  
  def test_inclusion
    assert_includes [1, 2, 3], 2
    refute_includes [1, 2, 3], 5
  end
  
  def test_instance_of
    assert_instance_of String, "hello"
    refute_instance_of Integer, "hello"
  end
  
  def test_kind_of
    assert_kind_of Numeric, 5
    assert_kind_of Numeric, 5.5
  end
  
  def test_match
    assert_match /hello/, "hello world"
    refute_match /goodbye/, "hello world"
  end
  
  def test_empty
    assert_empty []
    refute_empty [1, 2, 3]
  end
  
  def test_respond_to
    assert_respond_to "hello", :upcase
    refute_respond_to 5, :upcase
  end
end
```

### Testing exceptions

```ruby
class ExceptionTest < Minitest::Test
  def test_raises_exception
    assert_raises(ZeroDivisionError) do
      1 / 0
    end
  end
  
  def test_raises_with_message
    error = assert_raises(ArgumentError) do
      raise ArgumentError, "Invalid input"
    end
    assert_match /Invalid/, error.message
  end
end
```

### Setup and teardown

```ruby
class UserTest < Minitest::Test
  def setup
    # Runs before each test
    @user = User.new(name: "Alice")
  end
  
  def teardown
    # Runs after each test
    @user = nil
  end
  
  def test_user_name
    assert_equal "Alice", @user.name
  end
  
  def test_user_update
    @user.name = "Bob"
    assert_equal "Bob", @user.name
  end
end
```

### Skip tests

```ruby
class SkipTest < Minitest::Test
  def test_something
    skip "Not implemented yet"
    assert_equal 5, some_method
  end
  
  def test_skip_conditional
    skip "Only works on Linux" unless RUBY_PLATFORM =~ /linux/
    # test code
  end
end
```

### Spec syntax (alternative style)

```ruby
require 'minitest/autorun'

describe "Calculator" do
  before do
    @calc = Calculator.new
  end
  
  it "adds two numbers" do
    _(@calc.add(2, 3)).must_equal 5
  end
  
  it "subtracts two numbers" do
    _(@calc.subtract(5, 3)).must_equal 2
  end
  
  it "raises error on division by zero" do
    _ { @calc.divide(5, 0) }.must_raise ZeroDivisionError
  end
end
```

### Spec expectations

```ruby
describe Array do
  it "must be empty initially" do
    _(Array.new).must_be_empty
  end
  
  it "must include value" do
    _([1, 2, 3]).must_include 2
  end
  
  it "must be instance of Array" do
    _([]).must_be_instance_of Array
  end
  
  it "must be kind of Enumerable" do
    _([]).must_be_kind_of Enumerable
  end
  
  it "must match pattern" do
    _("hello").must_match /hel/
  end
  
  it "must respond to method" do
    _([]).must_respond_to :push
  end
end
```

### Mocking and stubbing

```ruby
class MockTest < Minitest::Test
  def test_mock
    mock = Minitest::Mock.new
    mock.expect :name, "Alice"
    mock.expect :age, 30
    
    assert_equal "Alice", mock.name
    assert_equal 30, mock.age
    
    mock.verify  # Ensure all expectations were called
  end
  
  def test_stub
    user = User.new
    user.stub :premium?, true do
      assert user.premium?
    end
  end
  
  def test_stub_constant
    Object.stub_const :API_URL, "http://test.com" do
      assert_equal "http://test.com", API_URL
    end
  end
end
```

### Testing with fixtures

```ruby
class UserTest < Minitest::Test
  def setup
    @user_data = {
      name: "Alice",
      email: "alice@example.com",
      age: 30
    }
  end
  
  def test_user_creation
    user = User.new(@user_data)
    assert_equal "Alice", user.name
    assert_equal "alice@example.com", user.email
  end
end
```

### Parallel test execution

```ruby
# Run tests in parallel
class ParallelTest < Minitest::Test
  parallelize_me!
  
  def test_one
    assert_equal 2, 1 + 1
  end
  
  def test_two
    assert_equal 4, 2 + 2
  end
end
```

### Custom assertions

```ruby
module CustomAssertions
  def assert_valid(object)
    assert object.valid?, "Expected #{object} to be valid"
  end
end

class MyTest < Minitest::Test
  include CustomAssertions
  
  def test_user_valid
    user = User.new(name: "Alice")
    assert_valid user
  end
end
```

### Testing output

```ruby
class OutputTest < Minitest::Test
  def test_puts_output
    output = capture_io do
      puts "Hello, World!"
    end.first
    
    assert_match /Hello/, output
  end
end
```

### Benchmark tests

```ruby
require 'minitest/benchmark'

class BenchmarkTest < Minitest::Benchmark
  def bench_algorithm
    assert_performance_linear 0.9999 do |n|
      n.times { "a" * n }
    end
  end
end
```

### Rails integration

```ruby
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user should be valid" do
    user = User.new(name: "Alice", email: "alice@example.com")
    assert user.valid?
  end
  
  test "user requires name" do
    user = User.new(email: "alice@example.com")
    assert_not user.valid?
    assert_includes user.errors[:name], "can't be blank"
  end
end
```

### Controller tests (Rails)

```ruby
class UsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end
  
  test "should create user" do
    assert_difference('User.count') do
      post :create, params: { user: { name: "Alice" } }
    end
    assert_redirected_to user_path(assigns(:user))
  end
end
```

### Integration tests (Rails)

```ruby
class UserFlowTest < ActionDispatch::IntegrationTest
  test "user signup flow" do
    get signup_path
    assert_response :success
    
    post users_path, params: {
      user: { name: "Alice", email: "alice@example.com" }
    }
    assert_redirected_to root_path
    follow_redirect!
    
    assert_select 'h1', 'Welcome'
  end
end
```

### Running tests

```bash
# Run all tests
ruby test/my_test.rb

# Run specific test
ruby test/my_test.rb --name test_something

# Run with verbose output
ruby test/my_test.rb -v

# Run all tests in directory
rake test

# Run specific test file
rake test TEST=test/models/user_test.rb
```

### Test organization

```ruby
# test/test_helper.rb
require 'minitest/autorun'
require_relative '../lib/my_app'

# test/models/user_test.rb
require 'test_helper'

class UserTest < Minitest::Test
  # tests here
end
```

### Minitest reporters (colorful output)

```ruby
# Gemfile
gem 'minitest-reporters'

# test_helper.rb
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
```

### Common patterns

**Testing private methods:**
```ruby
class MyClass
  private
  
  def private_method
    "secret"
  end
end

class MyClassTest < Minitest::Test
  def test_private_method
    obj = MyClass.new
    result = obj.send(:private_method)
    assert_equal "secret", result
  end
end
```

**Testing class methods:**
```ruby
class MathUtils
  def self.square(n)
    n * n
  end
end

class MathUtilsTest < Minitest::Test
  def test_square
    assert_equal 25, MathUtils.square(5)
  end
end
```

**Using let (with minitest-let gem):**
```ruby
describe User do
  let(:user) { User.new(name: "Alice") }
  
  it "has a name" do
    _(user.name).must_equal "Alice"
  end
end
```
