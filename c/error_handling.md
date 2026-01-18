# Error Handling in C

## Return Codes

```c
#include <stdio.h>

// Return 0 for success, -1 for error
int divide(int a, int b, int *result) {
    if (b == 0) {
        return -1;  // Error
    }
    *result = a / b;
    return 0;  // Success
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

## errno - Global Error Variable

```c
#include <stdio.h>
#include <errno.h>
#include <string.h>

int main() {
    FILE *fp = fopen("nonexistent.txt", "r");

    if (fp == NULL) {
        printf("Error code: %d\n", errno);
        printf("Error message: %s\n", strerror(errno));
        return 1;
    }

    fclose(fp);
    return 0;
}
```

## perror - Print Error

```c
#include <stdio.h>
#include <errno.h>

int main() {
    FILE *fp = fopen("missing.txt", "r");

    if (fp == NULL) {
        perror("Error opening file");  // Prints: "Error opening file: No such file or directory"
        return 1;
    }

    fclose(fp);
    return 0;
}
```

## Error Codes Enum

```c
typedef enum {
    ERR_SUCCESS = 0,
    ERR_NULL_POINTER = -1,
    ERR_INVALID_ARGUMENT = -2,
    ERR_OUT_OF_MEMORY = -3,
    ERR_FILE_NOT_FOUND = -4,
    ERR_PERMISSION_DENIED = -5
} ErrorCode;

const char* error_string(ErrorCode code) {
    switch (code) {
        case ERR_SUCCESS: return "Success";
        case ERR_NULL_POINTER: return "Null pointer";
        case ERR_INVALID_ARGUMENT: return "Invalid argument";
        case ERR_OUT_OF_MEMORY: return "Out of memory";
        case ERR_FILE_NOT_FOUND: return "File not found";
        case ERR_PERMISSION_DENIED: return "Permission denied";
        default: return "Unknown error";
    }
}

ErrorCode process_data(int *data, int size) {
    if (data == NULL) {
        return ERR_NULL_POINTER;
    }
    if (size <= 0) {
        return ERR_INVALID_ARGUMENT;
    }

    // Process data...
    return ERR_SUCCESS;
}

int main() {
    int arr[] = {1, 2, 3};
    ErrorCode result = process_data(arr, 3);

    if (result != ERR_SUCCESS) {
        printf("Error: %s\n", error_string(result));
        return 1;
    }

    printf("Success!\n");
    return 0;
}
```

## Assert for Debug

```c
#include <assert.h>
#include <stdio.h>

int divide(int a, int b) {
    assert(b != 0);  // Abort if b is 0 (debug only)
    return a / b;
}

int main() {
    int result = divide(10, 2);  // OK
    printf("%d\n", result);

    // result = divide(10, 0);  // Abort with assertion failure

    return 0;
}
```

```bash
# Compile with assertions enabled (default)
gcc program.c -o program

# Compile with assertions disabled (release)
gcc -DNDEBUG program.c -o program
```

## Goto for Cleanup

```c
#include <stdlib.h>
#include <stdio.h>

