# Memory Management in C

## malloc - Memory Allocation

```c
#include <stdlib.h>

// Allocate memory
int *ptr = malloc(5 * sizeof(int));

// Check if allocation succeeded
if (ptr == NULL) {
    printf("Memory allocation failed\n");
    return 1;
}

// Use the memory
for (int i = 0; i < 5; i++) {
    ptr[i] = i * 10;
}

// Free when done
free(ptr);
ptr = NULL;  // Good practice

// Single value
int *num = malloc(sizeof(int));
*num = 42;
free(num);
```

## calloc - Cleared Allocation

```c
// Allocates and initializes to zero
int *arr = calloc(5, sizeof(int));

// All elements are 0
for (int i = 0; i < 5; i++) {
    printf("%d ", arr[i]);  // 0 0 0 0 0
}

free(arr);

// Difference from malloc:
int *m = malloc(5 * sizeof(int));   // Garbage values
int *c = calloc(5, sizeof(int));    // All zeros
```

## realloc - Resize Memory

```c
// Initial allocation
int *arr = malloc(5 * sizeof(int));
for (int i = 0; i < 5; i++) {
    arr[i] = i;
}

// Resize to 10 elements
int *temp = realloc(arr, 10 * sizeof(int));

if (temp == NULL) {
    printf("Reallocation failed\n");
    free(arr);  // Original still valid
    return 1;
}

arr = temp;  // Update pointer

// Old values preserved, new space uninitialized
for (int i = 5; i < 10; i++) {
    arr[i] = i;
}

free(arr);
```

## free - Deallocate Memory

```c
int *ptr = malloc(100 * sizeof(int));

// Use memory...

// Free it
free(ptr);

// Set to NULL to avoid dangling pointer
ptr = NULL;

// Don't use after free!
// *ptr = 10;  // Undefined behavior

// Don't double free!
// free(ptr);  // Error if called twice
```

## Dynamic Arrays

```c
// 1D array
int n = 10;
int *arr = malloc(n * sizeof(int));

for (int i = 0; i < n; i++) {
    arr[i] = i * 2;
}

free(arr);

// Growing array
int capacity = 5;
int *arr = malloc(capacity * sizeof(int));
int size = 0;

// Add elements
for (int i = 0; i < 10; i++) {
    if (size >= capacity) {
        capacity *= 2;
        arr = realloc(arr, capacity * sizeof(int));
    }
    arr[size++] = i;
}

free(arr);
```

## Dynamic 2D Arrays

```c
// Method 1: Array of pointers
int rows = 3, cols = 4;
int **matrix = malloc(rows * sizeof(int*));

for (int i = 0; i < rows; i++) {
    matrix[i] = malloc(cols * sizeof(int));
}

// Use it
matrix[0][0] = 1;

// Free it
for (int i = 0; i < rows; i++) {
    free(matrix[i]);
}
free(matrix);

// Method 2: Single allocation
int *flat = malloc(rows * cols * sizeof(int));

// Access as 2D: flat[i * cols + j]
flat[0 * cols + 0] = 1;  // [0][0]
flat[1 * cols + 2] = 5;  // [1][2]

free(flat);
```

## Dynamic Strings

```c
// Allocate string
char *str = malloc(50 * sizeof(char));
strcpy(str, "Hello");

// Resize if needed
str = realloc(str, 100 * sizeof(char));
strcat(str, " World");

free(str);

// String duplication
char *original = "Hello";
char *copy = malloc(strlen(original) + 1);
strcpy(copy, original);
free(copy);

// Or use strdup (allocates automatically)
char *dup = strdup("Hello");
free(dup);
```

## Structures

```c
typedef struct {
    char *name;
    int age;
    float salary;
} Person;

// Allocate structure
Person *p = malloc(sizeof(Person));

// Allocate string inside
p->name = malloc(50 * sizeof(char));
strcpy(p->name, "John");
p->age = 30;
p->salary = 50000.0;

// Free
free(p->name);
free(p);

// Array of structures
Person *people = malloc(10 * sizeof(Person));
for (int i = 0; i < 10; i++) {
    people[i].name = malloc(50);
}
// Free all
for (int i = 0; i < 10; i++) {
    free(people[i].name);
}
free(people);
```

## Memory Leaks

