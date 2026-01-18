# Structs in C

## Basic Structure

```c
// Define structure
struct Person {
    char name[50];
    int age;
    float salary;
};

// Declare variable
struct Person p1;

// Initialize
strcpy(p1.name, "John");
p1.age = 30;
p1.salary = 50000.0;

// Access members
printf("Name: %s\n", p1.name);
printf("Age: %d\n", p1.age);
```

## Initialization

```c
struct Person {
    char name[50];
    int age;
    float salary;
};

// Method 1: During declaration
struct Person p1 = {"Alice", 25, 45000.0};

// Method 2: Designated initializers (C99)
struct Person p2 = {
    .name = "Bob",
    .age = 35,
    .salary = 60000.0
};

// Method 3: Partial initialization
struct Person p3 = {"Charlie", 28};  // salary is 0.0

// Method 4: Zero initialization
struct Person p4 = {0};  // All members set to 0
```

## typedef

```c
// Without typedef
struct Point {
    int x;
    int y;
};
struct Point p;  // Need 'struct' keyword

// With typedef
typedef struct {
    int x;
    int y;
} Point;

Point p;  // No 'struct' needed

// Named typedef
typedef struct Point {
    int x;
    int y;
} Point;
```

## Nested Structures

```c
typedef struct {
    int day;
    int month;
    int year;
} Date;

typedef struct {
    char name[50];
    Date birthdate;
    float salary;
} Employee;

// Usage
Employee emp = {
    .name = "John",
    .birthdate = {15, 6, 1990},
    .salary = 50000.0
};

printf("%d/%d/%d\n",
    emp.birthdate.day,
    emp.birthdate.month,
    emp.birthdate.year
);
```

## Array of Structures

```c
typedef struct {
    char name[30];
    int age;
} Person;

// Fixed size
Person people[3] = {
    {"Alice", 25},
    {"Bob", 30},
    {"Charlie", 35}
};

// Access
for (int i = 0; i < 3; i++) {
    printf("%s: %d\n", people[i].name, people[i].age);
}

// Dynamic array
int n = 5;
Person *arr = malloc(n * sizeof(Person));

for (int i = 0; i < n; i++) {
    sprintf(arr[i].name, "Person%d", i);
    arr[i].age = 20 + i;
}

free(arr);
```

## Pointers to Structures

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

// Modify via pointer
ptr->x = 30;
ptr->y = 40;
```

## Structures as Function Arguments

```c
typedef struct {
    int x;
    int y;
} Point;

// Pass by value (copy)
void print_point(Point p) {
    printf("(%d, %d)\n", p.x, p.y);
}

// Pass by reference (efficient)
void modify_point(Point *p) {
    p->x = 100;
    p->y = 200;
}

int main() {
    Point p = {10, 20};

    print_point(p);      // Copy passed
    modify_point(&p);    // Pointer passed
    print_point(p);      // 100, 200

    return 0;
}
```

## Return Structure from Function

```c
typedef struct {
    int x;
    int y;
} Point;

// Return by value
Point create_point(int x, int y) {
    Point p;
    p.x = x;
    p.y = y;
    return p;
}

// Return pointer (with malloc)
Point* create_point_ptr(int x, int y) {
    Point *p = malloc(sizeof(Point));
    p->x = x;
    p->y = y;
    return p;
}

int main() {
    Point p1 = create_point(10, 20);

    Point *p2 = create_point_ptr(30, 40);
    printf("%d %d\n", p2->x, p2->y);
    free(p2);

    return 0;
}
```

## Structure with Pointers

```c
typedef struct {
    char *name;
    int age;
    int *scores;
    int score_count;
} Student;

// Create and initialize
Student* create_student(const char *name, int age) {
    Student *s = malloc(sizeof(Student));

    s->name = malloc(strlen(name) + 1);
    strcpy(s->name, name);

    s->age = age;
    s->score_count = 5;
    s->scores = malloc(s->score_count * sizeof(int));

    return s;
}

// Free all memory
void free_student(Student *s) {
    free(s->name);
    free(s->scores);
    free(s);
}

// Usage
Student *s = create_student("Alice", 20);
s->scores[0] = 85;
free_student(s);
```

## Self-Referential Structures

```c
// Linked list node
typedef struct Node {
    int data;
    struct Node *next;  // Must use 'struct Node'
} Node;

