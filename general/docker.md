# Docker and Containers

## What is Docker?

Platform for running applications in isolated containers.

```
Container = Lightweight VM
Includes app + dependencies
Runs anywhere (dev, prod, cloud)
```

## Basic Commands

```bash
# Pull image
docker pull python:3.9

# List images
docker images

# Run container
docker run python:3.9

# Run interactively
docker run -it python:3.9 bash

# Run in background
docker run -d nginx

# List running containers
docker ps

# List all containers
docker ps -a

# Stop container
docker stop container_id

# Remove container
docker rm container_id

# Remove image
docker rmi image_name
```

## Dockerfile

```dockerfile
# Use base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy files
COPY requirements.txt .

# Install dependencies
RUN pip install -r requirements.txt

# Copy application
COPY . .

# Expose port
EXPOSE 5000

# Run application
CMD ["python", "app.py"]
```

## Build Image

```bash
# Build
docker build -t myapp:latest .

# Build with different Dockerfile
docker build -t myapp -f Dockerfile.prod .

# Build with args
docker build --build-arg VERSION=1.0 -t myapp .
```

## Run Container

```bash
# Basic
docker run myapp

# With port mapping
docker run -p 5000:5000 myapp

# With environment variables
docker run -e DATABASE_URL=postgres://... myapp

# With volume
docker run -v $(pwd):/app myapp

# With name
docker run --name my-container myapp

# Detached mode
docker run -d -p 5000:5000 myapp
```

## Docker Compose

```yaml
# docker-compose.yml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "5000:5000"
    environment:
      - DATABASE_URL=postgresql://db/mydb
    depends_on:
      - db

  db:
    image: postgres:13
    environment:
      - POSTGRES_DB=mydb
      - POSTGRES_PASSWORD=secret
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

### Commands

```bash
# Start services
docker-compose up

# Start in background
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs

# Rebuild
docker-compose build

# Execute command
docker-compose exec web python manage.py migrate
```

## Volumes

```bash
# Named volume
docker run -v mydata:/app/data myapp

# Bind mount
docker run -v $(pwd):/app myapp

# List volumes
docker volume ls

# Remove volume
docker volume rm mydata
```

## Networks

```bash
# Create network
docker network create mynetwork

# Run container on network
docker run --network mynetwork myapp

# List networks
docker network ls
```

## Multi-Stage Build

```dockerfile
# Build stage
FROM python:3.9 AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --user -r requirements.txt

# Final stage
FROM python:3.9-slim
WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY . .
CMD ["python", "app.py"]
```

## Best Practices

```dockerfile
# 1. Use specific versions
FROM python:3.9.10-slim

# 2. Minimize layers
RUN apt-get update && apt-get install -y \
    package1 \
    package2 \
    && rm -rf /var/lib/apt/lists/*

# 3. Order matters (cache)
# Copy requirements first
COPY requirements.txt .
RUN pip install -r requirements.txt
# Then copy code (changes more often)
COPY . .

# 4. Use .dockerignore
# .dockerignore:
# __pycache__
# *.pyc
# .git
# .env

# 5. Run as non-root user
RUN useradd -m myuser
USER myuser

# 6. Use COPY not ADD
COPY . .

# 7. Minimize image size
# Use alpine or slim images
FROM python:3.9-alpine
```

## Environment Variables

```bash
# Pass at runtime
docker run -e API_KEY=secret myapp

# Use .env file
docker run --env-file .env myapp

# In Dockerfile
ENV APP_ENV=production
```

## Health Checks

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:5000/health || exit 1
```

## Logs

```bash
# View logs
docker logs container_id

# Follow logs
docker logs -f container_id

# Last N lines
docker logs --tail 100 container_id
```

## Execute Commands

```bash
# Run command in running container
docker exec container_id ls /app

# Interactive shell
docker exec -it container_id bash

# As different user
docker exec -u root container_id apt-get update
```

## Copy Files

```bash
# From container to host
docker cp container_id:/app/file.txt ./file.txt

# From host to container
docker cp ./file.txt container_id:/app/file.txt
```

## Inspect

```bash
# Container details
docker inspect container_id

# Image details
docker inspect image_name

# Network details
docker network inspect mynetwork
```

## Clean Up

```bash
# Remove stopped containers
docker container prune

# Remove unused images
docker image prune

# Remove everything unused
docker system prune

# With volumes
docker system prune --volumes

# Force
docker system prune -a -f
```

## Registry

```bash
# Login
docker login

# Tag image
docker tag myapp:latest username/myapp:latest

# Push to Docker Hub
docker push username/myapp:latest

# Pull from registry
docker pull username/myapp:latest
```

## Example: Python App

```dockerfile
FROM python:3.9-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app
COPY . .

# Non-root user
RUN useradd -m appuser
USER appuser

EXPOSE 5000

CMD ["python", "app.py"]
```

```yaml
# docker-compose.yml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "5000:5000"
    environment:
      - FLASK_ENV=development
    volumes:
      - .:/app
    command: flask run --host=0.0.0.0
```

```bash
# Run
docker-compose up
```
