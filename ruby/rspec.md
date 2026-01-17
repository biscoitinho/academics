## RSpec - Behavior-Driven Development Testing

RSpec is the most popular BDD testing framework for Ruby.

### Setup

```ruby
# Gemfile
gem 'rspec'

# Install
bundle install

# Initialize
rspec --init
```

### Basic example

```ruby
# spec/calculator_spec.rb
RSpec.describe Calculator do
  describe '#add' do
    it 'adds two numbers' do
      calculator = Calculator.new
      result = calculator.add(2, 3)
      expect(result).to eq(5)
    end
  end
end
```

### Expectations (matchers)

#### Equality matchers

```ruby
RSpec.describe 'equality matchers' do
  it 'tests for equality' do
    expect(5).to eq(5)              # Value equality
    expect(5).to eql(5)             # Value & type equality
    expect("hello").to be("hello")  # Object identity (same object)
  end
end
```

#### Comparison matchers

```ruby
RSpec.describe 'comparison matchers' do
  it 'compares values' do
    expect(10).to be > 5
    expect(5).to be < 10
    expect(5).to be >= 5
    expect(5).to be <= 5
    expect(5).to be_between(1, 10).inclusive
  end
end
```

#### Type/class matchers

```ruby
RSpec.describe 'type matchers' do
  it 'checks types' do
    expect(5).to be_a(Integer)
    expect(5).to be_an(Integer)
    expect(5).to be_a_kind_of(Numeric)
    expect(5).to be_an_instance_of(Integer)
  end
end
```

#### Truthiness matchers

```ruby
RSpec.describe 'truthiness' do
  it 'checks for truth' do
    expect(true).to be_truthy
    expect(false).to be_falsy
    expect(nil).to be_nil
    expect("hello").to be_truthy
    expect(0).to be_truthy  # In Ruby, 0 is truthy!
  end
end
```

#### Collection matchers

```ruby
RSpec.describe 'collection matchers' do
  it 'checks collections' do
    expect([1, 2, 3]).to include(2)
    expect([1, 2, 3]).to include(1, 3)
    expect([1, 2, 3]).to contain_exactly(3, 2, 1)  # Order doesn't matter
    expect([1, 2, 3]).to match_array([3, 2, 1])
    expect([]).to be_empty
    expect([1, 2, 3]).to have(3).items
  end
end
```

#### String matchers

```ruby
RSpec.describe 'string matchers' do
  it 'matches strings' do
    expect("hello").to start_with("hel")
    expect("hello").to end_with("llo")
    expect("hello world").to include("world")
    expect("hello").to match(/hel/)
  end
end
```

#### Predicate matchers

```ruby
RSpec.describe 'predicate matchers' do
  it 'uses predicate methods' do
    expect([]).to be_empty
    expect(10).to be_even
    expect(5).to be_odd
    expect(10).to be_positive
    expect(nil).to be_nil
  end
end
```

### describe and context

```ruby
RSpec.describe User do
  describe '#name' do
    context 'when user has a name' do
      it 'returns the name' do
        user = User.new(name: "Alice")
        expect(user.name).to eq("Alice")
      end
    end
    
    context 'when user has no name' do
      it 'returns nil' do
        user = User.new
        expect(user.name).to be_nil
      end
    end
  end
end
```

### before and after hooks

```ruby
RSpec.describe User do
  before(:each) do
    # Runs before each test
    @user = User.new(name: "Alice")
  end
  
  after(:each) do
    # Runs after each test
    @user = nil
  end
  
  before(:all) do
    # Runs once before all tests in this block
    @admin = User.new(name: "Admin", role: :admin)
  end
  
  after(:all) do
    # Runs once after all tests in this block
    @admin = nil
  end
  
  it 'has a name' do
    expect(@user.name).to eq("Alice")
  end
end
```

### let and let!

```ruby
RSpec.describe User do
  # Lazy evaluation - only created when first used
  let(:user) { User.new(name: "Alice") }
  
  # Eager evaluation - created before each test
  let!(:admin) { User.new(name: "Admin", role: :admin) }
  
  it 'creates user on demand' do
    expect(user.name).to eq("Alice")
  end
  
  it 'has admin ready' do
    expect(admin.role).to eq(:admin)
  end
end
```

### subject

```ruby
RSpec.describe Array do
  subject { [1, 2, 3] }
  
  it { is_expected.to include(2) }
  it { is_expected.to have(3).items }
  
  # Named subject
  subject(:my_array) { [1, 2, 3] }
  
  it 'can be referenced by name' do
    expect(my_array.first).to eq(1)
  end
end
```

### Shared examples

```ruby
# spec/support/shared_examples.rb
RSpec.shared_examples 'a collection' do
  it 'responds to count' do
    expect(subject).to respond_to(:count)
  end
  
  it 'responds to each' do
    expect(subject).to respond_to(:each)
  end
end

# In your specs
RSpec.describe Array do
  subject { [1, 2, 3] }
  it_behaves_like 'a collection'
end

RSpec.describe Hash do
  subject { {a: 1, b: 2} }
  it_behaves_like 'a collection'
end
```

### Shared context

```ruby
RSpec.shared_context 'authenticated user' do
  let(:user) { User.new(name: "Alice") }
  let(:token) { "abc123" }
  
  before do
    allow(user).to receive(:authenticated?).and_return(true)
  end
end

RSpec.describe 'Dashboard' do
  include_context 'authenticated user'
  
  it 'shows user dashboard' do
    expect(user).to be_authenticated
  end
end
```

### Testing exceptions

