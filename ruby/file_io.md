## File I/O in Ruby

Reading and writing files in Ruby.

### Reading files

```ruby
# Read entire file
content = File.read("file.txt")

# Read file line by line
File.readlines("file.txt").each do |line|
  puts line
end

# Using block (auto-closes file)
File.open("file.txt", "r") do |file|
  content = file.read
end

# Manual open/close
file = File.open("file.txt", "r")
content = file.read
file.close
```

### Writing files

```ruby
# Write (overwrites existing)
File.write("file.txt", "Hello World")

# Using block
File.open("file.txt", "w") do |file|
  file.write("Hello World\n")
  file.puts "Another line"
end

# Append to file
File.open("file.txt", "a") do |file|
  file.puts "Appended line"
end
```

### File modes

```ruby
"r"   # Read only (default)
"r+"  # Read and write
"w"   # Write only (truncates or creates)
"w+"  # Read and write (truncates or creates)
"a"   # Append (write only)
"a+"  # Append (read and write)
"b"   # Binary mode (can combine: "rb", "wb")
```

### Reading line by line

```ruby
# Method 1: readlines (loads all into memory)
lines = File.readlines("file.txt")
lines.each { |line| puts line }

# Method 2: each_line (memory efficient)
File.open("file.txt").each_line do |line|
  puts line
end

# Method 3: foreach
File.foreach("file.txt") do |line|
  puts line
end
```

### Checking file existence

```ruby
if File.exist?("file.txt")
  puts "File exists"
end

# Check if it's a file
File.file?("file.txt")    # true

# Check if it's a directory
File.directory?("folder") # true
```

### File information

```ruby
# Size
File.size("file.txt")     # bytes

# File stats
stat = File.stat("file.txt")
stat.size                 # Size in bytes
stat.mtime               # Modified time
stat.atime               # Access time
stat.ctime               # Created time

# Is readable/writable?
File.readable?("file.txt")
File.writable?("file.txt")
File.executable?("script.sh")
```

### Working with paths

```ruby
# Get absolute path
File.absolute_path("file.txt")

# Get directory name
File.dirname("/path/to/file.txt")  # "/path/to"

# Get basename
File.basename("/path/to/file.txt") # "file.txt"

# Get extension
File.extname("file.txt")           # ".txt"

# Join paths
File.join("path", "to", "file.txt") # "path/to/file.txt"
```

### Directory operations

```ruby
# Create directory
Dir.mkdir("new_folder")

# List files in directory
Dir.entries(".")          # [".", "..", "file1.txt", "file2.txt"]
Dir.glob("*.txt")         # ["file1.txt", "file2.txt"]
Dir.glob("**/*.rb")       # All .rb files recursively

# Current directory
Dir.pwd                   # "/current/path"

# Change directory
Dir.chdir("/new/path")

# Check if directory exists
Dir.exist?("folder")
```

### Deleting files and directories

```ruby
# Delete file
File.delete("file.txt")

# Delete directory (must be empty)
Dir.delete("folder")

# Delete directory recursively
require 'fileutils'
FileUtils.rm_rf("folder")
```

### Copying and moving files

```ruby
require 'fileutils'

# Copy file
FileUtils.cp("source.txt", "dest.txt")

# Copy directory
FileUtils.cp_r("source_dir", "dest_dir")

# Move file
FileUtils.mv("old_name.txt", "new_name.txt")
```

### Reading binary files

```ruby
# Read binary
data = File.read("image.png", mode: "rb")

# Write binary
File.open("output.bin", "wb") do |file|
  file.write(binary_data)
end
```

### CSV files

```ruby
require 'csv'

# Read CSV
CSV.foreach("data.csv", headers: true) do |row|
  puts row["name"]
end

# Write CSV
CSV.open("output.csv", "w") do |csv|
  csv << ["Name", "Age"]
  csv << ["Alice", 30]
  csv << ["Bob", 25]
end
```

### JSON files

```ruby
require 'json'

# Read JSON
json_data = File.read("data.json")
data = JSON.parse(json_data)

# Write JSON
data = { name: "Alice", age: 30 }
File.write("output.json", JSON.pretty_generate(data))
```

### Temporary files

```ruby
require 'tempfile'

# Create temp file
Tempfile.create("prefix") do |file|
  file.write("Temporary content")
  puts file.path
end
# File automatically deleted after block
```

### Safe file operations

```ruby
# Ensure file is closed
begin
  file = File.open("file.txt", "r")
  content = file.read
ensure
  file.close if file
end

# Better: use block (auto-closes)
File.open("file.txt", "r") do |file|
  content = file.read
end
```

### Reading file with error handling

```ruby
begin
  content = File.read("file.txt")
rescue Errno::ENOENT
  puts "File not found"
rescue Errno::EACCES
  puts "Permission denied"
rescue => e
  puts "Error: #{e.message}"
end
```

### Common patterns

**Read and process large file:**
```ruby
File.open("large_file.txt").each_line do |line|
  # Process one line at a time (memory efficient)
  puts line if line.include?("search_term")
end
```

**Count lines in file:**
```ruby
line_count = File.readlines("file.txt").count
# or
line_count = File.foreach("file.txt").count
```

**Replace text in file:**
```ruby
content = File.read("file.txt")
content.gsub!("old_text", "new_text")
File.write("file.txt", content)
```

**Append to file:**
```ruby
File.open("log.txt", "a") do |file|
  file.puts "#{Time.now}: Log entry"
end
```
