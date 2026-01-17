## String Methods in Ruby

Common string operations and methods.

### Creating strings

```ruby
str = "Hello"
str = 'World'
str = %q(Hello)    # Like single quotes
str = %Q(Hello)    # Like double quotes
str = <<~TEXT
  Multi-line
  string
TEXT
```

### String interpolation

```ruby
name = "Alice"
age = 30

# Only works with double quotes
puts "Name: #{name}, Age: #{age}"  # Name: Alice, Age: 30

# Single quotes don't interpolate
puts 'Name: #{name}'  # Name: #{name}

# Expression in interpolation
puts "2 + 2 = #{2 + 2}"  # 2 + 2 = 4
```

### Case methods

```ruby
str = "Hello World"

str.upcase          # "HELLO WORLD"
str.downcase        # "hello world"
str.capitalize      # "Hello world"
str.swapcase        # "hELLO wORLD"

# In-place modification (with !)
str.upcase!         # Modifies str directly
```

### Checking content

```ruby
str = "Hello World"

str.include?("World")    # true
str.start_with?("Hello") # true
str.end_with?("ld")      # true
str.empty?               # false
```

### Extracting parts

```ruby
str = "Hello World"

# Indexing
str[0]              # "H"
str[-1]             # "d"
str[0, 5]           # "Hello" (start, length)
str[0..4]           # "Hello" (range)
str[6..-1]          # "World"

# Methods
str.chars           # ["H", "e", "l", "l", "o", " ", "W", "o", "r", "l", "d"]
str.split           # ["Hello", "World"]
str.split("o")      # ["Hell", " W", "rld"]
```

### Modifying strings

```ruby
str = "  Hello  "

str.strip           # "Hello" (remove whitespace)
str.lstrip          # "Hello  " (left strip)
str.rstrip          # "  Hello" (right strip)

str = "Hello"
str.reverse         # "olleH"
str.concat(" World")# "Hello World"
str + " World"      # "Hello World"
str * 3             # "HelloHelloHello"
```

### Replacing

```ruby
str = "Hello World"

str.sub("o", "0")       # "Hell0 World" (first occurrence)
str.gsub("o", "0")      # "Hell0 W0rld" (all occurrences)
str.delete("l")         # "Heo Word"
str.tr("aeiou", "*")    # "H*ll* W*rld" (translate chars)
```

### Searching

```ruby
str = "Hello World"

str.index("o")          # 4 (first occurrence)
str.rindex("o")         # 7 (last occurrence)
str.scan(/\w+/)         # ["Hello", "World"]
str.count("l")          # 3
```

### Size and length

```ruby
str = "Hello"

str.length          # 5
str.size            # 5 (same as length)
str.bytesize        # 5 (bytes)
```

### Comparison

```ruby
"abc" == "abc"      # true
"abc" < "def"       # true (alphabetically)
"abc".casecmp("ABC")  # 0 (case-insensitive compare)
```

### Converting

```ruby
str = "123"

str.to_i            # 123
str.to_f            # 123.0
str.to_sym          # :123

# Reverse
123.to_s            # "123"
:hello.to_s         # "hello"
```

### Iterating

```ruby
str = "Hello"

# Each character
str.each_char { |c| puts c }

# Each byte
str.each_byte { |b| puts b }

# Each line
multiline = "Line1\nLine2\nLine3"
multiline.each_line { |line| puts line }
```

### Joining arrays

```ruby
arr = ["Hello", "World"]

arr.join            # "HelloWorld"
arr.join(" ")       # "Hello World"
arr.join(", ")      # "Hello, World"
```

### Encoding

```ruby
str = "Hello"

str.encoding        # #<Encoding:UTF-8>
str.force_encoding("ASCII")
str.encode("UTF-8")
```

### Useful patterns

**Remove all spaces:**
```ruby
"H e l l o".delete(" ")  # "Hello"
```

**Squeeze repeated characters:**
```ruby
"Heeelllooo".squeeze     # "Helo"
```

**Center/justify:**
```ruby
"Hello".center(10)       # "  Hello   "
"Hello".ljust(10)        # "Hello     "
"Hello".rjust(10)        # "     Hello"
```

**Check if string is a number:**
```ruby
str = "123"
str.match?(/^\d+$/)      # true
```

**Truncate string:**
```ruby
"Hello World"[0, 5] + "..."  # "Hello..."
```

### String formatting

```ruby
# Using %
"Name: %s, Age: %d" % ["Alice", 30]  # "Name: Alice, Age: 30"

# Using format
format("%.2f", 3.14159)              # "3.14"
```
