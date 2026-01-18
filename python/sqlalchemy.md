## SQLAlchemy - Python SQL Toolkit and ORM

SQLAlchemy is the most popular Python SQL toolkit and Object-Relational Mapping (ORM) library.

### Installation

```bash
pip install sqlalchemy
pip install psycopg2-binary  # For PostgreSQL
pip install pymysql          # For MySQL
pip install cx_oracle        # For Oracle
```

### Database Connection

```python
from sqlalchemy import create_engine

# SQLite (file-based)
engine = create_engine('sqlite:///database.db')

# PostgreSQL
engine = create_engine('postgresql://user:password@localhost:5432/dbname')

# MySQL
engine = create_engine('mysql+pymysql://user:password@localhost:3306/dbname')

# With connection pooling
engine = create_engine(
    'postgresql://user:password@localhost/dbname',
    pool_size=10,
    max_overflow=20
)
```

### Define Models

```python
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from datetime import datetime

Base = declarative_base()

class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True)
    username = Column(String(50), unique=True, nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationship
    posts = relationship('Post', back_populates='author')

    def __repr__(self):
        return f"<User(username='{self.username}', email='{self.email}')>"

class Post(Base):
    __tablename__ = 'posts'

    id = Column(Integer, primary_key=True)
    title = Column(String(200), nullable=False)
    content = Column(String, nullable=False)
    user_id = Column(Integer, ForeignKey('users.id'))
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationship
    author = relationship('User', back_populates='posts')

    def __repr__(self):
        return f"<Post(title='{self.title}')>"
```

### Create Tables

```python
from sqlalchemy import create_engine
from models import Base

engine = create_engine('sqlite:///database.db')

# Create all tables
Base.metadata.create_all(engine)

# Drop all tables
Base.metadata.drop_all(engine)
```

### Sessions

```python
from sqlalchemy.orm import sessionmaker, Session

# Create session factory
SessionLocal = sessionmaker(bind=engine)

# Create session
session = SessionLocal()

# Use session
try:
    # Your database operations here
    user = User(username="john", email="john@example.com")
    session.add(user)
    session.commit()
finally:
    session.close()

# Context manager (recommended)
with Session(engine) as session:
    user = User(username="jane", email="jane@example.com")
    session.add(user)
    session.commit()
```

### Create (Insert)

```python
from sqlalchemy.orm import Session

with Session(engine) as session:
    # Single object
    user = User(username="john", email="john@example.com")
    session.add(user)
    session.commit()

    print(user.id)  # Auto-generated ID

# Multiple objects
with Session(engine) as session:
    users = [
        User(username="alice", email="alice@example.com"),
        User(username="bob", email="bob@example.com")
    ]
    session.add_all(users)
    session.commit()

# With relationship
with Session(engine) as session:
    user = User(username="author", email="author@example.com")
    post = Post(title="My Post", content="Content here", author=user)
    session.add(post)
    session.commit()
```

### Read (Query)

```python
from sqlalchemy.orm import Session

with Session(engine) as session:
    # Get all
    users = session.query(User).all()

    # Get first
    user = session.query(User).first()

    # Get by ID
    user = session.query(User).get(1)
    # Or
    user = session.get(User, 1)

    # Filter
    users = session.query(User).filter(User.username == 'john').all()
    users = session.query(User).filter_by(username='john').all()

    # Get one (raises if not found or multiple)
    user = session.query(User).filter_by(username='john').one()

    # Get one or None
    user = session.query(User).filter_by(username='john').one_or_none()

    # Count
    count = session.query(User).count()

    # Check existence
    exists = session.query(User).filter_by(username='john').first() is not None
```

### Filter Operators

```python
from sqlalchemy.orm import Session

with Session(engine) as session:
    # Equals
    session.query(User).filter(User.username == 'john')

    # Not equals
    session.query(User).filter(User.username != 'john')

    # Like (case-sensitive)
    session.query(User).filter(User.username.like('%john%'))

    # ilike (case-insensitive)
    session.query(User).filter(User.username.ilike('%john%'))

    # In
    session.query(User).filter(User.username.in_(['john', 'jane']))

    # Not in
    session.query(User).filter(~User.username.in_(['john', 'jane']))

    # IS NULL
    session.query(User).filter(User.email.is_(None))

    # IS NOT NULL
    session.query(User).filter(User.email.isnot(None))

    # AND
    session.query(User).filter(User.username == 'john', User.email == 'john@example.com')
    # Or
    from sqlalchemy import and_
    session.query(User).filter(and_(User.username == 'john', User.email == 'john@example.com'))

    # OR
    from sqlalchemy import or_
    session.query(User).filter(or_(User.username == 'john', User.username == 'jane'))

    # Greater than, less than
    session.query(User).filter(User.id > 10)
    session.query(User).filter(User.id <= 100)
```

### Ordering and Limiting