int process_files(const char *file1, const char *file2) {
    FILE *fp1 = NULL;
    FILE *fp2 = NULL;
    char *buffer = NULL;
    int result = -1;

    fp1 = fopen(file1, "r");
    if (fp1 == NULL) {
        goto cleanup;
    }

    fp2 = fopen(file2, "w");
    if (fp2 == NULL) {
        goto cleanup;
    }

    buffer = malloc(1024);
    if (buffer == NULL) {
        goto cleanup;
    }

    // Process files...
    result = 0;  // Success

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

int risky_operation(Error *err) {
    if (/* some condition */) {
        SET_ERROR(err, 1, "Operation failed");
        return -1;
    }
    return 0;
}

int main() {
    Error err = {0};
    if (risky_operation(&err) != 0) {
        print_error(&err);
        return 1;
    }
    return 0;
}
```

## File Operations Error Handling

```c
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

int read_file(const char *filename, char **content, size_t *size) {
    FILE *fp = fopen(filename, "rb");
    if (fp == NULL) {
        fprintf(stderr, "Cannot open %s: %s\n", filename, strerror(errno));
        return -1;
    }

    // Get file size
    fseek(fp, 0, SEEK_END);
    *size = ftell(fp);
    fseek(fp, 0, SEEK_SET);

    // Allocate buffer
    *content = malloc(*size + 1);
    if (*content == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        fclose(fp);
        return -1;
    }

    // Read file
    size_t read_size = fread(*content, 1, *size, fp);
    if (read_size != *size) {
        fprintf(stderr, "Read error: %s\n", strerror(errno));
        free(*content);
        fclose(fp);
        return -1;
    }

    (*content)[*size] = '\0';
    fclose(fp);
    return 0;
}

int main() {
    char *content;
    size_t size;

    if (read_file("test.txt", &content, &size) == 0) {
        printf("File size: %zu\n", size);
        printf("Content: %s\n", content);
        free(content);
        return 0;
    }

    return 1;
}
```

## Memory Allocation Errors

```c
#include <stdlib.h>
#include <stdio.h>

int* safe_malloc_array(int size) {
    if (size <= 0) {
        fprintf(stderr, "Invalid size: %d\n", size);
        return NULL;
    }

    int *arr = malloc(size * sizeof(int));
    if (arr == NULL) {
        fprintf(stderr, "Memory allocation failed for size %d\n", size);
        return NULL;
    }

    return arr;
}

int main() {
    int *arr = safe_malloc_array(100);
    if (arr == NULL) {
        return 1;
    }

    // Use array...

    free(arr);
    return 0;
}
```

## Defensive Programming

```c
#include <stdio.h>
#include <string.h>

// Validate all inputs
int string_length(const char *str) {
    if (str == NULL) {
        fprintf(stderr, "Error: NULL string\n");
        return -1;
    }
    return strlen(str);
}

// Bounds checking
int safe_array_access(int *arr, int size, int index, int *value) {
    if (arr == NULL) {
        return -1;
    }
    if (index < 0 || index >= size) {
        fprintf(stderr, "Index %d out of bounds [0, %d)\n", index, size);
        return -1;
    }

    *value = arr[index];
    return 0;
}

// Prevent buffer overflow
void safe_string_copy(char *dest, const char *src, size_t dest_size) {
    if (dest == NULL || src == NULL || dest_size == 0) {
        return;
    }

    strncpy(dest, src, dest_size - 1);
    dest[dest_size - 1] = '\0';  // Ensure null termination
}
```

## Common Error Patterns

```c
// Pattern 1: Check and return
int function() {
    if (error_condition) {
        return -1;
    }
    // Continue...
    return 0;
}

// Pattern 2: Check and cleanup
int function() {
    void *ptr = malloc(100);
    if (ptr == NULL) {
        return -1;
    }

    if (error_condition) {
        free(ptr);
        return -1;
    }

    free(ptr);
    return 0;
}

// Pattern 3: Multiple checks with goto
int function() {
    int *a = NULL;
    int *b = NULL;

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

## Exit Codes

```c
#include <stdlib.h>

int main() {
    // Standard exit codes
    return EXIT_SUCCESS;  // 0
    return EXIT_FAILURE;  // 1

    // Or use exit()
    exit(EXIT_SUCCESS);
    exit(EXIT_FAILURE);

    // Custom codes
    return 2;  // Custom error code
}
```

## Signal Handling

```c
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>

void signal_handler(int signum) {
    printf("\nCaught signal %d\n", signum);
    // Cleanup...
    exit(signum);
}

int main() {
    // Register signal handler
    signal(SIGINT, signal_handler);   // Ctrl+C
    signal(SIGTERM, signal_handler);  // Termination

    printf("Running... Press Ctrl+C to stop\n");

    while (1) {
        // Do work...
    }

    return 0;
}
```

## Logging Errors

```c
#include <stdio.h>
#include <time.h>
#include <stdarg.h>

void log_error(const char *format, ...) {
    FILE *log = fopen("error.log", "a");
    if (log == NULL) {
        return;
    }

    // Timestamp
    time_t now = time(NULL);
    char *time_str = ctime(&now);
    time_str[strlen(time_str) - 1] = '\0';  // Remove newline

    fprintf(log, "[%s] ERROR: ", time_str);

    // Variable arguments
    va_list args;
    va_start(args, format);
    vfprintf(log, format, args);
    va_end(args);

    fprintf(log, "\n");
    fclose(log);
}

int main() {
    log_error("Failed to open file: %s", "data.txt");
    log_error("Invalid value: %d", 42);
    return 0;
}
```

## Best Practices

```c
// 1. Always check return values
FILE *fp = fopen("file.txt", "r");
if (fp == NULL) {
    // Handle error
}

// 2. Clean up resources
void *ptr = malloc(100);
if (ptr == NULL) {
    return -1;
}
// ... use ptr ...
free(ptr);

// 3. Use meaningful error codes
#define ERR_INVALID_INPUT -1
#define ERR_OUT_OF_MEMORY -2

// 4. Provide context in error messages
fprintf(stderr, "Error: Cannot open '%s': %s\n", filename, strerror(errno));

// 5. Don't ignore errors
// BAD:
fclose(fp);

// GOOD:
if (fclose(fp) != 0) {
    perror("Error closing file");
}
```
