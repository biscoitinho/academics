# C Workflow

How a generic development workflow looks when working with C.

## Project Setup

### 1. Create Project Structure

Small project:
```
myproject/
├── src/
│   ├── main.c
│   └── utils.c
├── include/
│   └── utils.h
├── tests/
│   └── test_utils.c
├── Makefile
├── .gitignore
└── .clang-format
```

Larger project (with CMake):
```
myproject/
├── src/
│   ├── main.c
│   ├── parser.c
│   └── processor.c
├── include/
│   ├── parser.h
│   └── processor.h
├── tests/
│   ├── test_parser.c
│   └── test_processor.c
├── lib/           # Third-party libraries
├── build/         # Build output (gitignored)
├── CMakeLists.txt
├── .gitignore
└── .clang-format
```

### 2. Set Up Build

Minimal Makefile:
```makefile
CC = gcc
CFLAGS = -Wall -Wextra -Werror -g -std=c11
INCLUDES = -Iinclude

SRCS = src/main.c src/utils.c
OBJS = $(SRCS:.c=.o)
TARGET = myprogram

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)

.PHONY: clean
```

### 3. Configure .gitignore

```
# Build output
build/
*.o
*.out

# Executables (project-specific)
myprogram

# Editor files
.vscode/
*.swp
```

## Development Cycle

### Write Code
1. Write header file (`.h`) with function declarations
2. Write implementation (`.c`)
3. Include the header where needed
4. Compile and fix errors
5. Run and test

### Compile and Run

```bash
# Simple compile
make

# Run
./myprogram

# Compile with sanitizers during development
gcc -Wall -Wextra -g -fsanitize=address,undefined src/*.c -Iinclude -o myprogram
```

### Run Tests

```bash
# If using Unity or Check
make test
./test_runner

# Or compile and run test directly
gcc -Wall -g tests/test_utils.c src/utils.c -Iinclude -o test_utils
./test_utils
```

### Check for Memory Issues

```bash
# Valgrind
valgrind --leak-check=full ./myprogram

# Or compile with AddressSanitizer
gcc -fsanitize=address -g src/*.c -Iinclude -o myprogram
./myprogram
```

### Static Analysis

```bash
# Compiler warnings (already part of CFLAGS)
gcc -Wall -Wextra -Wpedantic -Wshadow ...

# clang-tidy
clang-tidy src/*.c -- -Iinclude -std=c11

# cppcheck
cppcheck --enable=all src/
```

### Typical Cycle
```
write header -> implement -> compile -> fix warnings -> test -> valgrind -> commit
```

## Best Practices

### Header Files
- Use include guards in every header:
  ```c
  #ifndef UTILS_H
  #define UTILS_H
  // declarations
  #endif
  ```
- Only put declarations in headers, not definitions
- Include only what is needed (minimize header dependencies)
- Keep headers self-contained (a header should compile on its own)

### Memory Management
- Every `malloc` should have a corresponding `free`
- Check `malloc` return value (it can return NULL)
- Set pointers to NULL after freeing: `free(ptr); ptr = NULL;`
- Allocate in the caller or in a dedicated "create" function, free in a corresponding "destroy" function
- Use `sizeof(*ptr)` instead of `sizeof(type)` for robustness:
  ```c
  int *arr = malloc(n * sizeof(*arr));  // Preferred
  ```

### Functions
- Keep functions short and focused (one task per function)
- Return error codes for functions that can fail
- Document function contracts (what the caller must ensure, what the function guarantees)
- Use `const` for pointers to data the function should not modify:
  ```c
  void print_data(const int *data, size_t len);
  ```

### Error Handling
- Check return values from every function that can fail (malloc, fopen, etc.)
- Use a consistent error handling pattern throughout the project
- Clean up resources on error paths (avoid leaks on early returns)
- Use `errno` and `perror` for system call errors

### Naming Conventions
- Functions and variables: `snake_case`
- Constants and macros: `UPPER_SNAKE_CASE`
- Type definitions: `PascalCase` or `snake_case_t`
- Prefix functions with module name to avoid collisions: `parser_init()`, `parser_parse()`

### Code Organization
- One `.c` file per module, with a corresponding `.h`
- Keep `main.c` thin - it should just parse arguments and call into modules
- Put shared type definitions in a common header
- Use `static` for functions and variables that are private to a file

## What to Avoid

### Memory Errors
- **Using uninitialized variables** - Always initialize variables at declaration
- **Buffer overflows** - Always check bounds; use `snprintf` over `sprintf`, `strncpy` over `strcpy`
- **Use after free** - Never access memory after calling `free()`
- **Double free** - Set pointer to NULL after freeing to catch this
- **Memory leaks** - Run Valgrind regularly during development

### Common Mistakes
- **Ignoring compiler warnings** - Compile with `-Wall -Wextra -Werror`; fix every warning
- **Not checking return values** - `malloc`, `fopen`, `scanf` can all fail
- **Off-by-one errors** - Arrays are 0-indexed; `for (i = 0; i < n; i++)` not `i <= n`
- **String handling without null terminator** - Always ensure strings are null-terminated
- **Integer overflow** - Check for overflow before arithmetic on user input
- **Casting malloc return** - In C (not C++), don't cast: `int *p = malloc(...)` not `(int *)malloc(...)`

### Design Anti-Patterns
- **God files** - Don't put everything in one `.c` file
- **Global variables** - Pass data through function parameters instead
- **Deep nesting** - Use early returns and helper functions
- **Magic numbers** - Use `#define` or `enum` for named constants
- **Premature optimization** - Write correct code first, then profile and optimize

## Debugging Workflow

1. **Reproduce the bug** with a minimal test case
2. **Compile with debug symbols**: `gcc -g -O0 ...`
3. **Run in GDB**:
   ```bash
   gdb ./myprogram
   (gdb) break main
   (gdb) run
   (gdb) next      # step line by line
   (gdb) print var  # inspect variables
   ```
4. **Check memory** with Valgrind if the issue seems memory-related
5. **Add assertions** (`assert()`) to document and enforce assumptions
6. **Write a test** that captures the bug before fixing it

## Multi-File Compilation

### Manual
```bash
gcc -c src/main.c -Iinclude -o build/main.o
gcc -c src/utils.c -Iinclude -o build/utils.o
gcc build/main.o build/utils.o -o myprogram
```

### With Make
```bash
make        # Recompiles only changed files
make clean  # Remove build artifacts
```

### With CMake
```bash
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Debug
make
```
