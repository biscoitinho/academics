# Loops in C

## For Loop

```c
// Basic for loop
for (int i = 0; i < 10; i++) {
    printf("%d ", i);
}

// Initialize outside
int i;
for (i = 0; i < 10; i++) {
    printf("%d ", i);
}

// Multiple variables
for (int i = 0, j = 10; i < j; i++, j--) {
    printf("%d %d\n", i, j);
}

// Decrement
for (int i = 10; i > 0; i--) {
    printf("%d ", i);
}

// Step by 2
for (int i = 0; i < 10; i += 2) {
    printf("%d ", i);
}

// Infinite loop
for (;;) {
    printf("Forever\n");
    break;  // Need break to exit
}
```

## While Loop

```c
// Basic while
int i = 0;
while (i < 10) {
    printf("%d ", i);
    i++;
}

// Condition first
while (i < 100) {
    i *= 2;
}

// Reading input
char ch;
while ((ch = getchar()) != '\n') {
    printf("%c", ch);
}

// Infinite loop
while (1) {
    printf("Forever\n");
    break;
}
```

## Do-While Loop

```c
// Executes at least once
int i = 0;
do {
    printf("%d ", i);
    i++;
} while (i < 10);

// Menu example
int choice;
do {
    printf("1. Option 1\n");
    printf("2. Option 2\n");
    printf("0. Exit\n");
    scanf("%d", &choice);
} while (choice != 0);

// Input validation
int num;
do {
    printf("Enter positive number: ");
    scanf("%d", &num);
} while (num <= 0);
```

## Break Statement

```c
// Exit loop
for (int i = 0; i < 10; i++) {
    if (i == 5) {
        break;      // Exit at 5
    }
    printf("%d ", i);   // Prints: 0 1 2 3 4
}

// Find in array
int arr[] = {10, 20, 30, 40, 50};
int target = 30;
int found = 0;

for (int i = 0; i < 5; i++) {
    if (arr[i] == target) {
        found = 1;
        break;
    }
}

// Nested loops
for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
        if (j == 1) break;  // Only breaks inner loop
        printf("%d,%d ", i, j);
    }
}
```

## Continue Statement

```c
// Skip iteration
for (int i = 0; i < 10; i++) {
    if (i == 5) {
        continue;   // Skip 5
    }
    printf("%d ", i);   // Prints: 0 1 2 3 4 6 7 8 9
}

// Skip even numbers
for (int i = 0; i < 10; i++) {
    if (i % 2 == 0) {
        continue;
    }
    printf("%d ", i);   // Prints odd: 1 3 5 7 9
}

// Process only valid data
int arr[] = {1, -5, 3, -2, 7};
for (int i = 0; i < 5; i++) {
    if (arr[i] < 0) {
        continue;   // Skip negative
    }
    printf("%d ", arr[i]);  // 1 3 7
}
```

## Array Iteration

```c
int arr[] = {10, 20, 30, 40, 50};
int size = sizeof(arr) / sizeof(arr[0]);

// Method 1: Index
for (int i = 0; i < size; i++) {
    printf("%d ", arr[i]);
}

// Method 2: Pointer
for (int *p = arr; p < arr + size; p++) {
    printf("%d ", *p);
}

// Method 3: Pointer with index
int *p = arr;
for (int i = 0; i < size; i++) {
    printf("%d ", p[i]);
}

// Reverse iteration
for (int i = size - 1; i >= 0; i--) {
    printf("%d ", arr[i]);
}
```

## String Iteration

```c
char str[] = "Hello";

// Until null terminator
for (int i = 0; str[i] != '\0'; i++) {
    printf("%c\n", str[i]);
}

// Using strlen
for (int i = 0; i < strlen(str); i++) {
    printf("%c\n", str[i]);
}

// Pointer
for (char *p = str; *p; p++) {
    printf("%c\n", *p);
}

// While
int i = 0;
while (str[i]) {
    printf("%c\n", str[i]);
    i++;
}
```

## Nested Loops

