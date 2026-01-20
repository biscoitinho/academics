# Software Architecture Patterns

## Monolithic Architecture

Single unified application.

```
All code in one codebase
Single deployment unit
Shared database
Tightly coupled components
```

**Pros:**
- Simple to develop
- Easy to test
- Easy to deploy

**Cons:**
- Hard to scale
- Tight coupling
- Long deployment cycles

**Use when:**
- Small applications
- Starting new project
- Small team

## Microservices

Multiple independent services.

```
Each service: separate codebase
Independent deployment
Own database
Loose coupling
```

**Structure:**
```
User Service → User DB
Order Service → Order DB
Payment Service → Payment DB
API Gateway → Routes requests
```

**Pros:**
- Independent scaling
- Technology flexibility
- Fault isolation

**Cons:**
- Complex infrastructure
- Network latency
- Data consistency challenges

**Use when:**
- Large applications
- Multiple teams
- Different scaling needs

## Layered (N-Tier)

Organized in horizontal layers.

```
Presentation Layer (UI)
      ↓
Business Logic Layer
      ↓
Data Access Layer
      ↓
Database
```

**Example (Python):**
```python
# Presentation (Flask)
@app.route('/users')
def get_users():
    return user_service.get_all()

# Business Logic
class UserService:
    def get_all(self):
        return user_repository.find_all()

# Data Access
class UserRepository:
    def find_all(self):
        return db.query('SELECT * FROM users')
```

**Pros:**
- Separation of concerns
- Easy to understand
- Testable layers

**Cons:**
- Can become complex
- Performance overhead

## MVC (Model-View-Controller)

Separates data, presentation, and control logic.

```
View → Controller → Model
   ←              ←
```

**Python (Flask):**
```python
# Model
class User:
    def __init__(self, name):
        self.name = name

# View (template)
# <h1>Hello {{ user.name }}</h1>

# Controller
@app.route('/user/<id>')
def show_user(id):
    user = User.get(id)
    return render_template('user.html', user=user)
```

**Use in:**
- Web applications
- Desktop GUIs
- Mobile apps

## Event-Driven

Components communicate via events.

```
Service A → Event Bus → Service B
                     → Service C
```

**Example (Python):**
```python
class EventBus:
    def __init__(self):
        self.subscribers = {}

    def subscribe(self, event, handler):
        if event not in self.subscribers:
            self.subscribers[event] = []
        self.subscribers[event].append(handler)

    def publish(self, event, data):
        for handler in self.subscribers.get(event, []):
            handler(data)

# Usage
bus = EventBus()

def on_order_created(data):
    print(f"Send email for order {data['id']}")

def on_order_created_inventory(data):
    print(f"Update inventory for order {data['id']}")

bus.subscribe('order.created', on_order_created)
bus.subscribe('order.created', on_order_created_inventory)

bus.publish('order.created', {'id': 123})
```

**Pros:**
- Loose coupling
- Scalable
- Reactive

**Cons:**
- Harder to debug
- Complex flow
- Event ordering

## CQRS (Command Query Responsibility Segregation)

Separate read and write operations.

```
Commands (Write) → Write Model → Write DB
Queries (Read) → Read Model → Read DB
                      ↑
                 Sync Events
```

**Example:**
```python
# Write side
class CreateUserCommand:
    def execute(self, data):
        user = User(**data)
        db.save(user)
        event_bus.publish('user.created', user)

# Read side
class UserQuery:
    def get_by_id(self, id):
        return read_db.get(id)

    def search(self, query):
        return read_db.search(query)
```

**Use when:**
- Different read/write loads
- Complex queries
- Event sourcing

## Hexagonal (Ports and Adapters)

Business logic independent of external systems.

```
   Adapters (HTTP, DB, etc.)
         ↓
      Ports (Interfaces)
         ↓
   Core Business Logic
```

**Example:**
```python
# Port (interface)
class UserRepository:
    def save(self, user): pass
    def find(self, id): pass

# Core
class UserService:
    def __init__(self, repository):
        self.repository = repository

    def create_user(self, data):
        user = User(**data)
        self.repository.save(user)

# Adapter (PostgreSQL)
class PostgresUserRepository(UserRepository):
    def save(self, user):
        db.execute('INSERT INTO users...', user)

# Adapter (MongoDB)
class MongoUserRepository(UserRepository):
    def save(self, user):
        mongo.insert_one(user)
```

**Pros:**
- Testable
- Technology independent
- Flexible

## Serverless

Functions as a service (FaaS).

```
Event → Function → Response
(No server management)
```

**Example (AWS Lambda):**
```python
def lambda_handler(event, context):
    user_id = event['user_id']
    user = get_user(user_id)
    return {
        'statusCode': 200,
        'body': json.dumps(user)
    }
```

**Pros:**
- No infrastructure management
- Auto-scaling
- Pay per use

**Cons:**
- Cold starts
- Vendor lock-in
- Limited execution time

## API Gateway Pattern

Single entry point for microservices.

```
Client → API Gateway → Service A
                   → Service B
                   → Service C
```

**Responsibilities:**
- Routing
- Authentication
- Rate limiting
- Load balancing

## Service Mesh

Infrastructure layer for service-to-service communication.

```
Service A ← Proxy ↔ Proxy → Service B
```

**Features:**
- Service discovery
- Load balancing
- Encryption
- Observability

**Examples:** Istio, Linkerd

## Repository Pattern

Abstraction over data access.

```python
class Repository:
    def find(self, id): pass
    def find_all(self): pass
    def save(self, entity): pass
    def delete(self, id): pass

class UserRepository(Repository):
    def find_by_email(self, email):
        return db.query('SELECT * FROM users WHERE email = ?', email)
```

## Clean Architecture

Dependency rule: Inner layers don't depend on outer layers.

```
Entities (Core business)
    ↓
Use Cases
    ↓
Interface Adapters (Controllers, Presenters)
    ↓
Frameworks & Drivers (DB, Web, UI)
```

**Pros:**
- Independent of frameworks
- Testable
- Independent of UI/DB

## Comparison

```
Monolith:
✅ Simple, fast development
❌ Hard to scale

Microservices:
✅ Scalable, flexible
❌ Complex, infrastructure overhead

Layered:
✅ Clear separation
❌ Can be rigid

Event-Driven:
✅ Loose coupling
❌ Complex debugging

Serverless:
✅ No infrastructure
❌ Vendor lock-in
```

## Choosing Architecture

```
Small app → Monolith
Growing app → Modular Monolith
Large/complex → Microservices
High read/write → CQRS
Real-time → Event-Driven
Minimal ops → Serverless
```

## Anti-Patterns

```
Big Ball of Mud:
- No clear structure
- Spaghetti code

God Object:
- One class does everything

Tight Coupling:
- Components depend on each other

Premature Optimization:
- Complex before needed
```

## Best Practices

```
1. Start simple (monolith)
2. Evolve as needed
3. Loose coupling
4. High cohesion
5. Single responsibility
6. Don't over-engineer
7. Consider team size
8. Think about deployment
```