```python
from sqlalchemy.orm import Session

with Session(engine) as session:
    # Order by
    users = session.query(User).order_by(User.username).all()

    # Order descending
    users = session.query(User).order_by(User.created_at.desc()).all()

    # Multiple order by
    users = session.query(User).order_by(User.username, User.created_at.desc()).all()

    # Limit
    users = session.query(User).limit(10).all()

    # Offset
    users = session.query(User).offset(10).limit(10).all()

    # Pagination
    page = 2
    per_page = 10
    users = session.query(User).offset((page - 1) * per_page).limit(per_page).all()
```

### Update

```python
from sqlalchemy.orm import Session

with Session(engine) as session:
    # Get and update
    user = session.query(User).filter_by(username='john').first()
    if user:
        user.email = 'newemail@example.com'
        session.commit()

# Bulk update
with Session(engine) as session:
    session.query(User).filter(User.username == 'john').update({
        'email': 'newemail@example.com'
    })
    session.commit()

# Update with expressions
with Session(engine) as session:
    from sqlalchemy import func
    session.query(User).filter(User.username == 'john').update({
        'updated_at': func.now()
    })
    session.commit()
```

### Delete

```python
from sqlalchemy.orm import Session

with Session(engine) as session:
    # Get and delete
    user = session.query(User).filter_by(username='john').first()
    if user:
        session.delete(user)
        session.commit()

# Bulk delete
with Session(engine) as session:
    session.query(User).filter(User.username == 'john').delete()
    session.commit()
```

### Relationships

#### One-to-Many

```python
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship

class User(Base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True)
    username = Column(String(50))

    posts = relationship('Post', back_populates='author')

class Post(Base):
    __tablename__ = 'posts'
    id = Column(Integer, primary_key=True)
    title = Column(String(200))
    user_id = Column(Integer, ForeignKey('users.id'))

    author = relationship('User', back_populates='posts')

# Usage
with Session(engine) as session:
    user = session.query(User).first()

    # Access related posts
    for post in user.posts:
        print(post.title)

    # Access author from post
    post = session.query(Post).first()
    print(post.author.username)
```

#### Many-to-Many

```python
from sqlalchemy import Table, Column, Integer, ForeignKey
from sqlalchemy.orm import relationship

# Association table
student_course = Table(
    'student_course',
    Base.metadata,
    Column('student_id', Integer, ForeignKey('students.id')),
    Column('course_id', Integer, ForeignKey('courses.id'))
)

class Student(Base):
    __tablename__ = 'students'
    id = Column(Integer, primary_key=True)
    name = Column(String(50))

    courses = relationship('Course', secondary=student_course, back_populates='students')

class Course(Base):
    __tablename__ = 'courses'
    id = Column(Integer, primary_key=True)
    name = Column(String(100))

    students = relationship('Student', secondary=student_course, back_populates='courses')

# Usage
with Session(engine) as session:
    student = Student(name="John")
    course1 = Course(name="Math")
    course2 = Course(name="Science")

    student.courses.append(course1)
    student.courses.append(course2)

    session.add(student)
    session.commit()

    # Access relationships
    for course in student.courses:
        print(course.name)
```

#### One-to-One

```python
class User(Base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True)
    username = Column(String(50))

    profile = relationship('Profile', back_populates='user', uselist=False)

class Profile(Base):
    __tablename__ = 'profiles'
    id = Column(Integer, primary_key=True)
    bio = Column(String)
    user_id = Column(Integer, ForeignKey('users.id'), unique=True)

    user = relationship('User', back_populates='profile')

# Usage
with Session(engine) as session:
    user = User(username="john")
    profile = Profile(bio="Developer", user=user)
    session.add(profile)
    session.commit()

    # Access
    print(user.profile.bio)
    print(profile.user.username)
```

### Joins

```python
from sqlalchemy.orm import Session

with Session(engine) as session:
    # Inner join
    results = session.query(User, Post).join(Post).all()

    for user, post in results:
        print(f"{user.username}: {post.title}")

    # Left outer join
    results = session.query(User).outerjoin(Post).all()

    # Filter on joined table
    users = session.query(User).join(Post).filter(Post.title.like('%Python%')).all()

    # Select specific columns
    results = session.query(User.username, Post.title).join(Post).all()
```

### Eager Loading

```python
from sqlalchemy.orm import Session, joinedload, subqueryload

with Session(engine) as session:
    # Without eager loading (N+1 problem)
    users = session.query(User).all()
    for user in users:
        for post in user.posts:  # Separate query for each user
            print(post.title)

    # With joined load (one query with JOIN)
    users = session.query(User).options(joinedload(User.posts)).all()
    for user in users:
        for post in user.posts:  # No additional queries
            print(post.title)

    # With subquery load (two queries total)
    users = session.query(User).options(subqueryload(User.posts)).all()
```

### Aggregations

