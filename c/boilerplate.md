# C Project Boilerplate Templates

## Basic Program

```c
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    printf("Hello, World!\n");
    return EXIT_SUCCESS;
}
```

## Main with Arguments

```c
#include <stdio.h>
#include <stdlib.h>

void print_usage(const char *program) {
    printf("Usage: %s [OPTIONS]\n", program);
    printf("Options:\n");
    printf("  -h, --help     Show this help\n");
    printf("  -v, --verbose  Verbose output\n");
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        print_usage(argv[0]);
        return EXIT_FAILURE;
    }

    // Parse arguments
    for (int i = 1; i < argc; i++) {
        // Process argv[i]
    }

    return EXIT_SUCCESS;
}
```

## Header File Template

**mymodule.h**
```c
#ifndef MYMODULE_H
#define MYMODULE_H

#include <stddef.h>

/* Constants */
#define MAX_SIZE 100

/* Type definitions */
typedef struct {
    int id;
    char name[50];
} MyStruct;

/* Function declarations */
int init_module(void);
void cleanup_module(void);
int process_data(const char *input, char *output, size_t size);

#endif  /* MYMODULE_H */
```

**mymodule.c**
```c
#include "mymodule.h"
#include <stdio.h>
#include <string.h>

/* Private functions */
static int validate_input(const char *input) {
    if (input == NULL) {
        return -1;
    }
    // Validation logic
    return 0;
}

/* Public functions */
int init_module(void) {
    // Initialize module
    return 0;
}

void cleanup_module(void) {
    // Cleanup resources
}

int process_data(const char *input, char *output, size_t size) {
    if (validate_input(input) != 0) {
        return -1;
    }

    // Process data
    strncpy(output, input, size - 1);
    output[size - 1] = '\0';

    return 0;
}
```

## Library Header

**mylib.h**
```c
#ifndef MYLIB_H
#define MYLIB_H

#ifdef __cplusplus
extern "C" {
#endif

/* Version */
#define MYLIB_VERSION_MAJOR 1
#define MYLIB_VERSION_MINOR 0
#define MYLIB_VERSION_PATCH 0

/* Error codes */
typedef enum {
    MYLIB_OK = 0,
    MYLIB_ERROR = -1,
    MYLIB_INVALID_PARAM = -2,
    MYLIB_OUT_OF_MEMORY = -3
} mylib_error_t;

/* Opaque handle */
typedef struct mylib_context mylib_context_t;

/* API functions */
mylib_context_t* mylib_create(void);
void mylib_destroy(mylib_context_t *ctx);
mylib_error_t mylib_process(mylib_context_t *ctx, const char *input);

/* Utility functions */
const char* mylib_error_string(mylib_error_t error);
void mylib_get_version(int *major, int *minor, int *patch);

#ifdef __cplusplus
}
#endif

#endif  /* MYLIB_H */
```

## Makefile Template

```makefile
# Project settings
PROJECT = myproject
VERSION = 1.0.0

# Compiler settings
CC = gcc
CFLAGS = -Wall -Wextra -std=c99 -pedantic
CFLAGS += -I include
LDFLAGS =
LIBS =

# Directories
SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin
INC_DIR = include

# Files
SRCS = $(wildcard $(SRC_DIR)/*.c)
OBJS = $(SRCS:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)
TARGET = $(BIN_DIR)/$(PROJECT)

# Build modes
DEBUG ?= 0
ifeq ($(DEBUG), 1)
    CFLAGS += -g -O0 -DDEBUG
else
    CFLAGS += -O2 -DNDEBUG
endif

# Targets
.PHONY: all clean install uninstall

all: $(TARGET)

$(TARGET): $(OBJS) | $(BIN_DIR)
	$(CC) $(LDFLAGS) $^ $(LIBS) -o $@
	@echo "Build complete: $(TARGET)"

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR) $(BIN_DIR):
	mkdir -p $@

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

install: $(TARGET)
	install -d $(DESTDIR)/usr/local/bin
	install -m 755 $(TARGET) $(DESTDIR)/usr/local/bin/

uninstall:
	rm -f $(DESTDIR)/usr/local/bin/$(PROJECT)
```

