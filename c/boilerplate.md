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

## Header + Source Template

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
    return (input != NULL) ? 0 : -1;
}

/* Public functions */
int init_module(void) {
    return 0;
}

void cleanup_module(void) {
    // Cleanup resources
}

int process_data(const char *input, char *output, size_t size) {
    if (validate_input(input) != 0) return -1;
    strncpy(output, input, size - 1);
    output[size - 1] = '\0';
    return 0;
}
```

## Makefile Template

```makefile
# Project settings
PROJECT = myproject
CC = gcc
CFLAGS = -Wall -Wextra -std=c99 -I include
LDFLAGS =
LIBS =

# Directories
SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin

# Files
SRCS = $(wildcard $(SRC_DIR)/*.c)
OBJS = $(SRCS:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)
TARGET = $(BIN_DIR)/$(PROJECT)

# Build modes
DEBUG ?= 0
ifeq ($(DEBUG), 1)
    CFLAGS += -g -DDEBUG
else
    CFLAGS += -O2 -DNDEBUG
endif

.PHONY: all clean install

all: $(TARGET)

$(TARGET): $(OBJS) | $(BIN_DIR)
	$(CC) $(LDFLAGS) $^ $(LIBS) -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR) $(BIN_DIR):
	mkdir -p $@

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

install: $(TARGET)
	install -m 755 $(TARGET) /usr/local/bin/
```

## CMakeLists.txt Template

```cmake
cmake_minimum_required(VERSION 3.10)
project(MyProject VERSION 1.0.0 LANGUAGES C)

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

# Install
install(TARGETS ${PROJECT_NAME} DESTINATION bin)
```

## Project Structure

```
myproject/
├── include/          # Header files
│   └── mylib.h
├── src/              # Source files
│   ├── main.c
│   └── mylib.c
├── tests/            # Test files
│   └── test_main.c
├── Makefile
├── .gitignore
└── README.md
```

## .gitignore

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

# IDE files
.vscode/
.idea/
*.swp

# Debug files
*.dSYM/
core
```

## README.md Template

```markdown
# MyProject

Brief description.

## Building

```bash
make            # Build
make DEBUG=1    # Debug build
make install    # Install
```

## Usage

```bash
myproject [OPTIONS] <input>
```

Options:
- `-h` - Show help
- `-v` - Verbose

## Testing

```bash
make test
```
```

## Command-Line Tool

```c
#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>

typedef struct {
    int verbose;
    char *input_file;
    char *output_file;
} config_t;

static void print_usage(const char *prog) {
    printf("Usage: %s [OPTIONS] <input>\n", prog);
    printf("  -h  Show help\n");
    printf("  -v  Verbose\n");
    printf("  -o  Output file\n");
}

static int parse_args(int argc, char *argv[], config_t *cfg) {
    int opt;
    while ((opt = getopt(argc, argv, "hvo:")) != -1) {
        switch (opt) {
            case 'h': print_usage(argv[0]); return 1;
            case 'v': cfg->verbose = 1; break;
            case 'o': cfg->output_file = optarg; break;
            default: return -1;
        }
    }
    if (optind >= argc) {
        fprintf(stderr, "Missing input file\n");
        return -1;
    }
    cfg->input_file = argv[optind];
    return 0;
}

int main(int argc, char *argv[]) {
    config_t config = {0};

    if (parse_args(argc, argv, &config) != 0) {
        return EXIT_FAILURE;
    }

    // Main logic here
    if (config.verbose) {
        printf("Processing: %s\n", config.input_file);
    }

    return EXIT_SUCCESS;
}
```

## Library API Template

**mylib.h**
```c
#ifndef MYLIB_H
#define MYLIB_H

/* Error codes */
typedef enum {
    LIB_OK = 0,
    LIB_ERROR = -1,
    LIB_INVALID_PARAM = -2
} lib_error_t;

/* Opaque handle */
typedef struct lib_context lib_context_t;

/* API */
lib_context_t* lib_create(void);
void lib_destroy(lib_context_t *ctx);
lib_error_t lib_process(lib_context_t *ctx, const char *input);
const char* lib_error_string(lib_error_t err);

#endif
```

**mylib.c**
```c
#include "mylib.h"
#include <stdlib.h>

struct lib_context {
    int initialized;
    // Internal state
};

lib_context_t* lib_create(void) {
    lib_context_t *ctx = malloc(sizeof(lib_context_t));
    if (!ctx) return NULL;
    ctx->initialized = 1;
    return ctx;
}

void lib_destroy(lib_context_t *ctx) {
    if (ctx) {
        free(ctx);
    }
}

lib_error_t lib_process(lib_context_t *ctx, const char *input) {
    if (!ctx || !input) return LIB_INVALID_PARAM;
    // Processing logic
    return LIB_OK;
}

const char* lib_error_string(lib_error_t err) {
    switch (err) {
        case LIB_OK: return "Success";
        case LIB_ERROR: return "Error";
        case LIB_INVALID_PARAM: return "Invalid parameter";
        default: return "Unknown";
    }
}
```

## Generic Data Structure

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
    size_t size;
} list_t;

list_t* list_create(void);
void list_destroy(list_t *list, void (*free_fn)(void*));
int list_append(list_t *list, void *data);
void* list_get(list_t *list, size_t index);

#endif
```

**list.c**
```c
#include "list.h"
#include <stdlib.h>

list_t* list_create(void) {
    list_t *list = malloc(sizeof(list_t));
    if (!list) return NULL;
    list->head = NULL;
    list->size = 0;
    return list;
}

void list_destroy(list_t *list, void (*free_fn)(void*)) {
    if (!list) return;
    list_node_t *curr = list->head;
    while (curr) {
        list_node_t *next = curr->next;
        if (free_fn) free_fn(curr->data);
        free(curr);
        curr = next;
    }
    free(list);
}

int list_append(list_t *list, void *data) {
    if (!list) return -1;

    list_node_t *node = malloc(sizeof(list_node_t));
    if (!node) return -1;

    node->data = data;
    node->next = NULL;

    if (!list->head) {
        list->head = node;
    } else {
        list_node_t *curr = list->head;
        while (curr->next) curr = curr->next;
        curr->next = node;
    }

    list->size++;
    return 0;
}

void* list_get(list_t *list, size_t index) {
    if (!list || index >= list->size) return NULL;

    list_node_t *curr = list->head;
    for (size_t i = 0; i < index; i++) {
        curr = curr->next;
    }
    return curr->data;
}
```
