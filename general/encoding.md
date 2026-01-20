# Encoding

## Character Encoding

### ASCII

- 7-bit encoding (128 characters)
- English letters, digits, punctuation
- 0-127

```python
# Character to ASCII
print(ord('A'))  # 65
print(ord('a'))  # 97
print(ord('0'))  # 48

# ASCII to character
print(chr(65))   # 'A'
print(chr(97))   # 'a'
```

```ruby
# Character to ASCII
puts 'A'.ord  # 65

# ASCII to character
puts 65.chr   # 'A'
```

### UTF-8

- Variable-length encoding (1-4 bytes)
- Backwards compatible with ASCII
- Supports all Unicode characters
- Most common on web

```python
# String to bytes (UTF-8)
s = "Hello 世界"
b = s.encode('utf-8')
print(b)  # b'Hello \xe4\xb8\x96\xe7\x95\x8c'

# Bytes to string
s = b.decode('utf-8')
print(s)  # "Hello 世界"

# Character code point
print(ord('世'))  # 19990

# Code point to character
print(chr(19990))  # '世'
```

```ruby
# String to bytes
s = "Hello 世界"
b = s.encode('UTF-8')
puts b.inspect

# Bytes to string
s = b.force_encoding('UTF-8')
puts s

# Character code
puts '世'.ord  # 19990
```

### UTF-16, UTF-32

```python
# UTF-16
s = "Hello"
b = s.encode('utf-16')
print(b)  # b'\xff\xfeH\x00e\x00l\x00l\x00o\x00'

# UTF-32
b = s.encode('utf-32')
print(b)  # b'\xff\xfe\x00\x00H\x00\x00\x00...'

# UTF-32 uses 4 bytes per character (fixed width)
```

### Encoding Errors

```python
# Strict (default) - raises error
try:
    b = "café".encode('ascii')
except UnicodeEncodeError as e:
    print("Error:", e)

# Ignore - skip invalid characters
b = "café".encode('ascii', errors='ignore')
print(b)  # b'caf'

# Replace - use ? for invalid
b = "café".encode('ascii', errors='replace')
print(b)  # b'caf?'

# xmlcharrefreplace - use XML entities
b = "café".encode('ascii', errors='xmlcharrefreplace')
print(b)  # b'caf&#233;'
```

## Base64

Encode binary data as ASCII text.

```python
import base64

# Encode
text = "Hello World"
encoded = base64.b64encode(text.encode())
print(encoded)  # b'SGVsbG8gV29ybGQ='

# Decode
decoded = base64.b64decode(encoded)
print(decoded.decode())  # "Hello World"

# URL-safe Base64 (replaces +/ with -_)
encoded = base64.urlsafe_b64encode(text.encode())
print(encoded)  # b'SGVsbG8gV29ybGQ='
```

```ruby
require 'base64'

# Encode
text = "Hello World"
encoded = Base64.encode64(text)
puts encoded  # SGVsbG8gV29ybGQ=\n

# Decode
decoded = Base64.decode64(encoded)
puts decoded  # Hello World

# URL-safe
encoded = Base64.urlsafe_encode64(text)
```

**Use cases:**
- Email attachments (MIME)
- Embedding images in HTML/CSS
- JWT tokens
- API authentication

**Example: Data URI**
```html
<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA..." />
```

## URL Encoding (Percent Encoding)

Encode special characters in URLs.

```python
from urllib.parse import quote, unquote

# Encode
text = "Hello World!"
encoded = quote(text)
print(encoded)  # 'Hello%20World%21'

# Decode
decoded = unquote(encoded)
print(decoded)  # "Hello World!"

# Full URL
from urllib.parse import urlencode

params = {'name': 'John Doe', 'age': 30}
query_string = urlencode(params)
print(query_string)  # 'name=John+Doe&age=30'

url = f'https://example.com/search?{query_string}'
print(url)  # https://example.com/search?name=John+Doe&age=30
```

```ruby
require 'uri'

# Encode
text = "Hello World!"
encoded = URI.encode_www_form_component(text)
puts encoded  # Hello+World%21

# Decode
decoded = URI.decode_www_form_component(encoded)
puts decoded  # Hello World!
```

**Special characters:**
```
Space:  %20 or +
!:      %21
":      %22
#:      %23
$:      %24
%:      %25
&:      %26
```

## HTML Encoding

Escape HTML special characters.

```python
import html

# Encode
text = '<script>alert("XSS")</script>'
encoded = html.escape(text)
print(encoded)  # &lt;script&gt;alert(&quot;XSS&quot;)&lt;/script&gt;

# Decode
decoded = html.unescape(encoded)
print(decoded)  # <script>alert("XSS")</script>
```

```ruby
require 'cgi'

# Encode
text = '<script>alert("XSS")</script>'
encoded = CGI.escapeHTML(text)
puts encoded  # &lt;script&gt;alert(&quot;XSS&quot;)&lt;/script&gt;

# Decode
decoded = CGI.unescapeHTML(encoded)
puts decoded
```

