# C Preprocessor

## #define - Constants

```c
#define PI 3.14159
#define MAX_SIZE 100
#define APP_NAME "MyApp"

int main() {
    double area = PI * 5 * 5;
    int arr[MAX_SIZE];
    printf("%s\n", APP_NAME);
    return 0;
}
```

## #define - Macros

```c
// Simple macro
#define SQUARE(x) ((x) * (x))

// Multi-line macro
#define SWAP(a, b, type) do { \
    type temp = a; \
    a = b; \
    b = temp; \
} while(0)

int main() {
    int result = SQUARE(5);      // 25
    int a = 10, b = 20;
    SWAP(a, b, int);             // a=20, b=10
    return 0;
}
```

## Macro Pitfalls

```c
// WRONG: Missing parentheses
#define SQUARE(x) x * x

int result = SQUARE(2 + 3);  // Expands to: 2 + 3 * 2 + 3 = 11 (wrong!)

// CORRECT: Add parentheses
#define SQUARE(x) ((x) * (x))

int result = SQUARE(2 + 3);  // Expands to: ((2 + 3) * (2 + 3)) = 25 (correct!)


// WRONG: Side effects
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int x = 5;
int result = MAX(x++, 10);  // x incremented twice!

// CORRECT: Use inline function
static inline int max(int a, int b) {
    return (a > b) ? a : b;
}
```

## #include

```c
// System headers (standard library)
#include <stdio.h>
#include <stdlib.h>

// User headers (same directory)
#include "myheader.h"

// User headers (relative path)
#include "lib/utils.h"
```

## Conditional Compilation

```c
#define DEBUG 1

#ifdef DEBUG
    printf("Debug mode\n");
#endif

#ifndef RELEASE
    printf("Not release mode\n");
#endif

#if DEBUG == 1
    printf("Debug level 1\n");
#elif DEBUG == 2
    printf("Debug level 2\n");
#else
    printf("No debug\n");
#endif
```

## Include Guards

```c
// myheader.h
#ifndef MYHEADER_H
#define MYHEADER_H

// Header content
void my_function();

#endif  // MYHEADER_H

// Alternative (non-standard but widely supported)
#pragma once
```

## Platform-Specific Code

```c
#ifdef _WIN32
    #include <windows.h>
    #define PATH_SEPARATOR '\\'
#elif defined(__linux__)
    #include <unistd.h>
    #define PATH_SEPARATOR '/'
#elif defined(__APPLE__)
    #include <sys/types.h>
    #define PATH_SEPARATOR '/'
#else
    #error "Unsupported platform"
#endif
```

## Debug Macros

```c
#ifdef DEBUG
    #define LOG(msg) printf("[DEBUG] %s\n", msg)
    #define LOG_INT(name, val) printf("[DEBUG] %s = %d\n", name, val)
#else
    #define LOG(msg)
    #define LOG_INT(name, val)
#endif

int main() {
    int x = 42;
    LOG("Starting program");      // Only in debug build
    LOG_INT("x", x);               // Only in debug build
    return 0;
}
```

## Predefined Macros

```c
#include <stdio.h>

int main() {
    printf("File: %s\n", __FILE__);      // Current file name
    printf("Line: %d\n", __LINE__);      // Current line number
    printf("Date: %s\n", __DATE__);      // Compilation date
    printf("Time: %s\n", __TIME__);      // Compilation time
    printf("Function: %s\n", __func__);  // Current function (C99)

    #ifdef __STDC__
        printf("Standard C\n");
    #endif

    return 0;
}
```

## Stringification (#)

```c
#define TO_STRING(x) #x

int main() {
    printf("%s\n", TO_STRING(hello));       // "hello"
    printf("%s\n", TO_STRING(123));         // "123"
    printf("%s\n", TO_STRING(a + b));       // "a + b"
    return 0;
}
```

## Token Pasting (##)

```c
#define CONCAT(a, b) a##b

int main() {
    int xy = 10;
    int result = CONCAT(x, y);  // Same as: int result = xy;
    printf("%d\n", result);     // 10

    return 0;
}
```

## Variadic Macros

```c
// C99 variadic macros
#define LOG(format, ...) printf("[LOG] " format "\n", __VA_ARGS__)

// GNU extension (allows empty __VA_ARGS__)
#define DEBUG(format, ...) printf("[DEBUG] " format "\n", ##__VA_ARGS__)

int main() {
    LOG("Value: %d", 42);           // [LOG] Value: 42
    DEBUG("Starting");              // [DEBUG] Starting
    DEBUG("x = %d, y = %d", 1, 2);  // [DEBUG] x = 1, y = 2
    return 0;
}
```

## Assert Macro

```c
#ifdef DEBUG
    #define ASSERT(condition) \
        if (!(condition)) { \
            fprintf(stderr, "Assertion failed: %s, file %s, line %d\n", \
                   #condition, __FILE__, __LINE__); \
            abort(); \
        }
#else
    #define ASSERT(condition)
#endif

int main() {
    int x = 5;
    ASSERT(x > 0);      // OK
    ASSERT(x < 0);      // Fails in debug mode
    return 0;
}
```

