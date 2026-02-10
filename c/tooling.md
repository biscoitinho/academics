# C Tooling

Recommended tools for working with C.

## Compilers

### GCC (GNU Compiler Collection)
The most widely used C compiler on Linux.

```bash
# Compile a file
gcc main.c -o main

# With warnings and debug info (recommended while learning)
gcc -Wall -Wextra -Werror -g -O0 main.c -o main

# Specify C standard
gcc -std=c99 main.c -o main
gcc -std=c11 main.c -o main

# Link with a library
gcc main.c -lm -o main    # link math library

# Compile without linking (produce .o file)
gcc -c utils.c
```

Common flags:
- `-Wall` - Enable most warnings
- `-Wextra` - Extra warnings
- `-Werror` - Treat warnings as errors
- `-g` - Include debug symbols
- `-O0` / `-O2` / `-O3` - Optimization levels
- `-std=c99` / `-std=c11` - C standard version
- `-pedantic` - Strict standard compliance

### Clang
LLVM-based compiler. Better error messages than GCC.

```bash
# Same flags as GCC
clang -Wall -Wextra -g main.c -o main
```

**GCC vs Clang**: Both produce quality code. Clang has better diagnostics and error messages. GCC has wider platform support. Use whichever is available; both accept the same flags.

## Build Systems

### Make
The traditional build tool for C projects. Uses a `Makefile`.

```makefile
CC = gcc
CFLAGS = -Wall -Wextra -g -std=c11

TARGET = myprogram
SRCS = main.c utils.c parser.c
OBJS = $(SRCS:.c=.o)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)

.PHONY: clean
```

```bash
make          # Build
make clean    # Clean build artifacts
```

### CMake
Cross-platform build system generator. Standard for larger projects.

```cmake
# CMakeLists.txt
cmake_minimum_required(VERSION 3.20)
project(myproject C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

add_executable(myprogram main.c utils.c)
```

```bash
mkdir build && cd build
cmake ..
make
```

### Meson
Modern build system. Faster and simpler than CMake for many use cases.

```meson
# meson.build
project('myproject', 'c', default_options: ['c_std=c11'])
executable('myprogram', 'main.c', 'utils.c')
```

```bash
meson setup build
meson compile -C build
```

## Debugging

### GDB (GNU Debugger)
The essential C debugger. Learn this early.

```bash
# Compile with debug symbols
gcc -g main.c -o main

# Start debugging
gdb ./main

# Common GDB commands
# run (r)         - Start program
# break main (b)  - Set breakpoint at main
# break file.c:42 - Breakpoint at line 42
# next (n)        - Step over
# step (s)        - Step into
# continue (c)    - Continue execution
# print var (p)   - Print variable value
# backtrace (bt)  - Show call stack
# watch var       - Break when variable changes
# quit (q)        - Exit GDB
```

### LLDB
LLVM's debugger. Default on macOS. Similar commands to GDB.

```bash
lldb ./main
```

### Valgrind
Memory error detector. Essential for finding leaks and invalid memory access.

```bash
# Detect memory leaks
valgrind --leak-check=full ./main

# Track memory origins
valgrind --track-origins=yes ./main

# Full check
valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./main
```

Common Valgrind messages:
- "Invalid read/write" - Accessing freed or out-of-bounds memory
- "Conditional jump depends on uninitialised value" - Using uninitialized variable
- "definitely lost" - Memory leak (forgot to free)
- "possibly lost" - Potential memory leak

### AddressSanitizer (ASan)
Compile-time instrumentation for detecting memory errors. Faster than Valgrind.

```bash
gcc -fsanitize=address -g main.c -o main
./main
```

### Other Sanitizers

```bash
# Undefined behavior
gcc -fsanitize=undefined -g main.c -o main

# Memory sanitizer (uninitialized reads, Clang only)
clang -fsanitize=memory -g main.c -o main

# Thread sanitizer (data races)
gcc -fsanitize=thread -g main.c -o main
```

## Static Analysis

### clang-tidy
Comprehensive static analyzer and linter.

```bash
clang-tidy main.c -- -std=c11

# With specific checks
clang-tidy -checks="bugprone-*,cert-*" main.c -- -std=c11
```

### cppcheck
Static analysis focused on finding bugs (works for both C and C++).

```bash
cppcheck --enable=all --std=c11 .
```

### Compiler Warnings as Linting
The compiler itself is a powerful linter with the right flags:

```bash
gcc -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Wformat=2 main.c -o main
```

## Testing

### Unity
Lightweight testing framework for C. Single header file.

```c
#include "unity.h"

void setUp(void) {}
void tearDown(void) {}

void test_addition(void) {
    TEST_ASSERT_EQUAL(4, add(2, 2));
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_addition);
    return UNITY_END();
}
```

### Check
Unit testing framework with fork-based test isolation (crashes in tests don't kill the runner).

```c
#include <check.h>

START_TEST(test_addition) {
    ck_assert_int_eq(add(2, 2), 4);
}
END_TEST
```

### cmocka
Testing framework with mocking support.

### Criterion
Modern testing framework with automatic test registration.

## Profiling

### gprof
GNU profiler. Shows where your program spends time.

```bash
gcc -pg main.c -o main
./main
gprof main gmon.out > profile.txt
```

### perf
Linux performance counter tool. Low overhead profiling.

```bash
perf record ./main
perf report
```

## Documentation

### Doxygen
Standard documentation generator for C projects.

```c
/**
 * @brief Calculate the sum of two integers.
 * @param a First integer
 * @param b Second integer
 * @return Sum of a and b
 */
int add(int a, int b) {
    return a + b;
}
```

## Recommended Stack

| Purpose | Tool |
|---------|------|
| Compiler | GCC or Clang |
| Build system | Make (small projects) / CMake (larger) |
| Debugging | GDB + Valgrind |
| Memory checking | AddressSanitizer or Valgrind |
| Static analysis | clang-tidy + compiler warnings |
| Testing | Unity or Check |
| Profiling | perf or gprof |
| Documentation | Doxygen |