**HTML entities:**
```
<   → &lt;
>   → &gt;
&   → &amp;
"   → &quot;
'   → &#39; or &apos;
```

## JSON Encoding

```python
import json

# Encode
data = {'name': 'Alice', 'age': 30, 'active': True}
json_str = json.dumps(data)
print(json_str)  # '{"name": "Alice", "age": 30, "active": true}'

# Decode
data = json.loads(json_str)
print(data)  # {'name': 'Alice', 'age': 30, 'active': True}

# Pretty print
json_str = json.dumps(data, indent=2)
print(json_str)
# {
#   "name": "Alice",
#   "age": 30,
#   "active": true
# }

# Handle special characters
data = {'text': 'Line 1\nLine 2\tTabbed'}
json_str = json.dumps(data)
print(json_str)  # {"text": "Line 1\nLine 2\tTabbed"}
```

```ruby
require 'json'

# Encode
data = {name: 'Alice', age: 30, active: true}
json_str = JSON.generate(data)
puts json_str  # {"name":"Alice","age":30,"active":true}

# Decode
data = JSON.parse(json_str)
puts data['name']  # Alice

# Pretty print
json_str = JSON.pretty_generate(data)
puts json_str
```

## Hex Encoding

```python
# String to hex
text = "Hello"
hex_str = text.encode().hex()
print(hex_str)  # '48656c6c6f'

# Hex to string
text = bytes.fromhex(hex_str).decode()
print(text)  # "Hello"

# Number to hex
n = 255
hex_str = hex(n)
print(hex_str)  # '0xff'

# Hex to number
n = int('ff', 16)
print(n)  # 255
```

```ruby
# String to hex
text = "Hello"
hex_str = text.unpack1('H*')
puts hex_str  # 48656c6c6f

# Hex to string
text = [hex_str].pack('H*')
puts text  # Hello

# Number to hex
n = 255
hex_str = n.to_s(16)
puts hex_str  # ff
```

## Binary Encoding

```python
# Number to binary
n = 10
binary = bin(n)
print(binary)  # '0b1010'

# Binary to number
n = int('1010', 2)
print(n)  # 10

# Bytes
data = bytes([255, 0, 128])
print(data)  # b'\xff\x00\x80'

# Bit manipulation
a = 0b1010  # 10
b = 0b1100  # 12

print(bin(a & b))  # 0b1000 (AND)
print(bin(a | b))  # 0b1110 (OR)
print(bin(a ^ b))  # 0b0110 (XOR)
print(bin(~a & 0xFF))  # 0b11110101 (NOT)
```

## Caesar Cipher (Simple Example)

```python
def caesar_cipher(text, shift):
    result = ""
    for char in text:
        if char.isalpha():
            start = ord('A') if char.isupper() else ord('a')
            shifted = (ord(char) - start + shift) % 26
            result += chr(start + shifted)
        else:
            result += char
    return result

# Encrypt
encrypted = caesar_cipher("HELLO", 3)
print(encrypted)  # "KHOOR"

# Decrypt
decrypted = caesar_cipher(encrypted, -3)
print(decrypted)  # "HELLO"
```

## Hashing (One-way Encoding)

```python
import hashlib

# MD5 (not secure, for checksums only)
text = "Hello World"
md5 = hashlib.md5(text.encode()).hexdigest()
print(md5)  # b10a8db164e0754105b7a99be72e3fe5

# SHA256 (secure)
sha256 = hashlib.sha256(text.encode()).hexdigest()
print(sha256)  # a591a6d40bf420404a011733cfb7b190d62c65bf0bcda32b57b277d9ad9f146e

# SHA512
sha512 = hashlib.sha512(text.encode()).hexdigest()
print(sha512[:64])  # 2c74fd...
```

