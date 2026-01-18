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
// Simple macro (always parenthesize!)
#define SQUARE(x) ((x) * (x))
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

// Multi-line macro
#define SWAP(a, b, type) do { \
    type temp = a; \
    a = b; \
    b = temp; \
} while(0)

int main() {
    int result = SQUARE(5);          // 25
    int max = MAX(10, 20);           // 20
    int a = 5, b = 10;
    SWAP(a, b, int);                 // a=10, b=5
    return 0;
}
```

## Macro Pitfalls

```c
// WRONG: Missing parentheses
#define SQUARE(x) x * x
SQUARE(2 + 3);  // Expands to: 2 + 3 * 2 + 3 = 11 (wrong!)

// CORRECT
#define SQUARE(x) ((x) * (x))
SQUARE(2 + 3);  // Expands to: ((2 + 3) * (2 + 3)) = 25 (correct!)

// WRONG: Side effects
#define MAX(a, b) ((a) > (b) ? (a) : (b))
int x = 5;
MAX(x++, 10);  // x incremented twice!

// CORRECT: Use inline function
static inline int max(int a, int b) {
    return (a > b) ? a : b;
}
```

## #include

```c
#include <stdio.h>      // System header
#include <stdlib.h>     // Search in system directories

#include "myheader.h"   // User header (same directory)
#include "lib/utils.h"  // User header (relative path)
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

## Conditional Compilation

```c
#define DEBUG 1

#ifdef DEBUG
    printf("Debug mode\n");
#endif

#ifndef RELEASE
    printf("Not release\n");
#endif

#if DEBUG == 1
    printf("Debug level 1\n");
#elif DEBUG == 2
    printf("Debug level 2\n");
#else
    printf("No debug\n");
#endif
```

## Platform-Specific Code

```c
#ifdef _WIN32
    #include <windows.h>
    #define PATH_SEP '\\'
#elif defined(__linux__)
    #include <unistd.h>
    #define PATH_SEP '/'
#elif defined(__APPLE__)
    #include <sys/types.h>
    #define PATH_SEP '/'
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
    LOG("Starting");    // Only in debug build
    LOG_INT("x", x);    // Only in debug build
    return 0;
}
```

## Predefined Macros

```c
int main() {
    printf("File: %s\n", __FILE__);      // Current file
    printf("Line: %d\n", __LINE__);      // Current line
    printf("Date: %s\n", __DATE__);      // Compilation date
    printf("Time: %s\n", __TIME__);      // Compilation time
    printf("Function: %s\n", __func__);  // Current function (C99)
    return 0;
}
```

## Stringification (#)

```c
#define TO_STRING(x) #x

int main() {
    printf("%s\n", TO_STRING(hello));    // "hello"
    printf("%s\n", TO_STRING(123));      // "123"
    printf("%s\n", TO_STRING(a + b));    // "a + b"
    return 0;
}
```

## Token Pasting (##)

```c
#define CONCAT(a, b) a##b

int main() {
    int xy = 10;
    int result = CONCAT(x, y);  // Same as: xy
    printf("%d\n", result);     // 10
    return 0;
}
```

## Variadic Macros

```c
// C99 variadic macros
#define LOG(format, ...) printf("[LOG] " format "\n", __VA_ARGS__)

// GNU extension (allows empty args)
#define DEBUG(format, ...) printf("[DEBUG] " format "\n", ##__VA_ARGS__)

int main() {
    LOG("Value: %d", 42);          // [LOG] Value: 42
    DEBUG("Starting");             // [DEBUG] Starting
    DEBUG("x = %d", 10);           // [DEBUG] x = 10
    return 0;
}
```

## Common Utility Macros

```c
// Array size
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))

// Min/Max with clamp
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define CLAMP(x, min, max) (MIN(MAX(x, min), max))

// Bit manipulation
#define SET_BIT(num, pos) ((num) |= (1 << (pos)))
#define CLEAR_BIT(num, pos) ((num) &= ~(1 << (pos)))
#define TOGGLE_BIT(num, pos) ((num) ^= (1 << (pos)))
#define CHECK_BIT(num, pos) ((num) & (1 << (pos)))

// Safe free
#define SAFE_FREE(ptr) do { \
    if (ptr) { \
        free(ptr); \
        ptr = NULL; \
    } \
} while(0)
```

## Assert Macro

```c
#ifdef DEBUG
    #define ASSERT(condition) \
        if (!(condition)) { \
            fprintf(stderr, "Assertion failed: %s, %s:%d\n", \
                   #condition, __FILE__, __LINE__); \
            abort(); \
        }
#else
    #define ASSERT(condition)
#endif

int main() {
    int x = 5;
    ASSERT(x > 0);     // OK
    ASSERT(x < 0);     // Fails in debug
    return 0;
}
```

## Error and Warning Directives

```c
#ifndef CONFIG_ENABLED
    #error "CONFIG_ENABLED must be defined"
#endif

#if BUFFER_SIZE < 10
    #error "BUFFER_SIZE too small"
#endif

#ifdef OLD_API
    #warning "Using deprecated API"
#endif
```

## Pragma Directive

```c
// Include guard alternative
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
int unused;
#pragma GCC diagnostic pop
```

## #undef

```c
#define TEMP 100
int x = TEMP;  // 100

#undef TEMP
// int y = TEMP;  // Error: TEMP undefined
```

## Conditional Features

```c
#define FEATURE_LOGGING 1
#define FEATURE_CACHE 0

#if FEATURE_LOGGING
    void log_message(const char *msg) {
        printf("[LOG] %s\n", msg);
    }
#else
    #define log_message(msg)
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

## Best Practices

```c
// 1. Use UPPERCASE for macros
#define MAX_SIZE 100

// 2. Always parenthesize macro arguments
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

// 5. Use meaningful names
#define DEBUG_MODE 1  // Better than #define D 1
```
