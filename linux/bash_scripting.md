## Bash Scripting

### Script Basics

#### Shebang and execution

```bash
#!/bin/bash
# First line - tells system which interpreter to use

# Make executable
chmod +x script.sh

# Run script
./script.sh
bash script.sh
```

#### Variables

```bash
# Define variable (no spaces around =)
name="Alice"
age=30
count=10

# Use variable
echo "Hello $name"
echo "Hello ${name}"  # Better - clearer

# Read-only variable
readonly PI=3.14159

# Environment variable
export PATH=$PATH:/new/path
```

#### Command substitution

```bash
# Backticks (old style)
current_date=`date`

# $() (preferred)
current_date=$(date)
files=$(ls -l)
user_count=$(who | wc -l)
```

#### Arrays

```bash
# Define array
fruits=("apple" "banana" "cherry")

# Access elements
echo ${fruits[0]}        # apple
echo ${fruits[1]}        # banana

# All elements
echo ${fruits[@]}        # All elements
echo ${fruits[*]}        # All elements

# Array length
echo ${#fruits[@]}       # 3

# Add element
fruits+=("orange")

# Loop through array
for fruit in "${fruits[@]}"; do
    echo "$fruit"
done
```

### Input/Output

#### Read user input

```bash
# Basic read
read name
echo "Hello $name"

# With prompt
read -p "Enter your name: " name

# Silent read (for passwords)
read -sp "Enter password: " password

# Read with timeout
read -t 5 -p "Enter within 5 seconds: " input

# Read into array
read -a words
echo "${words[0]}"
```

#### Arguments

```bash
# $0 = script name
# $1, $2, ... = arguments
# $# = number of arguments
# $@ = all arguments
# $* = all arguments (as single string)

echo "Script: $0"
echo "First arg: $1"
echo "All args: $@"
echo "Number of args: $#"

# Loop through arguments
for arg in "$@"; do
    echo "$arg"
done
```

### Conditionals

#### if statements

```bash
# Basic if
if [ condition ]; then
    commands
fi

# if-else
if [ condition ]; then
    commands
else
    commands
fi

# if-elif-else
if [ condition1 ]; then
    commands
elif [ condition2 ]; then
    commands
else
    commands
fi
```

#### Test conditions

```bash
# String comparisons
[ "$a" = "$b" ]      # Equal
[ "$a" != "$b" ]     # Not equal
[ -z "$a" ]          # Empty string
[ -n "$a" ]          # Not empty

# Numeric comparisons
[ $a -eq $b ]        # Equal
[ $a -ne $b ]        # Not equal
[ $a -gt $b ]        # Greater than
[ $a -lt $b ]        # Less than
[ $a -ge $b ]        # Greater or equal
[ $a -le $b ]        # Less or equal

# File tests
[ -e file ]          # Exists
[ -f file ]          # Is regular file
[ -d dir ]           # Is directory
[ -r file ]          # Is readable
[ -w file ]          # Is writable
[ -x file ]          # Is executable
[ -s file ]          # File not empty
[ file1 -nt file2 ]  # file1 newer than file2
[ file1 -ot file2 ]  # file1 older than file2

# Logical operators
[ cond1 ] && [ cond2 ]   # AND
[ cond1 ] || [ cond2 ]   # OR
! [ condition ]          # NOT

# [[ ]] (better - supports regex)
[[ $name == "Alice" ]]
[[ $name =~ ^A.*e$ ]]    # Regex match
```

#### Case statements

```bash
case $variable in
    pattern1)
        commands
        ;;
    pattern2|pattern3)
        commands
        ;;
    *)
        default commands
        ;;
esac

# Example
case $1 in
    start)
        echo "Starting..."
        ;;
    stop)
        echo "Stopping..."
        ;;
    restart)
        echo "Restarting..."
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
        ;;
esac
```

### Loops

#### for loop

```bash
# Iterate over list
for item in one two three; do
    echo "$item"
done

# Iterate over range
for i in {1..10}; do
    echo "$i"
done

# C-style
for ((i=0; i<10; i++)); do
    echo "$i"
done

# Iterate over files
for file in *.txt; do
    echo "Processing $file"
done
```

#### while loop

```bash
# Basic while
counter=0
while [ $counter -lt 10 ]; do
    echo "$counter"
    ((counter++))
done

# Read file line by line
while IFS= read -r line; do
    echo "$line"
done < file.txt

# Infinite loop
while true; do
    echo "Running..."
    sleep 1
done
```

#### until loop

```bash
counter=0
until [ $counter -eq 10 ]; do
    echo "$counter"
    ((counter++))
done
```

#### Loop control

```bash
# break - exit loop
for i in {1..10}; do
    if [ $i -eq 5 ]; then
        break
    fi
    echo "$i"
done

# continue - skip iteration
for i in {1..10}; do
    if [ $i -eq 5 ]; then
        continue
    fi
    echo "$i"
done
```

### Functions

```bash
# Define function
function greet() {
    echo "Hello $1"
}

# Alternative syntax
greet() {
    echo "Hello $1"
}

# Call function
greet "Alice"

# Function with return value
add() {
    local sum=$(($1 + $2))
    echo $sum
}

result=$(add 5 3)
echo "Result: $result"

# Function with return code
check_file() {
    if [ -f "$1" ]; then
        return 0
    else
        return 1
    fi
}

if check_file "test.txt"; then
    echo "File exists"
fi

# Local variables
my_function() {
    local var="local"
    echo "$var"
}
```

### String Operations

```bash
# Length
str="Hello World"
echo ${#str}             # 11

# Substring
echo ${str:0:5}          # Hello
echo ${str:6}            # World

# Replace
echo ${str/World/Bash}   # Hello Bash
echo ${str//o/0}         # Hell0 W0rld (all)

# Upper/lower case
echo ${str^^}            # HELLO WORLD
echo ${str,,}            # hello world

# Default values
echo ${var:-default}     # Use default if empty
echo ${var:=default}     # Set and use default if empty

# Concatenation
first="Hello"
second="World"
full="$first $second"
```

### Arithmetic

```bash
# $(( )) arithmetic
a=5
b=3
echo $((a + b))          # 8
echo $((a - b))          # 2
echo $((a * b))          # 15
echo $((a / b))          # 1
echo $((a % b))          # 2

# Increment/decrement
((a++))
((a--))
((a += 5))
((a -= 3))

# let command
let result=a+b
let a++

# expr (old style)
result=$(expr $a + $b)

# bc for floating point
result=$(echo "scale=2; 10 / 3" | bc)
```

### Error Handling

```bash
# Exit on error
set -e

# Exit on undefined variable
set -u

# Print commands before executing
set -x

# Combination
set -euo pipefail

# Custom error handling
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

[ -f "$file" ] || error_exit "File not found"

# Trap signals
trap "echo 'Script interrupted'; exit" INT TERM
trap "cleanup" EXIT

cleanup() {
    echo "Cleaning up..."
    rm -f /tmp/tempfile
}
```

### Redirection

```bash
# Stdout to file
command > file.txt       # Overwrite
command >> file.txt      # Append

# Stderr to file
command 2> errors.txt

# Both stdout and stderr
command &> output.txt
command > output.txt 2>&1

# Discard output
command > /dev/null
command 2>&1 > /dev/null

# Here document
cat << EOF
Multiple lines
of text
