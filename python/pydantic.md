## Pydantic - Data Validation

Pydantic is a data validation library that uses Python type annotations. It's the most widely used data validation library for Python.

### Installation

```bash
pip install pydantic
pip install pydantic[email]  # For email validation
```

### Basic Model

```python
from pydantic import BaseModel

class User(BaseModel):
    id: int
    name: str
    email: str
    is_active: bool = True  # Default value

# Create instance
user = User(id=1, name="John", email="john@example.com")

print(user.id)        # 1
print(user.name)      # John
print(user.is_active) # True

# Convert to dict
print(user.dict())
# {'id': 1, 'name': 'John', 'email': 'john@example.com', 'is_active': True}

# Convert to JSON
print(user.json())
# {"id": 1, "name": "John", "email": "john@example.com", "is_active": true}
```

### Type Validation

```python
from pydantic import BaseModel

class Product(BaseModel):
    name: str
    price: float
    quantity: int
    tags: list[str]

# Automatic type conversion
product = Product(
    name="Laptop",
    price="999.99",      # String converted to float
    quantity="5",        # String converted to int
    tags=["electronics", "computers"]
)

print(product.price)     # 999.99 (float)
print(product.quantity)  # 5 (int)

# Validation error
try:
    Product(name="Phone", price="invalid", quantity=10, tags=[])
except ValueError as e:
    print(e)
    # price: value is not a valid float
```

### Field Validation

```python
from pydantic import BaseModel, Field

class User(BaseModel):
    username: str = Field(..., min_length=3, max_length=50)
    age: int = Field(..., ge=0, le=120)  # ge = greater or equal, le = less or equal
    email: str = Field(..., pattern=r'^[\w\.-]+@[\w\.-]+\.\w+$')
    score: float = Field(default=0.0, ge=0.0, le=100.0)

# Valid
user = User(username="john", age=25, email="john@example.com")

# Invalid - username too short
try:
    User(username="ab", age=25, email="john@example.com")
except ValueError as e:
    print(e)
    # username: ensure this value has at least 3 characters

# Invalid - age too high
try:
    User(username="john", age=150, email="john@example.com")
except ValueError as e:
    print(e)
    # age: ensure this value is less than or equal to 120
```

### Common Validators

```python
from pydantic import BaseModel, EmailStr, HttpUrl, constr, conint

class UserProfile(BaseModel):
    email: EmailStr                      # Valid email
    website: HttpUrl                     # Valid URL
    username: constr(min_length=3)       # Constrained string
    age: conint(ge=18, le=100)          # Constrained int
    bio: str | None = None               # Optional field

user = UserProfile(
    email="user@example.com",
    website="https://example.com",
    username="john_doe",
    age=25
)
```

### Custom Validators

```python
from pydantic import BaseModel, validator

class User(BaseModel):
    username: str
    password: str
    password_confirm: str

    @validator('username')
    def username_alphanumeric(cls, v):
        if not v.isalnum():
            raise ValueError('Username must be alphanumeric')
        return v

    @validator('password')
    def password_strength(cls, v):
        if len(v) < 8:
            raise ValueError('Password must be at least 8 characters')
        if not any(c.isupper() for c in v):
            raise ValueError('Password must contain uppercase letter')
        if not any(c.isdigit() for c in v):
            raise ValueError('Password must contain digit')
        return v

    @validator('password_confirm')
    def passwords_match(cls, v, values):
        if 'password' in values and v != values['password']:
            raise ValueError('Passwords do not match')
        return v

# Valid
user = User(username="john", password="Secret123", password_confirm="Secret123")

# Invalid
try:
    User(username="john!", password="weak", password_confirm="weak")
except ValueError as e:
    print(e)
```

### Optional Fields

```python
from pydantic import BaseModel
from typing import Optional

class User(BaseModel):
    name: str
    email: str
    age: Optional[int] = None       # Can be None
    bio: str | None = None          # Python 3.10+ syntax
    phone: str = ""                 # Default empty string

user1 = User(name="John", email="john@example.com")
user2 = User(name="Jane", email="jane@example.com", age=25, bio="Developer")
```

### Nested Models

```python
from pydantic import BaseModel

class Address(BaseModel):
    street: str
    city: str
    country: str
    zip_code: str

class User(BaseModel):
    name: str
    email: str
    address: Address

user = User(
    name="John",
    email="john@example.com",
    address={
        "street": "123 Main St",
        "city": "New York",
        "country": "USA",
        "zip_code": "10001"
    }
)

print(user.address.city)  # New York
print(user.dict())        # Nested dict
```

### Lists and Dicts

```python
from pydantic import BaseModel

class Team(BaseModel):
    name: str
    members: list[str]
    scores: dict[str, int]

team = Team(
    name="Team A",
    members=["Alice", "Bob", "Charlie"],
    scores={"Alice": 100, "Bob": 95, "Charlie": 88}
)

print(team.members[0])      # Alice
print(team.scores["Bob"])   # 95
```

### Model Config

```python
from pydantic import BaseModel

class User(BaseModel):
    name: str
    email: str

    class Config:
        # Allow extra fields
        extra = 'allow'  # or 'forbid' or 'ignore'

        # Immutable (can't change after creation)
        allow_mutation = False

        # Use enum values
        use_enum_values = True

        # Validate on assignment
        validate_assignment = True

# With validate_assignment
user = User(name="John", email="john@example.com")
try:
    user.email = "invalid-email"  # Validates on assignment
except ValueError as e:
    print(e)
```

### Parsing Data