## CMakeLists.txt Template

```cmake
cmake_minimum_required(VERSION 3.10)
project(MyProject VERSION 1.0.0 LANGUAGES C)

# C Standard
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Options
option(BUILD_TESTS "Build tests" ON)
option(BUILD_SHARED_LIBS "Build shared libraries" OFF)

# Compiler flags
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_compile_options(-Wall -Wextra -g)
else()
    add_compile_options(-O2)
endif()

# Include directories
include_directories(include)

# Source files
file(GLOB SOURCES "src/*.c")

# Executable
add_executable(${PROJECT_NAME} ${SOURCES})

# Library
add_library(mylib STATIC src/mylib.c)

# Link
target_link_libraries(${PROJECT_NAME} mylib)

# Tests
if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()

# Install
install(TARGETS ${PROJECT_NAME} DESTINATION bin)
install(FILES include/mylib.h DESTINATION include)
```

## Project Structure

```
myproject/
├── include/
│   ├── mylib.h
│   └── utils.h
├── src/
│   ├── main.c
│   ├── mylib.c
│   └── utils.c
├── tests/
│   ├── test_main.c
│   └── test_utils.c
├── docs/
│   └── README.md
├── Makefile
├── CMakeLists.txt
├── .gitignore
└── README.md
```

## .gitignore Template

```gitignore
# Compiled files
*.o
*.a
*.so
*.exe

# Build directories
bin/
obj/
build/
cmake-build-*/

# IDE files
.vscode/
.idea/
*.swp
*~

# Debug files
*.dSYM/
vgcore.*
core

# OS files
.DS_Store
Thumbs.db
```

## README.md Template

```markdown
# MyProject

Brief description of your project.

## Features

- Feature 1
- Feature 2
- Feature 3

## Building

### Requirements

- GCC 7.0 or higher
- Make

### Compilation

```bash
make
```

### Installation

```bash
sudo make install
```

## Usage

```bash
myproject [OPTIONS] <input>
```

### Options

- `-h, --help` - Show help
- `-v, --verbose` - Verbose output

### Examples

```bash
myproject input.txt
myproject -v data.bin
```

## Testing

```bash
make test
```

## License

MIT License
```

## Test Template

**test_module.c**
```c
#include <stdio.h>
#include <assert.h>
#include "mymodule.h"

static int tests_passed = 0;
static int tests_failed = 0;

#define TEST(name) \
    static void name(void); \
    printf("Running %s...", #name); \
    name(); \
    tests_passed++; \
    printf(" PASSED\n"); \
    static void name(void)

TEST(test_basic) {
    assert(1 + 1 == 2);
}

TEST(test_module_init) {
    assert(init_module() == 0);
    cleanup_module();
}

TEST(test_process_data) {
    char output[100];
    assert(process_data("test", output, sizeof(output)) == 0);
}

int main(void) {
    printf("Running tests...\n\n");

    test_basic();
    test_module_init();
    test_process_data();

    printf("\n%d tests passed, %d failed\n", tests_passed, tests_failed);
    return tests_failed;
}
```

## Command-Line Tool Template

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>

typedef struct {
    int verbose;
    char *input_file;
    char *output_file;
} config_t;

static void print_usage(const char *program) {
    printf("Usage: %s [OPTIONS] <input>\n\n", program);
    printf("Options:\n");
    printf("  -h, --help          Show this help\n");
    printf("  -v, --verbose       Verbose output\n");
    printf("  -o, --output FILE   Output file\n");
    printf("  -V, --version       Show version\n");
}

static void print_version(void) {
    printf("myprogram version 1.0.0\n");
}