// Create node
Node* create_node(int data) {
    Node *node = malloc(sizeof(Node));
    node->data = data;
    node->next = NULL;
    return node;
}

// Usage
Node *head = create_node(10);
head->next = create_node(20);
head->next->next = create_node(30);

// Traverse
Node *current = head;
while (current != NULL) {
    printf("%d -> ", current->data);
    current = current->next;
}
printf("NULL\n");
```

## Bit Fields

```c
// Pack data into bits
typedef struct {
    unsigned int is_active : 1;   // 1 bit
    unsigned int age : 7;          // 7 bits (0-127)
    unsigned int id : 24;          // 24 bits
} Flags;

Flags f;
f.is_active = 1;
f.age = 25;
f.id = 12345;

printf("Size: %zu bytes\n", sizeof(Flags));  // 4 bytes
```

## Union (Similar to Struct)

```c
// Union: All members share same memory
union Data {
    int i;
    float f;
    char str[20];
};

union Data d;
d.i = 10;
printf("%d\n", d.i);

d.f = 3.14;
printf("%f\n", d.f);
// d.i is now garbage!

printf("Size: %zu\n", sizeof(d));  // Size of largest member
```

## Structure Alignment and Padding

```c
// Padding added for alignment
struct Example1 {
    char c;      // 1 byte
    // 3 bytes padding
    int i;       // 4 bytes
    char d;      // 1 byte
    // 3 bytes padding
};  // Total: 12 bytes

// Optimized order
struct Example2 {
    int i;       // 4 bytes
    char c;      // 1 byte
    char d;      // 1 byte
    // 2 bytes padding
};  // Total: 8 bytes

printf("%zu\n", sizeof(struct Example1));  // 12
printf("%zu\n", sizeof(struct Example2));  // 8
```

## Structure Comparison

```c
typedef struct {
    int x;
    int y;
} Point;

// Cannot use == directly
Point p1 = {10, 20};
Point p2 = {10, 20};

// if (p1 == p2) {}  // Error!

// Method 1: Compare members
if (p1.x == p2.x && p1.y == p2.y) {
    printf("Equal\n");
}

// Method 2: memcmp (dangerous with padding)
if (memcmp(&p1, &p2, sizeof(Point)) == 0) {
    printf("Equal\n");
}

// Method 3: Custom function
int point_equal(Point *a, Point *b) {
    return a->x == b->x && a->y == b->y;
}
```

## Common Patterns

```c
// Constructor pattern
typedef struct {
    char name[50];
    int value;
} Item;

Item create_item(const char *name, int value) {
    Item item;
    strncpy(item.name, name, 49);
    item.name[49] = '\0';
    item.value = value;
    return item;
}

// Method pattern (function pointers in struct)
typedef struct {
    int value;
    void (*print)(struct Calculator*);
} Calculator;

void calc_print(Calculator *c) {
    printf("Value: %d\n", c->value);
}

Calculator c = {.value = 42, .print = calc_print};
c.print(&c);
```

## Practical Example: Linked List

```c
typedef struct Node {
    int data;
    struct Node *next;
} Node;

typedef struct {
    Node *head;
    int size;
} LinkedList;

LinkedList* create_list() {
    LinkedList *list = malloc(sizeof(LinkedList));
    list->head = NULL;
    list->size = 0;
    return list;
}

void append(LinkedList *list, int data) {
    Node *new_node = malloc(sizeof(Node));
    new_node->data = data;
    new_node->next = NULL;

    if (list->head == NULL) {
        list->head = new_node;
    } else {
        Node *current = list->head;
        while (current->next != NULL) {
            current = current->next;
        }
        current->next = new_node;
    }
    list->size++;
}

void print_list(LinkedList *list) {
    Node *current = list->head;
    while (current != NULL) {
        printf("%d -> ", current->data);
        current = current->next;
    }
    printf("NULL\n");
}

void free_list(LinkedList *list) {
    Node *current = list->head;
    while (current != NULL) {
        Node *temp = current;
        current = current->next;
        free(temp);
    }
    free(list);
}

// Usage
LinkedList *list = create_list();
append(list, 10);
append(list, 20);
append(list, 30);
print_list(list);
free_list(list);
```
