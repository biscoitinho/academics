## ActiveRecord - Rails ORM

ActiveRecord is Rails' Object-Relational Mapping (ORM) system.

### Basics

#### Defining a model

```ruby
class User < ApplicationRecord
  # Automatically maps to 'users' table
end

# Convention: 
# Model: User (singular, CamelCase)
# Table: users (plural, snake_case)
```

#### Creating records

```ruby
# Method 1: new + save
user = User.new(name: "Alice", email: "alice@example.com")
user.save

# Method 2: create (new + save)
user = User.create(name: "Bob", email: "bob@example.com")

# Method 3: create! (raises exception on failure)
user = User.create!(name: "Charlie", email: "charlie@example.com")
```

#### Reading records

```ruby
# Find by ID
user = User.find(1)

# Find by attribute
user = User.find_by(email: "alice@example.com")

# First/last
User.first
User.last

# All records
User.all

# Count
User.count
```

#### Updating records

```ruby
# Method 1: Find, modify, save
user = User.find(1)
user.name = "Alice Smith"
user.save

# Method 2: update
user.update(name: "Alice Smith")

# Method 3: update_attribute (skip validations)
user.update_attribute(:name, "Alice Smith")

# Update multiple at once
User.where(active: false).update_all(deleted: true)
```

#### Deleting records

```ruby
# Find and destroy
user = User.find(1)
user.destroy

# Direct destroy
User.find(1).destroy

# Destroy all matching
User.where(active: false).destroy_all

# Delete (skip callbacks)
User.delete(1)
User.where(active: false).delete_all
```

### Querying

#### Where clauses

```ruby
# Simple where
User.where(active: true)

# Multiple conditions
User.where(active: true, role: 'admin')

# SQL fragments
User.where("age > ?", 21)
User.where("name LIKE ?", "%Smith%")

# Hash conditions
User.where(age: 18..65)
User.where(name: ['Alice', 'Bob', 'Charlie'])

# NOT
User.where.not(role: 'admin')
```

#### Ordering

```ruby
# Ascending
User.order(:name)
User.order(name: :asc)

# Descending
User.order(created_at: :desc)

# Multiple fields
User.order(role: :asc, name: :asc)
```

#### Limit and offset

```ruby
# Limit
User.limit(10)

# Offset (skip first N)
User.offset(20)

# Pagination
User.limit(10).offset(20)  # Page 3 (assuming 10 per page)
```

#### Selecting specific columns

```ruby
# Select columns
User.select(:id, :name, :email)

# Avoid N+1 queries
User.select(:id, :name).where(active: true)
```

#### Distinct

```ruby
User.select(:role).distinct
```

### Associations

#### belongs_to

```ruby
class Post < ApplicationRecord
  belongs_to :user
end

# Usage
post = Post.first
post.user  # Returns the associated user
```

#### has_many

```ruby
class User < ApplicationRecord
  has_many :posts
end

# Usage
user = User.first
user.posts  # Returns all posts for this user
user.posts.create(title: "New Post")
user.posts.count
```

#### has_one

```ruby
class User < ApplicationRecord
  has_one :profile
end

# Usage
user.profile
user.create_profile(bio: "Hello!")
```

#### has_many :through

```ruby
class Student < ApplicationRecord
  has_many :enrollments
  has_many :courses, through: :enrollments
end

class Enrollment < ApplicationRecord
  belongs_to :student
  belongs_to :course
end

class Course < ApplicationRecord
  has_many :enrollments
  has_many :students, through: :enrollments
end

# Usage
student.courses  # All courses for student
course.students  # All students in course
```

#### has_and_belongs_to_many

```ruby
class Student < ApplicationRecord
  has_and_belongs_to_many :courses
end

class Course < ApplicationRecord
  has_and_belongs_to_many :students
end

# Requires join table: courses_students
```

### Validations

```ruby
class User < ApplicationRecord
  # Presence
  validates :name, presence: true
  
  # Uniqueness
  validates :email, uniqueness: true
  
  # Format
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  
  # Length
  validates :password, length: { minimum: 8 }
  validates :name, length: { in: 2..50 }
  
  # Numericality
  validates :age, numericality: { greater_than: 0 }
  
  # Inclusion
  validates :role, inclusion: { in: %w[admin user guest] }
  
  # Custom validation
  validate :email_must_be_company_email
  
  private
  
  def email_must_be_company_email
    unless email.ends_with?('@company.com')
      errors.add(:email, "must be a company email")
    end
  end
end

# Check if valid
user.valid?  # true or false
user.invalid?

# Get errors
user.errors
user.errors.full_messages
```

