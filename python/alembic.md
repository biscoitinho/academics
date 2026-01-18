## Alembic - Database Migrations

Database migration tool for SQLAlchemy to manage schema changes.

### Setup

```bash
pip install alembic sqlalchemy

# Initialize
alembic init alembic
```

### Configuration

```python
# alembic.ini
sqlalchemy.url = postgresql://user:password@localhost/dbname

# alembic/env.py - Link models
from models import Base
target_metadata = Base.metadata
```

### Create Migration

```bash
# Auto-generate from model changes
alembic revision --autogenerate -m "create users table"

# Manual migration
alembic revision -m "add column"
```

### Migration File

```python
"""create users table"""
from alembic import op
import sqlalchemy as sa

revision = 'abc123'
down_revision = None

def upgrade():
    op.create_table(
        'users',
        sa.Column('id', sa.Integer(), primary_key=True),
        sa.Column('username', sa.String(50), nullable=False),
        sa.Column('email', sa.String(100), nullable=False)
    )

def downgrade():
    op.drop_table('users')
```

### Apply Migrations

```bash
alembic upgrade head        # Latest
alembic upgrade +1          # Next one
alembic downgrade -1        # Previous
alembic current             # Show current
alembic history             # List all
```

### Common Operations

```python
# Add column
def upgrade():
    op.add_column('users', sa.Column('age', sa.Integer()))

# Drop column
def upgrade():
    op.drop_column('users', 'age')

# Modify column
def upgrade():
    op.alter_column('users', 'email', type_=sa.String(200))

# Add index
def upgrade():
    op.create_index('ix_users_email', 'users', ['email'])

# Add foreign key
def upgrade():
    op.create_foreign_key('fk_posts_user', 'posts', 'users', ['user_id'], ['id'])

# Insert data
def upgrade():
    from sqlalchemy import table, column
    users = table('users', column('username'), column('email'))
    op.bulk_insert(users, [
        {'username': 'admin', 'email': 'admin@example.com'}
    ])
```

### Production Workflow

```bash
# 1. Create migration
alembic revision --autogenerate -m "add status field"

# 2. Review generated file
cat alembic/versions/xxxx_add_status_field.py

# 3. Test locally
alembic upgrade head
alembic downgrade -1
alembic upgrade head

# 4. Deploy
git push
alembic upgrade head

# 5. Rollback if needed
alembic downgrade -1
```

### Troubleshooting

```bash
# Mark DB as current
alembic stamp head

# Show SQL without running
alembic upgrade head --sql

# Force specific revision
alembic stamp abc123
```
