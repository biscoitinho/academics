## SQLAlchemy - ORM

### Install & Connect

```python
pip install sqlalchemy psycopg2-binary

from sqlalchemy import create_engine
engine = create_engine('postgresql://user:pass@localhost/db')
```

### Models

```python
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship

Base = declarative_base()

class User(Base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True)
    username = Column(String(50), unique=True)
    posts = relationship('Post', back_populates='author')

class Post(Base):
    __tablename__ = 'posts'
    id = Column(Integer, primary_key=True)
    title = Column(String(200))
    user_id = Column(Integer, ForeignKey('users.id'))
    author = relationship('User', back_populates='posts')

Base.metadata.create_all(engine)
```

### CRUD

```python
from sqlalchemy.orm import Session

with Session(engine) as session:
    # Create
    user = User(username="john")
    session.add(user)
    session.commit()

    # Read
    users = session.query(User).all()
    user = session.query(User).filter_by(username="john").first()
    user = session.get(User, 1)

    # Update
    user.username = "jane"
    session.commit()

    # Delete
    session.delete(user)
    session.commit()
```

### Queries

```python
# Filter
session.query(User).filter(User.username == 'john')
session.query(User).filter(User.username.like('%john%'))
session.query(User).filter(User.id.in_([1, 2, 3]))

# AND/OR
from sqlalchemy import and_, or_
session.query(User).filter(and_(User.id > 10, User.id < 20))

# Order & Limit
session.query(User).order_by(User.username).limit(10).all()

# Count
session.query(User).count()
```

### Relationships

```python
# One-to-Many
user = session.query(User).first()
for post in user.posts:
    print(post.title)

# Many-to-Many
from sqlalchemy import Table
association = Table('student_course', Base.metadata,
    Column('student_id', Integer, ForeignKey('students.id')),
    Column('course_id', Integer, ForeignKey('courses.id'))
)

class Student(Base):
    __tablename__ = 'students'
    id = Column(Integer, primary_key=True)
    courses = relationship('Course', secondary=association)
```

### Joins & Eager Loading

```python
# Join
session.query(User).join(Post).filter(Post.title.like('%Python%'))

# Eager loading (avoid N+1)
from sqlalchemy.orm import joinedload
users = session.query(User).options(joinedload(User.posts)).all()
```

### Aggregations

```python
from sqlalchemy import func
count = session.query(func.count(User.id)).scalar()
results = session.query(User.username, func.count(Post.id)).join(Post).group_by(User.username).all()
```

### Quick Setup

```python
# database.py
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

engine = create_engine('sqlite:///db.db')
SessionLocal = sessionmaker(bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
```
