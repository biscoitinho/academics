# Ruby Workflow

How a generic development workflow looks when working with Ruby and Rails.

---

## Part 1: General Ruby Workflow

### Project Setup

#### 1. Create Project Structure

```
myproject/
├── lib/
│   ├── myproject.rb
│   └── myproject/
│       ├── parser.rb
│       └── processor.rb
├── test/ (or spec/)
│   ├── test_helper.rb
│   ├── parser_test.rb
│   └── processor_test.rb
├── bin/
│   └── myproject
├── Gemfile
├── Gemfile.lock
├── Rakefile
├── .rubocop.yml
├── .ruby-version
└── .gitignore
```

#### 2. Set Up Environment

```bash
# Set Ruby version
rbenv local 3.3.0

# Initialize Bundler
bundle init

# Add dependencies to Gemfile, then install
bundle install

# Set up linting
bundle exec rubocop --init
```

#### 3. Gemfile Basics

```ruby
source "https://rubygems.org"

gem "thor"          # CLI framework
gem "httparty"      # HTTP client

group :development, :test do
  gem "rspec"
  gem "rubocop", require: false
  gem "pry"
end
```

### Development Cycle

#### Write Code
1. Write or modify Ruby code in `lib/`
2. Run it (`ruby lib/myproject.rb` or `bundle exec bin/myproject`)
3. Test in IRB/Pry if experimenting (`bundle exec irb -r ./lib/myproject`)
4. Write or update tests

#### Run Tests

```bash
# RSpec
bundle exec rspec
bundle exec rspec spec/parser_spec.rb
bundle exec rspec spec/parser_spec.rb:15  # Specific line

# Minitest
bundle exec rake test
bundle exec ruby -Itest test/parser_test.rb
```

#### Lint and Format

```bash
# Check
bundle exec rubocop

# Auto-fix
bundle exec rubocop -a

# Auto-fix including unsafe corrections
bundle exec rubocop -A
```

#### Typical Cycle
```
write code -> run tests -> rubocop -> commit
```

### Best Practices (General Ruby)

#### Code Style
- Follow the Ruby community style guide (enforced by RuboCop)
- Use snake_case for methods and variables, CamelCase for classes
- Use `?` suffix for predicate methods (`empty?`, `valid?`)
- Use `!` suffix for dangerous/mutating methods (`save!`, `sort!`)
- Prefer string interpolation over concatenation: `"Hello, #{name}"`
- Use symbols for hash keys: `{ name: "Alice" }` not `{ "name" => "Alice" }`

#### Ruby Idioms
- Use `each`, `map`, `select`, `reject` instead of `for` loops
- Use guard clauses: `return unless valid?` instead of wrapping in `if`
- Use `freeze` on constants: `DEFAULTS = { timeout: 30 }.freeze`
- Prefer `&&` / `||` over `and` / `or` (different precedence)
- Use blocks and yields for flexible interfaces

#### Dependencies
- Always use Bundler, even for small projects
- Run everything through `bundle exec` to use the correct gem versions
- Commit `Gemfile.lock` for applications (not for gems/libraries)
- Use pessimistic version constraints: `gem "rails", "~> 7.1"`

#### Testing
- Write tests first when possible (TDD is deeply embedded in Ruby culture)
- Use `describe` and `context` to organize tests clearly
- One assertion per test (when practical)
- Use factories (factory_bot) over fixtures for test data
- Mock external services, not internal code

#### Error Handling
- Rescue specific exceptions, not `StandardError` broadly
- Use `begin/rescue/ensure` or inline rescue for expected failures
- Raise meaningful custom exceptions for domain errors
- Use `retry` carefully (always with a limit)

### What to Avoid (General Ruby)

- **Monkey-patching core classes** in production code (reopening String, Array, etc.)
- **Deep inheritance hierarchies** - Prefer composition and modules
- **Metaprogramming without necessity** - It makes code hard to trace and debug
- **method_missing without respond_to_missing?** - Always define both together
- **Ignoring return values** - Ruby returns the last expression; be aware of what your methods return
- **Nested ternaries** - Use if/else for readability
- **Global variables** (`$var`) - Use class or module-level configuration instead

---

## Part 2: Rails Workflow

### Project Setup

```bash
# New Rails app with PostgreSQL
rails new myapp --database=postgresql

# API-only app
rails new myapp --api --database=postgresql

# After creation
cd myapp
rails db:create
rails db:migrate
```