### Callbacks

```ruby
class User < ApplicationRecord
  # Before callbacks
  before_validation :normalize_email
  before_save :encrypt_password
  before_create :generate_token
  
  # After callbacks
  after_create :send_welcome_email
  after_update :log_changes
  after_destroy :cleanup_data
  
  # Around callbacks
  around_save :log_save_time
  
  private
  
  def normalize_email
    self.email = email.downcase.strip
  end
  
  def send_welcome_email
    UserMailer.welcome(self).deliver_later
  end
  
  def log_save_time
    start_time = Time.now
    yield
    duration = Time.now - start_time
    Rails.logger.info "Save took #{duration} seconds"
  end
end
```

### Scopes

```ruby
class User < ApplicationRecord
  # Simple scope
  scope :active, -> { where(active: true) }
  
  # Scope with arguments
  scope :with_role, ->(role) { where(role: role) }
  
  # Chainable scopes
  scope :recent, -> { where('created_at > ?', 1.week.ago) }
  scope :ordered, -> { order(created_at: :desc) }
  
  # Default scope
  default_scope { where(deleted: false) }
end

# Usage
User.active
User.with_role('admin')
User.active.recent.ordered
```

### Eager loading (N+1 prevention)

```ruby
# Bad - N+1 queries
posts = Post.all
posts.each { |post| puts post.user.name }

# Good - eager load with includes
posts = Post.includes(:user)
posts.each { |post| puts post.user.name }

# Multiple associations
Post.includes(:user, :comments)

# Nested associations
Post.includes(comments: :user)
```

### Joining tables

```ruby
# Inner join
User.joins(:posts)

# Left outer join
User.left_outer_joins(:posts)

# Multiple joins
User.joins(:posts, :comments)

# Join with conditions
User.joins(:posts).where(posts: { published: true })
```

### Aggregations

```ruby
# Count
User.count
User.where(active: true).count

# Average
Order.average(:total)

# Sum
Order.sum(:total)

# Maximum/Minimum
Order.maximum(:total)
Order.minimum(:total)

# Group and count
User.group(:role).count
# { "admin" => 5, "user" => 100 }
```

### Transactions

```ruby
User.transaction do
  user = User.create!(name: "Alice")
  account = Account.create!(user: user, balance: 100)
  # Both succeed or both rollback
end

# Manual rollback
User.transaction do
  user.save!
  raise ActiveRecord::Rollback if some_condition
end
```

### Raw SQL

```ruby
# Execute raw SQL
User.find_by_sql("SELECT * FROM users WHERE age > 21")

# Using connection
ActiveRecord::Base.connection.execute("SELECT * FROM users")

# Sanitize SQL
User.where("name = ?", params[:name])
User.where("name = :name", name: params[:name])
```

### Migrations

```ruby
# Generate migration
rails generate migration AddAgeToUsers age:integer

# Migration file
class AddAgeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :age, :integer
  end
end

# Run migrations
rails db:migrate

# Rollback
rails db:rollback

# Common migration methods
add_column :table, :column, :type
remove_column :table, :column
rename_column :table, :old_name, :new_name
change_column :table, :column, :new_type
add_index :table, :column
remove_index :table, :column
```

### Model methods

```ruby
class User < ApplicationRecord
  # Class methods
  def self.admins
    where(role: 'admin')
  end
  
  # Instance methods
  def full_name
    "#{first_name} #{last_name}"
  end
  
  # Virtual attributes
  def password
    @password
  end
  
  def password=(value)
    @password = value
    self.password_digest = BCrypt::Password.create(value)
  end
end

# Usage
User.admins
user.full_name
```

### Polymorphic associations

```ruby
class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
end

class Post < ApplicationRecord
  has_many :comments, as: :commentable
end

class Video < ApplicationRecord
  has_many :comments, as: :commentable
end

# Usage
post = Post.first
post.comments.create(body: "Great post!")

comment = Comment.first
comment.commentable  # Could be Post or Video
```

### Single Table Inheritance (STI)

```ruby
class Vehicle < ApplicationRecord
  # table: vehicles (has 'type' column)
end

class Car < Vehicle
end

class Motorcycle < Vehicle
end

# All stored in 'vehicles' table with 'type' column
car = Car.create(name: "Tesla")
bike = Motorcycle.create(name: "Harley")
```
