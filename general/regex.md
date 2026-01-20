# Regular Expressions (Regex)

## Basics

Pattern matching for strings.

```python
import re

# Match
result = re.match(r'hello', 'hello world')
print(result)  # <re.Match object>

# Search (finds first occurrence)
result = re.search(r'world', 'hello world')
print(result.group())  # 'world'

# Find all
results = re.findall(r'\d+', 'I have 2 cats and 3 dogs')
print(results)  # ['2', '3']

# Replace
text = re.sub(r'\d+', 'X', 'I have 2 cats')
print(text)  # 'I have X cats'
```

```ruby
# Match
result = /hello/.match('hello world')
puts result  # hello

# Search
text = 'hello world'
if text =~ /world/
  puts "Found!"
end

# Find all
results = 'I have 2 cats and 3 dogs'.scan(/\d+/)
puts results.inspect  # ["2", "3"]

# Replace
text = 'I have 2 cats'.gsub(/\d+/, 'X')
puts text  # I have X cats
```

## Special Characters

```
.   - Any character (except newline)
^   - Start of string
$   - End of string
*   - 0 or more
+   - 1 or more
?   - 0 or 1
\   - Escape special character
|   - OR
()  - Group
[]  - Character set
{}  - Quantifier
```

## Character Classes

```python
import re

# Digits
print(re.findall(r'\d', 'abc123'))  # ['1', '2', '3']
print(re.findall(r'\D', 'abc123'))  # ['a', 'b', 'c']

# Word characters (a-z, A-Z, 0-9, _)
print(re.findall(r'\w+', 'hello world'))  # ['hello', 'world']
print(re.findall(r'\W+', 'hello world'))  # [' ']

# Whitespace
print(re.findall(r'\s+', 'hello world'))  # [' ']
print(re.findall(r'\S+', 'hello world'))  # ['hello', 'world']

# Custom character set
print(re.findall(r'[aeiou]', 'hello'))  # ['e', 'o']
print(re.findall(r'[^aeiou]', 'hello'))  # ['h', 'l', 'l'] (not vowels)

# Range
print(re.findall(r'[a-z]+', 'Hello123'))  # ['ello']
print(re.findall(r'[A-Z]+', 'Hello123'))  # ['H']
print(re.findall(r'[0-9]+', 'Hello123'))  # ['123']
```

## Quantifiers

```python
# * - 0 or more
print(re.findall(r'ab*', 'a ab abb abbb'))  # ['a', 'ab', 'abb', 'abbb']

# + - 1 or more
print(re.findall(r'ab+', 'a ab abb abbb'))  # ['ab', 'abb', 'abbb']

# ? - 0 or 1
print(re.findall(r'ab?', 'a ab abb'))  # ['a', 'ab', 'ab']

# {n} - Exactly n
print(re.findall(r'a{3}', 'aa aaa aaaa'))  # ['aaa', 'aaa']

# {n,} - n or more
print(re.findall(r'a{2,}', 'a aa aaa'))  # ['aa', 'aaa']

# {n,m} - Between n and m
print(re.findall(r'a{2,3}', 'a aa aaa aaaa'))  # ['aa', 'aaa', 'aaa']
```

## Anchors

```python
# ^ - Start of string
print(re.search(r'^hello', 'hello world'))  # Match
print(re.search(r'^world', 'hello world'))  # None

# $ - End of string
print(re.search(r'world$', 'hello world'))  # Match
print(re.search(r'hello$', 'hello world'))  # None

# \b - Word boundary
print(re.findall(r'\bcat\b', 'cat catfish scatter'))  # ['cat']

# \B - Not word boundary
print(re.findall(r'\Bcat\B', 'cat catfish scatter'))  # []
```

## Groups

