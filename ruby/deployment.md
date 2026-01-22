# Ruby Deployment Guide

Modern approaches to deploying Ruby applications (Sinatra and Rails).

## TL;DR - Complexity Comparison

**Sinatra**: Same difficulty as Flask/Django - straightforward
**Rails**: More complex than Python frameworks - but much better than it used to be

## Sinatra Deployment (Simple)

Sinatra deploys like Flask - no special tools needed.

### Basic Sinatra Setup

```ruby
# app.rb
require 'sinatra'

get '/' do
  'Hello World'
end
```

```ruby
# config.ru (for production servers)
require './app'
run Sinatra::Application
```

### Deploy to VPS (Manual - Like Flask)

```bash
# On server
git clone your-repo
cd your-repo

# Install dependencies
bundle install --deployment --without development test

# Run with Puma (production server)
bundle exec puma -C config/puma.rb -d

# Or use systemd service (recommended)
sudo systemctl start sinatra-app
```

### Puma Configuration

```ruby
# config/puma.rb
workers 2
threads 1, 6

bind 'tcp://0.0.0.0:9292'
pidfile 'tmp/pids/puma.pid'
state_path 'tmp/pids/puma.state'

preload_app!
```

### Systemd Service

```ini
# /etc/systemd/system/sinatra-app.service
[Unit]
Description=Sinatra App
After=network.target

[Service]
Type=simple
User=deploy
WorkingDirectory=/home/deploy/app
ExecStart=/home/deploy/.rbenv/shims/bundle exec puma -C config/puma.rb
Restart=always

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl enable sinatra-app
sudo systemctl start sinatra-app
```

**That's it!** Same simplicity as Flask.

## Rails Deployment (More Complex)

Rails needs extra steps due to asset pipeline and migrations.

### What Makes Rails More Complex

1. **Asset compilation** - CSS/JS must be precompiled
2. **Database migrations** - Must run on each deploy
3. **Environment config** - Secrets, credentials
4. **Background jobs** - Often needed (Sidekiq)
5. **Caching** - Redis/Memcached setup

### Traditional Manual Rails Deploy

```bash
# Pull code
git pull origin main

# Install gems
bundle install --deployment --without development test

# Precompile assets (Rails-specific!)
RAILS_ENV=production bundle exec rails assets:precompile

# Run migrations
RAILS_ENV=production bundle exec rails db:migrate

# Restart server
sudo systemctl restart rails-app
```

**Problem**: Lots of steps, error-prone, downtime during deploy.

## Modern Approach 1: Kamal (Recommended)

**Kamal** - Official Rails deployment tool (2023+), replaces Capistrano.

### What is Kamal?

- Created by Rails creator (DHH)
- Uses Docker under the hood
- Zero-downtime deployments
- Deploy to any VPS
- Much simpler than Capistrano

### Kamal Setup

```bash
# Add to Gemfile
gem 'kamal'

# Generate config
bundle exec kamal init
```

### Kamal Configuration

```yaml
# config/deploy.yml
service: myapp
image: username/myapp

servers:
  web:
    - 192.168.1.1
    - 192.168.1.2

registry:
  username: your-username
  password:
    - KAMAL_REGISTRY_PASSWORD

env:
  secret:
    - RAILS_MASTER_KEY

accessories:
  db:
    image: postgres:15
    host: 192.168.1.3
    port: 5432
    env:
      secret:
        - POSTGRES_PASSWORD
```

### Deploy with Kamal

```bash
# First time setup
kamal setup

# Every deploy after
kamal deploy

# Other commands
kamal app logs      # View logs
kamal app exec 'rails console'  # Run console
kamal rollback      # Rollback deploy
```

**That's it!** One command deployment.

### Kamal vs Capistrano

| Feature | Capistrano (Old) | Kamal (New) |
|---------|------------------|-------------|
| Complexity | ⭐⭐⭐⭐ Very hard | ⭐⭐ Medium |
| Setup time | Hours | Minutes |
| Docker-based | No | Yes |
| Zero-downtime | Complex | Built-in |
| Multi-server | Complex config | Simple config |

## Modern Approach 2: Docker (DIY)

Rails 7.1+ includes Dockerfile generation.

