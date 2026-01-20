# Security Best Practices

## OWASP Top 10

### 1. Injection (SQL, Command, etc.)

```python
# ❌ SQL Injection vulnerability
username = request.form['username']
query = f"SELECT * FROM users WHERE username = '{username}'"
# User input: admin' OR '1'='1

# ✅ Use parameterized queries
cursor.execute("SELECT * FROM users WHERE username = ?", (username,))

# ❌ Command injection
filename = request.args.get('file')
os.system(f'cat {filename}')  # Dangerous!

# ✅ Validate and sanitize
import shlex
filename = shlex.quote(filename)
```

### 2. Broken Authentication

```python
# ✅ Hash passwords
import bcrypt

password = 'secret123'
hashed = bcrypt.hashpw(password.encode(), bcrypt.gensalt())

# Verify
if bcrypt.checkpw(password.encode(), hashed):
    print("Authenticated")

# ✅ Strong password requirements
import re

def is_strong_password(password):
    if len(password) < 8:
        return False
    if not re.search(r'[A-Z]', password):
        return False
    if not re.search(r'[a-z]', password):
        return False
    if not re.search(r'\d', password):
        return False
    return True
```

### 3. Sensitive Data Exposure

```python
# ✅ Use environment variables
import os

SECRET_KEY = os.getenv('SECRET_KEY')
API_KEY = os.getenv('API_KEY')

# ❌ Don't commit secrets
# .env file in .gitignore

# ✅ Encrypt sensitive data
from cryptography.fernet import Fernet

key = Fernet.generate_key()
cipher = Fernet(key)

# Encrypt
encrypted = cipher.encrypt(b"sensitive data")

# Decrypt
decrypted = cipher.decrypt(encrypted)
```

### 4. XML External Entities (XXE)

```python
# ❌ Vulnerable to XXE
import xml.etree.ElementTree as ET
tree = ET.parse(untrusted_xml)

# ✅ Disable external entities
import defusedxml.ElementTree as ET
tree = ET.parse(untrusted_xml)
```

### 5. Broken Access Control

```python
# ❌ Missing authorization check
@app.route('/admin/users')
def admin_users():
    return get_all_users()  # Anyone can access!

# ✅ Check authorization
@app.route('/admin/users')
def admin_users():
    if not current_user.is_admin:
        abort(403)  # Forbidden
    return get_all_users()
```

### 6. Security Misconfiguration

```python
# ✅ Disable debug in production
app.debug = False

# ✅ Set security headers
@app.after_request
def set_security_headers(response):
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-Frame-Options'] = 'DENY'
    response.headers['X-XSS-Protection'] = '1; mode=block'
    response.headers['Strict-Transport-Security'] = 'max-age=31536000'
    return response
```

### 7. Cross-Site Scripting (XSS)

```python
# ❌ XSS vulnerability
user_input = '<script>alert("XSS")</script>'
html = f'<div>{user_input}</div>'  # Dangerous!

# ✅ Escape output
import html
safe_input = html.escape(user_input)
html = f'<div>{safe_input}</div>'

# ✅ Use templating engines (auto-escape)
# Jinja2, Django templates
```

### 8. Insecure Deserialization

```python
# ❌ Dangerous
import pickle
data = pickle.loads(untrusted_data)  # Can execute code!

# ✅ Use JSON
import json
data = json.loads(untrusted_data)  # Safer
```

### 9. Using Components with Known Vulnerabilities

```bash
# Check dependencies
pip install safety
safety check

# Update dependencies
pip list --outdated
pip install --upgrade package
```

### 10. Insufficient Logging & Monitoring

```python
import logging

# Log security events
logging.warning('Failed login attempt', extra={
    'username': username,
    'ip': request.remote_addr
})

# Log successful authentication
logging.info('User logged in', extra={'user_id': user.id})
```

## HTTPS/TLS

```python
# Force HTTPS
@app.before_request
def force_https():
    if not request.is_secure:
        return redirect(request.url.replace('http://', 'https://'))

# Generate self-signed cert (development only)
# openssl req -x509 -newkey rsa:4096 -nodes -out cert.pem -keyout key.pem -days 365

# Run Flask with HTTPS
app.run(ssl_context=('cert.pem', 'key.pem'))
```

## CSRF Protection