**Note:** Hashing is NOT encryption (can't be reversed).

## Compression

```python
import zlib

# Compress
text = "Hello World " * 100
compressed = zlib.compress(text.encode())
print(f"Original: {len(text)} bytes")
print(f"Compressed: {len(compressed)} bytes")

# Decompress
decompressed = zlib.decompress(compressed).decode()
print(decompressed[:50])

# gzip
import gzip

compressed = gzip.compress(text.encode())
decompressed = gzip.decompress(compressed).decode()
```

```ruby
require 'zlib'

# Compress
text = "Hello World " * 100
compressed = Zlib::Deflate.deflate(text)
puts "Original: #{text.bytesize} bytes"
puts "Compressed: #{compressed.bytesize} bytes"

# Decompress
decompressed = Zlib::Inflate.inflate(compressed)
puts decompressed[0..50]
```

## ROT13

```python
import codecs

# Encode
text = "Hello World"
encoded = codecs.encode(text, 'rot_13')
print(encoded)  # "Uryyb Jbeyq"

# Decode (same operation)
decoded = codecs.decode(encoded, 'rot_13')
print(decoded)  # "Hello World"
```

## Escape Sequences

```python
# Common escape sequences
print("Line 1\nLine 2")      # Newline
print("Tab\there")           # Tab
print("Quote: \"Hello\"")    # Quote
print("Path: C:\\Users")     # Backslash
print("Null: \0")            # Null character
print("Bell: \a")            # Alert/bell

# Raw string (no escaping)
print(r"C:\Users\name")      # C:\Users\name
```

## Unicode Normalization

```python
import unicodedata

# Different representations of "café"
s1 = "café"  # é as single character
s2 = "café"  # e + combining accent

print(len(s1), len(s2))  # Might differ

# Normalize
n1 = unicodedata.normalize('NFC', s1)  # Composed
n2 = unicodedata.normalize('NFD', s1)  # Decomposed

print(n1 == n2)  # False
print(len(n1), len(n2))  # Different lengths
```

## Encoding Detection

```python
import chardet

# Detect encoding
with open('file.txt', 'rb') as f:
    raw_data = f.read()
    result = chardet.detect(raw_data)
    encoding = result['encoding']
    print(f"Detected: {encoding}")

# Read with detected encoding
with open('file.txt', 'r', encoding=encoding) as f:
    content = f.read()
```

## Practical Examples

### Encode/Decode JWT-like Token

```python
import base64
import json

# Create token
header = {'alg': 'HS256', 'typ': 'JWT'}
payload = {'user_id': 123, 'exp': 1234567890}

# Encode
header_b64 = base64.urlsafe_b64encode(json.dumps(header).encode()).decode().rstrip('=')
payload_b64 = base64.urlsafe_b64encode(json.dumps(payload).encode()).decode().rstrip('=')

token = f"{header_b64}.{payload_b64}.signature"
print(token)

# Decode
parts = token.split('.')
header_json = base64.urlsafe_b64decode(parts[0] + '==').decode()
payload_json = base64.urlsafe_b64decode(parts[1] + '==').decode()

print(json.loads(header_json))
print(json.loads(payload_json))
```

### Safe Filename

```python
import re

def safe_filename(filename):
    # Remove/replace unsafe characters
    filename = re.sub(r'[^\w\s.-]', '', filename)
    filename = filename.replace(' ', '_')
    return filename

print(safe_filename("My Document (v2).pdf"))  # My_Document_v2.pdf
print(safe_filename("../../../etc/passwd"))    # etcpasswd
```

### Encode for SQL

```python
# ❌ NEVER do this (SQL injection risk)
query = f"SELECT * FROM users WHERE name = '{user_input}'"

# ✅ Use parameterized queries
query = "SELECT * FROM users WHERE name = ?"
cursor.execute(query, (user_input,))

# ✅ Or escape (not recommended, use parameterized instead)
import sqlite3
escaped = user_input.replace("'", "''")
```

## Common Encoding Issues

```python
# 1. Mixing bytes and strings
# ❌ Error
text = "Hello"
result = text + b" World"  # TypeError

# ✅ Fix
result = text + " World"
# or
result = text.encode() + b" World"

# 2. Wrong encoding
# ❌ Mojibake (garbled text)
text = "café"
wrong = text.encode('utf-8').decode('latin-1')
print(wrong)  # café (wrong!)

# ✅ Correct
correct = text.encode('utf-8').decode('utf-8')
print(correct)  # café

# 3. BOM (Byte Order Mark)
# Some UTF-8 files start with BOM (\ufeff)
with open('file.txt', 'r', encoding='utf-8-sig') as f:
    content = f.read()  # Removes BOM
```

## Encoding for Different Contexts

```python
# URL parameters
from urllib.parse import quote
param = quote("hello world")  # hello%20world

# HTML
import html
safe = html.escape("<script>")  # &lt;script&gt;

# JSON
import json
data = json.dumps({"key": "value"})  # '{"key": "value"}'

# SQL (use parameterized queries!)
# Don't manually encode

# Shell command (use shlex)
import shlex
cmd = shlex.quote("user input")

# Regex
import re
pattern = re.escape("user.*input")  # user\.\*input
```

## Best Practices

```python
# 1. Always specify encoding
with open('file.txt', 'r', encoding='utf-8') as f:
    content = f.read()

# 2. Use UTF-8 by default
# Most compatible and widely used

# 3. Handle encoding errors
try:
    text = bytes_data.decode('utf-8')
except UnicodeDecodeError:
    text = bytes_data.decode('utf-8', errors='replace')

# 4. Don't double-encode
# Encode once, decode once

# 5. Validate user input
# Check encoding before processing

# 6. Use appropriate encoding for context
# HTML: HTML entities
# URL: Percent encoding
# JSON: JSON encoding
# SQL: Parameterized queries
```