### Generate Dockerfile

```bash
# New Rails app - Dockerfile included automatically
rails new myapp

# Existing app - generate Dockerfile
rails generate dockerfile
```

### Generated Dockerfile (Simplified)

```dockerfile
FROM ruby:3.2-slim

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy app
COPY . .

# Precompile assets
RUN bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
```

### Build and Deploy

```bash
# Build image
docker build -t myapp .

# Run container
docker run -p 3000:3000 \
  -e DATABASE_URL=postgres://... \
  -e RAILS_MASTER_KEY=... \
  myapp

# Or use docker-compose
docker-compose up -d
```

### Docker Compose

```yaml
# docker-compose.yml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgresql://db/myapp_production
      - RAILS_MASTER_KEY=${RAILS_MASTER_KEY}
    depends_on:
      - db
      - redis

  db:
    image: postgres:15
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      - POSTGRES_PASSWORD=secret

  redis:
    image: redis:7

volumes:
  postgres_data:
```

```bash
docker-compose up -d
```

## Modern Approach 3: Platform-as-a-Service (Easiest)

Zero-config deployments - just git push.

### Fly.io (Popular Choice)

```bash
# Install flyctl
curl -L https://fly.io/install.sh | sh

# Login
fly auth login

# Launch app (auto-detects Rails)
fly launch

# Deploy
fly deploy

# Run migrations
fly ssh console "rails db:migrate"

# View logs
fly logs
```

**Pros**: Simple, free tier, automatic SSL, auto-scaling
**Cons**: Costs money at scale

### Heroku (Classic PaaS)

```bash
# Install Heroku CLI
brew install heroku/brew/heroku

# Login
heroku login

# Create app
heroku create myapp

# Deploy
git push heroku main

# Migrations run automatically (if configured)
# Or manually:
heroku run rails db:migrate

# View logs
heroku logs --tail
```

**Pros**: Dead simple, lots of addons
**Cons**: Expensive, less popular than before

### Render (Heroku Alternative)

- Connect GitHub repo via web UI
- Auto-detects Rails
- Auto-deploys on git push
- Free tier available
- Automatic SSL

**Steps**:
1. Connect repo on render.com
2. Click "New Web Service"
3. Select repo
4. Done - auto-deploys

### Railway (Newer Option)

```bash
# Install Railway CLI
npm i -g @railway/cli

# Login
railway login

# Initialize
railway init

# Deploy
railway up
```

## Comparison: Rails vs Python Deployment

### Flask/Django Manual Deploy

```bash
git pull
pip install -r requirements.txt
python manage.py migrate  # Django only
gunicorn app:app  # or systemctl restart
```

**Steps**: 3-4 commands

### Sinatra Manual Deploy

```bash
git pull
bundle install
systemctl restart sinatra-app
```

**Steps**: 3 commands - **Same complexity as Python**

### Rails Manual Deploy

```bash
git pull
bundle install
rails assets:precompile  # Extra!
rails db:migrate
systemctl restart rails-app
```

**Steps**: 5 commands - **More complex than Python**

### With Modern Tools

**Python (Docker)**:
```bash
docker-compose up -d
```

**Rails (Kamal)**:
```bash
kamal deploy
```

**Rails (Fly.io/Heroku)**:
```bash
fly deploy
# or
git push heroku main
```

**Conclusion**: With modern tools, complexity is similar.

## Nginx Setup (For VPS Deployments)

Same for both Sinatra and Rails.

```nginx
# /etc/nginx/sites-available/myapp
upstream app {
  server 127.0.0.1:3000;
}

server {
  listen 80;
  server_name myapp.com;

  root /home/deploy/app/public;

  location / {
    proxy_pass http://app;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  }

  # Rails: Serve static assets directly
  location ~ ^/(assets|packs)/ {
    gzip_static on;
    expires max;
    add_header Cache-Control public;
  }
}
```

```bash
sudo ln -s /etc/nginx/sites-available/myapp /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

## Environment Variables

### Rails Credentials (Modern Way)

```bash
# Edit credentials
EDITOR=vim rails credentials:edit