```python
from pydantic import BaseModel

class User(BaseModel):
    id: int
    name: str
    email: str

# From dict
data = {"id": 1, "name": "John", "email": "john@example.com"}
user = User(**data)

# From JSON string
json_str = '{"id": 1, "name": "John", "email": "john@example.com"}'
user = User.parse_raw(json_str)

# From file
# user = User.parse_file('user.json')

# Multiple objects
users_data = [
    {"id": 1, "name": "John", "email": "john@example.com"},
    {"id": 2, "name": "Jane", "email": "jane@example.com"}
]
users = [User(**data) for data in users_data]
```

### Export Data

```python
from pydantic import BaseModel

class User(BaseModel):
    id: int
    name: str
    email: str
    password: str

user = User(id=1, name="John", email="john@example.com", password="secret")

# To dict
print(user.dict())
# {'id': 1, 'name': 'John', 'email': 'john@example.com', 'password': 'secret'}

# Exclude fields
print(user.dict(exclude={'password'}))
# {'id': 1, 'name': 'John', 'email': 'john@example.com'}

# Include only specific fields
print(user.dict(include={'id', 'name'}))
# {'id': 1, 'name': 'John'}

# To JSON
print(user.json())
print(user.json(exclude={'password'}))
```

### Root Validators

```python
from pydantic import BaseModel, root_validator

class DateRange(BaseModel):
    start_date: str
    end_date: str

    @root_validator
    def check_dates(cls, values):
        start = values.get('start_date')
        end = values.get('end_date')
        if start and end and start > end:
            raise ValueError('start_date must be before end_date')
        return values

# Valid
date_range = DateRange(start_date="2024-01-01", end_date="2024-12-31")

# Invalid
try:
    DateRange(start_date="2024-12-31", end_date="2024-01-01")
except ValueError as e:
    print(e)
    # start_date must be before end_date
```

### With FastAPI

```python
from fastapi import FastAPI
from pydantic import BaseModel, EmailStr

app = FastAPI()

class UserCreate(BaseModel):
    username: str
    email: EmailStr
    password: str

class UserResponse(BaseModel):
    id: int
    username: str
    email: str

    class Config:
        orm_mode = True  # Work with ORM models

@app.post("/users/", response_model=UserResponse)
def create_user(user: UserCreate):
    # user is automatically validated
    # Create user in database
    return {
        "id": 1,
        "username": user.username,
        "email": user.email
    }
```

### With SQLAlchemy

```python
from pydantic import BaseModel
from sqlalchemy import Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class UserDB(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True)
    name = Column(String)
    email = Column(String)

class UserSchema(BaseModel):
    id: int
    name: str
    email: str

    class Config:
        orm_mode = True  # Allow from_orm()

# Convert SQLAlchemy model to Pydantic
db_user = UserDB(id=1, name="John", email="john@example.com")
pydantic_user = UserSchema.from_orm(db_user)

print(pydantic_user.dict())
# {'id': 1, 'name': 'John', 'email': 'john@example.com'}
```

### Environment Variables

```python
from pydantic import BaseSettings

class Settings(BaseSettings):
    app_name: str = "MyApp"
    database_url: str
    secret_key: str
    debug: bool = False

    class Config:
        env_file = ".env"

# Reads from environment variables or .env file
settings = Settings()

print(settings.database_url)
print(settings.secret_key)
```

### Datetime Handling

```python
from pydantic import BaseModel
from datetime import datetime

class Event(BaseModel):
    name: str
    created_at: datetime
    updated_at: datetime | None = None

# Automatic parsing
event = Event(
    name="Conference",
    created_at="2024-01-15T10:00:00"  # String parsed to datetime
)

print(event.created_at)           # datetime object
print(event.json())               # ISO format string
```

### Common Patterns

#### API Request/Response Models

```python
from pydantic import BaseModel, EmailStr

class UserCreate(BaseModel):
    """For creating users"""
    username: str
    email: EmailStr
    password: str

class UserUpdate(BaseModel):
    """For updating users"""
    email: EmailStr | None = None
    bio: str | None = None

class UserResponse(BaseModel):
    """For API responses"""
    id: int
    username: str
    email: str

    class Config:
        orm_mode = True
```

#### Configuration Model

```python
from pydantic import BaseSettings, Field

class AppConfig(BaseSettings):
    app_name: str = "MyApp"
    database_url: str = Field(..., env='DATABASE_URL')
    redis_url: str = Field(..., env='REDIS_URL')
    secret_key: str = Field(..., env='SECRET_KEY')
    debug: bool = False

    class Config:
        env_file = ".env"
        env_file_encoding = 'utf-8'

config = AppConfig()
```

### Best Practices

1. **Use type hints** - Leverage Python's type system
2. **Default values** - Provide sensible defaults
3. **Custom validators** - For complex validation logic
4. **Nested models** - For structured data
5. **orm_mode** - When working with databases
6. **Separate schemas** - Create/Update/Response models
7. **Document fields** - Use Field() with description
8. **Reuse models** - Don't repeat yourself

### Quick Reference

```python
from pydantic import BaseModel, Field, validator

class Model(BaseModel):
    # Basic types
    name: str
    age: int
    active: bool
    score: float

    # Optional
    bio: str | None = None

    # Default value
    status: str = "pending"

    # Field constraints
    username: str = Field(..., min_length=3, max_length=50)

    # Custom validator
    @validator('age')
    def check_age(cls, v):
        if v < 0:
            raise ValueError('Age must be positive')
        return v

    # Config
    class Config:
        validate_assignment = True
        extra = 'forbid'

# Usage
model = Model(name="John", age=25, username="john_doe")
print(model.dict())
print(model.json())
```