```ruby
RSpec.describe Calculator do
  it 'raises error on division by zero' do
    calculator = Calculator.new
    expect { calculator.divide(5, 0) }.to raise_error(ZeroDivisionError)
  end
  
  it 'raises error with message' do
    expect { raise "Error!" }.to raise_error("Error!")
    expect { raise "Error!" }.to raise_error(/Error/)
  end
end
```

### Mocking and stubbing

#### allow (stub methods)

```ruby
RSpec.describe User do
  it 'stubs a method' do
    user = User.new
    allow(user).to receive(:premium?).and_return(true)
    
    expect(user.premium?).to be true
  end
  
  it 'stubs with arguments' do
    user = User.new
    allow(user).to receive(:discount).with(100).and_return(10)
    
    expect(user.discount(100)).to eq(10)
  end
end
```

#### expect (verify method calls)

```ruby
RSpec.describe User do
  it 'expects method to be called' do
    user = User.new
    expect(user).to receive(:save)
    user.save
  end
  
  it 'expects method with specific arguments' do
    user = User.new
    expect(user).to receive(:update).with(name: "Alice")
    user.update(name: "Alice")
  end
  
  it 'expects method to be called twice' do
    user = User.new
    expect(user).to receive(:save).twice
    user.save
    user.save
  end
end
```

#### Double (mock objects)

```ruby
RSpec.describe 'doubles' do
  it 'creates a double' do
    user = double('User', name: "Alice", age: 30)
    
    expect(user.name).to eq("Alice")
    expect(user.age).to eq(30)
  end
  
  it 'uses instance_double' do
    user = instance_double(User, name: "Alice")
    allow(user).to receive(:save).and_return(true)
    
    expect(user.save).to be true
  end
end
```

### One-liner syntax

```ruby
RSpec.describe Array do
  subject { [1, 2, 3] }
  
  it { is_expected.to be_a(Array) }
  it { is_expected.to include(2) }
  it { is_expected.to have(3).items }
  it { is_expected.not_to be_empty }
end
```

### Pending tests

```ruby
RSpec.describe 'Feature' do
  it 'will be implemented later' do
    pending 'waiting for API'
    expect(true).to be false
  end
  
  xit 'is skipped' do
    expect(true).to be false
  end
  
  it 'not implemented'  # Just description, no block
end
```

### Aggregate failures

```ruby
RSpec.describe 'Multiple assertions' do
  it 'checks multiple things', :aggregate_failures do
    expect(5).to eq(5)
    expect(10).to be > 5
    expect("hello").to start_with("h")
    # All assertions run even if one fails
  end
end
```

### Custom matchers

```ruby
RSpec::Matchers.define :be_a_multiple_of do |expected|
  match do |actual|
    actual % expected == 0
  end
  
  failure_message do |actual|
    "expected #{actual} to be a multiple of #{expected}"
  end
end

RSpec.describe 'custom matcher' do
  it 'uses custom matcher' do
    expect(10).to be_a_multiple_of(5)
  end
end
```

### Rails integration

#### Model specs

```ruby
# spec/models/user_spec.rb
RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:email) }
  end
  
  describe 'associations' do
    it { should have_many(:posts) }
    it { should belong_to(:team) }
  end
  
  describe '#full_name' do
    it 'returns first and last name' do
      user = User.new(first_name: "Alice", last_name: "Smith")
      expect(user.full_name).to eq("Alice Smith")
    end
  end
end
```

#### Controller specs

```ruby
# spec/controllers/users_controller_spec.rb
RSpec.describe UsersController, type: :controller do
  describe 'GET #index' do
    it 'returns success' do
      get :index
      expect(response).to have_http_status(:success)
    end
    
    it 'assigns @users' do
      users = create_list(:user, 3)
      get :index
      expect(assigns(:users)).to eq(users)
    end
  end
  
  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a user' do
        expect {
          post :create, params: { user: { name: "Alice" } }
        }.to change(User, :count).by(1)
      end
    end
  end
end
```

#### Request specs

```ruby
# spec/requests/users_spec.rb
RSpec.describe 'Users API', type: :request do
  describe 'GET /users' do
    it 'returns all users' do
      create_list(:user, 3)
      get '/users'
      
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end
end
```

#### Feature specs (with Capybara)

```ruby
# spec/features/user_signup_spec.rb
RSpec.describe 'User signup', type: :feature do
  scenario 'user signs up successfully' do
    visit signup_path
    
    fill_in 'Name', with: 'Alice'
    fill_in 'Email', with: 'alice@example.com'
    fill_in 'Password', with: 'password123'
    
    click_button 'Sign Up'
    
    expect(page).to have_content('Welcome, Alice!')
    expect(current_path).to eq(root_path)
  end
end
```

### Factory Bot integration

```ruby
# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    name { "Alice" }
    email { "alice@example.com" }
    age { 30 }
    
    trait :admin do
      role { :admin }
    end
  end
end

# In specs
RSpec.describe User do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  
  it 'creates a user' do
    expect(user.name).to eq("Alice")
  end
end
```

### Running specs

```bash
# Run all specs
rspec

# Run specific file
rspec spec/models/user_spec.rb

# Run specific line
rspec spec/models/user_spec.rb:10

# Run with documentation format
rspec --format documentation

# Run with color
rspec --color

# Run only failed tests
rspec --only-failures

# Run with coverage
rspec --require spec_helper
```

### Configuration

```ruby
# spec/spec_helper.rb
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = "spec/examples.txt"
  config.disable_monkey_patching!
  config.warnings = true
  
  config.default_formatter = "doc" if config.files_to_run.one?
  
  config.order = :random
  Kernel.srand config.seed
end
```
