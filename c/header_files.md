# Header Files and Multi-File Projects

## Basic Header File

**math_utils.h**
```c
#ifndef MATH_UTILS_H
#define MATH_UTILS_H

// Function declarations
int add(int a, int b);
int subtract(int a, int b);
double average(int *arr, int size);

// Constants
#define PI 3.14159
#define MAX_SIZE 100

// Type definitions
typedef struct {
    int x;
    int y;
} Point;

#endif  // MATH_UTILS_H
```

**math_utils.c**
```c
#include "math_utils.h"

int add(int a, int b) {
    return a + b;
}

int subtract(int a, int b) {
    return a - b;
}

double average(int *arr, int size) {
    int sum = 0;
    for (int i = 0; i < size; i++) {
        sum += arr[i];
    }
    return (double)sum / size;
}
```

**main.c**
```c
#include <stdio.h>
#include "math_utils.h"

int main() {
    int result = add(10, 5);
    printf("%d\n", result);

    Point p = {10, 20};
    printf("(%d, %d)\n", p.x, p.y);

    return 0;
}
```

## Include Guards

```c
// Prevent multiple inclusion
#ifndef HEADER_NAME_H
#define HEADER_NAME_H

// Header content here

#endif  // HEADER_NAME_H

// Alternative (non-standard but widely supported)
#pragma once

// Header content
```

## System vs User Headers

```c
#include <stdio.h>      // System header (standard library)
#include <stdlib.h>     // Search in system directories

#include "myheader.h"   // User header (same directory)
#include "lib/util.h"   // User header (relative path)
```

## Static vs Extern

**globals.h**
```c
#ifndef GLOBALS_H
#define GLOBALS_H

// Declaration (extern)
extern int global_counter;
extern const char *app_name;

#endif
```

**globals.c**
```c
#include "globals.h"

// Definition
int global_counter = 0;
const char *app_name = "MyApp";
```

**main.c**
```c
#include <stdio.h>
#include "globals.h"

int main() {
    global_counter++;
    printf("%s: %d\n", app_name, global_counter);
    return 0;
}
```

## Static Functions

**utils.c**
```c
// Static = internal to this file only
static int helper_function(int x) {
    return x * 2;
}

// Public function
int public_function(int x) {
    return helper_function(x) + 1;
}
```

## Project Structure

```
project/
├── include/
│   ├── math_utils.h
│   └── string_utils.h
├── src/
│   ├── math_utils.c
│   ├── string_utils.c
│   └── main.c
├── Makefile
└── README.md
```

**Compile:**
```bash
gcc -I include -c src/math_utils.c -o math_utils.o
gcc -I include -c src/string_utils.c -o string_utils.o
gcc -I include -c src/main.c -o main.o
gcc math_utils.o string_utils.o main.o -o program
```

## Inline Functions

**utils.h**
```c
#ifndef UTILS_H
#define UTILS_H

// Inline function (small, frequently used)
static inline int max(int a, int b) {
    return (a > b) ? a : b;
}

static inline int min(int a, int b) {
    return (a < b) ? a : b;
}

#endif
```

## Forward Declarations

```c
// Forward declare struct
typedef struct Node Node;

struct Node {
    int data;
    Node *next;  // Can use Node now
};

// Forward declare function
void process_data(int *data, int size);

int main() {
    int arr[] = {1, 2, 3};
    process_data(arr, 3);
    return 0;
}

void process_data(int *data, int size) {
    // Implementation
}
```

## Library Example

**mylib/list.h**
```c
#ifndef LIST_H
#define LIST_H

typedef struct Node {
    int value;
    struct Node *next;
} Node;

typedef struct {
    Node *head;
    int size;
} List;

List* list_create(void);
void list_append(List *list, int value);
void list_free(List *list);
void list_print(List *list);

#endif
```