```c
// LEAK: Lost pointer
void leak_example() {
    int *ptr = malloc(100 * sizeof(int));
    ptr = malloc(200 * sizeof(int));  // Lost first allocation!
    free(ptr);  // Only frees second allocation
}

// FIX: Free before reassigning
void correct_example() {
    int *ptr = malloc(100 * sizeof(int));
    free(ptr);
    ptr = malloc(200 * sizeof(int));
    free(ptr);
}

// LEAK: Forgetting to free
void another_leak() {
    int *ptr = malloc(100 * sizeof(int));
    // ... use ptr ...
    // Function returns without free(ptr)
}

// LEAK: Early return
void early_return_leak(int condition) {
    int *ptr = malloc(100 * sizeof(int));

    if (condition) {
        return;  // Leak! Forgot to free
    }

    free(ptr);
}

// FIX: Free before all returns
void fixed_early_return(int condition) {
    int *ptr = malloc(100 * sizeof(int));

    if (condition) {
        free(ptr);
        return;
    }

    free(ptr);
}
```

## Common Errors

```c
// Use after free
int *ptr = malloc(sizeof(int));
free(ptr);
*ptr = 10;  // Error! Undefined behavior

// Double free
int *ptr = malloc(sizeof(int));
free(ptr);
free(ptr);  // Error! Crash or corruption

// Memory leak
for (int i = 0; i < 1000; i++) {
    int *ptr = malloc(1000);  // Never freed!
}

// Freeing stack memory
int x = 10;
int *ptr = &x;
free(ptr);  // Error! x is on stack, not heap

// Freeing wrong pointer
int *base = malloc(100 * sizeof(int));
int *ptr = base + 10;
free(ptr);  // Error! Must free base

// Buffer overflow
int *arr = malloc(5 * sizeof(int));
arr[10] = 100;  // Error! Out of bounds

// Using uninitialized memory
int *ptr = malloc(sizeof(int));
printf("%d\n", *ptr);  // Undefined! Garbage value

// Correct: Initialize first
int *ptr = malloc(sizeof(int));
*ptr = 0;
```

## Best Practices

```c
// Always check allocation
int *ptr = malloc(size);
if (ptr == NULL) {
    // Handle error
    return -1;
}

// Initialize allocated memory
int *arr = calloc(n, sizeof(int));  // Zeros
// or
int *arr = malloc(n * sizeof(int));
memset(arr, 0, n * sizeof(int));    // Zeros

// Set to NULL after free
free(ptr);
ptr = NULL;

// Free in reverse order of allocation
int *p1 = malloc(100);
int *p2 = malloc(100);
free(p2);
free(p1);

// Match every malloc with free
void function() {
    int *ptr = malloc(100);
    // ... use ptr ...
    free(ptr);
}

// Use sizeof with type
int *arr = malloc(n * sizeof(*arr));  // Better than sizeof(int)
```

## Memory Functions

```c
#include <string.h>

// Set memory to value
int *arr = malloc(10 * sizeof(int));
memset(arr, 0, 10 * sizeof(int));  // All zeros

// Copy memory
int src[] = {1, 2, 3, 4, 5};
int *dest = malloc(5 * sizeof(int));
memcpy(dest, src, 5 * sizeof(int));

// Move memory (handles overlap)
memmove(dest, src, 5 * sizeof(int));

// Compare memory
if (memcmp(arr1, arr2, n * sizeof(int)) == 0) {
    printf("Arrays equal\n");
}

free(dest);
free(arr);
```

## Stack vs Heap

```c
// Stack allocation (automatic)
void stack_example() {
    int arr[100];  // Allocated on stack
    // Automatically freed when function returns
}

// Heap allocation (manual)
void heap_example() {
    int *arr = malloc(100 * sizeof(int));  // On heap
    // Must explicitly free
    free(arr);
}

// Stack: Fast, limited size, automatic cleanup
// Heap: Slower, large size, manual cleanup

// Large data should go on heap
int *big = malloc(1000000 * sizeof(int));  // Use heap
// int big[1000000];  // Stack overflow!
```

## Practical Example

```c
// Dynamic string array
typedef struct {
    char **items;
    int size;
    int capacity;
} StringArray;

StringArray* create_array() {
    StringArray *arr = malloc(sizeof(StringArray));
    arr->capacity = 10;
    arr->size = 0;
    arr->items = malloc(arr->capacity * sizeof(char*));
    return arr;
}

void add_string(StringArray *arr, const char *str) {
    if (arr->size >= arr->capacity) {
        arr->capacity *= 2;
        arr->items = realloc(arr->items, arr->capacity * sizeof(char*));
    }
    arr->items[arr->size] = strdup(str);
    arr->size++;
}

void free_array(StringArray *arr) {
    for (int i = 0; i < arr->size; i++) {
        free(arr->items[i]);
    }
    free(arr->items);
    free(arr);
}

// Usage
StringArray *arr = create_array();
add_string(arr, "Hello");
add_string(arr, "World");
free_array(arr);
```
