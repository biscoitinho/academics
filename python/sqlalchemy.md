## SQLAlchemy - ORM and SQL Toolkit

### Installation

```bash
pip install sqlalchemy
pip install psycopg2-binary  # PostgreSQL
pip install pymysql          # MySQL
```

### Database Connection

```python
from sqlalchemy import create_engine

engine = create_engine('sqlite:///database.db')
engine = create_engine('postgresql://user:pass@localhost/dbname')
engine = create_engine('mysql+pymysql://user:pass@localhost/dbname')
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

    posts = relationship('Post', back_populates='author')

class Post(Base):
    __tablename__ = 'posts'

    id = Column(Integer, primary_key=True)
    title = Column(String(200), nullable=False)
    content = Column(String, nullable=False)
    user_id = Column(Integer, ForeignKey('users.id'))

    author = relationship('User', back_populates='posts')
```

### Create Tables

```python
Base.metadata.create_all(engine)  # Create
Base.metadata.drop_all(engine)    # Drop
```

### Sessions

```python
from sqlalchemy.orm import Session

# Recommended: Context manager
with Session(engine) as session:
    user = User(username="john", email="john@example.com")
    session.add(user)
    session.commit()
```

### Create (Insert)

```python
with Session(engine) as session:
    # Single
    user = User(username="john", email="john@example.com")
    session.add(user)
    session.commit()

    # Multiple
    users = [
        User(username="alice", email="alice@example.com"),
        User(username="bob", email="bob@example.com")
    ]
    session.add_all(users)
    session.commit()
```

### Read (Query)

```python
with Session(engine) as session:
    # All
    users = session.query(User).all()

    # First
    user = session.query(User).first()

    # By ID
    user = session.get(User, 1)

    # Filter
    user = session.query(User).filter_by(username='john').first()
    user = session.query(User).filter(User.username == 'john').first()

    # Count
    count = session.query(User).count()
```

### Filter Operators

```python
# Equals / Not equals
session.query(User).filter(User.username == 'john')
session.query(User).filter(User.username != 'john')

# Like / ilike
session.query(User).filter(User.username.like('%john%'))
session.query(User).filter(User.username.ilike('%john%'))

# In / Not in
session.query(User).filter(User.username.in_(['john', 'jane']))
session.query(User).filter(~User.username.in_(['john', 'jane']))

# NULL checks
session.query(User).filter(User.email.is_(None))
session.query(User).filter(User.email.isnot(None))

# AND / OR
from sqlalchemy import and_, or_
session.query(User).filter(and_(User.id > 10, User.id < 20))
session.query(User).filter(or_(User.username == 'john', User.username == 'jane'))

# Comparison
session.query(User).filter(User.id > 10)
session.query(User).filter(User.id <= 100)
```

### Ordering and Limiting

```python
# Order by
users = session.query(User).order_by(User.username).all()
users = session.query(User).order_by(User.created_at.desc()).all()

# Limit / Offset
users = session.query(User).limit(10).all()
users = session.query(User).offset(10).limit(10).all()
```

### Update

```python
with Session(engine) as session:
    # Get and update
    user = session.query(User).filter_by(username='john').first()
    user.email = 'newemail@example.com'
    session.commit()

    # Bulk update
    session.query(User).filter_by(username='john').update({'email': 'new@example.com'})
    session.commit()
```

### Delete

```python
with Session(engine) as session:
    # Get and delete
    user = session.query(User).filter_by(username='john').first()
    session.delete(user)
    session.commit()

    # Bulk delete
    session.query(User).filter_by(username='john').delete()
    session.commit()
```

### Relationships

#### One-to-Many

```python
class User(Base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True)
    posts = relationship('Post', back_populates='author')

class Post(Base):
    __tablename__ = 'posts'
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.id'))
    author = relationship('User', back_populates='posts')

# Usage
with Session(engine) as session:
    user = session.query(User).first()
    for post in user.posts:
        print(post.title)
```

#### Many-to-Many

```python
from sqlalchemy import Table

student_course = Table('student_course', Base.metadata,
    Column('student_id', Integer, ForeignKey('students.id')),
    Column('course_id', Integer, ForeignKey('courses.id'))
)

class Student(Base):
    __tablename__ = 'students'
    id = Column(Integer, primary_key=True)
    courses = relationship('Course', secondary=student_course, back_populates='students')

class Course(Base):
    __tablename__ = 'courses'
    id = Column(Integer, primary_key=True)
    students = relationship('Student', secondary=student_course, back_populates='courses')
```

### Joins

```python
# Inner join
results = session.query(User, Post).join(Post).all()

# Left outer join
results = session.query(User).outerjoin(Post).all()

# Filter on joined table
users = session.query(User).join(Post).filter(Post.title.like('%Python%')).all()
```

### Eager Loading

```python
from sqlalchemy.orm import joinedload, subqueryload

# Avoid N+1 problem
users = session.query(User).options(joinedload(User.posts)).all()
users = session.query(User).options(subqueryload(User.posts)).all()
```

### Aggregations

```python
from sqlalchemy import func

# Count, sum, avg
count = session.query(func.count(User.id)).scalar()
total = session.query(func.sum(Post.views)).scalar()
avg = session.query(func.avg(Post.views)).scalar()

# Group by
results = session.query(
    User.username,
    func.count(Post.id).label('post_count')
).join(Post).group_by(User.username).all()
```

### Raw SQL

```python
from sqlalchemy import text

result = session.execute(
    text("SELECT * FROM users WHERE username = :username"),
    {"username": "john"}
)
for row in result:
    print(row)
```

### Transactions

```python
with Session(engine) as session:
    try:
        user = User(username="john", email="john@example.com")
        session.add(user)
        session.commit()
    except Exception as e:
        session.rollback()
        raise
```

### Common Patterns

```python
# database.py
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

engine = create_engine('sqlite:///./database.db')
SessionLocal = sessionmaker(bind=engine)
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

# CRUD
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
