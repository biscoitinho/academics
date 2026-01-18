# Error Handling in C

## Return Codes

```c
// Return 0 for success, -1 for error
int divide(int a, int b, int *result) {
    if (b == 0) return -1;
    *result = a / b;
    return 0;
}

int main() {
    int result;
    if (divide(10, 2, &result) == 0) {
        printf("Result: %d\n", result);
    } else {
        printf("Error: Division by zero\n");
    }
    return 0;
}
```

## errno and perror

```c
#include <stdio.h>
#include <errno.h>
#include <string.h>

int main() {
    FILE *fp = fopen("missing.txt", "r");

    if (fp == NULL) {
        // Method 1: perror (prints to stderr)
        perror("Error");  // "Error: No such file or directory"

        // Method 2: strerror
        printf("Error: %s\n", strerror(errno));

        // Method 3: errno code
        printf("Error code: %d\n", errno);

        return 1;
    }

    fclose(fp);
    return 0;
}
```

## Error Code Enum

```c
typedef enum {
    ERR_SUCCESS = 0,
    ERR_NULL_POINTER = -1,
    ERR_INVALID_ARG = -2,
    ERR_OUT_OF_MEMORY = -3,
    ERR_FILE_NOT_FOUND = -4
} ErrorCode;

const char* error_string(ErrorCode code) {
    switch (code) {
        case ERR_SUCCESS: return "Success";
        case ERR_NULL_POINTER: return "Null pointer";
        case ERR_INVALID_ARG: return "Invalid argument";
        case ERR_OUT_OF_MEMORY: return "Out of memory";
        case ERR_FILE_NOT_FOUND: return "File not found";
        default: return "Unknown error";
    }
}

ErrorCode process_data(int *data, int size) {
    if (data == NULL) return ERR_NULL_POINTER;
    if (size <= 0) return ERR_INVALID_ARG;
    // Process data...
    return ERR_SUCCESS;
}
```

## Assert for Debugging

```c
#include <assert.h>

int divide(int a, int b) {
    assert(b != 0);  // Abort if b is 0 (debug only)
    return a / b;
}

// Compile with assertions: gcc program.c -o program
// Disable assertions: gcc -DNDEBUG program.c -o program
```

## Goto for Cleanup

```c
int process_files(const char *file1, const char *file2) {
    FILE *fp1 = NULL;
    FILE *fp2 = NULL;
    char *buffer = NULL;
    int result = -1;

    fp1 = fopen(file1, "r");
    if (!fp1) goto cleanup;

    fp2 = fopen(file2, "w");
    if (!fp2) goto cleanup;

    buffer = malloc(1024);
    if (!buffer) goto cleanup;

    // Process files...
    result = 0;

cleanup:
    if (fp1) fclose(fp1);
    if (fp2) fclose(fp2);
    if (buffer) free(buffer);
    return result;
}
```

## Custom Error Structure

```c
typedef struct {
    int code;
    char message[256];
    const char *file;
    int line;
} Error;

#define SET_ERROR(err, c, msg) do { \
    (err)->code = (c); \
    snprintf((err)->message, 256, "%s", (msg)); \
    (err)->file = __FILE__; \
    (err)->line = __LINE__; \
} while(0)

void print_error(Error *err) {
    printf("Error %d: %s\n", err->code, err->message);
    printf("  at %s:%d\n", err->file, err->line);
}
```

## File Operations

```c
int read_file(const char *filename, char **content, size_t *size) {
    FILE *fp = fopen(filename, "rb");
    if (!fp) {
        fprintf(stderr, "Cannot open %s: %s\n", filename, strerror(errno));
        return -1;
    }

    // Get file size
    fseek(fp, 0, SEEK_END);
    *size = ftell(fp);
    fseek(fp, 0, SEEK_SET);

    // Allocate and read
    *content = malloc(*size + 1);
    if (!*content) {
        fclose(fp);
        return -1;
    }

    if (fread(*content, 1, *size, fp) != *size) {
        free(*content);
        fclose(fp);
        return -1;
    }

    (*content)[*size] = '\0';
    fclose(fp);
    return 0;
}
```

## Defensive Programming

```c
// Validate inputs
int string_length(const char *str) {
    if (!str) {
        fprintf(stderr, "Error: NULL string\n");
        return -1;
    }
    return strlen(str);
}

// Bounds checking
int safe_array_access(int *arr, int size, int index, int *value) {
    if (!arr || index < 0 || index >= size) {
        return -1;
    }
    *value = arr[index];
    return 0;
}

// Prevent buffer overflow
void safe_copy(char *dest, const char *src, size_t dest_size) {
    if (!dest || !src || dest_size == 0) return;
    strncpy(dest, src, dest_size - 1);
    dest[dest_size - 1] = '\0';
}
```

## Common Error Patterns

```c
// Pattern 1: Check and return
int function() {
    if (error_condition) return -1;
    // Continue...
    return 0;
}

// Pattern 2: Check with cleanup
int function() {
    void *ptr = malloc(100);
    if (!ptr) return -1;

    if (error_condition) {
        free(ptr);
        return -1;
    }

    free(ptr);
    return 0;
}

// Pattern 3: Multiple checks with goto
int function() {
    int *a = NULL, *b = NULL;

    a = malloc(100);
    if (!a) goto error;

    b = malloc(200);
    if (!b) goto error;

    // Success
    free(a);
    free(b);
    return 0;

error:
    if (a) free(a);
    if (b) free(b);
    return -1;
}
```

## Signal Handling

```c
#include <signal.h>

void signal_handler(int signum) {
    printf("\nCaught signal %d\n", signum);
    // Cleanup...
    exit(signum);
}

int main() {
    signal(SIGINT, signal_handler);   // Ctrl+C
    signal(SIGTERM, signal_handler);  // Termination

    while (1) {
        // Do work...
    }
    return 0;
}
```

## Logging

```c
#include <stdarg.h>
#include <time.h>

void log_error(const char *format, ...) {
    FILE *log = fopen("error.log", "a");
    if (!log) return;

    // Timestamp
    time_t now = time(NULL);
    char *time_str = ctime(&now);
    time_str[strlen(time_str) - 1] = '\0';

    fprintf(log, "[%s] ERROR: ", time_str);

    // Variable arguments
    va_list args;
    va_start(args, format);
    vfprintf(log, format, args);
    va_end(args);

    fprintf(log, "\n");
    fclose(log);
}

// Usage
log_error("Failed to open %s", "data.txt");
log_error("Invalid value: %d", 42);
```

## Best Practices

```c
// 1. Always check return values
FILE *fp = fopen("file.txt", "r");
if (!fp) {
    // Handle error
}

// 2. Clean up resources
void *ptr = malloc(100);
if (!ptr) return -1;
// ... use ptr ...
free(ptr);

// 3. Use meaningful error codes
#define ERR_INVALID_INPUT -1
#define ERR_OUT_OF_MEMORY -2

// 4. Provide context
fprintf(stderr, "Error: Cannot open '%s': %s\n", filename, strerror(errno));

// 5. Don't ignore errors
if (fclose(fp) != 0) {
    perror("Error closing file");
}
```