static int parse_args(int argc, char *argv[], config_t *config) {
    static struct option long_options[] = {
        {"help",    no_argument,       0, 'h'},
        {"verbose", no_argument,       0, 'v'},
        {"output",  required_argument, 0, 'o'},
        {"version", no_argument,       0, 'V'},
        {0, 0, 0, 0}
    };

    int opt;
    while ((opt = getopt_long(argc, argv, "hvo:V", long_options, NULL)) != -1) {
        switch (opt) {
            case 'h':
                print_usage(argv[0]);
                return 1;
            case 'v':
                config->verbose = 1;
                break;
            case 'o':
                config->output_file = optarg;
                break;
            case 'V':
                print_version();
                return 1;
            default:
                print_usage(argv[0]);
                return -1;
        }
    }

    if (optind >= argc) {
        fprintf(stderr, "Error: Missing input file\n");
        print_usage(argv[0]);
        return -1;
    }

    config->input_file = argv[optind];
    return 0;
}

int main(int argc, char *argv[]) {
    config_t config = {0};

    int result = parse_args(argc, argv, &config);
    if (result != 0) {
        return (result < 0) ? EXIT_FAILURE : EXIT_SUCCESS;
    }

    if (config.verbose) {
        printf("Input: %s\n", config.input_file);
        if (config.output_file) {
            printf("Output: %s\n", config.output_file);
        }
    }

    // Main program logic here

    return EXIT_SUCCESS;
}
```

## Data Structure Template

**list.h**
```c
#ifndef LIST_H
#define LIST_H

#include <stddef.h>

typedef struct list_node {
    void *data;
    struct list_node *next;
} list_node_t;

typedef struct {
    list_node_t *head;
    list_node_t *tail;
    size_t size;
} list_t;

list_t* list_create(void);
void list_destroy(list_t *list, void (*free_data)(void*));
int list_append(list_t *list, void *data);
int list_prepend(list_t *list, void *data);
void* list_remove(list_t *list, size_t index);
void* list_get(list_t *list, size_t index);
size_t list_size(list_t *list);
void list_foreach(list_t *list, void (*func)(void*));

#endif  /* LIST_H */
```

**list.c**
```c
#include "list.h"
#include <stdlib.h>

list_t* list_create(void) {
    list_t *list = malloc(sizeof(list_t));
    if (!list) return NULL;

    list->head = NULL;
    list->tail = NULL;
    list->size = 0;
    return list;
}

void list_destroy(list_t *list, void (*free_data)(void*)) {
    if (!list) return;

    list_node_t *current = list->head;
    while (current) {
        list_node_t *next = current->next;
        if (free_data) {
            free_data(current->data);
        }
        free(current);
        current = next;
    }
    free(list);
}

int list_append(list_t *list, void *data) {
    if (!list) return -1;

    list_node_t *node = malloc(sizeof(list_node_t));
    if (!node) return -1;

    node->data = data;
    node->next = NULL;

    if (list->tail) {
        list->tail->next = node;
    } else {
        list->head = node;
    }

    list->tail = node;
    list->size++;
    return 0;
}

// ... implement other functions
```

## Config File Parser Template

```c
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef struct {
    char key[64];
    char value[256];
} config_entry_t;

typedef struct {
    config_entry_t *entries;
    int count;
} config_t;

config_t* config_load(const char *filename) {
    FILE *fp = fopen(filename, "r");
    if (!fp) return NULL;

    config_t *config = malloc(sizeof(config_t));
    config->entries = malloc(sizeof(config_entry_t) * 100);
    config->count = 0;

    char line[512];
    while (fgets(line, sizeof(line), fp)) {
        // Skip comments and empty lines
        if (line[0] == '#' || line[0] == '\n') continue;

        char key[64], value[256];
        if (sscanf(line, "%63[^=]=%255[^\n]", key, value) == 2) {
            strcpy(config->entries[config->count].key, key);
            strcpy(config->entries[config->count].value, value);
            config->count++;
        }
    }

    fclose(fp);
    return config;
}

const char* config_get(config_t *config, const char *key) {
    for (int i = 0; i < config->count; i++) {
        if (strcmp(config->entries[i].key, key) == 0) {
            return config->entries[i].value;
        }
    }
    return NULL;
}

void config_free(config_t *config) {
    free(config->entries);
    free(config);
}
```
