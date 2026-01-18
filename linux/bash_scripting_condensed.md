## Bash Scripting

### Script Basics

```bash
#!/bin/bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures

echo "Hello World"
```

### Variables

```bash
# Assignment
name="Alice"
count=10

# Command substitution
files=$(ls -l)
date=$(date +%Y-%m-%d)

# Arrays
fruits=("apple" "banana" "orange")
echo "${fruits[0]}"
echo "${fruits[@]}"  # All elements
```

### User Input

```bash
# Read input
read -p "Enter name: " name
echo "Hello $name"

# Arguments
$0    # Script name
$1    # First argument
$#    # Number of arguments
$@    # All arguments
```

### Conditionals

```bash
# If statement
if [[ -f "$file" ]]; then
    echo "File exists"
elif [[ -d "$file" ]]; then
    echo "Directory exists"
else
    echo "Not found"
fi

# Test conditions
[[ -f file ]]      # File exists
[[ -d dir ]]       # Directory exists
[[ -z "$var" ]]    # String is empty
[[ "$a" == "$b" ]] # Strings equal
[[ $a -eq $b ]]    # Numbers equal
[[ $a -gt $b ]]    # Greater than

# Case statement
case "$1" in
    start)
        echo "Starting"
        ;;
    stop)
        echo "Stopping"
        ;;
    *)
        echo "Usage: $0 {start|stop}"
        ;;
esac
```

### Loops

```bash
# For loop
for i in {1..10}; do
    echo "$i"
done

for file in *.txt; do
    echo "$file"
done

# While loop
count=0
while [[ $count -lt 10 ]]; do
    echo "$count"
    ((count++))
done

# Read file line by line
while IFS= read -r line; do
    echo "$line"
done < file.txt
```

### Functions

```bash
# Define function
greet() {
    echo "Hello $1"
}

# Call function
greet "Alice"

# Return value
add() {
    echo $(($1 + $2))
}
result=$(add 5 3)
```

### String Operations

```bash
# Length
${#string}

# Substring
${string:0:5}

# Replace
${string/old/new}      # First occurrence
${string//old/new}     # All occurrences

# Uppercase/lowercase
${string^^}    # Uppercase
${string,,}    # Lowercase
```

### Arithmetic

```bash
# Basic
result=$((5 + 3))
((count++))
((count += 5))

# Operations
$((a + b))     # Addition
$((a - b))     # Subtraction
$((a * b))     # Multiplication
$((a / b))     # Division
$((a % b))     # Modulo
```

### Error Handling

```bash
# Exit on error
set -e

# Check command success
if command; then
    echo "Success"
else
    echo "Failed"
fi

# Error function
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Trap errors
trap 'echo "Error on line $LINENO"' ERR
```

### Redirection

```bash
# Redirect output
command > file.txt           # Overwrite
command >> file.txt          # Append
command 2> error.log         # Stderr
command &> all.log           # Stdout and stderr
command > /dev/null 2>&1     # Discard all

# Here document
cat << EOF
Multiple
lines
of text
