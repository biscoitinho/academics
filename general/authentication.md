# Authentication and Authorization

## Authentication vs Authorization

**Authentication**: Who are you? (Identity verification)
**Authorization**: What can you do? (Permission check)

```
Authentication → Login (username/password)
Authorization → Access control (can user delete post?)
```

## Basic Authentication

### Username/Password

```python
import hashlib

# ❌ NEVER store plain passwords!
users = {
    'alice': 'password123'  # Bad!
}

# ✅ Store hashed passwords
import bcrypt

def hash_password(password):
    return bcrypt.hashpw(password.encode(), bcrypt.gensalt())

def check_password(password, hashed):
    return bcrypt.checkpw(password.encode(), hashed)

# Registration
hashed = hash_password('secret123')
users['alice'] = hashed

# Login
if check_password('secret123', users['alice']):
    print("Authenticated!")
```

```ruby
require 'bcrypt'

# Hash password
hashed = BCrypt::Password.create('secret123')

# Check password
if BCrypt::Password.new(hashed) == 'secret123'
  puts "Authenticated!"
end
```

## Session-Based Authentication

```python
from flask import Flask, session, request, redirect

app = Flask(__name__)
app.secret_key = 'super-secret-key'

users = {
    'alice': hash_password('password123')
}

@app.route('/login', methods=['POST'])
def login():
    username = request.form['username']
    password = request.form['password']

    if username in users and check_password(password, users[username]):
        session['user_id'] = username
        return redirect('/dashboard')
    return 'Invalid credentials', 401

@app.route('/dashboard')
def dashboard():
    if 'user_id' not in session:
        return redirect('/login')
    return f"Welcome {session['user_id']}"

@app.route('/logout')
def logout():
    session.pop('user_id', None)
    return redirect('/login')
```

**How it works:**
```
1. User logs in
2. Server creates session
3. Server sends session ID in cookie
4. Client sends cookie with each request
5. Server validates session
```

## JWT (JSON Web Token)

Self-contained token with claims.

### Structure

```
Header.Payload.Signature

Example:
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.
eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.
SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

### Python JWT

```python
import jwt
import datetime

SECRET_KEY = 'your-secret-key'

# Generate token
def create_token(user_id):
    payload = {
        'user_id': user_id,
        'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=24),
        'iat': datetime.datetime.utcnow()
    }
    token = jwt.encode(payload, SECRET_KEY, algorithm='HS256')
    return token

# Verify token
def verify_token(token):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
        return payload['user_id']
    except jwt.ExpiredSignatureError:
        return None  # Token expired
    except jwt.InvalidTokenError:
        return None  # Invalid token

# Login
@app.route('/api/login', methods=['POST'])
def api_login():
    username = request.json['username']
    password = request.json['password']

    if authenticate(username, password):
        token = create_token(username)
        return {'token': token}
    return {'error': 'Invalid credentials'}, 401

# Protected endpoint
@app.route('/api/profile')
def api_profile():
    token = request.headers.get('Authorization', '').replace('Bearer ', '')
    user_id = verify_token(token)

    if user_id:
        return {'user_id': user_id, 'name': 'Alice'}
    return {'error': 'Unauthorized'}, 401
```

### Ruby JWT

```ruby
require 'jwt'

SECRET_KEY = 'your-secret-key'

# Generate token
def create_token(user_id)
  payload = {
    user_id: user_id,
    exp: Time.now.to_i + 86400,  # 24 hours
    iat: Time.now.to_i
  }
  JWT.encode(payload, SECRET_KEY, 'HS256')
end

# Verify token
def verify_token(token)
  decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })
  decoded[0]['user_id']
rescue JWT::ExpiredSignature
  nil
rescue JWT::DecodeError
  nil
end
```

## OAuth 2.0

Authorization framework for third-party access.

### Flow

```
1. User clicks "Login with Google"
2. Redirect to Google authorization page
3. User approves
4. Google redirects back with authorization code
5. Exchange code for access token
6. Use access token to access Google APIs
```

### Python OAuth (GitHub example)

```python
import requests

CLIENT_ID = 'your-client-id'
CLIENT_SECRET = 'your-client-secret'
REDIRECT_URI = 'http://localhost:5000/callback'

# Step 1: Redirect to GitHub
@app.route('/login/github')
def github_login():
    auth_url = f'https://github.com/login/oauth/authorize?client_id={CLIENT_ID}&redirect_uri={REDIRECT_URI}'
    return redirect(auth_url)