```python
# Capture groups
match = re.search(r'(\d+)-(\d+)-(\d+)', '2024-01-15')
print(match.group(0))  # '2024-01-15' (full match)
print(match.group(1))  # '2024' (first group)
print(match.group(2))  # '01' (second group)
print(match.group(3))  # '15' (third group)

# Named groups
match = re.search(r'(?P<year>\d+)-(?P<month>\d+)-(?P<day>\d+)', '2024-01-15')
print(match.group('year'))   # '2024'
print(match.group('month'))  # '01'
print(match.group('day'))    # '15'

# Non-capturing group
match = re.search(r'(?:Mr|Mrs|Ms) (\w+)', 'Mrs Smith')
print(match.group(1))  # 'Smith' (only named group captured)
```

```ruby
# Capture groups
match = /(\d+)-(\d+)-(\d+)/.match('2024-01-15')
puts match[0]  # 2024-01-15
puts match[1]  # 2024
puts match[2]  # 01
puts match[3]  # 15

# Named groups
match = /(?<year>\d+)-(?<month>\d+)-(?<day>\d+)/.match('2024-01-15')
puts match[:year]   # 2024
puts match[:month]  # 01
puts match[:day]    # 15
```

## OR

```python
# | - OR operator
print(re.findall(r'cat|dog', 'I have a cat and a dog'))  # ['cat', 'dog']

# Group with OR
print(re.findall(r'(Mr|Mrs|Ms) \w+', 'Mr Smith and Mrs Jones'))
# ['Mr', 'Mrs']
```

## Lookahead / Lookbehind

```python
# Positive lookahead (?=...)
# Match if followed by pattern
print(re.findall(r'\d+(?= dollars)', '100 dollars and 50 euros'))
# ['100']

# Negative lookahead (?!...)
# Match if NOT followed by pattern
print(re.findall(r'\d+(?! dollars)', '100 dollars and 50 euros'))
# ['10', '5'] (50 and 100's 0)

# Positive lookbehind (?<=...)
# Match if preceded by pattern
print(re.findall(r'(?<=\$)\d+', 'Price: $100'))
# ['100']

# Negative lookbehind (?<!...)
# Match if NOT preceded by pattern
print(re.findall(r'(?<!\$)\d+', 'Price: $100 and 50 items'))
# ['00', '50']
```

## Flags

```python
# Case insensitive
print(re.findall(r'hello', 'HELLO Hello hello', re.IGNORECASE))
# ['HELLO', 'Hello', 'hello']

# Multiline (^ and $ match line start/end)
text = 'line1\nline2\nline3'
print(re.findall(r'^line', text, re.MULTILINE))
# ['line', 'line', 'line']

# Dot matches newline
text = 'hello\nworld'
print(re.findall(r'hello.world', text, re.DOTALL))
# ['hello\nworld']

# Verbose (allow comments and whitespace)
pattern = re.compile(r'''
    \d{3}  # Area code
    -
    \d{3}  # Prefix
    -
    \d{4}  # Line number
''', re.VERBOSE)
print(pattern.findall('Call 555-123-4567'))  # ['555-123-4567']
```

```ruby
# Case insensitive
puts 'HELLO Hello hello'.scan(/hello/i).inspect
# ["HELLO", "Hello", "hello"]

# Multiline
text = "line1\nline2\nline3"
puts text.scan(/^line/m).inspect

# Extended (verbose)
pattern = /
  \d{3}  # Area code
  -
  \d{3}  # Prefix
  -
  \d{4}  # Line number
/x
```

## Common Patterns

### Email

```python
email_pattern = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'

emails = re.findall(email_pattern, 'Contact: john@example.com or jane@test.org')
print(emails)  # ['john@example.com', 'jane@test.org']
```

### Phone Number

```python
# US phone: (123) 456-7890 or 123-456-7890
phone_pattern = r'\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}'

phones = re.findall(phone_pattern, 'Call (555) 123-4567 or 555-987-6543')
print(phones)  # ['(555) 123-4567', '555-987-6543']
```

### URL

```python
url_pattern = r'https?://[^\s]+'

urls = re.findall(url_pattern, 'Visit https://example.com or http://test.org')
print(urls)  # ['https://example.com', 'http://test.org']
```

