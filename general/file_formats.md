# File Formats

## JSON

```python
import json

# Write JSON
data = {'name': 'Alice', 'age': 30}
with open('data.json', 'w') as f:
    json.dump(data, f)

# Read JSON
with open('data.json') as f:
    data = json.load(f)

# String to JSON
json_string = '{"name": "Alice", "age": 30}'
data = json.loads(json_string)

# JSON to string
json_string = json.dumps(data, indent=2)
```

```ruby
require 'json'

# Write JSON
data = {name: 'Alice', age: 30}
File.write('data.json', JSON.generate(data))

# Read JSON
data = JSON.parse(File.read('data.json'))

# String to JSON
data = JSON.parse('{"name": "Alice", "age": 30}')

# To JSON string
json_string = JSON.pretty_generate(data)
```

## CSV

```python
import csv

# Write CSV
data = [
    ['Name', 'Age'],
    ['Alice', 30],
    ['Bob', 25]
]

with open('data.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerows(data)

# Read CSV
with open('data.csv') as f:
    reader = csv.reader(f)
    for row in reader:
        print(row)

# Dict writer
with open('data.csv', 'w', newline='') as f:
    fieldnames = ['name', 'age']
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerow({'name': 'Alice', 'age': 30})
```

```ruby
require 'csv'

# Write CSV
CSV.open('data.csv', 'w') do |csv|
  csv << ['Name', 'Age']
  csv << ['Alice', 30]
  csv << ['Bob', 25]
end

# Read CSV
CSV.foreach('data.csv') do |row|
  puts row.inspect
end

# With headers
CSV.foreach('data.csv', headers: true) do |row|
  puts row['Name']
end
```

## YAML

```python
import yaml

# Write YAML
data = {'name': 'Alice', 'age': 30, 'hobbies': ['reading', 'coding']}
with open('data.yaml', 'w') as f:
    yaml.dump(data, f)

# Read YAML
with open('data.yaml') as f:
    data = yaml.safe_load(f)
```

```ruby
require 'yaml'

# Write YAML
data = {name: 'Alice', age: 30, hobbies: ['reading', 'coding']}
File.write('data.yaml', data.to_yaml)

# Read YAML
data = YAML.load_file('data.yaml')
```

## XML

```python
import xml.etree.ElementTree as ET

# Parse XML
tree = ET.parse('data.xml')
root = tree.getroot()

for child in root:
    print(child.tag, child.attrib)

# Find elements
users = root.findall('user')
for user in users:
    name = user.find('name').text
    print(name)

# Create XML
root = ET.Element('users')
user = ET.SubElement(root, 'user', id='1')
name = ET.SubElement(user, 'name')
name.text = 'Alice'

tree = ET.ElementTree(root)
tree.write('output.xml')
```

## INI

```python
import configparser

# Read INI
config = configparser.ConfigParser()
config.read('config.ini')

value = config['section']['key']
port = config.getint('server', 'port')

# Write INI
config['DEFAULT'] = {'debug': 'true'}
config['database'] = {'host': 'localhost', 'port': '5432'}

with open('config.ini', 'w') as f:
    config.write(f)
```

## Binary Files

```python
# Write binary
data = b'\x00\x01\x02\x03'
with open('data.bin', 'wb') as f:
    f.write(data)

# Read binary
with open('data.bin', 'rb') as f:
    data = f.read()

# Struct (pack/unpack)
import struct

# Pack integers
data = struct.pack('ii', 10, 20)  # Two integers

# Unpack
a, b = struct.unpack('ii', data)
print(a, b)  # 10 20
```

## Pickle (Python)

```python
import pickle

# Serialize object
data = {'name': 'Alice', 'scores': [90, 85, 88]}
with open('data.pkl', 'wb') as f:
    pickle.dump(data, f)

# Deserialize
with open('data.pkl', 'rb') as f:
    data = pickle.load(f)

# Warning: Only load trusted pickle files!
```

## MessagePack

```python
import msgpack

# Serialize
data = {'name': 'Alice', 'age': 30}
packed = msgpack.packb(data)

# Deserialize
unpacked = msgpack.unpackb(packed)
```

## Protocol Buffers

```protobuf
// user.proto
message User {
  string name = 1;
  int32 age = 2;
}
```

```python
# After compiling .proto
user = User()
user.name = "Alice"
user.age = 30

# Serialize
data = user.SerializeToString()

# Deserialize
user2 = User()
user2.ParseFromString(data)
```

## SQLite

```python
import sqlite3

# Connect
conn = sqlite3.connect('data.db')
cursor = conn.cursor()

# Create table
cursor.execute('''
    CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY,
        name TEXT,
        age INTEGER
    )
''')

# Insert
cursor.execute('INSERT INTO users (name, age) VALUES (?, ?)', ('Alice', 30))
conn.commit()

# Query
cursor.execute('SELECT * FROM users')
for row in cursor.fetchall():
    print(row)

conn.close()
```

## File Format Comparison

```
JSON:
✅ Human-readable
✅ Universal support
❌ No comments
❌ Limited types

YAML:
✅ Human-readable
✅ Comments
✅ Complex structures
❌ Slower parsing

XML:
✅ Self-describing
✅ Validation (schemas)
❌ Verbose
❌ Hard to read

CSV:
✅ Simple
✅ Excel compatible
❌ No nesting
❌ Type information lost

Binary:
✅ Fast
✅ Small size
❌ Not human-readable
❌ Platform-specific

Pickle:
✅ Python objects
❌ Python-only
❌ Security risk

MessagePack:
✅ Fast
✅ Small
✅ Binary
❌ Not human-readable

Protocol Buffers:
✅ Efficient
✅ Versioning
✅ Multi-language
❌ Requires schema
```
