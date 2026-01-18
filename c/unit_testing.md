# Unit Testing in C

## Simple Assert-Based Testing

**test.c**
```c
#include <stdio.h>
#include <assert.h>

int add(int a, int b) { return a + b; }
int multiply(int a, int b) { return a * b; }

void test_add() {
    assert(add(2, 3) == 5);
    assert(add(-1, 1) == 0);
    assert(add(0, 0) == 0);
    printf("test_add: PASSED\n");
}

void test_multiply() {
    assert(multiply(2, 3) == 6);
    assert(multiply(-2, 3) == -6);
    assert(multiply(0, 5) == 0);
    printf("test_multiply: PASSED\n");
}

int main() {
    test_add();
    test_multiply();
    printf("All tests passed!\n");
    return 0;
}
```

```bash
gcc test.c -o test
./test
```

## Custom Test Framework

**test_framework.h**
```c
#ifndef TEST_FRAMEWORK_H
#define TEST_FRAMEWORK_H

#include <stdio.h>

static int tests_passed = 0;
static int tests_failed = 0;

#define ASSERT_EQ(expected, actual) do { \
    if ((expected) == (actual)) { \
        tests_passed++; \
        printf("."); \
    } else { \
        tests_failed++; \
        printf("\n[FAIL] %s:%d: Expected %d, got %d\n", \
               __FILE__, __LINE__, expected, actual); \
    } \
} while(0)

#define ASSERT_TRUE(condition) do { \
    if (condition) { \
        tests_passed++; \
        printf("."); \
    } else { \
        tests_failed++; \
        printf("\n[FAIL] %s:%d: Assertion failed\n", \
               __FILE__, __LINE__); \
    } \
} while(0)

#define TEST_SUMMARY() do { \
    printf("\n\nPassed: %d, Failed: %d, Total: %d\n", \
           tests_passed, tests_failed, tests_passed + tests_failed); \
} while(0)

#endif
```

**test.c**
```c
#include "test_framework.h"

int add(int a, int b) { return a + b; }
int is_even(int n) { return n % 2 == 0; }

void test_add() {
    ASSERT_EQ(5, add(2, 3));
    ASSERT_EQ(0, add(-1, 1));
    ASSERT_EQ(-5, add(-2, -3));
}

void test_is_even() {
    ASSERT_TRUE(is_even(2));
    ASSERT_TRUE(is_even(0));
    ASSERT_TRUE(!is_even(3));
}

int main() {
    printf("Running tests");
    test_add();
    test_is_even();
    TEST_SUMMARY();
    return tests_failed;
}
```

## Unity Test Framework

**Installation:**
```bash
git clone https://github.com/ThrowTheSwitch/Unity.git
```

**test_runner.c**
```c
#include "unity.h"

int add(int a, int b) { return a + b; }

void setUp(void) {
    // Runs before each test
}

void tearDown(void) {
    // Runs after each test
}

void test_add_positive() {
    TEST_ASSERT_EQUAL(5, add(2, 3));
}

void test_add_negative() {
    TEST_ASSERT_EQUAL(-5, add(-2, -3));
}

void test_add_zero() {
    TEST_ASSERT_EQUAL(0, add(0, 0));
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_add_positive);
    RUN_TEST(test_add_negative);
    RUN_TEST(test_add_zero);
    return UNITY_END();
}
```

**Compile:**
```bash
gcc test_runner.c Unity/src/unity.c -I Unity/src -o test
./test
```

## Testing with Mocks

```c
// database.h
typedef struct {
    int (*get_user)(int id);
} Database;

int get_user_age(Database *db, int user_id) {
    return db->get_user(user_id);
}

// test.c
#include <assert.h>

int mock_get_user(int id) {
    if (id == 1) return 25;
    if (id == 2) return 30;
    return -1;
}

void test_get_user_age() {
    Database db = { .get_user = mock_get_user };

    assert(get_user_age(&db, 1) == 25);
    assert(get_user_age(&db, 2) == 30);
    assert(get_user_age(&db, 999) == -1);

    printf("test_get_user_age: PASSED\n");
}
```