### Date

```python
# YYYY-MM-DD
date_pattern = r'\d{4}-\d{2}-\d{2}'

dates = re.findall(date_pattern, 'Born on 1990-05-15 and moved 2010-12-25')
print(dates)  # ['1990-05-15', '2010-12-25']
```

### IP Address

```python
ip_pattern = r'\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'

ips = re.findall(ip_pattern, 'Server: 192.168.1.1 and 10.0.0.1')
print(ips)  # ['192.168.1.1', '10.0.0.1']
```

### Credit Card

```python
# Simple pattern (check luhn algorithm separately)
card_pattern = r'\b\d{4}[-\s]?\d{4}[-\s]?\d{4}[-\s]?\d{4}\b'

cards = re.findall(card_pattern, 'Card: 1234-5678-9012-3456')
print(cards)  # ['1234-5678-9012-3456']
```

### Username

```python
# Alphanumeric, 3-16 characters
username_pattern = r'^[a-zA-Z0-9_]{3,16}$'

print(bool(re.match(username_pattern, 'john_doe')))  # True
print(bool(re.match(username_pattern, 'ab')))  # False (too short)
```

### Password Strength

```python
# At least 8 chars, 1 uppercase, 1 lowercase, 1 digit, 1 special
password_pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$'

print(bool(re.match(password_pattern, 'Pass123!')))  # True
print(bool(re.match(password_pattern, 'password')))  # False
```

### HTML Tags

```python
# Extract text between tags
html = '<p>Hello</p><div>World</div>'
text = re.findall(r'<[^>]+>([^<]+)</[^>]+>', html)
print(text)  # ['Hello', 'World']

# Remove HTML tags
clean = re.sub(r'<[^>]+>', '', html)
print(clean)  # 'HelloWorld'
```

## Validation

```python
def validate_email(email):
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return bool(re.match(pattern, email))

print(validate_email('test@example.com'))  # True
print(validate_email('invalid-email'))  # False

def validate_phone(phone):
    pattern = r'^\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}$'
    return bool(re.match(pattern, phone))

print(validate_phone('(555) 123-4567'))  # True
print(validate_phone('123'))  # False
```

```ruby
def validate_email(email)
  pattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/
  !pattern.match(email).nil?
end

puts validate_email('test@example.com')  # true
puts validate_email('invalid')  # false
```

## Extract and Transform

```python
# Extract domain from email
def get_domain(email):
    match = re.search(r'@([a-zA-Z0-9.-]+)', email)
    return match.group(1) if match else None

print(get_domain('john@example.com'))  # 'example.com'

# Convert phone format
def format_phone(phone):
    digits = re.sub(r'\D', '', phone)
    if len(digits) == 10:
        return f'({digits[:3]}) {digits[3:6]}-{digits[6:]}'
    return phone

print(format_phone('5551234567'))  # '(555) 123-4567'
print(format_phone('555-123-4567'))  # '(555) 123-4567'
```

## Substitution with Function

```python
def capitalize_match(match):
    return match.group(0).upper()

text = 'hello world'
result = re.sub(r'\b\w+\b', capitalize_match, text)
print(result)  # 'HELLO WORLD'

# With lambda
result = re.sub(r'\d+', lambda m: str(int(m.group(0)) * 2), 'I have 5 cats')
print(result)  # 'I have 10 cats'
```

## Split

```python
# Split on multiple delimiters
text = 'apple,banana;orange|grape'
fruits = re.split(r'[,;|]', text)
print(fruits)  # ['apple', 'banana', 'orange', 'grape']

# Split on whitespace (multiple spaces/tabs)
text = 'hello    world\t\tfoo'
words = re.split(r'\s+', text)
print(words)  # ['hello', 'world', 'foo']
```

## Greedy vs Non-greedy