#### Rails Project Structure (Key Directories)
```
myapp/
├── app/
│   ├── controllers/
│   ├── models/
│   ├── views/
│   ├── helpers/
│   ├── mailers/
│   ├── jobs/
│   └── services/         # Convention, not generated
├── config/
│   ├── routes.rb
│   ├── database.yml
│   └── environments/
├── db/
│   ├── migrate/
│   ├── schema.rb
│   └── seeds.rb
├── spec/ (or test/)
├── Gemfile
└── .rubocop.yml
```

### Rails Development Cycle

#### 1. Generate Resources

```bash
# Model
rails g model User name:string email:string
rails db:migrate

# Controller
rails g controller Users index show

# Full scaffold (model + controller + views + tests)
rails g scaffold Article title:string body:text published:boolean
rails db:migrate
```

#### 2. Write Code

Follow the MVC pattern:
1. **Model** - Business logic, validations, associations
2. **Controller** - Handle requests, call models, render responses
3. **View** - Display data (or serializer for APIs)

#### 3. Console-Driven Development

```bash
# Rails console for experimenting
rails console

# In console
User.create(name: "Alice", email: "alice@example.com")
User.where(name: "Alice").first
User.count
```

Use the console frequently to test queries, try model methods, and debug.

#### 4. Run Tests

```bash
# RSpec
bundle exec rspec
bundle exec rspec spec/models/
bundle exec rspec spec/controllers/
bundle exec rspec spec/requests/

# Run specific test
bundle exec rspec spec/models/user_spec.rb:25
```

#### 5. Check Routes

```bash
rails routes
rails routes | grep users
```

#### Typical Rails Cycle
```
generate/write migration -> migrate -> write model -> write tests ->
write controller -> write views/serializer -> run tests -> rubocop -> commit
```

### Rails Best Practices

#### Models
- Keep models thin but let them own validations and associations
- Move complex business logic to service objects (`app/services/`)
- Use scopes for reusable queries: `scope :active, -> { where(active: true) }`
- Add database-level constraints (not just Rails validations)
- Use `has_many :through` over `has_and_belongs_to_many`

#### Controllers
- Keep controllers thin - they should coordinate, not compute
- Use `before_action` for shared setup (finding records, authentication)
- Use strong parameters for every create/update action
- Respond with appropriate HTTP status codes
- One resource per controller (RESTful design)

#### Database
- Always write reversible migrations
- Add indexes for foreign keys and frequently queried columns
- Use `rails db:migrate`, never edit `schema.rb` directly
- Seed development data in `db/seeds.rb`
- Use `find_each` for batch processing (not `all.each`)

#### Service Objects
For complex business logic that spans multiple models:

```ruby
# app/services/user_registration.rb
class UserRegistration
  def initialize(params)
    @params = params
  end

  def call
    user = User.create!(@params)
    WelcomeMailer.send_welcome(user).deliver_later
    user
  end
end
```

#### Background Jobs
- Use Active Job with Sidekiq (or Solid Queue in Rails 8+)
- Move slow operations out of the request cycle (emails, API calls, reports)
- Make jobs idempotent (safe to retry)

#### Testing Rails
- Test models for validations, associations, and business logic
- Test requests (integration) over controller tests
- Use `FactoryBot` for test data
- Use `shoulda-matchers` for one-liner validation/association tests
- Test happy paths and key error paths

### What to Avoid (Rails)

- **Fat controllers** - Move logic to models or service objects
- **N+1 queries** - Use `includes`, `preload`, or `eager_load`
- **Callbacks for business logic** - Use service objects instead; callbacks make flow hard to follow
- **Skipping migrations** - Never manually alter the database
- **Default scope** - It causes surprises; use explicit scopes
- **Over-using concerns** - They can become dumping grounds; prefer clear service objects
- **Raw SQL in controllers** - Use ActiveRecord query interface; use raw SQL only when necessary and in models/query objects
- **Putting secrets in code** - Use `rails credentials:edit` or environment variables
- **Ignoring the log** - `tail -f log/development.log` shows SQL queries, errors, and request details

### Rails Debugging

```bash
# View logs
tail -f log/development.log

# Console with context
rails console

# Debug in controller or model
debugger  # Ruby 3.1+
# or
binding.pry  # with pry-byebug gem
```

### Deployment Checklist

1. Run full test suite: `bundle exec rspec`
2. Run linter: `bundle exec rubocop`
3. Check for pending migrations: `rails db:migrate:status`
4. Precompile assets (if not API-only): `rails assets:precompile`
5. Set environment variables in production
6. Review `config/environments/production.rb` settings