**mylib/list.c**
```c
#include <stdio.h>
#include <stdlib.h>
#include "list.h"

List* list_create(void) {
    List *list = malloc(sizeof(List));
    list->head = NULL;
    list->size = 0;
    return list;
}

void list_append(List *list, int value) {
    Node *node = malloc(sizeof(Node));
    node->value = value;
    node->next = NULL;

    if (list->head == NULL) {
        list->head = node;
    } else {
        Node *curr = list->head;
        while (curr->next) {
            curr = curr->next;
        }
        curr->next = node;
    }
    list->size++;
}

void list_free(List *list) {
    Node *curr = list->head;
    while (curr) {
        Node *temp = curr;
        curr = curr->next;
        free(temp);
    }
    free(list);
}

void list_print(List *list) {
    Node *curr = list->head;
    while (curr) {
        printf("%d -> ", curr->value);
        curr = curr->next;
    }
    printf("NULL\n");
}
```

**main.c**
```c
#include "mylib/list.h"

int main() {
    List *list = list_create();
    list_append(list, 10);
    list_append(list, 20);
    list_append(list, 30);
    list_print(list);
    list_free(list);
    return 0;
}
```

## Conditional Compilation

**config.h**
```c
#ifndef CONFIG_H
#define CONFIG_H

#define DEBUG 1
#define VERSION "1.0.0"

#ifdef DEBUG
    #define LOG(msg) printf("[DEBUG] %s\n", msg)
#else
    #define LOG(msg)  // No-op in release
#endif

#endif
```

**main.c**
```c
#include <stdio.h>
#include "config.h"

int main() {
    LOG("Program started");  // Only prints if DEBUG is defined
    printf("Version: %s\n", VERSION);
    return 0;
}
```

## Opaque Pointers

**list.h** (hide implementation)
```c
#ifndef LIST_H
#define LIST_H

// Opaque pointer - implementation hidden
typedef struct List List;

List* list_create(void);
void list_destroy(List *list);
void list_add(List *list, int value);

#endif
```

**list.c**
```c
#include "list.h"
#include <stdlib.h>

// Actual implementation (hidden from users)
struct List {
    int *data;
    int size;
    int capacity;
};

List* list_create(void) {
    List *list = malloc(sizeof(List));
    list->capacity = 10;
    list->size = 0;
    list->data = malloc(list->capacity * sizeof(int));
    return list;
}

void list_destroy(List *list) {
    free(list->data);
    free(list);
}

void list_add(List *list, int value) {
    if (list->size >= list->capacity) {
        list->capacity *= 2;
        list->data = realloc(list->data, list->capacity * sizeof(int));
    }
    list->data[list->size++] = value;
}
```

## Common Mistakes

```c
// WRONG: Defining variables in header
// myheader.h
int global_var = 0;  // Error! Multiple definition if included twice

// CORRECT: Declare in header, define in .c
// myheader.h
extern int global_var;

// myheader.c
int global_var = 0;


// WRONG: Missing include guard
// myheader.h
void function();

// If included twice, redefinition error!

// CORRECT: Use include guard
#ifndef MYHEADER_H
#define MYHEADER_H
void function();
#endif


// WRONG: Implementation in header
// utils.h
int add(int a, int b) {
    return a + b;
}

// CORRECT: Only declaration
// utils.h
int add(int a, int b);

// utils.c
int add(int a, int b) {
    return a + b;
}
```

## Compilation Commands

```bash
# Compile to object files
gcc -c file1.c -o file1.o
gcc -c file2.c -o file2.o

# Link object files
gcc file1.o file2.o -o program

# One-step compilation
gcc file1.c file2.c -o program

# With include directory
gcc -I include src/main.c src/utils.c -o program

# Create static library
ar rcs libmylib.a utils.o math.o

# Link with static library
gcc main.c -L. -lmylib -o program

# Create shared library
gcc -shared -fPIC utils.c -o libmylib.so

# Link with shared library
gcc main.c -L. -lmylib -o program
```
