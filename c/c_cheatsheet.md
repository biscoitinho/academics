# C Cheatsheet

## Compilation

```bash
# Compile
gcc file.c -o program

# With warnings
gcc -Wall file.c -o program

# Debug symbols
gcc -g file.c -o program

# Multiple files
gcc main.c utils.c -o program

# Run
./program
```

## Basic Structure

```c
#include <stdio.h>

int main() {
    printf("Hello World\n");
    return 0;
}
```

## Data Types

```c
// Integer types
char c = 'A';           // 1 byte
short s = 100;          // 2 bytes
int i = 1000;           // 4 bytes
long l = 100000L;       // 8 bytes

// Unsigned
unsigned int u = 100;

// Floating point
float f = 3.14f;        // 4 bytes
double d = 3.14159;     // 8 bytes

// Boolean (C99+)
#include <stdbool.h>
bool b = true;
```

## Variables

```c
int x = 10;
const int MAX = 100;    // Constant

// Type casting
int a = 10;
float b = (float)a;
```

## Operators

```c
// Arithmetic
+ - * / %

// Comparison
== != < > <= >=

// Logical
&& || !

// Bitwise
& | ^ ~ << >>

// Assignment
= += -= *= /= %=

// Increment/Decrement
i++ ++i i-- --i

// Ternary
int max = (a > b) ? a : b;
```

## Control Flow

```c
// If-else
if (x > 0) {
    printf("Positive\n");
} else if (x < 0) {
    printf("Negative\n");
} else {
    printf("Zero\n");
}

// Switch
switch (day) {
    case 1:
        printf("Monday\n");
        break;
    case 2:
        printf("Tuesday\n");
        break;
    default:
        printf("Other\n");
}
```

## Loops

```c
// For
for (int i = 0; i < 10; i++) {
    printf("%d ", i);
}

// While
int i = 0;
while (i < 10) {
    printf("%d ", i);
    i++;
}

// Do-while
int i = 0;
do {
    printf("%d ", i);
    i++;
} while (i < 10);

// Break and continue
for (int i = 0; i < 10; i++) {
    if (i == 5) break;      // Exit loop
    if (i == 3) continue;   // Skip iteration
    printf("%d ", i);
}
```

## Arrays

```c
// Declaration
int arr[5];
int arr2[5] = {1, 2, 3, 4, 5};
int arr3[] = {1, 2, 3};  // Size inferred

// Access
arr[0] = 10;
int x = arr[0];

// Iteration
for (int i = 0; i < 5; i++) {
    printf("%d ", arr[i]);
}

// Multidimensional
int matrix[3][3] = {{1,2,3}, {4,5,6}, {7,8,9}};
```

## Strings

```c
#include <string.h>

// Declaration
char str1[] = "Hello";
char str2[20] = "World";

// Length
int len = strlen(str1);

// Copy
strcpy(str2, str1);

// Concatenate
strcat(str1, str2);

// Compare (returns 0 if equal)
if (strcmp(str1, str2) == 0) {
    printf("Equal\n");
}

// Find character
char *ptr = strchr(str1, 'e');
```

## Functions

```c
// Declaration
int add(int a, int b);

// Definition
int add(int a, int b) {
    return a + b;
}

// Void function
void print_message(char *msg) {
    printf("%s\n", msg);
}

// Main
int main() {
    int sum = add(5, 3);
    print_message("Hello");
    return 0;
}
```

## Pointers

```c
int x = 10;
int *ptr = &x;      // Pointer to x

printf("%d\n", *ptr);   // Dereference: 10
*ptr = 20;              // Modify via pointer
printf("%d\n", x);      // x is now 20

// Null pointer
int *p = NULL;

// Pointer arithmetic
int arr[5] = {1, 2, 3, 4, 5};
int *p = arr;
printf("%d\n", *p);     // 1
printf("%d\n", *(p+1)); // 2
```

## Structs

```c
// Definition
struct Person {
    char name[50];
    int age;
    float salary;
};

// Usage
struct Person p1;
strcpy(p1.name, "John");
p1.age = 30;
p1.salary = 50000.0;

// Typedef
typedef struct {
    int x;
    int y;
} Point;

Point p = {10, 20};

// Pointer to struct
Point *ptr = &p;
printf("%d %d\n", ptr->x, ptr->y);
```

## Memory Management

```c
#include <stdlib.h>

// Allocate
int *ptr = malloc(5 * sizeof(int));
if (ptr == NULL) {
    printf("Allocation failed\n");
    return 1;
}

// Initialize to zero
int *ptr2 = calloc(5, sizeof(int));

// Resize
ptr = realloc(ptr, 10 * sizeof(int));

// Free
free(ptr);
ptr = NULL;
```

## File I/O

```c
#include <stdio.h>

// Write
FILE *fp = fopen("file.txt", "w");
if (fp == NULL) {
    perror("Error opening file");
    return 1;
}
fprintf(fp, "Hello World\n");
fclose(fp);

// Read
FILE *fp = fopen("file.txt", "r");
char buffer[100];
while (fgets(buffer, 100, fp) != NULL) {
    printf("%s", buffer);
}
fclose(fp);

// Modes: "r" "w" "a" "r+" "w+" "a+"
```

## Preprocessor

```c
// Include
#include <stdio.h>
#include "myheader.h"

// Define
#define PI 3.14159
#define MAX(a,b) ((a) > (b) ? (a) : (b))

// Conditional compilation
#ifdef DEBUG
    printf("Debug mode\n");
#endif

#ifndef HEADER_H
#define HEADER_H
// Header content
#endif
```

## Common Functions

```c
// stdio.h
printf("format", args);
scanf("format", &var);
getchar();
putchar(c);

// stdlib.h
malloc(size);
calloc(n, size);
realloc(ptr, size);
free(ptr);
exit(0);
atoi("123");    // String to int
atof("3.14");   // String to float

// string.h
strlen(str);
strcpy(dest, src);
strcat(dest, src);
strcmp(str1, str2);
strchr(str, ch);
strstr(str, substr);

// math.h (-lm flag needed)
sqrt(x);
pow(x, y);
ceil(x);
floor(x);
abs(x);
```

## Standard Input/Output

```c
// Printf format specifiers
%d    // int
%f    // float/double
%c    // char
%s    // string
%p    // pointer
%x    // hexadecimal
%o    // octal

// Examples
int n = 42;
printf("%d\n", n);
printf("%.2f\n", 3.14159);  // 2 decimals
printf("%5d\n", n);         // Width 5

// Scanf
int x;
scanf("%d", &x);

char str[50];
scanf("%s", str);           // Reads until whitespace
scanf("%49s", str);         // Limit input size
fgets(str, 50, stdin);      // Read line with spaces
```

## Enums

```c
enum Color {
    RED,      // 0
    GREEN,    // 1
    BLUE      // 2
};

enum Color c = RED;

// Custom values
enum Status {
    ERROR = -1,
    SUCCESS = 0,
    PENDING = 1
};
```

## Common Patterns

```c
// Swap values
void swap(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

// Array size
int arr[] = {1, 2, 3, 4, 5};
int size = sizeof(arr) / sizeof(arr[0]);

// Dynamic 2D array
int **matrix = malloc(rows * sizeof(int*));
for (int i = 0; i < rows; i++) {
    matrix[i] = malloc(cols * sizeof(int));
}

// Free 2D array
for (int i = 0; i < rows; i++) {
    free(matrix[i]);
}
free(matrix);
```
