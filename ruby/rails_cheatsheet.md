# Rails Cheatsheet

Quick reference for Ruby on Rails framework.

## Creating a new Rails app

```bash
# New app
rails new myapp

# With PostgreSQL
rails new myapp --database=postgresql

# API only
rails new myapp --api

# Skip test files
rails new myapp --skip-test

# With specific Rails version
rails _7.0.0_ new myapp
```

## Rails CLI commands

```bash
# Start server
rails server
rails s

# Console
rails console
rails c

# Database
rails db:create       # Create database
rails db:migrate      # Run migrations
rails db:rollback     # Undo last migration
rails db:seed         # Run seeds
rails db:reset        # Drop, create, migrate, seed
rails db:drop         # Drop database

# Routes
rails routes          # Show all routes
rails routes | grep user  # Filter routes

# Tests
rails test            # Run all tests
rails test:models     # Run model tests

# Assets
rails assets:precompile   # Compile assets
rails assets:clobber      # Remove compiled assets
```

## Generators

```bash
# Model
rails g model User name:string email:string age:integer

# Controller
rails g controller Users index show new create

# Scaffold (model + controller + views)
rails g scaffold Post title:string body:text

# Migration
rails g migration AddAgeToUsers age:integer
rails g migration CreateProducts name:string price:decimal

# Resource routes
rails g resource Article title:string body:text
```

## MVC Structure

### Models (app/models/)

```ruby
class User < ApplicationRecord
  # Validations
  validates :name, presence: true
  validates :email, uniqueness: true
  
  # Associations
  has_many :posts
  belongs_to :team
  
  # Scopes
  scope :active, -> { where(active: true) }
  
  # Callbacks
  before_save :normalize_email
  after_create :send_welcome_email
  
  private
  
  def normalize_email
    self.email = email.downcase
  end
end
```

### Controllers (app/controllers/)

```ruby
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  # GET /users
  def index
    @users = User.all
  end
  
  # GET /users/1
  def show
  end
  
  # GET /users/new
  def new
    @user = User.new
  end
  
  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: 'User created.'
    else
      render :new
    end
  end
  
  # GET /users/1/edit
  def edit
  end
  
  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User updated.'
    else
      render :edit
    end
  end
  
  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User deleted.'
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:name, :email)
  end
end
```

### Views (app/views/)

```erb
<!-- app/views/users/index.html.erb -->
<h1>Users</h1>

<% @users.each do |user| %>
  <div>
    <%= user.name %>
    <%= link_to 'Show', user %>
    <%= link_to 'Edit', edit_user_path(user) %>
    <%= link_to 'Delete', user, method: :delete, data: { confirm: 'Are you sure?' } %>
  </div>
<% end %>

<%= link_to 'New User', new_user_path %>
```

## Routes (config/routes.rb)

```ruby
Rails.application.routes.draw do
  # Root route
  root 'home#index'
  
  # Resource routes (RESTful)
  resources :users
  
  # Nested resources
  resources :users do
    resources :posts
  end
  
  # Limit resource actions
  resources :photos, only: [:index, :show]
  resources :comments, except: [:destroy]
  
  # Custom routes
  get '/about', to: 'pages#about'
  post '/search', to: 'search#create'
  
  # Member routes (on specific resource)
  resources :posts do
    member do
      post 'publish'
    end
  end
  # Generates: POST /posts/1/publish
  
  # Collection routes (on all resources)
  resources :posts do
    collection do
      get 'archived'
    end
  end
  # Generates: GET /posts/archived
  
  # Namespace
  namespace :admin do
    resources :users
  end
  # Generates: /admin/users
  
  # Concerns (shared routes)
  concern :commentable do
    resources :comments
  end
  
  resources :posts, concerns: :commentable
  resources :videos, concerns: :commentable
end
```

## Migrations

```ruby
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :age
      t.boolean :active, default: true
      t.references :team, foreign_key: true
      
      t.timestamps
    end
    
    add_index :users, :email, unique: true
  end
end

# Column types:
# :string, :text, :integer, :bigint, :float, :decimal
# :boolean, :binary, :date, :datetime, :time
# :json, :jsonb, :uuid, :inet
```

## Validations

```ruby
class User < ApplicationRecord
  validates :name, presence: true
  validates :email, uniqueness: true
  validates :age, numericality: { greater_than: 0 }
  validates :password, length: { minimum: 8 }
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :role, inclusion: { in: %w[admin user guest] }
  validates :terms, acceptance: true
  validates :password, confirmation: true  # Requires password_confirmation field
  
  # Custom validation
  validate :email_must_be_company_email
  
  private
  
  def email_must_be_company_email
    unless email.ends_with?('@company.com')
      errors.add(:email, 'must be a company email')
    end
  end
end
```

## Helpers

```ruby
# app/helpers/application_helper.rb
module ApplicationHelper
  def format_date(date)
    date.strftime('%B %d, %Y')
  end
  
  def avatar_for(user, size: 50)
    image_tag "https://via.placeholder.com/#{size}", alt: user.name
  end
end

# Use in views
<%= format_date(@post.created_at) %>
<%= avatar_for(@user, size: 100) %>
```

## Partials

```erb
<!-- app/views/users/_user.html.erb -->
<div class="user">
  <h3><%= user.name %></h3>
  <p><%= user.email %></p>
</div>

<!-- Render in view -->
<%= render @user %>
<%= render partial: 'user', locals: { user: @user } %>
<%= render partial: 'user', collection: @users %>
```