## Test Organization

```
project/
├── src/
│   ├── math_utils.c
│   └── string_utils.c
├── include/
│   ├── math_utils.h
│   └── string_utils.h
├── tests/
│   ├── test_math_utils.c
│   ├── test_string_utils.c
│   └── test_all.c
└── Makefile
```

**Makefile**
```makefile
CC = gcc
CFLAGS = -Wall -I include

SRC = src/math_utils.c src/string_utils.c
OBJ = $(SRC:.c=.o)

TEST_SRC = tests/test_all.c
TEST_OBJ = $(TEST_SRC:.c=.o)

all: program

program: $(OBJ) main.o
	$(CC) $(OBJ) main.o -o program

test: $(OBJ) $(TEST_OBJ)
	$(CC) $(OBJ) $(TEST_OBJ) -o test
	./test

clean:
	rm -f $(OBJ) $(TEST_OBJ) program test

.PHONY: all test clean
```

## Memory Leak Testing (Valgrind)

```c
#include <stdlib.h>

int* create_array(int size) {
    return malloc(size * sizeof(int));
}

int main() {
    int *arr = create_array(10);
    // ... use array ...
    free(arr);
    return 0;
}
```

```bash
# Compile with debug symbols
gcc -g program.c -o program

# Run with valgrind
valgrind --leak-check=full ./program

# Output shows memory leaks if any
```

## Code Coverage (gcov)

```bash
# Compile with coverage flags
gcc -fprofile-arcs -ftest-coverage program.c -o program

# Run the program
./program

# Generate coverage report
gcov program.c

# View coverage
cat program.c.gcov
```

## Test Best Practices

```c
// 1. Test one thing per test
void test_add_positive() {
    assert(add(2, 3) == 5);
}

// 2. Use descriptive names
void test_empty_string_returns_zero_length() {
    assert(strlen("") == 0);
}

// 3. Test edge cases
void test_division_by_zero() {
    assert(safe_divide(10, 0) == -1);
}

// 4. Setup and teardown
void setup() {
    // Allocate resources
}

void teardown() {
    // Free resources
}

void test_with_cleanup() {
    setup();
    // ... test code ...
    teardown();
}
```

## Example: Testing Linked List

**list.c**
```c
#include <stdlib.h>

typedef struct Node {
    int data;
    struct Node *next;
} Node;

Node* create_node(int data) {
    Node *node = malloc(sizeof(Node));
    node->data = data;
    node->next = NULL;
    return node;
}

int list_length(Node *head) {
    int count = 0;
    while (head) {
        count++;
        head = head->next;
    }
    return count;
}

void free_list(Node *head) {
    while (head) {
        Node *temp = head;
        head = head->next;
        free(temp);
    }
}
```

**test_list.c**
```c
#include <assert.h>
#include <stdio.h>

void test_create_node() {
    Node *node = create_node(42);
    assert(node != NULL);
    assert(node->data == 42);
    assert(node->next == NULL);
    free(node);
    printf("test_create_node: PASSED\n");
}

void test_list_length() {
    Node *head = create_node(1);
    head->next = create_node(2);
    head->next->next = create_node(3);

    assert(list_length(head) == 3);
    assert(list_length(NULL) == 0);

    free_list(head);
    printf("test_list_length: PASSED\n");
}

int main() {
    test_create_node();
    test_list_length();
    printf("All tests passed!\n");
    return 0;
}
```

## Common Test Assertions

```c
// Equality
assert(actual == expected);
assert(strcmp(str1, str2) == 0);

// Truthiness
assert(condition);
assert(ptr != NULL);

// Ranges
assert(value > 0);
assert(value >= min && value <= max);

// Arrays
int arr1[] = {1, 2, 3};
int arr2[] = {1, 2, 3};
assert(memcmp(arr1, arr2, sizeof(arr1)) == 0);
```