```python
html = '<div>First</div><div>Second</div>'

# Greedy (default - matches as much as possible)
print(re.findall(r'<div>.*</div>', html))
# ['<div>First</div><div>Second</div>']

# Non-greedy (? after quantifier - matches as little as possible)
print(re.findall(r'<div>.*?</div>', html))
# ['<div>First</div>', '<div>Second</div>']
```

## Compile Pattern

```python
# Compile for reuse (faster)
email_regex = re.compile(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')

text1 = 'Email: john@example.com'
text2 = 'Contact: jane@test.org'

print(email_regex.findall(text1))  # ['john@example.com']
print(email_regex.findall(text2))  # ['jane@test.org']
```

## Common Mistakes

```python
# 1. Not escaping special characters
# ❌ Bad
pattern = r'.'  # Matches any character
# ✅ Good
pattern = r'\.'  # Matches literal dot

# 2. Forgetting anchors
# ❌ Bad: Partial match
re.match(r'\d+', 'abc123')  # None (must start with digit)
# ✅ Good
re.search(r'\d+', 'abc123')  # Finds '123'

# 3. Greedy when should be non-greedy
# ❌ Bad
re.findall(r'<.*>', '<b>bold</b> <i>italic</i>')
# ['<b>bold</b> <i>italic</i>']
# ✅ Good
re.findall(r'<.*?>', '<b>bold</b> <i>italic</i>')
# ['<b>', '</b>', '<i>', '</i>']

# 4. Not using raw strings
# ❌ Bad (need double backslashes)
pattern = '\\d+'
# ✅ Good (raw string)
pattern = r'\d+'
```

## Testing Regex

```python
import re

def test_regex(pattern, test_cases):
    regex = re.compile(pattern)
    for text, expected in test_cases:
        match = bool(regex.match(text))
        status = "✓" if match == expected else "✗"
        print(f"{status} '{text}': {match} (expected {expected})")

# Test email pattern
email_pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
test_cases = [
    ('test@example.com', True),
    ('invalid-email', False),
    ('user@domain.co.uk', True),
    ('@example.com', False)
]
test_regex(email_pattern, test_cases)
```

## Best Practices

```python
# 1. Use raw strings
pattern = r'\d+'  # Not '\\d+'

# 2. Compile for reuse
regex = re.compile(r'\d+')

# 3. Be specific
# ❌ Too broad
r'.*'
# ✅ Specific
r'\w+'

# 4. Use non-capturing groups when possible
r'(?:Mr|Mrs|Ms) \w+'  # vs r'(Mr|Mrs|Ms) \w+'

# 5. Test your patterns
# Use online tools: regex101.com, regexr.com

# 6. Comment complex patterns (verbose mode)
pattern = re.compile(r'''
    ^                # Start of string
    [a-zA-Z0-9]+     # Username
    @                # At symbol
    [a-zA-Z0-9.-]+   # Domain
    \.[a-zA-Z]{2,}   # TLD
    $                # End of string
''', re.VERBOSE)

# 7. Don't parse HTML/XML with regex
# Use proper parsers (BeautifulSoup, lxml)
```

## Practical Examples

```python
# Remove duplicates spaces
text = 'hello    world'
clean = re.sub(r'\s+', ' ', text)
print(clean)  # 'hello world'

# Extract hashtags
text = 'I love #python and #coding!'
hashtags = re.findall(r'#\w+', text)
print(hashtags)  # ['#python', '#coding']

# Mask credit card
card = '1234-5678-9012-3456'
masked = re.sub(r'\d(?=\d{4})', '*', card)
print(masked)  # '****-****-****-3456'

# Extract numbers from string
text = 'Price: $99.99'
price = re.search(r'\d+\.?\d*', text).group()
print(price)  # '99.99'

# Validate hex color
def is_hex_color(color):
    return bool(re.match(r'^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$', color))

print(is_hex_color('#FF5733'))  # True
print(is_hex_color('#FFF'))     # True
print(is_hex_color('FF5733'))   # False
```