```python
from sqlalchemy import func
from sqlalchemy.orm import Session

with Session(engine) as session:
    # Count
    count = session.query(func.count(User.id)).scalar()

    # Count with filter
    count = session.query(func.count(User.id)).filter(User.username.like('j%')).scalar()

    # Sum
    total = session.query(func.sum(Post.views)).scalar()

    # Average
    avg = session.query(func.avg(Post.views)).scalar()

    # Min/Max
    min_id = session.query(func.min(User.id)).scalar()
    max_id = session.query(func.max(User.id)).scalar()

    # Group by
    results = session.query(
        User.username,
        func.count(Post.id).label('post_count')
    ).join(Post).group_by(User.username).all()

    for username, post_count in results:
        print(f"{username}: {post_count} posts")
```

### Raw SQL

```python
from sqlalchemy import text
from sqlalchemy.orm import Session

with Session(engine) as session:
    # Execute raw SQL
    result = session.execute(text("SELECT * FROM users WHERE username = :username"),
                           {"username": "john"})

    for row in result:
        print(row)

    # With ORM mapping
    result = session.execute(text("SELECT * FROM users")).scalars(User)
    users = result.all()

    # Insert/Update/Delete
    session.execute(text("UPDATE users SET email = :email WHERE username = :username"),
                   {"email": "new@example.com", "username": "john"})
    session.commit()
```

### Transactions

```python
from sqlalchemy.orm import Session

# Auto-commit on success, rollback on error
with Session(engine) as session:
    try:
        user = User(username="john", email="john@example.com")
        session.add(user)

        post = Post(title="First Post", content="Content", author=user)
        session.add(post)

        session.commit()
    except Exception as e:
        session.rollback()
        print(f"Error: {e}")
        raise

# Explicit transaction
with Session(engine) as session:
    with session.begin():
        user = User(username="john", email="john@example.com")
        session.add(user)
        # Automatically commits at end of block, or rolls back on exception
```

### Column Types

```python
from sqlalchemy import Column, Integer, String, Float, Boolean, Date, DateTime, Text, JSON, Enum
import enum

class UserRole(enum.Enum):
    ADMIN = "admin"
    USER = "user"
    GUEST = "guest"

class Example(Base):
    __tablename__ = 'examples'

    id = Column(Integer, primary_key=True)
    name = Column(String(100))              # VARCHAR(100)
    description = Column(Text)              # TEXT
    price = Column(Float)                   # FLOAT
    is_active = Column(Boolean, default=True)  # BOOLEAN
    created_date = Column(Date)             # DATE
    created_at = Column(DateTime)           # DATETIME
    data = Column(JSON)                     # JSON (PostgreSQL, SQLite 3.9+)
    role = Column(Enum(UserRole))           # ENUM
```

### Best Practices

```python
# 1. Use context managers for sessions
with Session(engine) as session:
    # Operations here
    session.commit()

# 2. Use relationship loading appropriately
users = session.query(User).options(joinedload(User.posts)).all()

# 3. Flush vs Commit
with Session(engine) as session:
    user = User(username="john", email="john@example.com")
    session.add(user)
    session.flush()  # Send to DB, get ID, but don't commit
    print(user.id)   # Available after flush
    session.commit() # Actually commit transaction

# 4. Refresh objects
with Session(engine) as session:
    user = session.query(User).first()
    # ... some time passes, DB might have changed ...
    session.refresh(user)  # Get latest from DB

# 5. Expire objects
with Session(engine) as session:
    user = session.query(User).first()
    session.expire(user)  # Mark as stale, will reload on next access
```

### Common Patterns

#### Repository Pattern

```python
class UserRepository:
    def __init__(self, session: Session):
        self.session = session

    def get_by_id(self, user_id: int):
        return self.session.query(User).get(user_id)

    def get_by_username(self, username: str):
        return self.session.query(User).filter_by(username=username).first()

    def create(self, user: User):
        self.session.add(user)
        self.session.commit()
        return user

    def update(self, user: User):
        self.session.commit()
        return user

    def delete(self, user: User):
        self.session.delete(user)
        self.session.commit()

# Usage
with Session(engine) as session:
    repo = UserRepository(session)
    user = repo.get_by_username("john")
```

#### Database Setup Module

```python
# database.py
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

SQLALCHEMY_DATABASE_URL = "sqlite:///./database.db"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    connect_args={"check_same_thread": False}  # SQLite only
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
```

### Quick Reference

```python
# Connect
engine = create_engine('sqlite:///db.db')

# Define model
class User(Base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True)
    name = Column(String(50))

# Create tables
Base.metadata.create_all(engine)

# Session
with Session(engine) as session:
    # Create
    user = User(name="John")
    session.add(user)
    session.commit()

    # Read
    users = session.query(User).all()
    user = session.query(User).filter_by(name="John").first()

    # Update
    user.name = "Jane"
    session.commit()

    # Delete
    session.delete(user)
    session.commit()
```
