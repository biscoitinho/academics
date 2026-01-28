# Compression

Reducing data size for storage and transmission.

## Why Compress?

- **Save disk space** - Store more data
- **Faster transmission** - Less data to send
- **Lower costs** - Bandwidth and storage
- **Better performance** - Smaller files load faster

**Trade-off**: CPU time vs space/bandwidth

## Types of Compression

### Lossless
**No data lost** - can reconstruct original exactly.

**Use for**: Text, code, executables, archives

**Algorithms**:
- gzip, zlib
- bzip2
- LZMA, xz
- Brotli

### Lossy
**Some data lost** - smaller size, can't reconstruct exactly.

**Use for**: Images, video, audio (where perfect quality not needed)

**Algorithms**:
- JPEG (images)
- MP3, AAC (audio)
- H.264, H.265 (video)

## Common Algorithms

### Gzip (Deflate)

Most common web compression.

```python
import gzip

# Compress
data = b"This is some text to compress" * 100
compressed = gzip.compress(data)

print(f"Original: {len(data)} bytes")
print(f"Compressed: {len(compressed)} bytes")
# Original: 2900 bytes, Compressed: ~60 bytes

# Decompress
decompressed = gzip.decompress(compressed)
assert data == decompressed
```

```ruby
require 'zlib'

data = "This is some text to compress" * 100
compressed = Zlib::Deflate.deflate(data)
decompressed = Zlib::Inflate.inflate(compressed)
```

**Compression ratio**: ~10-20x for text
**Speed**: Fast
**Use**: HTTP compression, `.gz` files

### Bzip2

Better compression, slower.

```python
import bz2

compressed = bz2.compress(data)
decompressed = bz2.decompress(compressed)
```

**Compression ratio**: ~15-25x for text
**Speed**: Slower than gzip
**Use**: Archives, backups

### LZMA (xz)

Best compression, slowest.

```python
import lzma

compressed = lzma.compress(data)
decompressed = lzma.decompress(compressed)
```

**Compression ratio**: ~20-30x for text
**Speed**: Much slower
**Use**: Software distribution, backups

### Brotli

Modern, optimized for web.

```python
import brotli

compressed = brotli.compress(data)
decompressed = brotli.decompress(compressed)
```

**Compression ratio**: Better than gzip
**Speed**: Similar to gzip
**Use**: Modern web browsers

## HTTP Compression

```python
# Flask with gzip
from flask import Flask
from flask_compress import Compress

app = Flask(__name__)
Compress(app)  # Auto-compresses responses

@app.route('/data')
def get_data():
    return {"data": "..." * 10000}  # Automatically compressed
```

**Headers**:
```
Request:  Accept-Encoding: gzip, deflate, br
Response: Content-Encoding: gzip
```

**Savings**: 70-90% reduction for JSON/HTML

## File Compression

### Compress File

```python
import gzip
import shutil

# Compress
with open('large_file.txt', 'rb') as f_in:
    with gzip.open('large_file.txt.gz', 'wb') as f_out:
        shutil.copyfileobj(f_in, f_out)
```

```bash
# Command line
gzip large_file.txt        # Creates large_file.txt.gz
bzip2 large_file.txt       # Creates large_file.txt.bz2
xz large_file.txt          # Creates large_file.txt.xz
```

### Decompress File

```python
with gzip.open('file.gz', 'rb') as f:
    data = f.read()
```

```bash
gunzip file.gz             # Extracts file
bunzip2 file.bz2
unxz file.xz
```

## Archive Formats

### TAR (Tape Archive)

**Combines multiple files**, doesn't compress.

```bash
# Create archive
tar -cf archive.tar file1.txt file2.txt dir/

# Extract archive
tar -xf archive.tar

# List contents
tar -tf archive.tar
```

### TAR + Compression

```bash
# tar.gz (most common)
tar -czf archive.tar.gz files/
tar -xzf archive.tar.gz

# tar.bz2 (better compression)
tar -cjf archive.tar.bz2 files/
tar -xjf archive.tar.bz2

# tar.xz (best compression)
tar -cJf archive.tar.xz files/
tar -xJf archive.tar.xz
```

### ZIP

**Combines and compresses**, Windows-friendly.

```python
import zipfile

# Create ZIP
with zipfile.ZipFile('archive.zip', 'w', zipfile.ZIP_DEFLATED) as zipf:
    zipf.write('file1.txt')
    zipf.write('file2.txt')

# Extract ZIP
with zipfile.ZipFile('archive.zip', 'r') as zipf:
    zipf.extractall('extracted/')
```