# Generates config/credentials.yml.enc (encrypted)
# And config/master.key (keep secret!)
```

```yaml
# config/credentials.yml.enc (encrypted)
secret_key_base: abc123...
database:
  password: secret
aws:
  access_key_id: YOUR_KEY
```

```ruby
# Access in code
Rails.application.credentials.aws[:access_key_id]
```

### Using ENV Variables (Alternative)

```ruby
# config/database.yml
production:
  url: <%= ENV['DATABASE_URL'] %>

# config/puma.rb
workers ENV.fetch('WEB_CONCURRENCY', 2)
```

```bash
# .env file (use dotenv gem)
DATABASE_URL=postgresql://localhost/myapp_production
REDIS_URL=redis://localhost:6379
RAILS_MASTER_KEY=abc123...
```

## Background Jobs (Rails)

Most Rails apps need background workers.

### Sidekiq Setup

```ruby
# Gemfile
gem 'sidekiq'
gem 'redis'
```

```ruby
# app/jobs/example_job.rb
class ExampleJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do work
  end
end
```

### Deploy with Sidekiq

```bash
# Systemd service
[Service]
ExecStart=/home/deploy/.rbenv/shims/bundle exec sidekiq -C config/sidekiq.yml
```

Or with Docker/Kamal, add as separate service.

## Deployment Checklist

### Before First Deploy

- [ ] Set up production database
- [ ] Configure environment variables
- [ ] Set up Redis (if using Sidekiq/caching)
- [ ] Generate master.key or set RAILS_MASTER_KEY
- [ ] Configure mail service (SendGrid, etc.)
- [ ] Set up CDN for assets (optional)

### Every Deploy

- [ ] Run tests locally
- [ ] Commit and push code
- [ ] Deploy (method depends on approach)
- [ ] Run migrations (if any)
- [ ] Check logs for errors
- [ ] Smoke test production

## Common Issues

### Asset Precompilation Fails

```bash
# Clear tmp and retry
rails tmp:clear
rails assets:clobber
rails assets:precompile
```

### Bundle Install Errors

```bash
# Native gem compilation fails
sudo apt-get install build-essential libpq-dev nodejs

# Or use bundler platform
bundle lock --add-platform x86_64-linux
```

### Database Migration Fails

```bash
# Check database connection
rails db:version

# Rollback if needed
rails db:rollback

# Reset (CAUTION - destroys data!)
rails db:reset  # Only in development!
```

### Memory Issues

```ruby
# Reduce Puma workers/threads
# config/puma.rb
workers 1  # Instead of 2
threads 1, 3  # Instead of 1, 6
```

## Recommendations by Use Case

### Personal Project / Learning
**Use**: Fly.io or Render
- Free tier
- Zero config
- Learn deployment basics

### Small Production App
**Sinatra**: Manual VPS with systemd
**Rails**: Kamal + VPS

### Scaling Production App
**Use**: Kamal with multiple servers
- Or managed platform (Heroku, AWS)
- Add load balancer
- Multiple web servers
- Separate database server

### Enterprise
**Use**: Kubernetes (complex)
- Or AWS/GCP managed services
- Consider hiring DevOps

## Modern vs Old Ruby Deployment

### Old Way (2010-2015)
- Capistrano (very complex)
- Manual asset compilation
- Complex Nginx configs
- RVM/rbenv version conflicts
- Painful debugging

### New Way (2024+)
- Kamal (simple)
- Docker (standardized)
- PaaS (zero config)
- Better tooling
- Much improved experience

**Verdict**: Rails deployment used to be painful. Now it's manageable, especially with Kamal or PaaS platforms.

## Key Takeaways

1. **Sinatra = Flask** - Same deployment simplicity
2. **Rails is more complex** - But much better than before
3. **Use Kamal for VPS** - Modern, official, simple
4. **Use PaaS for simplicity** - Fly.io, Render, Railway
5. **Docker is standard** - Rails 7.1+ includes it
6. **Capistrano is dying** - Don't learn it for new projects
7. **Environment management matters** - Use Rails credentials or ENV vars
8. **Background jobs need setup** - Plan for Sidekiq

**Bottom Line**: Ruby deployment isn't as painful as it used to be, but Rails is still more work than Flask/Django. Kamal and modern PaaS options have made it much better!
