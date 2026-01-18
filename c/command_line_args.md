# Command Line Arguments in C

## Basic Usage

```c
#include <stdio.h>

int main(int argc, char *argv[]) {
    // argc = argument count
    // argv = argument vector (array of strings)

    printf("Program: %s\n", argv[0]);
    printf("Arguments: %d\n", argc);

    for (int i = 1; i < argc; i++) {
        printf("arg[%d]: %s\n", i, argv[i]);
    }

    return 0;
}
```

```bash
# Compile and run
gcc program.c -o program
./program hello world 123

# Output:
# Program: ./program
# Arguments: 4
# arg[1]: hello
# arg[2]: world
# arg[3]: 123
```

## Parsing Arguments

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <name> [age]\n", argv[0]);
        return 1;
    }

    char *name = argv[1];
    int age = 0;

    if (argc >= 3) {
        age = atoi(argv[2]);  // String to int
    }

    printf("Name: %s\n", name);
    if (age > 0) {
        printf("Age: %d\n", age);
    }

    return 0;
}
```

## Flag-Based Arguments

```c
#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[]) {
    int verbose = 0;
    char *output = NULL;

    // Parse flags
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-v") == 0 || strcmp(argv[i], "--verbose") == 0) {
            verbose = 1;
        } else if (strcmp(argv[i], "-o") == 0 && i + 1 < argc) {
            output = argv[++i];
        } else {
            printf("Unknown option: %s\n", argv[i]);
            return 1;
        }
    }

    if (verbose) {
        printf("Verbose mode enabled\n");
    }
    if (output) {
        printf("Output file: %s\n", output);
    }

    return 0;
}
```

```bash
./program -v -o output.txt
# Verbose mode enabled
# Output file: output.txt
```

## Using getopt

```c
#include <stdio.h>
#include <unistd.h>  // For getopt

int main(int argc, char *argv[]) {
    int opt;
    int verbose = 0;
    char *output = NULL;

    // Parse options: -v and -o <file>
    while ((opt = getopt(argc, argv, "vo:")) != -1) {
        switch (opt) {
            case 'v':
                verbose = 1;
                break;
            case 'o':
                output = optarg;  // Option argument
                break;
            case '?':
                printf("Unknown option\n");
                return 1;
        }
    }

    if (verbose) {
        printf("Verbose mode\n");
    }
    if (output) {
        printf("Output: %s\n", output);
    }

    // Remaining non-option arguments
    for (int i = optind; i < argc; i++) {
        printf("File: %s\n", argv[i]);
    }

    return 0;
}
```

## File Processing Example

```c
#include <stdio.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <file1> [file2] ...\n", argv[0]);
        return 1;
    }

    // Process each file
    for (int i = 1; i < argc; i++) {
        FILE *fp = fopen(argv[i], "r");
        if (fp == NULL) {
            fprintf(stderr, "Error opening %s\n", argv[i]);
            continue;
        }

        printf("Processing: %s\n", argv[i]);

        char line[256];
        while (fgets(line, sizeof(line), fp)) {
            printf("%s", line);
        }

        fclose(fp);
    }

    return 0;
}
```

## Validation

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int is_number(const char *str) {
    for (int i = 0; str[i]; i++) {
        if (str[i] < '0' || str[i] > '9') {
            return 0;
        }
    }
    return 1;
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Usage: %s <num1> <num2>\n", argv[0]);
        return 1;
    }

    if (!is_number(argv[1]) || !is_number(argv[2])) {
        fprintf(stderr, "Error: Arguments must be numbers\n");
        return 1;
    }

    int a = atoi(argv[1]);
    int b = atoi(argv[2]);

    printf("%d + %d = %d\n", a, b, a + b);

    return 0;
}
```

## Common Patterns

```c
// Help message
void print_usage(const char *program) {
    printf("Usage: %s [OPTIONS] <file>\n", program);
    printf("Options:\n");
    printf("  -h, --help     Show this help\n");
    printf("  -v, --verbose  Verbose output\n");
    printf("  -o FILE        Output file\n");
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        print_usage(argv[0]);
        return 1;
    }

    // Check for help
    if (strcmp(argv[1], "-h") == 0 || strcmp(argv[1], "--help") == 0) {
        print_usage(argv[0]);
        return 0;
    }

    // ... rest of program
    return 0;
}
```

## Environment Variables

```c
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[], char *envp[]) {
    // Method 1: Using envp
    printf("Environment:\n");
    for (int i = 0; envp[i] != NULL; i++) {
        printf("%s\n", envp[i]);
    }

    // Method 2: Using getenv
    char *home = getenv("HOME");
    if (home) {
        printf("HOME: %s\n", home);
    }

    char *path = getenv("PATH");
    if (path) {
        printf("PATH: %s\n", path);
    }

    return 0;
}
```

## Calculator Example

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    if (argc != 4) {
        printf("Usage: %s <num1> <op> <num2>\n", argv[0]);
        printf("Example: %s 10 + 5\n", argv[0]);
        return 1;
    }

    double a = atof(argv[1]);
    char *op = argv[2];
    double b = atof(argv[3]);
    double result;

    if (strcmp(op, "+") == 0) {
        result = a + b;
    } else if (strcmp(op, "-") == 0) {
        result = a - b;
    } else if (strcmp(op, "*") == 0 || strcmp(op, "x") == 0) {
        result = a * b;
    } else if (strcmp(op, "/") == 0) {
        if (b == 0) {
            fprintf(stderr, "Error: Division by zero\n");
            return 1;
        }
        result = a / b;
    } else {
        fprintf(stderr, "Error: Unknown operator '%s'\n", op);
        return 1;
    }

    printf("%.2f %s %.2f = %.2f\n", a, op, b, result);
    return 0;
}
```

```bash
./calc 10 + 5      # 10.00 + 5.00 = 15.00
./calc 20 - 8      # 20.00 - 8.00 = 12.00
./calc 4 x 3       # 4.00 x 3.00 = 12.00
./calc 15 / 3      # 15.00 / 3.00 = 5.00
```
