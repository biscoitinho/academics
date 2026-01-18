# Strings in C

## String Basics

```c
#include <string.h>

// String is array of chars ending with '\0'
char str1[] = "Hello";           // {'H','e','l','l','o','\0'}
char str2[20] = "World";
char str3[] = {'H', 'i', '\0'};

// String literal (read-only)
char *str4 = "Hello";

// Empty string
char empty[10] = "";
```

## String Input/Output

```c
// Output
printf("%s\n", str);
puts(str);              // Adds newline automatically

// Input (stops at whitespace)
char name[50];
scanf("%s", name);      // No & needed (name is pointer)

// Input with size limit
scanf("%49s", name);

// Read line with spaces
fgets(name, 50, stdin);

// Remove newline from fgets
name[strcspn(name, "\n")] = '\0';
```

## String Length

```c
char str[] = "Hello";

int len = strlen(str);  // 5 (doesn't count '\0')

// Manual length
int length = 0;
while (str[length] != '\0') {
    length++;
}
```

## String Copy

```c
char src[] = "Hello";
char dest[20];

// Copy
strcpy(dest, src);

// Copy with size limit (safer)
strncpy(dest, src, 19);
dest[19] = '\0';        // Ensure null termination

// Manual copy
int i = 0;
while (src[i] != '\0') {
    dest[i] = src[i];
    i++;
}
dest[i] = '\0';
```

## String Concatenation

```c
char str1[50] = "Hello";
char str2[] = " World";

// Concatenate
strcat(str1, str2);     // str1 = "Hello World"

// Safe concatenation (limit total size)
strncat(str1, str2, 49);

// Manual concatenation
int i = strlen(str1);
int j = 0;
while (str2[j] != '\0') {
    str1[i++] = str2[j++];
}
str1[i] = '\0';
```

## String Comparison

```c
char str1[] = "apple";
char str2[] = "banana";

// Compare (returns 0 if equal)
if (strcmp(str1, str2) == 0) {
    printf("Equal\n");
} else if (strcmp(str1, str2) < 0) {
    printf("str1 < str2\n");
} else {
    printf("str1 > str2\n");
}

// Compare n characters
strncmp(str1, str2, 3);

// Case-insensitive (non-standard)
#include <strings.h>
strcasecmp(str1, str2);
```

## String Search

```c
char str[] = "Hello World";

// Find character
char *ptr = strchr(str, 'W');
if (ptr != NULL) {
    printf("Found at position: %ld\n", ptr - str);  // 6
}

// Find last occurrence
char *ptr2 = strrchr(str, 'o');

// Find substring
char *ptr3 = strstr(str, "World");
if (ptr3 != NULL) {
    printf("Found: %s\n", ptr3);    // "World"
}

// Check if string contains char
if (strchr(str, 'W') != NULL) {
    printf("Contains W\n");
}
```

## String Tokenization

```c
char str[] = "apple,banana,cherry";
char *token;

// Get first token
token = strtok(str, ",");

// Get remaining tokens
while (token != NULL) {
    printf("%s\n", token);
    token = strtok(NULL, ",");
}

// strtok modifies original string!
```

## Character Functions

```c
#include <ctype.h>

char c = 'a';

// Check
isalpha(c);     // Is letter?
isdigit(c);     // Is digit?
isalnum(c);     // Is letter or digit?
isspace(c);     // Is whitespace?
isupper(c);     // Is uppercase?
islower(c);     // Is lowercase?

// Convert
toupper(c);     // To uppercase
tolower(c);     // To lowercase
```

## String Conversion

```c
#include <stdlib.h>

// String to integer
char str1[] = "123";
int num = atoi(str1);           // 123

// String to long
long l = atol("123456");

// String to float
float f = atof("3.14");

// String to double
double d = atof("3.14159");

// Integer to string (using sprintf)
char buffer[20];
int n = 42;
sprintf(buffer, "%d", n);       // "42"

// With snprintf (safer)
snprintf(buffer, 20, "%d", n);
```