## Min/Max Macros

```c
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define CLAMP(x, min, max) (MIN(MAX(x, min), max))

int main() {
    int a = MIN(5, 10);              // 5
    int b = MAX(5, 10);              // 10
    int c = CLAMP(15, 0, 10);        // 10
    int d = CLAMP(-5, 0, 10);        // 0
    return 0;
}
```

## Array Size Macro

```c
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))

int main() {
    int numbers[] = {1, 2, 3, 4, 5};
    int size = ARRAY_SIZE(numbers);  // 5

    for (int i = 0; i < size; i++) {
        printf("%d ", numbers[i]);
    }
    return 0;
}
```

## Offsetof Macro

```c
#include <stddef.h>

typedef struct {
    char a;
    int b;
    double c;
} MyStruct;

int main() {
    printf("Offset of a: %zu\n", offsetof(MyStruct, a));  // 0
    printf("Offset of b: %zu\n", offsetof(MyStruct, b));  // 4
    printf("Offset of c: %zu\n", offsetof(MyStruct, c));  // 8
    return 0;
}
```

## Container Of Macro

```c
#define container_of(ptr, type, member) \
    ((type *)((char *)(ptr) - offsetof(type, member)))

typedef struct {
    int id;
    char name[50];
    double value;
} Record;

int main() {
    Record r = {1, "test", 3.14};
    char *name_ptr = r.name;

    // Get parent struct from member pointer
    Record *r_ptr = container_of(name_ptr, Record, name);
    printf("ID: %d\n", r_ptr->id);  // 1

    return 0;
}
```

## Compile-Time Assertions

```c
// C11 static_assert
#include <assert.h>

static_assert(sizeof(int) == 4, "int must be 4 bytes");

// Pre-C11 alternative
#define STATIC_ASSERT(condition) \
    typedef char static_assertion_##__LINE__[(condition) ? 1 : -1]

STATIC_ASSERT(sizeof(char) == 1);
```

## Macro Tricks

```c
// Do-while(0) trick for multi-statement macros
#define SAFE_FREE(ptr) do { \
    if (ptr) { \
        free(ptr); \
        ptr = NULL; \
    } \
} while(0)

// Unique variable names
#define UNIQUE_VAR(prefix) CONCAT(prefix, __LINE__)

// Bit manipulation
#define SET_BIT(num, pos) ((num) |= (1 << (pos)))
#define CLEAR_BIT(num, pos) ((num) &= ~(1 << (pos)))
#define TOGGLE_BIT(num, pos) ((num) ^= (1 << (pos)))
#define CHECK_BIT(num, pos) ((num) & (1 << (pos)))
```

## Error Directive

```c
#ifndef CONFIG_ENABLED
    #error "CONFIG_ENABLED must be defined"
#endif

#if BUFFER_SIZE < 10
    #error "BUFFER_SIZE too small"
#endif
```

## Warning Directive

```c
#ifdef OLD_API
    #warning "Using deprecated API"
#endif
```

## Pragma Directive

```c
// Once (include guard alternative)
#pragma once

// Pack structure
#pragma pack(push, 1)
struct Packed {
    char a;
    int b;
};
#pragma pack(pop)

// Disable warning
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-variable"
int unused_var;
#pragma GCC diagnostic pop
```

## Macro Best Practices

```c
// 1. Use UPPERCASE for macros
#define MAX_SIZE 100

// 2. Parenthesize arguments
#define SQUARE(x) ((x) * (x))

// 3. Use do-while for multi-statement macros
#define MACRO() do { \
    statement1; \
    statement2; \
} while(0)

// 4. Prefer inline functions when possible
static inline int square(int x) {
    return x * x;
}

// 5. Document macros
/**
 * Calculate square of a number
 * @param x Number to square
 * @return x squared
 */
#define SQUARE(x) ((x) * (x))
```

## #undef

```c
#define TEMP 100

int x = TEMP;  // 100

#undef TEMP

// TEMP is no longer defined
// int y = TEMP;  // Error
```

## Conditional Features

```c
// Feature flags
#define FEATURE_LOGGING 1
#define FEATURE_CACHE 1
#define FEATURE_ENCRYPTION 0

#if FEATURE_LOGGING
    void log_message(const char *msg) {
        printf("[LOG] %s\n", msg);
    }
#else
    #define log_message(msg)  // No-op
#endif

#if FEATURE_CACHE
    void cache_data(void *data) {
        // Caching logic
    }
#endif
```

## Version Checking

```c
#if __STDC_VERSION__ >= 201112L
    // C11 features
    _Static_assert(sizeof(int) == 4, "int size");
#elif __STDC_VERSION__ >= 199901L
    // C99 features
    #define restrict __restrict
#else
    // C89
    #define inline
    #define restrict
#endif
```