```c
// 2D pattern
for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
        printf("* ");
    }
    printf("\n");
}

// Multiplication table
for (int i = 1; i <= 10; i++) {
    for (int j = 1; j <= 10; j++) {
        printf("%4d", i * j);
    }
    printf("\n");
}

// 2D array
int matrix[3][3] = {{1,2,3}, {4,5,6}, {7,8,9}};
for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
        printf("%d ", matrix[i][j]);
    }
    printf("\n");
}
```

## Loop Patterns

```c
// Sum elements
int arr[] = {1, 2, 3, 4, 5};
int sum = 0;
for (int i = 0; i < 5; i++) {
    sum += arr[i];
}

// Find maximum
int max = arr[0];
for (int i = 1; i < 5; i++) {
    if (arr[i] > max) {
        max = arr[i];
    }
}

// Count occurrences
int count = 0;
for (int i = 0; i < 5; i++) {
    if (arr[i] == 3) {
        count++;
    }
}

// Search
int found_index = -1;
for (int i = 0; i < 5; i++) {
    if (arr[i] == 3) {
        found_index = i;
        break;
    }
}
```

## Common Algorithms

```c
// Bubble sort
void bubble_sort(int arr[], int n) {
    for (int i = 0; i < n-1; i++) {
        for (int j = 0; j < n-i-1; j++) {
            if (arr[j] > arr[j+1]) {
                int temp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = temp;
            }
        }
    }
}

// Linear search
int linear_search(int arr[], int n, int target) {
    for (int i = 0; i < n; i++) {
        if (arr[i] == target) {
            return i;
        }
    }
    return -1;
}

// Reverse array
void reverse(int arr[], int n) {
    for (int i = 0; i < n/2; i++) {
        int temp = arr[i];
        arr[i] = arr[n-1-i];
        arr[n-1-i] = temp;
    }
}

// Copy array
void copy_array(int dest[], int src[], int n) {
    for (int i = 0; i < n; i++) {
        dest[i] = src[i];
    }
}
```

## Loop with goto (Rarely used)

```c
// Multi-level break
for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
        if (i == 1 && j == 1) {
            goto done;  // Exit both loops
        }
        printf("%d,%d ", i, j);
    }
}
done:
printf("\nDone\n");

// Error handling
for (int i = 0; i < n; i++) {
    if (arr[i] < 0) {
        goto error;
    }
    process(arr[i]);
}
goto success;

error:
    printf("Error found\n");
    return -1;

success:
    printf("Success\n");
    return 0;
```

## Performance Tips

```c
// Cache length outside loop
int len = strlen(str);
for (int i = 0; i < len; i++) {
    // Don't call strlen() each iteration
}

// Avoid: (slow)
for (int i = 0; i < strlen(str); i++) {
    // strlen called every iteration!
}

// Decrement vs increment (usually no difference)
for (int i = n-1; i >= 0; i--) {
    // Sometimes minimally faster
}

// Loop unrolling (manual optimization)
for (int i = 0; i < n; i += 4) {
    sum += arr[i];
    sum += arr[i+1];
    sum += arr[i+2];
    sum += arr[i+3];
}
```

## Common Mistakes

```c
// Off-by-one error
for (int i = 0; i <= 10; i++) {  // Should be i < 10
    arr[i] = 0;  // Array overflow if arr[10]
}

// Infinite loop
for (int i = 0; i < 10; i--) {  // i decrements!
    printf("%d ", i);
}

// Modifying loop variable incorrectly
for (int i = 0; i < 10; i++) {
    i += 2;  // Don't modify i inside loop body
}

// Semicolon after for
for (int i = 0; i < 10; i++);  // Empty loop!
{
    printf("%d ", i);  // Only runs once after loop
}

// Float comparison
for (float f = 0.0; f != 1.0; f += 0.1) {  // Dangerous!
    // May never equal 1.0 due to precision
}

// Better:
for (float f = 0.0; f < 1.0; f += 0.1) {
    // Use < or >
}
```