## String Formatting

```c
char buffer[100];

// Format string
sprintf(buffer, "Name: %s, Age: %d", "John", 30);

// Safe version
snprintf(buffer, 100, "Value: %.2f", 3.14159);

// Multiple values
int x = 10, y = 20;
sprintf(buffer, "(%d, %d)", x, y);
```

## Character Array Iteration

```c
char str[] = "Hello";

// Method 1: Index
for (int i = 0; str[i] != '\0'; i++) {
    printf("%c\n", str[i]);
}

// Method 2: strlen
for (int i = 0; i < strlen(str); i++) {
    printf("%c\n", str[i]);
}

// Method 3: Pointer
for (char *p = str; *p != '\0'; p++) {
    printf("%c\n", *p);
}
```

## String Modification

```c
char str[] = "Hello World";

// Change character
str[0] = 'h';               // "hello World"

// Uppercase all
for (int i = 0; str[i]; i++) {
    str[i] = toupper(str[i]);
}

// Lowercase all
for (int i = 0; str[i]; i++) {
    str[i] = tolower(str[i]);
}

// Remove character
void remove_char(char *str, char ch) {
    int i = 0, j = 0;
    while (str[i]) {
        if (str[i] != ch) {
            str[j++] = str[i];
        }
        i++;
    }
    str[j] = '\0';
}
```

## Dynamic Strings

```c
#include <stdlib.h>

// Allocate
char *str = malloc(100 * sizeof(char));
strcpy(str, "Hello");

// Resize
str = realloc(str, 200 * sizeof(char));

// Duplicate string
char *copy = strdup(str);   // Allocates and copies

// Free
free(str);
free(copy);
```

## Array of Strings

```c
// Fixed size
char names[3][20] = {
    "Alice",
    "Bob",
    "Charlie"
};

// Access
printf("%s\n", names[0]);   // Alice

// Array of pointers (more flexible)
char *fruits[] = {
    "Apple",
    "Banana",
    "Cherry"
};

for (int i = 0; i < 3; i++) {
    printf("%s\n", fruits[i]);
}
```

## String Utilities

```c
// Reverse string
void reverse(char *str) {
    int len = strlen(str);
    for (int i = 0; i < len/2; i++) {
        char temp = str[i];
        str[i] = str[len-1-i];
        str[len-1-i] = temp;
    }
}

// Count occurrences
int count_char(const char *str, char ch) {
    int count = 0;
    while (*str) {
        if (*str == ch) count++;
        str++;
    }
    return count;
}

// Trim whitespace
void trim(char *str) {
    // Left trim
    int i = 0;
    while (isspace(str[i])) i++;

    int j = 0;
    while (str[i]) {
        str[j++] = str[i++];
    }
    str[j] = '\0';

    // Right trim
    j = strlen(str) - 1;
    while (j >= 0 && isspace(str[j])) {
        str[j--] = '\0';
    }
}

// Check if palindrome
int is_palindrome(const char *str) {
    int len = strlen(str);
    for (int i = 0; i < len/2; i++) {
        if (str[i] != str[len-1-i]) {
            return 0;
        }
    }
    return 1;
}
```

## Common Mistakes

```c
// String literal modification
char *str = "Hello";
// str[0] = 'h';        // Undefined behavior!

// Correct way:
char str[] = "Hello";
str[0] = 'h';           // OK

// Buffer overflow
char small[5];
strcpy(small, "Hello World");   // Overflow!

// Use strncpy or ensure buffer is large enough
char large[20];
strcpy(large, "Hello World");   // OK

// Uninitialized buffer
char str[10];
strcat(str, "Hello");   // Undefined! str has garbage

// Initialize first:
char str[10] = "";
strcat(str, "Hello");   // OK

// Missing null terminator
char str[5] = {'H','e','l','l','o'};
printf("%s\n", str);    // May print garbage after
```
