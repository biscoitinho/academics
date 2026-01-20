# CI/CD (Continuous Integration/Continuous Deployment)

## What is CI/CD?

**CI (Continuous Integration):** Automatically test code when pushed
**CD (Continuous Deployment):** Automatically deploy after tests pass

```
Code Push → Build → Test → Deploy
```

## CI Pipeline

```
1. Developer pushes code
2. CI server detects changes
3. Run tests
4. Build application
5. Report results
```

## GitHub Actions

### Basic Workflow

```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2

      - name: Set up Python
        uses: actions/setup-python@v2
        with:
          python-version: '3.9'

      - name: Install dependencies
        run: |
          pip install -r requirements.txt

      - name: Run tests
        run: |
          pytest

      - name: Lint
        run: |
          flake8 .
```

### Matrix Build

```yaml
jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
        python-version: ['3.8', '3.9', '3.10']

    steps:
      - uses: actions/checkout@v2
      - name: Set up Python ${{ matrix.python-version }}
        uses: actions/setup-python@v2
        with:
          python-version: ${{ matrix.python-version }}
      - run: pytest
```

### Deploy

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'

    steps:
      - uses: actions/checkout@v2

      - name: Deploy to production
        run: |
          ./deploy.sh
        env:
          API_KEY: ${{ secrets.API_KEY }}
```

## GitLab CI

```yaml
# .gitlab-ci.yml
stages:
  - test
  - build
  - deploy

test:
  stage: test
  image: python:3.9
  script:
    - pip install -r requirements.txt
    - pytest
  only:
    - branches

build:
  stage: build
  script:
    - docker build -t myapp:latest .
  only:
    - main

deploy:
  stage: deploy
  script:
    - kubectl apply -f k8s/
  only:
    - main
  when: manual
```

## Travis CI

```yaml
# .travis.yml
language: python
python:
  - "3.8"
  - "3.9"

install:
  - pip install -r requirements.txt

script:
  - pytest
  - flake8

deploy:
  provider: heroku
  api_key: $HEROKU_API_KEY
  app: my-app
  on:
    branch: main
```

## Jenkins

```groovy
// Jenkinsfile
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'pip install -r requirements.txt'
            }
        }

        stage('Test') {
            steps {
                sh 'pytest'
            }
        }

        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                sh './deploy.sh'
            }
        }
    }

    post {
        failure {
            mail to: 'team@example.com',
                 subject: "Build failed: ${env.JOB_NAME}",
                 body: "Build ${env.BUILD_NUMBER} failed"
        }
    }
}
```

## CircleCI

```yaml
# .circleci/config.yml
version: 2.1

jobs:
  test:
    docker:
      - image: python:3.9
    steps:
      - checkout
      - run:
          name: Install dependencies
          command: pip install -r requirements.txt
      - run:
          name: Run tests
          command: pytest

  deploy:
    docker:
      - image: python:3.9
    steps:
      - checkout
      - run:
          name: Deploy
          command: ./deploy.sh

workflows:
  version: 2
  test-and-deploy:
    jobs:
      - test
      - deploy:
          requires:
            - test
          filters:
            branches:
              only: main
```

## Common Tasks

### Run Tests

```yaml
- name: Run tests
  run: pytest --cov=myapp tests/
```

### Linting

```yaml
- name: Lint
  run: |
    flake8 .
    pylint myapp/
```

### Build Docker

```yaml
- name: Build Docker image
  run: docker build -t myapp:${{ github.sha }} .

- name: Push to registry
  run: docker push myapp:${{ github.sha }}
```

### Deploy

```yaml
- name: Deploy to Heroku
  uses: akhileshns/heroku-deploy@v3.12.12
  with:
    heroku_api_key: ${{ secrets.HEROKU_API_KEY }}
    heroku_app_name: "my-app"
```

## Secrets Management

```yaml
# Store secrets in CI settings, not in code

jobs:
  deploy:
    steps:
      - name: Deploy
        env:
          API_KEY: ${{ secrets.API_KEY }}
          DATABASE_URL: ${{ secrets.DATABASE_URL }}
        run: ./deploy.sh
```

## Caching

```yaml
# GitHub Actions
- name: Cache dependencies
  uses: actions/cache@v2
  with:
    path: ~/.cache/pip
    key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}

- name: Install dependencies
  run: pip install -r requirements.txt
```

## Artifacts

```yaml
# Save build artifacts
- name: Upload artifact
  uses: actions/upload-artifact@v2
  with:
    name: dist
    path: dist/

# Download in another job
- name: Download artifact
  uses: actions/download-artifact@v2
  with:
    name: dist
```

## Notifications

```yaml
# Slack notification
- name: Notify Slack
  if: always()
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

## Best Practices

```yaml
# 1. Fast feedback
# Run quick tests first

# 2. Fail fast
# Stop pipeline on first failure

# 3. Parallel jobs
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - run: flake8

  test:
    runs-on: ubuntu-latest
    steps:
      - run: pytest

# 4. Keep builds fast
# Use caching
# Optimize Docker layers

# 5. Deploy on success only
if: github.ref == 'refs/heads/main' && success()

# 6. Use environment-specific configs
# Dev, staging, production

# 7. Monitor pipelines
# Set up alerts for failures
```

## Deployment Strategies

### Blue-Green

```
Blue (current) → Testing
Green (new) → Deploy
Switch traffic: Blue → Green
```

### Canary

```
90% traffic → Old version
10% traffic → New version
Monitor, then gradually increase
```

### Rolling

```
Update servers one by one
1. Update server 1
2. Test server 1
3. Update server 2
4. Continue...
```

## Example: Full Pipeline

```yaml
name: CI/CD

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-python@v2
      - run: pip install flake8
      - run: flake8 .

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-python@v2
      - run: pip install -r requirements.txt
      - run: pytest --cov=myapp

  build:
    needs: [lint, test]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - run: docker build -t myapp:latest .

  deploy-staging:
    needs: build
    if: github.ref == 'refs/heads/develop'
    runs-on: ubuntu-latest
    steps:
      - run: ./deploy.sh staging

  deploy-production:
    needs: build
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment: production
    steps:
      - run: ./deploy.sh production
```