# Step 2: Handle callback
@app.route('/callback')
def github_callback():
    code = request.args.get('code')

    # Step 3: Exchange code for token
    token_url = 'https://github.com/login/oauth/access_token'
    data = {
        'client_id': CLIENT_ID,
        'client_secret': CLIENT_SECRET,
        'code': code
    }
    headers = {'Accept': 'application/json'}
    response = requests.post(token_url, data=data, headers=headers)
    access_token = response.json()['access_token']

    # Step 4: Use token to get user info
    user_url = 'https://api.github.com/user'
    headers = {'Authorization': f'Bearer {access_token}'}
    user_response = requests.get(user_url, headers=headers)
    user = user_response.json()

    # Create session
    session['user_id'] = user['login']
    return redirect('/dashboard')
```

## API Keys

Simple token for API access.

```python
import secrets

# Generate API key
def generate_api_key():
    return secrets.token_urlsafe(32)

api_key = generate_api_key()
print(api_key)  # 'Xj3kR...'

# Store in database
users = {
    'alice': {
        'api_key': hash(api_key),
        'permissions': ['read', 'write']
    }
}

# Validate API key
@app.route('/api/data')
def get_data():
    api_key = request.headers.get('X-API-Key')

    # Find user by API key
    user = find_user_by_api_key(api_key)
    if not user:
        return {'error': 'Invalid API key'}, 401

    return {'data': 'secret data'}
```

## Multi-Factor Authentication (MFA)

Additional verification step.

### TOTP (Time-based One-Time Password)

```python
import pyotp

# Generate secret (once, during setup)
secret = pyotp.random_base32()
print(f"Secret: {secret}")

# Generate QR code for user to scan
totp = pyotp.TOTP(secret)
print(f"Provisioning URI: {totp.provisioning_uri('alice@example.com', issuer_name='MyApp')}")

# Verify code
def verify_totp(user_secret, user_code):
    totp = pyotp.TOTP(user_secret)
    return totp.verify(user_code)

# Login with MFA
@app.route('/login', methods=['POST'])
def login_with_mfa():
    username = request.json['username']
    password = request.json['password']
    totp_code = request.json['totp_code']

    user = authenticate(username, password)
    if not user:
        return {'error': 'Invalid credentials'}, 401

    if not verify_totp(user['totp_secret'], totp_code):
        return {'error': 'Invalid TOTP code'}, 401

    token = create_token(username)
    return {'token': token}
```

## Password Reset

```python
import secrets
import datetime

password_reset_tokens = {}

# Request password reset
@app.route('/forgot-password', methods=['POST'])
def forgot_password():
    email = request.json['email']
    user = find_user_by_email(email)

    if user:
        # Generate reset token
        token = secrets.token_urlsafe(32)
        expires = datetime.datetime.now() + datetime.timedelta(hours=1)

        password_reset_tokens[token] = {
            'user_id': user['id'],
            'expires': expires
        }

        # Send email with reset link
        reset_link = f"https://example.com/reset-password?token={token}"
        send_email(email, f"Reset link: {reset_link}")

    return {'message': 'If email exists, reset link sent'}

# Reset password
@app.route('/reset-password', methods=['POST'])
def reset_password():
    token = request.json['token']
    new_password = request.json['password']

    if token not in password_reset_tokens:
        return {'error': 'Invalid token'}, 400

    reset_data = password_reset_tokens[token]

    if datetime.datetime.now() > reset_data['expires']:
        return {'error': 'Token expired'}, 400

    # Update password
    user_id = reset_data['user_id']
    update_password(user_id, hash_password(new_password))

    # Invalidate token
    del password_reset_tokens[token]

    return {'message': 'Password reset successful'}
```

## Role-Based Access Control (RBAC)

```python
# Define roles and permissions
ROLES = {
    'admin': ['read', 'write', 'delete', 'manage_users'],
    'editor': ['read', 'write'],
    'viewer': ['read']
}

users = {
    'alice': {'role': 'admin'},
    'bob': {'role': 'editor'},
    'charlie': {'role': 'viewer'}
}

# Check permission
def has_permission(user_id, permission):
    user = users.get(user_id)
    if not user:
        return False

    role = user['role']
    return permission in ROLES.get(role, [])

# Decorator for permission check
from functools import wraps

def require_permission(permission):
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            user_id = session.get('user_id')
            if not has_permission(user_id, permission):
                return {'error': 'Forbidden'}, 403
            return f(*args, **kwargs)
        return decorated_function
    return decorator

# Usage
@app.route('/api/delete', methods=['DELETE'])
@require_permission('delete')
def delete_resource():
    return {'message': 'Deleted'}
```

## HTTP Authentication Headers

```python
# Bearer Token (JWT)
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# API Key
X-API-Key: your-api-key

# Basic Auth (base64 encoded username:password)
Authorization: Basic dXNlcm5hbWU6cGFzc3dvcmQ=
```

```python
# Send authenticated request
import requests

# Bearer token
headers = {'Authorization': 'Bearer YOUR_TOKEN'}
response = requests.get('https://api.example.com/data', headers=headers)