```bash
# Command line
zip archive.zip file1.txt file2.txt
unzip archive.zip
```

## Streaming Compression

**Compress data on-the-fly** without loading all in memory.

```python
import gzip

# Write compressed stream
with gzip.open('output.gz', 'wt') as f:
    for i in range(1000000):
        f.write(f"Line {i}\n")

# Read compressed stream
with gzip.open('output.gz', 'rt') as f:
    for line in f:
        process(line)  # Process one line at a time
```

## Database Compression

```sql
-- PostgreSQL - compressed column
CREATE TABLE logs (
    id SERIAL,
    data TEXT COMPRESSION pglz
);

-- MySQL - compressed table
CREATE TABLE logs (
    id INT,
    data TEXT
) ROW_FORMAT=COMPRESSED;
```

**Savings**: 50-80% disk space
**Trade-off**: Slower queries

## Image Compression

### Lossless (PNG)

```python
from PIL import Image

img = Image.open('photo.png')
img.save('photo_compressed.png', optimize=True)
```

**Use**: Screenshots, graphics with text

### Lossy (JPEG)

```python
from PIL import Image

img = Image.open('photo.png')
img.save('photo.jpg', 'JPEG', quality=85)  # 85 = good quality
```

**Quality levels**:
- 95-100: Nearly lossless
- 85-95: High quality
- 75-85: Good quality
- 50-75: Medium quality
- <50: Low quality

**Use**: Photos, where perfect quality not needed

### WebP (Modern)

```python
img.save('photo.webp', 'WEBP', quality=85)
```

**Better than JPEG** - smaller size, same quality

## Compression Comparison

| Algorithm | Ratio | Speed | Use Case |
|-----------|-------|-------|----------|
| **gzip** | Medium | Fast | Web, general |
| **bzip2** | Good | Slow | Archives |
| **LZMA/xz** | Best | Very slow | Software dist |
| **Brotli** | Good | Fast | Modern web |
| **LZ4** | Low | Very fast | Real-time |
| **Zstandard** | Good | Very fast | Modern general |

## When to Compress

### ✅ Compress when:
- Storing text files
- Transmitting over network
- Archiving old data
- Backing up
- Serving web assets

### ❌ Don't compress when:
- Already compressed (jpg, mp3, zip)
- Random data (won't compress)
- Real-time requirements (too slow)
- Tiny files (overhead not worth it)

## Compression Levels

Most algorithms support levels (1-9).

```python
import gzip

# Level 1 - Fast, less compression
fast = gzip.compress(data, compresslevel=1)

# Level 9 - Slow, more compression
best = gzip.compress(data, compresslevel=9)

# Default is usually 6 (good balance)
```

**Rule**: Higher level = better compression + slower

## Real-World Examples

### Log File Rotation

```bash
# Compress old logs
gzip /var/log/app.log.1
gzip /var/log/app.log.2

# Automatic with logrotate
/var/log/app.log {
    daily
    rotate 7
    compress
    delaycompress
}
```

### Nginx Compression

```nginx
# nginx.conf
gzip on;
gzip_types text/plain text/css application/json;
gzip_min_length 1000;
```

### CDN/Asset Compression

```python
# Pre-compress static assets
import gzip
import os

for filename in os.listdir('static/'):
    with open(f'static/{filename}', 'rb') as f_in:
        with gzip.open(f'static/{filename}.gz', 'wb') as f_out:
            f_out.writelines(f_in)
```

Serve `.gz` version if browser supports.

### Database Backup

```bash
# Compress backup on-the-fly
pg_dump database | gzip > backup.sql.gz

# Restore
gunzip < backup.sql.gz | psql database
```

## Compression Tips

1. **Compress similar data together** - Better ratio
2. **Use streaming** - For large files
3. **Pick right algorithm** - Speed vs size trade-off
4. **Pre-compress static assets** - Don't compress on every request
5. **Don't compress twice** - Check if already compressed
6. **Test compression ratio** - Some data doesn't compress well

## Key Takeaways

1. **Lossless** - No data lost (text, code)
2. **Lossy** - Acceptable loss (images, video)
3. **gzip** - General purpose, fast
4. **bzip2/xz** - Better compression, slower
5. **Brotli** - Modern web standard
6. **HTTP compression** - 70-90% bandwidth savings
7. **Don't compress compressed** - No benefit
8. **Choose compression level** - Speed vs size

**Remember**: Compression saves space but costs CPU. Use when transfer/storage is bottleneck!
