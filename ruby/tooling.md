# Ruby Tooling

Recommended tools for working with Ruby.

## Version Management

### rbenv
Lightweight Ruby version manager. Preferred by many for its simplicity.

```bash
# Install a Ruby version
rbenv install 3.3.0

# Set global version
rbenv global 3.3.0

# Set local version (per project, creates .ruby-version file)
rbenv local 3.2.2

# List installed versions
rbenv versions

# List available versions
rbenv install -l
```

Uses shims to intercept Ruby commands and redirect to the correct version.

### rvm (Ruby Version Manager)
Full-featured version manager. Manages rubies and gemsets.

```bash
# Install a Ruby version
rvm install 3.3.0

# Switch version
rvm use 3.3.0

# Create a gemset (isolated gem environment)
rvm gemset create myproject
rvm use 3.3.0@myproject
```

**rbenv vs rvm**: rbenv is simpler and less invasive (doesn't modify shell functions). rvm has more features (gemsets) but is heavier. Most modern projects use rbenv with Bundler instead of rvm gemsets.

### asdf
Universal version manager that supports Ruby and many other languages.

```bash
asdf plugin add ruby
asdf install ruby 3.3.0
asdf local ruby 3.3.0
```

## Dependency Management

### Bundler
The standard dependency manager for Ruby. Every Ruby project should use it.

```bash
# Initialize (creates Gemfile)
bundle init

# Install dependencies
bundle install

# Add a gem
bundle add rails

# Update a specific gem
bundle update nokogiri

# Update all gems
bundle update

# Run a command in bundle context
bundle exec rake test
bundle exec rails server

# Show where a gem is installed
bundle info rails
```

**Gemfile** specifies dependencies:
```ruby
source "https://rubygems.org"

gem "rails", "~> 7.1"
gem "pg", "~> 1.5"

group :development, :test do
  gem "rspec-rails"
  gem "pry"
end

group :development do
  gem "rubocop", require: false
end
```

**Gemfile.lock** locks exact versions for reproducible installs. Always commit it.

### gem
Ruby's built-in package manager. Bundler wraps around it.

```bash
# Install a gem globally
gem install rails

# List installed gems
gem list

# Search for gems
gem search nokogiri

# Gem info
gem info rails
```

## Linting and Formatting

### RuboCop
The standard Ruby linter and formatter. Enforces the community Ruby style guide.

```bash
gem install rubocop

# Lint
rubocop

# Auto-correct safe issues
rubocop -a

# Auto-correct all (including unsafe)
rubocop -A

# Check specific files
rubocop app/models/user.rb
```

Configuration in `.rubocop.yml`:
```yaml
AllCops:
  TargetRubyVersion: 3.3
  NewCops: enable
  Exclude:
    - "db/schema.rb"
    - "bin/*"
    - "vendor/**/*"

Style/StringLiterals:
  EnforcedStyle: double_quotes

Metrics/MethodLength:
  Max: 15
```

Extensions:
- `rubocop-rails` - Rails-specific cops
- `rubocop-rspec` - RSpec-specific cops
- `rubocop-performance` - Performance-focused cops
- `rubocop-minitest` - Minitest-specific cops

### Standard
RuboCop with a fixed, non-configurable ruleset. Zero configuration.

```bash
gem install standardrb

# Lint
standardrb

# Auto-fix
standardrb --fix
```

**RuboCop vs Standard**: Use RuboCop if you want full control. Use Standard if you want zero configuration debates.

## Testing

### RSpec
The most popular Ruby testing framework. Behavior-driven syntax.

```bash
gem install rspec

# Initialize in project
rspec --init

# Run all tests
rspec

# Run specific file
rspec spec/models/user_spec.rb

# Run specific test by line number
rspec spec/models/user_spec.rb:15

# Run with documentation format
rspec --format documentation
```

Example:
```ruby
RSpec.describe User do
  describe "#full_name" do
    it "returns first and last name combined" do
      user = User.new(first: "John", last: "Doe")
      expect(user.full_name).to eq("John Doe")
    end
  end
end
```

Key libraries with RSpec:
- `factory_bot` - Test data factories
- `faker` - Generate fake data
- `shoulda-matchers` - One-liner tests for common Rails patterns
- `webmock` - Stub HTTP requests
- `vcr` - Record and replay HTTP interactions

### Minitest
Built-in testing framework. Simpler and faster than RSpec.

```bash
# Run tests
ruby -Itest test/models/user_test.rb

# With Rake
rake test
```

Example:
```ruby
class UserTest < Minitest::Test
  def test_full_name
    user = User.new(first: "John", last: "Doe")
    assert_equal "John Doe", user.full_name
  end
end
```

### SimpleCov
Code coverage for Ruby.

```ruby
# In spec_helper.rb or test_helper.rb
require "simplecov"
SimpleCov.start
```

## Debugging

### debug (Built-in, Ruby 3.1+)
Ruby's built-in debugger. Modern and feature-rich.

```ruby
# Insert breakpoint
binding.break
# or
debugger
```

```bash
# Run script with debugger
rdbg script.rb

# Attach to running process
rdbg --attach
```

### pry
Interactive Ruby shell and runtime debugger. Powerful REPL with syntax highlighting.

```bash
gem install pry
```

```ruby
# Insert breakpoint
require "pry"; binding.pry
```

Useful pry commands: `ls` (list methods), `cd` (navigate objects), `show-method`, `edit`, `whereami`.

### pry-byebug
Adds step debugging to pry.

```ruby
# In Gemfile
gem "pry-byebug", group: [:development, :test]
```

Commands: `next`, `step`, `continue`, `finish`, `break`.

### byebug
Standalone step debugger (Ruby < 3.1).

```ruby
require "byebug"; byebug
```

## Build and Task Automation

### Rake
Ruby's build tool (like Make). Standard for task automation.

```ruby
# Rakefile
task :greet do
  puts "Hello!"
end

task default: :greet

namespace :db do
  task :seed do
    # Seed the database
  end
end
```

```bash
# Run task
rake greet
rake db:seed

# List available tasks
rake -T
```

### Thor
Framework for building command-line tools.

## IRB (Interactive Ruby)

Built-in REPL for experimenting with Ruby code.

```bash
irb

# With a specific version
irb --prompt simple
```

Modern IRB (Ruby 3.0+) includes autocomplete and syntax highlighting.

## Recommended Stack

| Purpose | Tool |
|---------|------|
| Version management | rbenv |
| Dependencies | Bundler |
| Linting + formatting | RuboCop (or Standard) |
| Testing | RSpec + factory_bot |
| Code coverage | SimpleCov |
| Debugging | debug (built-in) or pry |
| Task automation | Rake |
| REPL | IRB or Pry |
