# Makefile for C Projects

## Basic Makefile

```makefile
CC = gcc
CFLAGS = -Wall -Wextra -g

TARGET = program
SRCS = main.c utils.c
OBJS = $(SRCS:.c=.o)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $(TARGET)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)

.PHONY: all clean
```

```bash
make        # Build
make clean  # Clean
```

## Automatic Dependencies

```makefile
CC = gcc
CFLAGS = -Wall -MMD -MP -I include

TARGET = program
SRCS = $(wildcard src/*.c)
OBJS = $(SRCS:.c=.o)
DEPS = $(OBJS:.o=.d)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $(TARGET)

-include $(DEPS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(DEPS) $(TARGET)

.PHONY: all clean
```

## Debug and Release Builds

```makefile
CC = gcc
CFLAGS_DEBUG = -Wall -g -DDEBUG
CFLAGS_RELEASE = -Wall -O2 -DNDEBUG

TARGET = program
SRCS = main.c utils.c
OBJS = $(SRCS:.c=.o)

all: debug

debug: CFLAGS = $(CFLAGS_DEBUG)
debug: $(TARGET)

release: CFLAGS = $(CFLAGS_RELEASE)
release: clean $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $(TARGET)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)

.PHONY: all debug release clean
```

```bash
make debug    # Debug build
make release  # Release build
```

## Static Library

```makefile
CC = gcc
CFLAGS = -Wall -fPIC
AR = ar

LIB = libmylib.a
SRCS = utils.c math.c
OBJS = $(SRCS:.c=.o)

all: $(LIB)

$(LIB): $(OBJS)
	$(AR) rcs $(LIB) $(OBJS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(LIB)

# Shared library: use -shared instead of ar
# $(LIB:.a=.so): $(OBJS)
# 	$(CC) -shared $(OBJS) -o $@

.PHONY: all clean
```

## With Testing

```makefile
CC = gcc
CFLAGS = -Wall -I include

PROGRAM = program
PROGRAM_SRCS = src/main.c src/utils.c
PROGRAM_OBJS = $(PROGRAM_SRCS:.c=.o)

TEST = test
TEST_SRCS = tests/test.c src/utils.c
TEST_OBJS = $(TEST_SRCS:.c=.o)

all: $(PROGRAM)

$(PROGRAM): $(PROGRAM_OBJS)
	$(CC) $(PROGRAM_OBJS) -o $(PROGRAM)

$(TEST): $(TEST_OBJS)
	$(CC) $(TEST_OBJS) -o $(TEST)

test: $(TEST)
	./$(TEST)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(PROGRAM_OBJS) $(TEST_OBJS) $(PROGRAM) $(TEST)

.PHONY: all test clean
```

## Variables and Functions

```makefile
# Variables
CC := gcc
CFLAGS := -Wall -g

# Wildcard
SRCS := $(wildcard src/*.c)

# Pattern substitution
OBJS := $(SRCS:.c=.o)
OBJS := $(patsubst src/%.c,obj/%.o,$(SRCS))

# Conditional
DEBUG ?= 0
ifeq ($(DEBUG),1)
    CFLAGS += -DDEBUG
endif
```

## Installation

```makefile
PREFIX = /usr/local
BINDIR = $(PREFIX)/bin

install: program
	mkdir -p $(BINDIR)
	install -m 755 program $(BINDIR)/

uninstall:
	rm -f $(BINDIR)/program

.PHONY: install uninstall
```

## CMake Alternative

**CMakeLists.txt**
```cmake
cmake_minimum_required(VERSION 3.10)
project(MyProject C)

set(CMAKE_C_STANDARD 99)

# Compiler flags
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_compile_options(-Wall -Wextra -g)
else()
    add_compile_options(-O2)
endif()

include_directories(include)
file(GLOB SOURCES "src/*.c")

# Executable
add_executable(${PROJECT_NAME} ${SOURCES})

# Library
add_library(mylib STATIC src/mylib.c)
target_link_libraries(${PROJECT_NAME} mylib)

# Tests
enable_testing()
add_executable(test tests/test.c)
target_link_libraries(test mylib)
add_test(NAME MyTest COMMAND test)

# Install
install(TARGETS ${PROJECT_NAME} DESTINATION bin)
```

```bash
mkdir build && cd build
cmake ..
make
make test
```

## Common Patterns

```makefile
# Run program
run: $(TARGET)
	./$(TARGET)

# Run with valgrind
valgrind: $(TARGET)
	valgrind --leak-check=full ./$(TARGET)

# Format code
format:
	clang-format -i src/*.c include/*.h

# Print variable
print-%:
	@echo $* = $($*)

.PHONY: run valgrind format print-%
```

## Complete Example

```makefile
# Compiler
CC := gcc
CFLAGS := -Wall -Wextra -std=c99 -I include
LDFLAGS :=
LIBS := -lm

# Directories
SRC_DIR := src
OBJ_DIR := obj
BIN_DIR := bin
TEST_DIR := tests

# Files
TARGET := $(BIN_DIR)/program
SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(SRCS:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

TEST_TARGET := $(BIN_DIR)/test
TEST_SRCS := $(wildcard $(TEST_DIR)/*.c)
TEST_OBJS := $(TEST_SRCS:$(TEST_DIR)/%.c=$(OBJ_DIR)/test_%.o)

# Build mode
DEBUG ?= 0
ifeq ($(DEBUG),1)
    CFLAGS += -g -DDEBUG
else
    CFLAGS += -O2 -DNDEBUG
endif

# Targets
all: $(TARGET)

$(TARGET): $(OBJS) | $(BIN_DIR)
	$(CC) $(LDFLAGS) $^ $(LIBS) -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

$(TEST_TARGET): $(TEST_OBJS) $(filter-out $(OBJ_DIR)/main.o,$(OBJS)) | $(BIN_DIR)
	$(CC) $(LDFLAGS) $^ $(LIBS) -o $@

$(OBJ_DIR)/test_%.o: $(TEST_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

$(OBJ_DIR) $(BIN_DIR):
	mkdir -p $@

test: $(TEST_TARGET)
	./$(TEST_TARGET)

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

run: $(TARGET)
	./$(TARGET)

-include $(DEPS)

.PHONY: all test clean run
```

## Compilation Commands

```bash
# Basic compilation
gcc file.c -o program

# Multiple files
gcc main.c utils.c -o program

# With flags
gcc -Wall -Wextra -O2 main.c -o program

# With includes
gcc -I include main.c -o program

# With libraries
gcc main.c -lm -o program          # Link math lib
gcc main.c -L. -lmylib -o program  # Link custom lib

# Create object files
gcc -c file.c -o file.o

# Link object files
gcc file1.o file2.o -o program

# Create static library
ar rcs libmylib.a file1.o file2.o

# Create shared library
gcc -shared -fPIC file.c -o libmylib.so
```
