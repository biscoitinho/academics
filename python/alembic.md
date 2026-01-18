## Alembic - Database Migrations

Alembic is a database migration tool for SQLAlchemy. It allows you to manage database schema changes over time.

### Installation

```bash
pip install alembic
pip install sqlalchemy  # Required dependency
```

### Initialize Alembic

```bash
# In your project directory
alembic init alembic

# This creates:
# alembic/
#   env.py           # Migration environment
#   script.py.mako   # Migration template
#   versions/        # Migration files
# alembic.ini        # Configuration file
```

### Configuration

```python
# alembic.ini - Set database URL
sqlalchemy.url = postgresql://user:password@localhost/dbname

# Or use environment variable (better for production)
# sqlalchemy.url =

# Then in alembic/env.py
import os
from dotenv import load_dotenv

load_dotenv()
config.set_main_option('sqlalchemy.url', os.getenv('DATABASE_URL'))
```

### Define Your Models

```python
# models.py
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime

Base = declarative_base()

class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True)
    username = Column(String(50), unique=True, nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)

class Post(Base):
    __tablename__ = 'posts'

    id = Column(Integer, primary_key=True)
    title = Column(String(200), nullable=False)
    content = Column(String, nullable=False)
    user_id = Column(Integer, ForeignKey('users.id'))
```

### Link Models to Alembic

```python
# alembic/env.py - Add this near the top
from models import Base
target_metadata = Base.metadata
```

### Create Migration

```bash
# Auto-generate migration from model changes
alembic revision --autogenerate -m "create users and posts tables"

# This creates: alembic/versions/xxxx_create_users_and_posts_tables.py
```

### Migration File Example

```python
# alembic/versions/xxxx_create_users_table.py
"""create users table

Revision ID: abc123
Revises:
Create Date: 2024-01-15 10:00:00
"""
from alembic import op
import sqlalchemy as sa

# revision identifiers
revision = 'abc123'
down_revision = None
branch_labels = None
depends_on = None

def upgrade():
    op.create_table(
        'users',
        sa.Column('id', sa.Integer(), primary_key=True),
        sa.Column('username', sa.String(50), nullable=False),
        sa.Column('email', sa.String(100), nullable=False),
        sa.Column('created_at', sa.DateTime(), nullable=True)
    )
    op.create_index('ix_users_email', 'users', ['email'], unique=True)

def downgrade():
    op.drop_index('ix_users_email', table_name='users')
    op.drop_table('users')
```

### Apply Migrations

```bash
# Upgrade to latest version
alembic upgrade head

# Upgrade by 1 version
alembic upgrade +1

# Downgrade by 1 version
alembic downgrade -1

# Downgrade to specific revision
alembic downgrade abc123

# Show current version
alembic current

# Show migration history
alembic history
```

### Common Operations

#### Add Column

```bash
alembic revision -m "add age to users"
```

```python
def upgrade():
    op.add_column('users', sa.Column('age', sa.Integer(), nullable=True))

def downgrade():
    op.drop_column('users', 'age')
```

#### Modify Column

```python
def upgrade():
    op.alter_column('users', 'email',
                    existing_type=sa.String(100),
                    type_=sa.String(200),
                    nullable=False)

def downgrade():
    op.alter_column('users', 'email',
                    existing_type=sa.String(200),
                    type_=sa.String(100),
                    nullable=False)
```

#### Drop Column

```python
def upgrade():
    op.drop_column('users', 'age')

def downgrade():
    op.add_column('users', sa.Column('age', sa.Integer(), nullable=True))
```

#### Create Index

```python
def upgrade():
    op.create_index('ix_users_username', 'users', ['username'], unique=True)

def downgrade():
    op.drop_index('ix_users_username', table_name='users')
```

#### Add Foreign Key

```python
def upgrade():
    op.create_foreign_key(
        'fk_posts_user_id',
        'posts', 'users',
        ['user_id'], ['id']
    )

def downgrade():
    op.drop_constraint('fk_posts_user_id', 'posts', type_='foreignkey')
```

#### Bulk Insert Data

```python
from alembic import op
from sqlalchemy import table, column, Integer, String

def upgrade():
    users_table = table('users',
        column('id', Integer),
        column('username', String),
        column('email', String)
    )

    op.bulk_insert(users_table, [
        {'username': 'admin', 'email': 'admin@example.com'},
        {'username': 'user1', 'email': 'user1@example.com'}
    ])

def downgrade():
    op.execute("DELETE FROM users WHERE username IN ('admin', 'user1')")
```

### Manual Migration (no autogenerate)

```bash
alembic revision -m "add custom change"
```

```python
def upgrade():
    # Write your own SQL or use op commands
    op.execute("UPDATE users SET active = true WHERE created_at < '2024-01-01'")

def downgrade():
    op.execute("UPDATE users SET active = false WHERE created_at < '2024-01-01'")
```

### Common Commands

```bash
# Create new migration
alembic revision -m "description"
alembic revision --autogenerate -m "description"

# Apply migrations
alembic upgrade head              # Latest
alembic upgrade +1                # Next one
alembic upgrade abc123            # Specific revision

# Revert migrations
alembic downgrade -1              # Previous one
alembic downgrade abc123          # Specific revision
alembic downgrade base            # Revert all

# Information
alembic current                   # Current revision
alembic history                   # All revisions
alembic show abc123               # Show specific revision
```

### Best Practices

1. **Always review autogenerated migrations** - They may miss complex changes
2. **Test migrations** - Run upgrade/downgrade before committing
3. **Use version control** - Commit migration files
4. **Write both upgrade and downgrade** - Always reversible
5. **One logical change per migration** - Easier to debug
6. **Add meaningful messages** - Describe what changed
7. **Don't modify existing migrations** - Create new ones instead
8. **Backup database before production migrations**

### Production Workflow

```bash
# 1. Create migration locally
alembic revision --autogenerate -m "add user status field"

# 2. Review the migration file
cat alembic/versions/xxxx_add_user_status_field.py

# 3. Test locally
alembic upgrade head
alembic downgrade -1
alembic upgrade head

# 4. Commit to version control
git add alembic/versions/xxxx_add_user_status_field.py
git commit -m "Add user status field migration"

# 5. Deploy to production
git pull
alembic upgrade head

# 6. If something goes wrong
alembic downgrade -1
```

### Troubleshooting

```bash
# Migration out of sync
alembic stamp head               # Mark current DB as up-to-date

# Show SQL without executing
alembic upgrade head --sql

# Check what would run
alembic upgrade head --sql > migration.sql
cat migration.sql

# Force revision
alembic stamp abc123

# Show pending migrations
alembic current
alembic history --verbose
```

### Example Project Structure

```
project/
├── alembic/
│   ├── versions/
│   │   ├── abc123_create_users_table.py
│   │   └── def456_add_posts_table.py
│   ├── env.py
│   └── script.py.mako
├── alembic.ini
├── models.py
├── database.py
└── main.py
```

### Quick Reference

```bash
alembic init alembic                          # Initialize
alembic revision -m "msg"                     # Manual migration
alembic revision --autogenerate -m "msg"      # Auto migration
alembic upgrade head                          # Apply all
alembic downgrade -1                          # Revert one
alembic current                               # Show current
alembic history                               # Show history
```
