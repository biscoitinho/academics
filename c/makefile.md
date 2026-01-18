# Makefile for C Projects

## Basic Makefile

```makefile
# Compiler
CC = gcc

# Compiler flags
CFLAGS = -Wall -Wextra -g

# Target executable
TARGET = program

# Source files
SRCS = main.c utils.c

# Object files
OBJS = $(SRCS:.c=.o)

# Default target
all: $(TARGET)

# Link
$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $(TARGET)

# Compile
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Clean
clean:
	rm -f $(OBJS) $(TARGET)

# Phony targets
.PHONY: all clean
```

```bash
make        # Build
make clean  # Clean
```

## With Header Dependencies

```makefile
CC = gcc
CFLAGS = -Wall -I include

TARGET = program
SRCS = src/main.c src/utils.c src/math.c
OBJS = $(SRCS:.c=.o)
DEPS = include/utils.h include/math.h

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $(TARGET)

%.o: %.c $(DEPS)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)

.PHONY: all clean
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

## Multiple Targets

```makefile
CC = gcc
CFLAGS = -Wall -g

all: program test

program: main.o utils.o
	$(CC) main.o utils.o -o program

test: test.o utils.o
	$(CC) test.o utils.o -o test

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o program test

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

# Default: debug build
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
SRCS = utils.c math.c string.c
OBJS = $(SRCS:.c=.o)

all: $(LIB)

$(LIB): $(OBJS)
	$(AR) rcs $(LIB) $(OBJS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(LIB)

install: $(LIB)
	cp $(LIB) /usr/local/lib/
	cp *.h /usr/local/include/

.PHONY: all clean install
```

```bash
make          # Build library
make install  # Install to system
```

## Shared Library

```makefile
CC = gcc
CFLAGS = -Wall -fPIC

LIB = libmylib.so
SRCS = utils.c math.c
OBJS = $(SRCS:.c=.o)

all: $(LIB)

$(LIB): $(OBJS)
	$(CC) -shared $(OBJS) -o $(LIB)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(LIB)

.PHONY: all clean
```

## With Testing

```makefile
CC = gcc
CFLAGS = -Wall -I include

# Main program
PROGRAM = program
PROGRAM_SRCS = src/main.c src/utils.c
PROGRAM_OBJS = $(PROGRAM_SRCS:.c=.o)

# Tests
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

```bash
make        # Build program
make test   # Build and run tests
```

## Directory Structure

```makefile
CC = gcc
CFLAGS = -Wall -I include

SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin
INC_DIR = include

TARGET = $(BIN_DIR)/program
SRCS = $(wildcard $(SRC_DIR)/*.c)
OBJS = $(SRCS:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

all: directories $(TARGET)

directories:
	mkdir -p $(OBJ_DIR) $(BIN_DIR)

$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $(TARGET)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

.PHONY: all directories clean
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

# Shell command
GIT_HASH := $(shell git rev-parse HEAD)

# Conditional
ifeq ($(DEBUG),1)
    CFLAGS += -DDEBUG
endif

# Functions
define compile
	$(CC) $(CFLAGS) -c $< -o $@
endef

%.o: %.c
	$(compile)
```

## Installation Targets

```makefile
PREFIX = /usr/local
BINDIR = $(PREFIX)/bin
LIBDIR = $(PREFIX)/lib
INCDIR = $(PREFIX)/include

install: program
	mkdir -p $(BINDIR)
	cp program $(BINDIR)/
	chmod 755 $(BINDIR)/program

uninstall:
	rm -f $(BINDIR)/program

install-lib: libmylib.a
	mkdir -p $(LIBDIR) $(INCDIR)
	cp libmylib.a $(LIBDIR)/
	cp *.h $(INCDIR)/

.PHONY: install uninstall install-lib
```

## Verbose Output

```makefile
CC = gcc
CFLAGS = -Wall

# Quiet by default, verbose with V=1
ifdef V
    Q =
else
    Q = @
endif

TARGET = program
OBJS = main.o utils.o

$(TARGET): $(OBJS)
	@echo "Linking $@"
	$(Q)$(CC) $(OBJS) -o $(TARGET)

%.o: %.c
	@echo "Compiling $<"
	$(Q)$(CC) $(CFLAGS) -c $< -o $@

clean:
	@echo "Cleaning"
	$(Q)rm -f $(OBJS) $(TARGET)

.PHONY: clean
```

```bash
make       # Quiet
make V=1   # Verbose
```

## CMake Alternative

**CMakeLists.txt**
```cmake
cmake_minimum_required(VERSION 3.10)
project(MyProject C)

set(CMAKE_C_STANDARD 99)

# Executable
add_executable(program
    src/main.c
    src/utils.c
)

# Include directories
target_include_directories(program PRIVATE include)

# Compiler flags
target_compile_options(program PRIVATE -Wall -Wextra)

# Library
add_library(mylib STATIC
    src/utils.c
    src/math.c
)

# Link library
target_link_libraries(program mylib)

# Tests
enable_testing()
add_executable(test tests/test.c)
target_link_libraries(test mylib)
add_test(NAME MyTest COMMAND test)
```

```bash
mkdir build
cd build
cmake ..
make
make test
```

## Common Patterns

```makefile
# Print variables
print-%:
	@echo $* = $($*)

# Run with arguments
run: $(TARGET)
	./$(TARGET) arg1 arg2

# Valgrind memory check
valgrind: $(TARGET)
	valgrind --leak-check=full ./$(TARGET)

# Code formatting
format:
	clang-format -i src/*.c include/*.h

# Static analysis
analyze:
	cppcheck --enable=all src/

# Generate documentation
docs:
	doxygen Doxyfile

.PHONY: print-% run valgrind format analyze docs
```

## Complete Example

```makefile
# Compiler settings
CC := gcc
CFLAGS := -Wall -Wextra -std=c99 -I include
LDFLAGS :=
LIBS := -lm

# Directories
SRC_DIR := src
OBJ_DIR := obj
BIN_DIR := bin
INC_DIR := include
TEST_DIR := tests

# Files
TARGET := $(BIN_DIR)/program
SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(SRCS:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

TEST_TARGET := $(BIN_DIR)/test
TEST_SRCS := $(wildcard $(TEST_DIR)/*.c)
TEST_OBJS := $(TEST_SRCS:$(TEST_DIR)/%.c=$(OBJ_DIR)/test_%.o)

# Build modes
DEBUG ?= 0
ifeq ($(DEBUG),1)
    CFLAGS += -g -DDEBUG
else
    CFLAGS += -O2 -DNDEBUG
endif

# Default target
all: $(TARGET)

# Create directories
$(OBJ_DIR) $(BIN_DIR):
	mkdir -p $@

# Link
$(TARGET): $(OBJS) | $(BIN_DIR)
	$(CC) $(LDFLAGS) $^ $(LIBS) -o $@

# Compile
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

# Tests
$(TEST_TARGET): $(TEST_OBJS) $(filter-out $(OBJ_DIR)/main.o,$(OBJS)) | $(BIN_DIR)
	$(CC) $(LDFLAGS) $^ $(LIBS) -o $@

$(OBJ_DIR)/test_%.o: $(TEST_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

test: $(TEST_TARGET)
	./$(TEST_TARGET)

# Clean
clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

# Run
run: $(TARGET)
	./$(TARGET)

# Include dependencies
-include $(DEPS)

.PHONY: all test clean run
```