# API key
headers = {'X-API-Key': 'YOUR_API_KEY'}
response = requests.get('https://api.example.com/data', headers=headers)

# Basic auth
from requests.auth import HTTPBasicAuth
response = requests.get('https://api.example.com/data',
    auth=HTTPBasicAuth('username', 'password'))
```

## Refresh Tokens

```python
# Generate both access and refresh tokens
def create_tokens(user_id):
    access_token = create_token(user_id, expires_in=15*60)  # 15 min
    refresh_token = secrets.token_urlsafe(32)

    # Store refresh token
    store_refresh_token(user_id, refresh_token)

    return {
        'access_token': access_token,
        'refresh_token': refresh_token
    }

# Refresh access token
@app.route('/api/refresh', methods=['POST'])
def refresh():
    refresh_token = request.json['refresh_token']

    user_id = validate_refresh_token(refresh_token)
    if not user_id:
        return {'error': 'Invalid refresh token'}, 401

    # Generate new access token
    access_token = create_token(user_id, expires_in=15*60)

    return {'access_token': access_token}
```

## Security Best Practices

```python
# 1. Use HTTPS
# Never send credentials over HTTP

# 2. Hash passwords
# Use bcrypt, Argon2, or scrypt

# 3. Set token expiration
token = create_token(user_id, expires_in=3600)  # 1 hour

# 4. Validate input
def is_valid_email(email):
    import re
    pattern = r'^[\w\.-]+@[\w\.-]+\.\w+$'
    return re.match(pattern, email) is not None

# 5. Rate limiting
from flask_limiter import Limiter

limiter = Limiter(app)

@app.route('/login', methods=['POST'])
@limiter.limit("5 per minute")  # Max 5 login attempts
def login():
    pass

# 6. CSRF protection (for session-based auth)
# Use CSRF tokens

# 7. Secure cookies
app.config['SESSION_COOKIE_SECURE'] = True  # HTTPS only
app.config['SESSION_COOKIE_HTTPONLY'] = True  # No JavaScript access
app.config['SESSION_COOKIE_SAMESITE'] = 'Lax'  # CSRF protection

# 8. Store secrets securely
# Use environment variables, not hardcoded
import os
SECRET_KEY = os.environ.get('SECRET_KEY')
```

## Common Vulnerabilities

```python
# 1. SQL Injection
# ❌ Bad
query = f"SELECT * FROM users WHERE username = '{username}'"

# ✅ Good
query = "SELECT * FROM users WHERE username = ?"
cursor.execute(query, (username,))

# 2. Timing attacks
# ❌ Bad: String comparison
if password == stored_password:
    pass

# ✅ Good: Constant-time comparison
import hmac
if hmac.compare_digest(password, stored_password):
    pass

# 3. Brute force
# Solution: Rate limiting, account lockout

# 4. Session fixation
# Solution: Regenerate session ID after login

# 5. XSS (Cross-Site Scripting)
# Solution: Escape user input, use Content-Security-Policy
```

## Token Storage (Client-side)

```javascript
// LocalStorage (vulnerable to XSS)
localStorage.setItem('token', token);

// Secure cookie (HTTPOnly, prevents XSS)
// Set by server:
// Set-Cookie: token=...; HttpOnly; Secure; SameSite=Strict

// Memory (most secure, lost on refresh)
let token = null;

// Best practice:
// - Access token in memory or short-lived cookie
// - Refresh token in HTTPOnly cookie
```

## Single Sign-On (SSO)

```
User logs in once → Access multiple applications

Examples: Google SSO, Okta, Auth0

Protocols: SAML, OAuth 2.0, OpenID Connect
```

## Logout

```python
# Session-based
@app.route('/logout')
def logout():
    session.clear()
    return redirect('/login')

# JWT-based (stateless)
# Client discards token
# Optional: Maintain token blacklist

blacklisted_tokens = set()

@app.route('/logout', methods=['POST'])
def jwt_logout():
    token = get_token_from_header()
    blacklisted_tokens.add(token)
    return {'message': 'Logged out'}

# Verify token is not blacklisted
def verify_token(token):
    if token in blacklisted_tokens:
        return None
    # ... verify JWT
```

## Comparison

```
Session-Based:
  ✅ Easy to invalidate
  ✅ Server controls
  ❌ Server storage needed
  ❌ Not RESTful
  Use: Web apps

JWT:
  ✅ Stateless
  ✅ Scalable
  ✅ Cross-domain
  ❌ Hard to invalidate
  ❌ Token size
  Use: APIs, microservices

OAuth:
  ✅ Third-party access
  ✅ Limited permissions
  ❌ Complex
  Use: Social login, API access

API Keys:
  ✅ Simple
  ✅ Machine-to-machine
  ❌ No expiration (usually)
  ❌ Hard to rotate
  Use: Server-to-server
```
