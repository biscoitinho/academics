# Pointers in C

## Basics

```c
int x = 42;
int *ptr = &x;      // Pointer to x

// & = address-of operator
// * = dereference operator

printf("%p\n", ptr);    // Address
printf("%d\n", *ptr);   // Value: 42

*ptr = 100;             // Modify via pointer
printf("%d\n", x);      // x is now 100
```

## Declaration

```c
int *p1;            // Pointer to int
char *p2;           // Pointer to char
float *p3;          // Pointer to float

int *p4, *p5;       // Multiple pointers
int *p6, x;         // p6 is pointer, x is int

// Initialize to NULL
int *ptr = NULL;
if (ptr == NULL) {
    printf("Null pointer\n");
}
```

## Pointer Arithmetic

```c
int arr[] = {10, 20, 30, 40, 50};
int *p = arr;       // Points to first element

printf("%d\n", *p);       // 10
printf("%d\n", *(p+1));   // 20
printf("%d\n", *(p+2));   // 30

p++;                      // Move to next element
printf("%d\n", *p);       // 20

p += 2;                   // Move 2 elements forward
printf("%d\n", *p);       // 40

// Subtract pointers (distance between)
int *p1 = &arr[1];
int *p2 = &arr[4];
int diff = p2 - p1;       // 3
```

## Array and Pointer Relationship

```c
int arr[5] = {1, 2, 3, 4, 5};

// These are equivalent:
arr[0]  ==  *arr
arr[1]  ==  *(arr + 1)
arr[i]  ==  *(arr + i)

// Array name is pointer to first element
int *p = arr;             // No & needed

// Iterate with pointer
for (int *p = arr; p < arr + 5; p++) {
    printf("%d ", *p);
}
```

## Pass by Reference

```c
void swap(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

int main() {
    int x = 10, y = 20;
    swap(&x, &y);
    printf("%d %d\n", x, y);  // 20 10
    return 0;
}
```

## Return Multiple Values

```c
#include <math.h>

void calculate(int n, int *square, double *sqrt_val) {
    *square = n * n;
    *sqrt_val = sqrt(n);
}

int main() {
    int sq;
    double sq_root;
    calculate(100, &sq, &sq_root);
    printf("%d %.2f\n", sq, sq_root);
    return 0;
}
```

## Pointer to Pointer

```c
int x = 42;
int *p = &x;
int **pp = &p;      // Pointer to pointer

printf("%d\n", **pp);   // 42

// Modify via double pointer
**pp = 100;
printf("%d\n", x);      // 100
```

## Dynamic Arrays

```c
#include <stdlib.h>

int n = 5;
int *arr = malloc(n * sizeof(int));

// Use like normal array
for (int i = 0; i < n; i++) {
    arr[i] = i * 10;
}

// Free when done
free(arr);
arr = NULL;
```

## Pointer to Function

```c
int add(int a, int b) {
    return a + b;
}

int multiply(int a, int b) {
    return a * b;
}

int main() {
    // Declare function pointer
    int (*operation)(int, int);

    operation = add;
    printf("%d\n", operation(5, 3));    // 8

    operation = multiply;
    printf("%d\n", operation(5, 3));    // 15

    return 0;
}
```

## Arrays of Pointers

```c
char *names[] = {
    "Alice",
    "Bob",
    "Charlie"
};

for (int i = 0; i < 3; i++) {
    printf("%s\n", names[i]);
}

// 2D array with pointers
int *matrix[3];
for (int i = 0; i < 3; i++) {
    matrix[i] = malloc(4 * sizeof(int));
}
```

## Struct Pointers

```c
typedef struct {
    int x;
    int y;
} Point;

Point p = {10, 20};
Point *ptr = &p;

// Access with arrow operator
printf("%d %d\n", ptr->x, ptr->y);

// Equivalent to:
printf("%d %d\n", (*ptr).x, (*ptr).y);
```

## Const Pointers

```c
int x = 10;

// Pointer to constant int (can't modify value)
const int *p1 = &x;
// *p1 = 20;        // Error
p1 = NULL;          // OK

// Constant pointer (can't reassign pointer)
int *const p2 = &x;
*p2 = 20;           // OK
// p2 = NULL;       // Error

// Constant pointer to constant int
const int *const p3 = &x;
// *p3 = 20;        // Error
// p3 = NULL;       // Error
```

## Void Pointers

```c
void *ptr;          // Generic pointer

int x = 42;
ptr = &x;           // Can point to any type

// Must cast before dereferencing
printf("%d\n", *(int*)ptr);

float f = 3.14;
ptr = &f;
printf("%.2f\n", *(float*)ptr);
```

## Common Mistakes

```c
// Uninitialized pointer
int *p;             // Don't dereference!
// *p = 10;         // Undefined behavior

// Dangling pointer
int *p = malloc(sizeof(int));
free(p);
// *p = 10;         // Error: use after free
p = NULL;           // Good practice

// Lost pointer
int *p = malloc(100);
p = malloc(200);    // Memory leak! Lost first allocation

// Correct way:
int *p = malloc(100);
free(p);
p = malloc(200);

// Return local address
int* get_value() {
    int x = 42;
    return &x;      // Error: x is destroyed
}
```

## Practical Examples

```c
// String copy
void string_copy(char *dest, const char *src) {
    while (*src != '\0') {
        *dest++ = *src++;
    }
    *dest = '\0';
}

// Array reverse
void reverse(int *arr, int size) {
    int *left = arr;
    int *right = arr + size - 1;

    while (left < right) {
        int temp = *left;
        *left = *right;
        *right = temp;
        left++;
        right--;
    }
}

// Find element
int* find(int *arr, int size, int value) {
    for (int i = 0; i < size; i++) {
        if (arr[i] == value) {
            return &arr[i];
        }
    }
    return NULL;
}
```