## Forms

```erb
<!-- Form with form_with -->
<%= form_with model: @user do |f| %>
  <% if @user.errors.any? %>
    <div class="errors">
      <ul>
        <% @user.errors.full_messages.each do |msg| %>
          <li><%= msg %></li>
        <% end %>
      </ul>
    </div>
  <% end %>
  
  <%= f.label :name %>
  <%= f.text_field :name %>
  
  <%= f.label :email %>
  <%= f.email_field :email %>
  
  <%= f.label :age %>
  <%= f.number_field :age %>
  
  <%= f.label :bio %>
  <%= f.text_area :bio %>
  
  <%= f.label :role %>
  <%= f.select :role, ['admin', 'user', 'guest'] %>
  
  <%= f.label :active %>
  <%= f.check_box :active %>
  
  <%= f.submit %>
<% end %>
```

## Flash messages

```ruby
# In controller
redirect_to @user, notice: 'User created successfully'
redirect_to @user, alert: 'Something went wrong'
flash[:info] = 'FYI'

# In view
<% flash.each do |type, message| %>
  <div class="alert alert-<%= type %>">
    <%= message %>
  </div>
<% end %>
```

## Sessions and cookies

```ruby
# Sessions
session[:user_id] = user.id
current_user_id = session[:user_id]
session.delete(:user_id)

# Cookies
cookies[:user_preferences] = { theme: 'dark' }.to_json
preferences = JSON.parse(cookies[:user_preferences])
cookies.delete(:user_preferences)

# Encrypted cookies
cookies.encrypted[:secret] = 'sensitive data'

# Signed cookies (tamper-proof)
cookies.signed[:user_id] = user.id
```

## Callbacks

```ruby
class User < ApplicationRecord
  # Before
  before_validation :normalize_email
  before_save :encrypt_password
  before_create :generate_token
  before_update :log_changes
  before_destroy :cleanup
  
  # After
  after_validation :send_errors
  after_save :update_cache
  after_create :send_welcome_email
  after_update :notify_admin
  after_destroy :cleanup_files
  
  # Around
  around_save :benchmark_save
  
  private
  
  def benchmark_save
    start = Time.now
    yield
    duration = Time.now - start
    Rails.logger.info "Save took #{duration}s"
  end
end
```

## Mailers

```ruby
# Generate mailer
rails g mailer User welcome

# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
  def welcome(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome!')
  end
end

# app/views/user_mailer/welcome.html.erb
<h1>Welcome, <%= @user.name %>!</h1>

# Send email
UserMailer.welcome(@user).deliver_now
UserMailer.welcome(@user).deliver_later  # Background job
```

## Background jobs

```ruby
# Generate job
rails g job ProcessData

# app/jobs/process_data_job.rb
class ProcessDataJob < ApplicationJob
  queue_as :default
  
  def perform(data)
    # Process data
  end
end

# Enqueue job
ProcessDataJob.perform_later(data)
ProcessDataJob.set(wait: 1.hour).perform_later(data)
```

## Concerns

```ruby
# app/models/concerns/searchable.rb
module Searchable
  extend ActiveSupport::Concern
  
  included do
    scope :search, ->(query) { where('name LIKE ?', "%#{query}%") }
  end
  
  class_methods do
    def searchable_fields
      [:name, :email]
    end
  end
end

# Use in model
class User < ApplicationRecord
  include Searchable
end
```

## Asset Pipeline

```ruby
# app/assets/stylesheets/application.css
/*
 *= require_tree .
 *= require_self
 */

# app/assets/javascripts/application.js
//= require rails-ujs
//= require turbolinks
//= require_tree .

# In views
<%= stylesheet_link_tag 'application' %>
<%= javascript_include_tag 'application' %>
<%= image_tag 'logo.png' %>
```

## Environment configuration

```ruby
# config/environments/development.rb
config.cache_classes = false
config.eager_load = false
config.consider_all_requests_local = true

# config/environments/production.rb
config.cache_classes = true
config.eager_load = true
config.consider_all_requests_local = false
```

## Credentials

```bash
# Edit credentials
rails credentials:edit

# Access in code
Rails.application.credentials.secret_key_base
Rails.application.credentials.aws[:access_key_id]
```

## Common gems

```ruby
# Gemfile
gem 'devise'           # Authentication
gem 'pundit'           # Authorization
gem 'kaminari'         # Pagination
gem 'ransack'          # Search
gem 'carrierwave'      # File uploads
gem 'sidekiq'          # Background jobs
gem 'puma'             # Web server
gem 'pg'               # PostgreSQL
gem 'redis'            # Redis
gem 'jbuilder'         # JSON builder
```

## Testing (RSpec)

```ruby
# spec/models/user_spec.rb
RSpec.describe User, type: :model do
  it { should validate_presence_of(:name) }
  it { should have_many(:posts) }
end

# spec/controllers/users_controller_spec.rb
RSpec.describe UsersController, type: :controller do
  describe 'GET #index' do
    it 'returns success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
```

## API mode

```ruby
# Generate API-only app
rails new myapi --api

# Controller
class Api::V1::UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users
  end
  
  def show
    @user = User.find(params[:id])
    render json: @user
  end
end

# Routes
namespace :api do
  namespace :v1 do
    resources :users
  end
end
```
