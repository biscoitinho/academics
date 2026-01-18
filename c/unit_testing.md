# Unit Testing in C

## Simple Assert-Based Testing

**math_utils.c**
```c
int add(int a, int b) {
    return a + b;
}

int multiply(int a, int b) {
    return a * b;
}
```

**test_math_utils.c**
```c
#include <stdio.h>
#include <assert.h>

int add(int a, int b);
int multiply(int a, int b);

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
gcc math_utils.c test_math_utils.c -o test
./test
```

## MinUnit (Minimal Framework)

**minunit.h**
```c
#ifndef MINUNIT_H
#define MINUNIT_H

#define mu_assert(message, test) do { \
    if (!(test)) return message; \
} while (0)

#define mu_run_test(test) do { \
    char *message = test(); \
    tests_run++; \
    if (message) return message; \
} while (0)

extern int tests_run;

#endif
```

**test.c**
```c
#include <stdio.h>
#include "minunit.h"

int tests_run = 0;

int add(int a, int b) { return a + b; }

static char* test_add() {
    mu_assert("error: add(2,3) != 5", add(2, 3) == 5);
    mu_assert("error: add(-1,1) != 0", add(-1, 1) == 0);
    return 0;
}

static char* test_multiply() {
    mu_assert("error: 2*3 != 6", 2 * 3 == 6);
    return 0;
}

static char* all_tests() {
    mu_run_test(test_add);
    mu_run_test(test_multiply);
    return 0;
}

int main() {
    char *result = all_tests();
    if (result != 0) {
        printf("%s\n", result);
    } else {
        printf("ALL TESTS PASSED\n");
    }
    printf("Tests run: %d\n", tests_run);
    return result != 0;
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

// Function to test
int add(int a, int b) {
    return a + b;
}

// Setup runs before each test
void setUp(void) {
    // Initialize test
}

// Teardown runs after each test
void tearDown(void) {
    // Clean up
}

// Test cases
void test_add_positive_numbers(void) {
    TEST_ASSERT_EQUAL(5, add(2, 3));
}

void test_add_negative_numbers(void) {
    TEST_ASSERT_EQUAL(-5, add(-2, -3));
}

void test_add_zero(void) {
    TEST_ASSERT_EQUAL(0, add(0, 0));
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_add_positive_numbers);
    RUN_TEST(test_add_negative_numbers);
    RUN_TEST(test_add_zero);
    return UNITY_END();
}
```

**Compile:**
```bash
gcc test_runner.c Unity/src/unity.c -I Unity/src -o test
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
    printf("\n\nTests passed: %d\n", tests_passed); \
    printf("Tests failed: %d\n", tests_failed); \
    printf("Total: %d\n", tests_passed + tests_failed); \
} while(0)

#endif
```

**test_example.c**
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

## Testing with Mocks

**database.h**
```c
typedef struct {
    int (*get_user)(int id);
} Database;

int get_user_age(Database *db, int user_id);
```

**database.c**
```c
#include "database.h"

int get_user_age(Database *db, int user_id) {
    return db->get_user(user_id);
}
```

**test_database.c**
```c
#include <stdio.h>
#include <assert.h>
#include "database.h"

// Mock function
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

int main() {
    test_get_user_age();
    return 0;
}
```

## Testing Memory Leaks (Valgrind)

**program.c**
```c
#include <stdlib.h>

int* create_array(int size) {
    return malloc(size * sizeof(int));
}

int main() {
    int *arr = create_array(10);
    // ... use array ...
    free(arr);  // Don't forget!
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

# Source files
SRC = src/math_utils.c src/string_utils.c
OBJ = $(SRC:.c=.o)

# Test files
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

## Assertions

```c
#include <assert.h>

void test_assertions() {
    // Simple assertion
    assert(1 + 1 == 2);

    // String comparison
    char *str = "hello";
    assert(strcmp(str, "hello") == 0);

    // Pointer checks
    int *ptr = malloc(sizeof(int));
    assert(ptr != NULL);
    free(ptr);

    // Array checks
    int arr[3] = {1, 2, 3};
    assert(arr[0] == 1);
    assert(sizeof(arr)/sizeof(arr[0]) == 3);
}
```

## Testing Best Practices

```c
// 1. Test one thing per test
void test_add_positive() {
    assert(add(2, 3) == 5);
}

void test_add_negative() {
    assert(add(-2, -3) == -5);
}

// 2. Use descriptive names
void test_empty_string_returns_zero_length() {
    assert(strlen("") == 0);
}

// 3. Test edge cases
void test_division_by_zero() {
    // Test how function handles error
    assert(safe_divide(10, 0) == -1);  // Returns error code
}

// 4. Setup and teardown
void setup_test() {
    // Allocate resources
}

void teardown_test() {
    // Free resources
}

void test_with_cleanup() {
    setup_test();
    // ... test code ...
    teardown_test();
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