```python
# Flask-WTF
from flask_wtf import FlaskForm
from flask_wtf.csrf import CSRFProtect

csrf = CSRFProtect(app)

# Include CSRF token in forms
# {{ form.csrf_token }}
```

## Rate Limiting

```python
from flask_limiter import Limiter

limiter = Limiter(app)

@app.route('/login', methods=['POST'])
@limiter.limit("5 per minute")
def login():
    # Max 5 login attempts per minute
    pass
```

## Input Validation

```python
def validate_email(email):
    import re
    pattern = r'^[\w\.-]+@[\w\.-]+\.\w+$'
    return bool(re.match(pattern, email))

def sanitize_input(user_input):
    # Remove dangerous characters
    return re.sub(r'[<>\'"]', '', user_input)
```

## Secure Cookies

```python
app.config['SESSION_COOKIE_SECURE'] = True  # HTTPS only
app.config['SESSION_COOKIE_HTTPONLY'] = True  # No JavaScript
app.config['SESSION_COOKIE_SAMESITE'] = 'Lax'  # CSRF protection
```

## Content Security Policy

```python
@app.after_request
def set_csp(response):
    response.headers['Content-Security-Policy'] = (
        "default-src 'self'; "
        "script-src 'self' https://trusted.com; "
        "style-src 'self' 'unsafe-inline'"
    )
    return response
```

## API Security

```python
# API Key in header
API_KEY = os.getenv('API_KEY')

@app.before_request
def check_api_key():
    if request.headers.get('X-API-Key') != API_KEY:
        abort(401)

# Rate limiting per API key
# JWT for authentication
# OAuth for authorization
```

## Password Storage

```python
# ✅ Use bcrypt (or Argon2)
import bcrypt

# Hash
password = 'secret123'
salt = bcrypt.gensalt(rounds=12)  # Higher = more secure, slower
hashed = bcrypt.hashpw(password.encode(), salt)

# Verify
if bcrypt.checkpw(input_password.encode(), stored_hash):
    print("Correct password")

# ❌ Never use MD5 or SHA1 for passwords
```

## File Upload Security

```python
from werkzeug.utils import secure_filename
import os

ALLOWED_EXTENSIONS = {'txt', 'pdf', 'png', 'jpg'}

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/upload', methods=['POST'])
def upload():
    file = request.files['file']

    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        file.save(os.path.join(UPLOAD_FOLDER, filename))
    else:
        return "Invalid file type", 400
```

## Database Security

```python
# ✅ Least privilege principle
# CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'password';
# GRANT SELECT, INSERT, UPDATE ON mydb.* TO 'app_user'@'localhost';

# ✅ Connection encryption
# Use SSL/TLS for database connections

# ✅ Backup encryption
# Encrypt database backups
```

## Secrets Management

```bash
# Use environment variables
export SECRET_KEY='...'

# Or use secret management services
# AWS Secrets Manager
# HashiCorp Vault
# Azure Key Vault
```

```python
# Load from .env file (not committed)
from dotenv import load_dotenv
load_dotenv()

SECRET_KEY = os.getenv('SECRET_KEY')
```

## Security Checklist

```
✅ Use HTTPS everywhere
✅ Validate all input
✅ Escape all output
✅ Use parameterized queries
✅ Hash passwords with bcrypt/Argon2
✅ Implement rate limiting
✅ Use CSRF protection
✅ Set security headers
✅ Keep dependencies updated
✅ Log security events
✅ Use environment variables for secrets
✅ Implement proper authentication
✅ Use least privilege principle
✅ Encrypt sensitive data
✅ Regular security audits
```

## Security Testing

```python
# Test for SQL injection
test_inputs = ["admin' OR '1'='1", "1'; DROP TABLE users--"]

# Test for XSS
test_inputs = ["<script>alert('XSS')</script>", "<img src=x onerror=alert('XSS')>"]

# Use security scanners
# OWASP ZAP
# Burp Suite
# Nikto
```

## Common Vulnerabilities

```python
# Path traversal
# ❌
filename = request.args.get('file')
with open(filename) as f:  # User input: ../../etc/passwd
    pass

# ✅
import os
filename = os.path.basename(filename)

# Open redirect
# ❌
return redirect(request.args.get('next'))  # User: http://evil.com

# ✅
from urllib.parse import urlparse
next_url = request.args.get('next')
if urlparse(next_url).netloc:
    abort(400)  # External URL not allowed
```
