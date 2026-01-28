# Cryptography Basics

Fundamentals of secure communication and data protection.

## Hashing

**One-way function** - can't reverse to get original input.

```python
import hashlib

# SHA-256
hash = hashlib.sha256(b"password123").hexdigest()
# Output: ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f

# Same input = same hash
hash2 = hashlib.sha256(b"password123").hexdigest()
# hash == hash2 (always!)

# Different input = different hash
hash3 = hashlib.sha256(b"password124").hexdigest()
# hash != hash3
```

```ruby
require 'digest'

hash = Digest::SHA256.hexdigest('password123')
# Same output as Python
```

**Use cases**:
- Password storage
- File integrity checking
- Digital signatures
- Git commits

**Common algorithms**:
- MD5 (broken, don't use for security)
- SHA-1 (deprecated)
- SHA-256, SHA-512 (good)
- bcrypt, scrypt, Argon2 (for passwords)

### Password Hashing

```python
import bcrypt

# Hash password (includes salt automatically)
password = b"secret123"
hashed = bcrypt.hashpw(password, bcrypt.gensalt())

# Verify password
if bcrypt.checkpw(password, hashed):
    print("Correct!")
```

**Why bcrypt?** Slow by design, resistant to brute force.

## Encryption

**Two-way** - can decrypt back to original.

### Symmetric Encryption

**Same key** for encryption and decryption.

```python
from cryptography.fernet import Fernet

# Generate key
key = Fernet.generate_key()
cipher = Fernet(key)

# Encrypt
message = b"Secret message"
encrypted = cipher.encrypt(message)

# Decrypt
decrypted = cipher.decrypt(encrypted)
# decrypted == message
```

**Algorithms**: AES, ChaCha20
**Use case**: Encrypting files, database fields

**Problem**: How to share the key securely?

### Asymmetric Encryption (Public-Key)

**Two keys**: public (encrypt) and private (decrypt).

```python
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import serialization

# Generate keypair
private_key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
public_key = private_key.public_key()

# Encrypt with public key
from cryptography.hazmat.primitives.asymmetric import padding
encrypted = public_key.encrypt(b"Secret", padding.OAEP(...))

# Decrypt with private key
decrypted = private_key.decrypt(encrypted, padding.OAEP(...))
```

**Algorithms**: RSA, ECC
**Use case**: SSL/TLS, SSH, PGP email

## Digital Signatures

**Prove message came from sender, wasn't modified**.

```python
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives import hashes

# Sign with private key
message = b"I owe you $100"
signature = private_key.sign(
    message,
    padding.PSS(...),
    hashes.SHA256()
)

# Verify with public key
try:
    public_key.verify(
        signature,
        message,
        padding.PSS(...),
        hashes.SHA256()
    )
    print("Signature valid!")
except:
    print("Signature invalid!")
```

**Use cases**: Software updates, blockchain, legal documents

## SSL/TLS

**Secure web communication** (HTTPS).

```
1. Client: "Hello, let's talk securely"
2. Server: "Here's my certificate and public key"
3. Client: Verifies certificate with CA
4. Client: Generates session key, encrypts with server's public key
5. Server: Decrypts with private key
6. Both: Use session key for symmetric encryption (fast)
```

**Why hybrid?** Asymmetric is slow, symmetric is fast.

## Certificates

**Prove server identity**.

```
Certificate contains:
- Domain name (example.com)
- Public key
- Signature from Certificate Authority (CA)

Browser trusts CA, CA vouches for server.
```

**Let's Encrypt**: Free SSL certificates

## JWT (JSON Web Tokens)

**Signed data for authentication**.

```python
import jwt

# Create token
payload = {"user_id": 123, "exp": 1234567890}
token = jwt.encode(payload, "secret_key", algorithm="HS256")

# Verify token
decoded = jwt.decode(token, "secret_key", algorithms=["HS256"])
# decoded == payload
```

**Structure**: `header.payload.signature`

**Use case**: API authentication, single sign-on

## Common Attacks

### Brute Force
Try all possible keys/passwords.

**Defense**: Strong passwords, rate limiting, slow hashing (bcrypt)

### Rainbow Tables
Precomputed hashes for common passwords.

**Defense**: Salt (random data added to password)

```python
# With salt
salt = os.urandom(16)
hash = hashlib.pbkdf2_hmac('sha256', password, salt, 100000)
```

### Man-in-the-Middle (MITM)
Intercept communication.

**Defense**: SSL/TLS, certificate pinning

### Replay Attack
Reuse valid message.

**Defense**: Nonce (number used once), timestamps

## Best Practices

✅ **Use proven libraries** - Don't roll your own crypto
✅ **Use bcrypt/scrypt for passwords** - Not plain SHA-256
✅ **Add salt** - Prevent rainbow table attacks
✅ **Use HTTPS** - Encrypt data in transit
✅ **Keep keys secret** - Never commit to git
✅ **Rotate keys** - Change periodically
✅ **Use strong passwords** - Long and random

❌ **Don't use MD5/SHA-1 for security** - Broken
❌ **Don't store plaintext passwords** - Always hash
❌ **Don't use same key for everything** - Separate keys
❌ **Don't trust user input** - Validate and sanitize

## Key Storage

```python
# Environment variable
import os
secret_key = os.environ['SECRET_KEY']

# Config file (not in git!)
with open('config.secret') as f:
    secret_key = f.read()

# Key management service
from aws_secretsmanager import get_secret
secret_key = get_secret('my-app/secret-key')
```

## Common Use Cases

### Password Storage
```python
import bcrypt

# Registration
hashed = bcrypt.hashpw(password.encode(), bcrypt.gensalt())
db.save(user, hashed)

# Login
stored_hash = db.get_password(user)
if bcrypt.checkpw(password.encode(), stored_hash):
    login_success()
```

### File Encryption
```python
from cryptography.fernet import Fernet

# Encrypt file
key = Fernet.generate_key()
cipher = Fernet(key)

with open('secret.txt', 'rb') as f:
    data = f.read()

encrypted = cipher.encrypt(data)

with open('secret.txt.enc', 'wb') as f:
    f.write(encrypted)
```

### API Token
```python
import secrets

# Generate secure random token
token = secrets.token_urlsafe(32)
# Example: 'xvK8Q2_zN7JGM4pR3wLqBnC1dFaE5gHi'
```

## Key Takeaways

1. **Hashing** - One-way, for passwords and integrity
2. **Symmetric encryption** - Fast, same key for encrypt/decrypt
3. **Asymmetric encryption** - Public key encrypts, private key decrypts
4. **Digital signatures** - Prove authenticity
5. **SSL/TLS** - Secure web communication
6. **Use libraries** - Don't implement crypto yourself
7. **Salt passwords** - Prevent rainbow tables
8. **HTTPS everywhere** - Encrypt data in transit

**Remember**: Cryptography is hard. Use battle-tested libraries, follow best practices!
