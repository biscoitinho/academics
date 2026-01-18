## Pydantic - Data Validation

```bash
pip install pydantic
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
from pydantic import BaseModel, Field, EmailStr

class User(BaseModel):
    username: str = Field(..., min_length=3, max_length=50)
    age: int = Field(..., ge=0, le=120)
    email: EmailStr
    score: float = Field(default=0.0, ge=0.0, le=100.0)
```

### Custom Validators

```python
from pydantic import validator

class User(BaseModel):
    username: str
    password: str
    password_confirm: str

    @validator('username')
    def username_alphanumeric(cls, v):
        if not v.isalnum():
            raise ValueError('Must be alphanumeric')
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

class User(BaseModel):
    name: str
    address: Address

user = User(name="John", address={"street": "123 Main", "city": "NYC"})
```

### Lists & Dicts

```python
class Team(BaseModel):
    name: str
    members: list[str]
    scores: dict[str, int]
```

### Parsing & Export

```python
# From dict
user = User(**data)

# From JSON
user = User.parse_raw(json_str)

# Export excluding fields
user.dict(exclude={'password'})
user.json(exclude={'password'})
```

### Config

```python
class User(BaseModel):
    name: str

    class Config:
        validate_assignment = True  # Validate on assignment
        extra = 'forbid'           # Forbid extra fields
        orm_mode = True            # Work with ORM
```

### With FastAPI

```python
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class UserCreate(BaseModel):
    username: str
    email: str

@app.post("/users/")
def create_user(user: UserCreate):
    return user.dict()
```

### With SQLAlchemy

```python
class UserSchema(BaseModel):
    id: int
    name: str

    class Config:
        orm_mode = True

# Convert ORM to Pydantic
pydantic_user = UserSchema.from_orm(db_user)
```

### Environment Variables

```python
from pydantic import BaseSettings

class Settings(BaseSettings):
    app_name: str = "MyApp"
    database_url: str

    class Config:
        env_file = ".env"

settings = Settings()
```

### Quick Reference

```python
from pydantic import BaseModel, Field, validator, EmailStr

class Model(BaseModel):
    name: str
    age: int
    email: EmailStr
    score: float = Field(default=0.0, ge=0.0)

    @validator('age')
    def check_age(cls, v):
        if v < 0:
            raise ValueError('Must be positive')
        return v

model = Model(name="John", age=25, email="john@example.com")
print(model.dict())
```
