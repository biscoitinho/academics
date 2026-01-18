## Pydantic - Data Validation

Data validation using Python type annotations.

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
    is_active: bool = True

user = User(id=1, name="John", email="john@example.com")
print(user.dict())  # To dict
print(user.json())  # To JSON
```

### Field Validation

```python
from pydantic import BaseModel, Field

class User(BaseModel):
    username: str = Field(..., min_length=3, max_length=50)
    age: int = Field(..., ge=0, le=120)
    email: str = Field(..., regex=r'^[\w\.-]+@[\w\.-]+\.\w+$')
    score: float = Field(default=0.0, ge=0.0, le=100.0)
```

### Common Validators

```python
from pydantic import BaseModel, EmailStr, HttpUrl, constr, conint

class UserProfile(BaseModel):
    email: EmailStr                 # Valid email
    website: HttpUrl                # Valid URL
    username: constr(min_length=3)  # Constrained string
    age: conint(ge=18, le=100)      # Constrained int
    bio: str | None = None          # Optional
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
            raise ValueError('Must be alphanumeric')
        return v

    @validator('password')
    def password_strength(cls, v):
        if len(v) < 8:
            raise ValueError('Must be 8+ characters')
        return v

    @validator('password_confirm')
    def passwords_match(cls, v, values):
        if 'password' in values and v != values['password']:
            raise ValueError('Passwords do not match')
        return v
```

### Nested Models

```python
class Address(BaseModel):
    street: str
    city: str
    zip_code: str

class User(BaseModel):
    name: str
    address: Address

user = User(
    name="John",
    address={"street": "123 Main", "city": "NYC", "zip_code": "10001"}
)
print(user.address.city)  # NYC
```

### Lists and Dicts

```python
class Team(BaseModel):
    name: str
    members: list[str]
    scores: dict[str, int]

team = Team(
    name="Team A",
    members=["Alice", "Bob"],
    scores={"Alice": 100, "Bob": 95}
)
```

### Parsing Data

```python
# From dict
data = {"id": 1, "name": "John", "email": "john@example.com"}
user = User(**data)

# From JSON
json_str = '{"id": 1, "name": "John", "email": "john@example.com"}'
user = User.parse_raw(json_str)

# Multiple objects
users = [User(**data) for data in users_data]
```

### Export Data

```python
user = User(id=1, name="John", email="john@example.com", password="secret")

# Exclude fields
user.dict(exclude={'password'})

# Include only
user.dict(include={'id', 'name'})

# To JSON
user.json(exclude={'password'})
```

### Root Validators

```python
from pydantic import BaseModel, root_validator

class DateRange(BaseModel):
    start_date: str
    end_date: str

    @root_validator
    def check_dates(cls, values):
        if values['start_date'] > values['end_date']:
            raise ValueError('start must be before end')
        return values
```

### Model Config

```python
class User(BaseModel):
    name: str
    email: str

    class Config:
        validate_assignment = True  # Validate on assignment
        extra = 'forbid'           # Forbid extra fields
        orm_mode = True            # Work with ORM models
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

@app.post("/users/")
def create_user(user: UserCreate):
    return {"username": user.username, "email": user.email}
```

### With SQLAlchemy

```python
class UserSchema(BaseModel):
    id: int
    name: str
    email: str

    class Config:
        orm_mode = True

# Convert ORM to Pydantic
db_user = UserDB(id=1, name="John", email="john@example.com")
pydantic_user = UserSchema.from_orm(db_user)
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

settings = Settings()
```

### Quick Reference

```python
from pydantic import BaseModel, Field, validator, EmailStr

class Model(BaseModel):
    # Types
    name: str
    age: int
    active: bool
    score: float

    # Optional
    bio: str | None = None

    # Field constraints
    username: str = Field(..., min_length=3, max_length=50)

    # Validators
    email: EmailStr

    # Custom validator
    @validator('age')
    def check_age(cls, v):
        if v < 0:
            raise ValueError('Must be positive')
        return v

    class Config:
        validate_assignment = True

# Usage
model = Model(name="John", age=25, username="john", email="john@example.com")
print(model.dict())
print(model.json())
```
