# COBOL Basics and Comparison with Modern Languages

Comprehensive guide to COBOL programming with comparisons to Python, Ruby, C, and GNUcobol vs traditional COBOL.

---

## Table of Contents

1. [Overview](#overview)
2. [COBOL Structure](#cobol-structure)
3. [Data Types and Variables](#data-types-and-variables)
4. [Control Structures](#control-structures)
5. [File Handling](#file-handling)
6. [Comparison with Modern Languages](#comparison-with-modern-languages)
7. [GNUcobol vs Traditional COBOL](#gnucobol-vs-traditional-cobol)
8. [Modern COBOL Features](#modern-cobol-features)

---

## Overview

###  What is COBOL?

**COBOL** (Common Business-Oriented Language)
- Created: 1959 (65+ years old!)
- Designer: CODASYL Committee (Grace Hopper influenced)
- Purpose: Business data processing
- Philosophy: Self-documenting, English-like syntax

**Current Usage**:
```
Active COBOL code: 220+ billion lines
Daily transactions: 3 trillion
ATM transactions: 95%
Credit card systems: 80%
Fortune 500 companies using COBOL: 92%
```

**Why Still Used**:
- Proven reliability (decades of testing)
- Handles decimal arithmetic perfectly
- Excellent for batch processing
- Legacy code still running
- Banks reluctant to rewrite
- COBOL programmers expensive

---

## COBOL Structure

### Program Divisions

**Four Main Divisions**:
```cobol
       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO-WORLD.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       PROCEDURE DIVISION.
```

**Complete Example**:
```cobol
      *> Simple COBOL Program
       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO-WORLD.
       AUTHOR. YOUR-NAME.
       DATE-WRITTEN. 2026-02-01.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MESSAGE    PIC X(20) VALUE 'Hello, COBOL World!'.

       PROCEDURE DIVISION.
           DISPLAY WS-MESSAGE.
           STOP RUN.
```

### Division Breakdown

**1. IDENTIFICATION DIVISION**:
```cobol
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PROGRAM-NAME.
       AUTHOR. DEVELOPER-NAME.
       DATE-WRITTEN. 2026-02-01.
       DATE-COMPILED.
       SECURITY. CONFIDENTIAL.
```
- Program metadata
- Documentation
- Not executed

**2. ENVIRONMENT DIVISION**:
```cobol
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-Z.
       OBJECT-COMPUTER. IBM-Z.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INPUT-FILE ASSIGN TO 'INPUT.DAT'
               ORGANIZATION IS LINE SEQUENTIAL.
```
- System-dependent information
- File assignments
- Device mappings

**3. DATA DIVISION**:
```cobol
       DATA DIVISION.
       FILE SECTION.
       FD  INPUT-FILE.
       01  INPUT-RECORD      PIC X(80).

       WORKING-STORAGE SECTION.
       01  WS-COUNTER        PIC 9(4) VALUE ZERO.
       01  WS-NAME           PIC X(30).

       LOCAL-STORAGE SECTION.
       01  LS-TEMP           PIC 9(5).

       LINKAGE SECTION.
       01  PARM-DATA         PIC X(100).
```
- Variable declarations
- File descriptions
- Record layouts

**4. PROCEDURE DIVISION**:
```cobol
       PROCEDURE DIVISION.
       MAIN-PARA.
           PERFORM INIT-PARA.
           PERFORM PROCESS-PARA.
           PERFORM CLEANUP-PARA.
           STOP RUN.

       INIT-PARA.
           DISPLAY 'Initializing...'.

       PROCESS-PARA.
           DISPLAY 'Processing...'.

       CLEANUP-PARA.
           DISPLAY 'Cleaning up...'.
```
- Executable code
- Business logic
- Paragraph-based organization

---

## Data Types and Variables

### PICTURE Clause (PIC)

**Numeric**:
```cobol
      *> Integers
       01  WS-COUNT          PIC 9(4).          *> 0000-9999
       01  WS-PRICE          PIC 9(5)V99.       *> 00000.00-99999.99
       01  WS-SIGNED         PIC S9(4).         *> -9999 to +9999

      *> Decimal (packed decimal on mainframe)
       01  WS-AMOUNT         PIC 9(7)V99 COMP-3.

      *> Binary
       01  WS-BINARY         PIC 9(4) COMP.     *> Binary storage
```

**Alphanumeric**:
```cobol
       01  WS-NAME           PIC X(30).         *> 30 characters
       01  WS-ADDRESS        PIC X(50).
       01  WS-INITIAL        PIC A(1).          *> Alphabetic only
```

**Alphabetic**:
```cobol
       01  WS-LETTER         PIC A(1).          *> A-Z only
       01  WS-WORD           PIC A(20).
```

**Edited (Display Formatting)**:
```cobol
       01  WS-DISPLAY-AMOUNT PIC $,$$$,$$9.99.  *> $1,234.56
       01  WS-DISPLAY-DATE   PIC 99/99/9999.    *> 01/31/2026
       01  WS-PHONE          PIC (999)999-9999. *> (555)123-4567
```

### Level Numbers

**Hierarchical Data**:
```cobol
       01  EMPLOYEE-RECORD.
           05  EMP-ID            PIC 9(6).
           05  EMP-NAME.
               10  FIRST-NAME    PIC X(15).
               10  LAST-NAME     PIC X(20).
           05  EMP-SALARY        PIC 9(7)V99.
           05  EMP-HIRE-DATE.
               10  HIRE-YEAR     PIC 9(4).
               10  HIRE-MONTH    PIC 99.
               10  HIRE-DAY      PIC 99.
```

**Levels**:
```
01: Record level (highest)
02-49: Group/elementary items
66: RENAMES clause
77: Independent items (no subdivision)
88: Condition names (Boolean-like)
```

### Condition Names (88 Level)

**Boolean-like Logic**:
```cobol
       01  WS-STATUS         PIC X(1).
           88  STATUS-ACTIVE     VALUE 'A'.
           88  STATUS-INACTIVE   VALUE 'I'.
           88  STATUS-SUSPENDED  VALUE 'S'.

       PROCEDURE DIVISION.
           MOVE 'A' TO WS-STATUS.
           IF STATUS-ACTIVE
               DISPLAY 'User is active'
           END-IF.

           SET STATUS-INACTIVE TO TRUE.
           *> WS-STATUS now contains 'I'
```

### Comparison with Other Languages

**COBOL vs Python**:
```cobol
      *> COBOL
       01  WS-COUNT  PIC 9(4) VALUE ZERO.
       01  WS-NAME   PIC X(30) VALUE SPACES.
       01  WS-PRICE  PIC 9(5)V99 VALUE 99.99.
```

```python
# Python - dynamically typed
count = 0
name = ""
price = 99.99
```

**COBOL vs Ruby**:
```cobol
      *> COBOL
       01  CUSTOMER-RECORD.
           05  CUSTOMER-ID       PIC 9(6).
           05  CUSTOMER-NAME     PIC X(30).
           05  CUSTOMER-BALANCE  PIC S9(7)V99.
```

```ruby
# Ruby - flexible structures
customer = {
  id: 0,
  name: "",
  balance: 0.0
}

# Or with class
class Customer
  attr_accessor :id, :name, :balance
end
```

**COBOL vs C**:
```cobol
      *> COBOL - self-descriptive
       01  WS-EMPLOYEE-SALARY PIC 9(7)V99 VALUE ZERO.
```

```c
/* C - concise but less descriptive */
double employee_salary = 0.0;

/* C struct (similar to COBOL record) */
struct Employee {
    int id;
    char name[30];
    double salary;
};
```

---

## Control Structures

### IF Statements

**COBOL**:
```cobol
       IF WS-AGE > 18
           DISPLAY 'Adult'
       ELSE
           DISPLAY 'Minor'
       END-IF.

      *> Nested IF
       IF WS-SALARY > 50000
           IF WS-YEARS-SERVICE > 5
               MOVE 10 TO WS-BONUS-PCT
           ELSE
               MOVE 5 TO WS-BONUS-PCT
           END-IF
       ELSE
           MOVE 0 TO WS-BONUS-PCT
       END-IF.

      *> Multiple conditions
       IF (WS-AGE > 18) AND (WS-STATUS = 'A')
           PERFORM PROCESS-ADULT
       END-IF.

       IF WS-GRADE = 'A' OR WS-GRADE = 'B'
           DISPLAY 'Passing grade'
       END-IF.
```

**Python Equivalent**:
```python
if age > 18:
    print('Adult')
else:
    print('Minor')

# Nested
if salary > 50000:
    bonus_pct = 10 if years_service > 5 else 5
else:
    bonus_pct = 0

# Multiple conditions
if age > 18 and status == 'A':
    process_adult()

if grade in ['A', 'B']:
    print('Passing grade')
```

**Ruby Equivalent**:
```ruby
if age > 18
  puts 'Adult'
else
  puts 'Minor'
end

# Nested (ternary)
bonus_pct = salary > 50000 ? (years_service > 5 ? 10 : 5) : 0

# Multiple conditions
process_adult if age > 18 && status == 'A'

puts 'Passing grade' if ['A', 'B'].include?(grade)
```

**C Equivalent**:
```c
if (age > 18) {
    printf("Adult\n");
} else {
    printf("Minor\n");
}

// Nested
if (salary > 50000) {
    bonus_pct = (years_service > 5) ? 10 : 5;
} else {
    bonus_pct = 0;
}

// Multiple conditions
if (age > 18 && status == 'A') {
    process_adult();
}

if (grade == 'A' || grade == 'B') {
    printf("Passing grade\n");
}
```

### EVALUATE (Switch/Case)

**COBOL**:
```cobol
       EVALUATE WS-GRADE
           WHEN 'A'
               DISPLAY 'Excellent'
           WHEN 'B'
               DISPLAY 'Good'
           WHEN 'C'
               DISPLAY 'Average'
           WHEN 'D'
               DISPLAY 'Below Average'
           WHEN 'F'
               DISPLAY 'Fail'
           WHEN OTHER
               DISPLAY 'Invalid Grade'
       END-EVALUATE.

      *> Multiple values
       EVALUATE TRUE
           WHEN WS-SCORE >= 90
               MOVE 'A' TO WS-GRADE
           WHEN WS-SCORE >= 80
               MOVE 'B' TO WS-GRADE
           WHEN WS-SCORE >= 70
               MOVE 'C' TO WS-GRADE
           WHEN WS-SCORE >= 60
               MOVE 'D' TO WS-GRADE
           WHEN OTHER
               MOVE 'F' TO WS-GRADE
       END-EVALUATE.
```

**Python**:
```python
# Python 3.10+ match statement
match grade:
    case 'A':
        print('Excellent')
    case 'B':
        print('Good')
    case 'C':
        print('Average')
    case 'D':
        print('Below Average')
    case 'F':
        print('Fail')
    case _:
        print('Invalid Grade')

# Traditional if-elif
if score >= 90:
    grade = 'A'
elif score >= 80:
    grade = 'B'
elif score >= 70:
    grade = 'C'
elif score >= 60:
    grade = 'D'
else:
    grade = 'F'
```

**Ruby**:
```ruby
case grade
when 'A'
  puts 'Excellent'
when 'B'
  puts 'Good'
when 'C'
  puts 'Average'
when 'D'
  puts 'Below Average'
when 'F'
  puts 'Fail'
else
  puts 'Invalid Grade'
end

# Grade assignment
grade = case
        when score >= 90 then 'A'
        when score >= 80 then 'B'
        when score >= 70 then 'C'
        when score >= 60 then 'D'
        else 'F'
        end
```

**C**:
```c
switch (grade) {
    case 'A':
        printf("Excellent\n");
        break;
    case 'B':
        printf("Good\n");
        break;
    case 'C':
        printf("Average\n");
        break;
    case 'D':
        printf("Below Average\n");
        break;
    case 'F':
        printf("Fail\n");
        break;
    default:
        printf("Invalid Grade\n");
}

// Grade assignment (if-else)
if (score >= 90)
    grade = 'A';
else if (score >= 80)
    grade = 'B';
else if (score >= 70)
    grade = 'C';
else if (score >= 60)
    grade = 'D';
else
    grade = 'F';
```

### Loops

**PERFORM (Loop)**:
```cobol
      *> Simple loop
       PERFORM 10 TIMES
           DISPLAY 'Hello'
       END-PERFORM.

      *> Counter loop
       PERFORM VARYING WS-COUNTER FROM 1 BY 1
           UNTIL WS-COUNTER > 10
           DISPLAY 'Counter: ' WS-COUNTER
       END-PERFORM.

      *> While loop
       PERFORM UNTIL WS-EOF = 'Y'
           READ INPUT-FILE
               AT END MOVE 'Y' TO WS-EOF
           END-READ
       END-PERFORM.

      *> Paragraph-based loop
       PERFORM PROCESS-RECORD
           VARYING WS-INDEX FROM 1 BY 1
           UNTIL WS-INDEX > 100.

       PROCESS-RECORD.
           DISPLAY 'Processing record ' WS-INDEX.
```

**Python**:
```python
# Simple loop
for i in range(10):
    print('Hello')

# Counter loop
for counter in range(1, 11):
    print(f'Counter: {counter}')

# While loop
eof = False
while not eof:
    try:
        line = file.readline()
        if not line:
            eof = True
    except:
        eof = True

# List iteration
for index in range(1, 101):
    print(f'Processing record {index}')
```

**Ruby**:
```ruby
# Simple loop
10.times do
  puts 'Hello'
end

# Counter loop
(1..10).each do |counter|
  puts "Counter: #{counter}"
end

# While loop
until eof
  begin
    line = file.gets
    eof = true if line.nil?
  rescue
    eof = true
  end
end

# Range iteration
(1..100).each do |index|
  puts "Processing record #{index}"
end
```

**C**:
```c
// Simple loop
for (int i = 0; i < 10; i++) {
    printf("Hello\n");
}

// Counter loop
for (int counter = 1; counter <= 10; counter++) {
    printf("Counter: %d\n", counter);
}

// While loop
while (!eof) {
    // Read from file
    if (fgets(buffer, sizeof(buffer), file) == NULL) {
        eof = 1;
    }
}

// Index loop
for (int index = 1; index <= 100; index++) {
    printf("Processing record %d\n", index);
}
```

---

## File Handling

### Sequential File Processing

**COBOL** (Traditional):
```cobol
       IDENTIFICATION DIVISION.
       PROGRAM-ID. FILE-READER.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INPUT-FILE ASSIGN TO 'INPUT.DAT'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT OUTPUT-FILE ASSIGN TO 'OUTPUT.DAT'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  INPUT-FILE.
       01  INPUT-RECORD      PIC X(80).

       FD  OUTPUT-FILE.
       01  OUTPUT-RECORD     PIC X(80).

       WORKING-STORAGE SECTION.
       01  WS-EOF            PIC X VALUE 'N'.
       01  WS-COUNTER        PIC 9(5) VALUE ZERO.

       PROCEDURE DIVISION.
       MAIN-PARA.
           OPEN INPUT INPUT-FILE
           OPEN OUTPUT OUTPUT-FILE.

           PERFORM UNTIL WS-EOF = 'Y'
               READ INPUT-FILE
                   AT END
                       MOVE 'Y' TO WS-EOF
                   NOT AT END
                       ADD 1 TO WS-COUNTER
                       WRITE OUTPUT-RECORD FROM INPUT-RECORD
               END-READ
           END-PERFORM.

           DISPLAY 'Records processed: ' WS-COUNTER.

           CLOSE INPUT-FILE
           CLOSE OUTPUT-FILE.

           STOP RUN.
```

**Python Equivalent**:
```python
def process_files():
    counter = 0

    with open('INPUT.DAT', 'r') as input_file, \
         open('OUTPUT.DAT', 'w') as output_file:

        for line in input_file:
            counter += 1
            output_file.write(line)

    print(f'Records processed: {counter}')

process_files()
```

**Ruby Equivalent**:
```ruby
def process_files
  counter = 0

  File.open('INPUT.DAT', 'r') do |input_file|
    File.open('OUTPUT.DAT', 'w') do |output_file|
      input_file.each_line do |line|
        counter += 1
        output_file.write(line)
      end
    end
  end

  puts "Records processed: #{counter}"
end

process_files
```

**C Equivalent**:
```c
#include <stdio.h>

int main() {
    FILE *input_file, *output_file;
    char buffer[81];
    int counter = 0;

    input_file = fopen("INPUT.DAT", "r");
    output_file = fopen("OUTPUT.DAT", "w");

    if (input_file && output_file) {
        while (fgets(buffer, sizeof(buffer), input_file)) {
            counter++;
            fputs(buffer, output_file);
        }

        printf("Records processed: %d\n", counter);

        fclose(input_file);
        fclose(output_file);
    }

    return 0;
}
```

### Indexed File (VSAM KSDS)

**COBOL**:
```cobol
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CUSTOMER-FILE ASSIGN TO 'CUSTFILE'
               ORGANIZATION IS INDEXED
               ACCESS MODE IS RANDOM
               RECORD KEY IS CUST-ID
               FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  CUSTOMER-FILE.
       01  CUSTOMER-RECORD.
           05  CUST-ID           PIC 9(6).
           05  CUST-NAME         PIC X(30).
           05  CUST-BALANCE      PIC S9(7)V99.

       WORKING-STORAGE SECTION.
       01  WS-FILE-STATUS    PIC XX.
       01  WS-SEARCH-ID      PIC 9(6).

       PROCEDURE DIVISION.
           OPEN I-O CUSTOMER-FILE.

          *> Random read by key
           MOVE 123456 TO WS-SEARCH-ID.
           READ CUSTOMER-FILE
               KEY IS CUST-ID = WS-SEARCH-ID
               INVALID KEY
                   DISPLAY 'Customer not found'
               NOT INVALID KEY
                   DISPLAY 'Name: ' CUST-NAME
                   DISPLAY 'Balance: ' CUST-BALANCE
           END-READ.

          *> Update record
           IF WS-FILE-STATUS = '00'
               ADD 100.00 TO CUST-BALANCE
               REWRITE CUSTOMER-RECORD
                   INVALID KEY
                       DISPLAY 'Update failed'
               END-REWRITE
           END-IF.

           CLOSE CUSTOMER-FILE.
           STOP RUN.
```

**Python (SQLite equivalent)**:
```python
import sqlite3

def process_customer(search_id):
    conn = sqlite3.connect('customers.db')
    cursor = conn.cursor()

    # Read by key
    cursor.execute('''
        SELECT name, balance FROM customers WHERE id = ?
    ''', (search_id,))

    row = cursor.fetchone()

    if row:
        name, balance = row
        print(f'Name: {name}')
        print(f'Balance: {balance}')

        # Update
        cursor.execute('''
            UPDATE customers SET balance = balance + 100.00
            WHERE id = ?
        ''', (search_id,))

        conn.commit()
    else:
        print('Customer not found')

    conn.close()

process_customer(123456)
```

---

## Comparison with Modern Languages

### Key Differences

| Feature | COBOL | Python | Ruby | C |
|---------|-------|--------|------|---|
| **Typing** | Static, strict | Dynamic | Dynamic | Static |
| **Syntax** | Verbose, English-like | Concise | Concise | Concise |
| **Decimal Math** | Native (COMP-3) | Library (Decimal) | Native (BigDecimal) | Library |
| **Fixed Format** | Yes (columns 7-72) | No | No | No |
| **Case Sensitive** | No | Yes | Yes | Yes |
| **File Handling** | Built-in, powerful | Simple | Simple | Manual |
| **OOP** | Limited (COBOL 2002+) | Full | Full | Limited (structs) |
| **String Handling** | Manual (MOVE, INSPECT) | Built-in methods | Built-in methods | Manual (string.h) |
| **Error Handling** | File status, condition codes | Exceptions (try/except) | Exceptions (begin/rescue) | Return codes, errno |
| **Memory Management** | Automatic | Automatic (GC) | Automatic (GC) | Manual (malloc/free) |
| **Performance** | Fast (compiled) | Slower (interpreted) | Slower (interpreted) | Fastest (compiled) |
| **Readability** | Very high (verbose) | High | High | Medium |
| **Learning Curve** | Moderate | Easy | Easy | Moderate-Hard |

### Decimal Arithmetic

**COBOL** (Perfect for money):
```cobol
       01  WS-PRICE      PIC 9(5)V99 VALUE 123.45.
       01  WS-QUANTITY   PIC 9(3) VALUE 10.
       01  WS-TOTAL      PIC 9(7)V99.

       COMPUTE WS-TOTAL = WS-PRICE * WS-QUANTITY.
       *> WS-TOTAL = 1234.50 (exact, no floating point errors)
```

**Python** (Float has rounding errors):
```python
price = 123.45
quantity = 10
total = price * quantity
# total = 1234.5000000000002 (floating point error!)

# Use Decimal for exact math
from decimal import Decimal
price = Decimal('123.45')
quantity = Decimal('10')
total = price * quantity
# total = Decimal('1234.50') (exact)
```

**Ruby**:
```ruby
price = 123.45
quantity = 10
total = price * quantity
# total = 1234.5000000000002 (same issue)

# Use BigDecimal
require 'bigdecimal'
price = BigDecimal('123.45')
quantity = BigDecimal('10')
total = price * quantity
# total = 0.123450e4 (exact)
```

**C**:
```c
// Float has same precision issues
float price = 123.45f;
int quantity = 10;
float total = price * quantity;
// total = 1234.500122 (floating point error)

// Use integer cents
int price_cents = 12345;  // 123.45 in cents
int quantity = 10;
int total_cents = price_cents * quantity;
// total_cents = 123450 (exact, then divide by 100)
```

**Why COBOL Wins**:
- COMP-3 (packed decimal) stores exact decimal values
- No floating point errors
- Perfect for financial calculations
- Hardware support on mainframes

---

## GNUcobol vs Traditional COBOL

### Traditional COBOL (IBM COBOL for z/OS)

**Commercial, Mainframe-based**:
```
Compiler: IBM Enterprise COBOL
Version: 6.4 (latest)
Platform: z/OS mainframe
Cost: Expensive (mainframe licensing)
Target: Large enterprises, banks
Features:
  - Optimized for IBM Z hardware
  - Full language support
  - Integrated with CICS, IMS, DB2
  - JCL integration
  - VSAM file support
  - Sysplex compatibility
```

**Example** (IBM COBOL):
```cobol
      *> IBM COBOL specific features
       IDENTIFICATION DIVISION.
       PROGRAM-ID. IBMCOBOL.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-Z16.
       OBJECT-COMPUTER. IBM-Z16.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-AMOUNT     PIC 9(7)V99 COMP-3.  *> Packed decimal
       01  WS-BINARY     PIC 9(9) COMP.        *> Binary

       PROCEDURE DIVISION.
          *> IBM extensions
           EXEC CICS RECEIVE
               INTO(WS-DATA)
               LENGTH(WS-LENGTH)
           END-EXEC.

           EXEC SQL
               SELECT NAME, SALARY
               INTO :WS-NAME, :WS-SALARY
               FROM EMPLOYEE
               WHERE EMPNO = :WS-EMPNO
           END-EXEC.

           STOP RUN.
```

### GNUcobol (Open Source)

**Free, Cross-Platform**:
```
Compiler: GNUcobol (formerly OpenCOBOL)
Version: 3.2+ (latest)
Platform: Linux, Windows, macOS, Unix
Cost: Free (GPL)
Target: Open source developers, learning, migration
Features:
  - COBOL 85, 2002, 2014 standards
  - Generates C code (compiled to native)
  - Modern OS integration
  - No mainframe required
  - SQLite, PostgreSQL, MySQL support
```

**Installation**:
```bash
# Ubuntu/Debian
sudo apt-get install gnucobol

# RHEL/Fedora
sudo dnf install gnucobol

# Compile COBOL program
cobc -x program.cob         # Compile to executable
./program                   # Run

# Or compile and run
cobc -x program.cob && ./program
```

**Example** (GNUcobol):
```cobol
      *> GNUcobol program
       IDENTIFICATION DIVISION.
       PROGRAM-ID. GNUCOBOL-DEMO.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           FUNCTION ALL INTRINSIC.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-NAME       PIC X(30).
       01  WS-COUNT      PIC 9(4).

       PROCEDURE DIVISION.
           DISPLAY 'Enter your name: ' WITH NO ADVANCING.
           ACCEPT WS-NAME.
           DISPLAY 'Hello, ' FUNCTION TRIM(WS-NAME) '!'.

          *> Modern intrinsic functions
           MOVE FUNCTION LENGTH(WS-NAME) TO WS-COUNT.
           DISPLAY 'Your name has ' WS-COUNT ' characters'.

           STOP RUN.
```

### Feature Comparison

| Feature | IBM COBOL | GNUcobol |
|---------|-----------|----------|
| **Cost** | Expensive (mainframe) | Free |
| **Platform** | z/OS mainframe | Linux, Windows, macOS, Unix |
| **Standards** | COBOL 85, 2014 | COBOL 85, 2002, 2014 |
| **Compilation** | Native mainframe code | C translation → native |
| **CICS Support** | Full | Limited (TXSeries) |
| **VSAM** | Full support | Emulated (B-tree files) |
| **SQL Integration** | DB2, IMS | SQLite, PostgreSQL, MySQL |
| **Performance** | Excellent (optimized hardware) | Good (depends on C compiler) |
| **Debugging** | IBM Debug Tool | GDB (C debugger) |
| **File I/O** | QSAM, VSAM, BDAM | Sequential, Indexed, Relative |
| **Extensions** | IBM-specific | Minimal |
| **Learning** | Requires mainframe access | Easy (any computer) |
| **Production Use** | Banks, Fortune 500 | Small-medium businesses, migration |

### File Format Differences

**IBM COBOL** (VSAM):
```cobol
       SELECT CUSTOMER-FILE ASSIGN TO 'DD:CUSTFILE'
           ORGANIZATION IS INDEXED
           ACCESS MODE IS DYNAMIC
           RECORD KEY IS CUST-ID
           ALTERNATE RECORD KEY IS CUST-NAME WITH DUPLICATES
           FILE STATUS IS WS-STATUS.
```

**GNUcobol** (Indexed File):
```cobol
       SELECT CUSTOMER-FILE ASSIGN TO 'customer.dat'
           ORGANIZATION IS INDEXED
           ACCESS MODE IS DYNAMIC
           RECORD KEY IS CUST-ID
           ALTERNATE RECORD KEY IS CUST-NAME WITH DUPLICATES
           FILE STATUS IS WS-STATUS.
```

**Key Difference**:
- IBM: Uses JCL DD statements, VSAM catalogs
- GNU: Direct file paths, B-tree indexed files

### Migration Path

**From IBM COBOL to GNUcobol**:

1. **Remove IBM-specific features**:
   - CICS commands → Replace with accept/display or SQL
   - VSAM → Use indexed files
   - JCL DD statements → Direct file paths
   - COMP-3 → Use COMP (binary) or display

2. **Database Integration**:
   ```cobol
   *> IBM (DB2)
   EXEC SQL
       SELECT NAME INTO :WS-NAME
       FROM EMPLOYEE
       WHERE ID = :WS-ID
   END-EXEC.

   *> GNUcobol (PostgreSQL with ESQL)
   EXEC SQL
       SELECT NAME INTO :WS-NAME
       FROM EMPLOYEE
       WHERE ID = :WS-ID
   END-EXEC.
   ```

3. **File I/O**:
   ```cobol
   *> IBM
   SELECT FILE1 ASSIGN TO 'DD:INPUT'
       ORGANIZATION IS SEQUENTIAL.

   *> GNUcobol
   SELECT FILE1 ASSIGN TO 'input.dat'
       ORGANIZATION IS LINE SEQUENTIAL.
   ```

---

## Modern COBOL Features

### COBOL 2002/2014 Features

**Object-Oriented COBOL**:
```cobol
       IDENTIFICATION DIVISION.
       CLASS-ID. BankAccount.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  account-balance PIC 9(9)V99 PRIVATE.
       01  account-number  PIC X(10) PRIVATE.

       PROCEDURE DIVISION.

       METHOD-ID. deposit.
       DATA DIVISION.
       LINKAGE SECTION.
       01  amount PIC 9(7)V99.

       PROCEDURE DIVISION USING BY VALUE amount.
           ADD amount TO account-balance.
           DISPLAY 'New balance: ' account-balance.
       END METHOD deposit.

       METHOD-ID. withdraw.
       DATA DIVISION.
       LINKAGE SECTION.
       01  amount PIC 9(7)V99.

       PROCEDURE DIVISION USING BY VALUE amount.
           IF amount <= account-balance
               SUBTRACT amount FROM account-balance
               DISPLAY 'Withdrawal successful'
           ELSE
               DISPLAY 'Insufficient funds'
           END-IF.
       END METHOD withdraw.

       END CLASS BankAccount.
```

**User-Defined Functions**:
```cobol
       IDENTIFICATION DIVISION.
       FUNCTION-ID. calculate-tax.

       DATA DIVISION.
       LINKAGE SECTION.
       01  salary    PIC 9(7)V99.
       01  tax       PIC 9(7)V99.

       PROCEDURE DIVISION USING salary RETURNING tax.
           IF salary < 50000
               COMPUTE tax = salary * 0.15
           ELSE
               COMPUTE tax = (50000 * 0.15) +
                            ((salary - 50000) * 0.25)
           END-IF.
           GOBACK.
       END FUNCTION calculate-tax.

      *> Usage
       CALL calculate-tax USING WS-SALARY RETURNING WS-TAX.
```

**JSON Support** (COBOL 2014):
```cobol
       IDENTIFICATION DIVISION.
       PROGRAM-ID. JSON-DEMO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  JSON-TEXT    PIC X(500).
       01  EMPLOYEE-DATA.
           05  EMP-NAME     PIC X(30).
           05  EMP-SALARY   PIC 9(7)V99.
           05  EMP-ACTIVE   PIC X.

       PROCEDURE DIVISION.
          *> Generate JSON
           MOVE 'John Doe' TO EMP-NAME.
           MOVE 75000.00 TO EMP-SALARY.
           MOVE 'Y' TO EMP-ACTIVE.

           JSON GENERATE JSON-TEXT FROM EMPLOYEE-DATA.
           DISPLAY JSON-TEXT.

          *> Parse JSON
           MOVE '{"EMP-NAME":"Jane Smith","EMP-SALARY":80000.00}'
               TO JSON-TEXT.
           JSON PARSE JSON-TEXT INTO EMPLOYEE-DATA.
           DISPLAY 'Name: ' EMP-NAME.
           DISPLAY 'Salary: ' EMP-SALARY.

           STOP RUN.
```

**XML Support**:
```cobol
       XML GENERATE XML-TEXT FROM EMPLOYEE-RECORD.
       XML PARSE XML-TEXT INTO EMPLOYEE-RECORD.
```

---

## Key Takeaways

**COBOL Strengths**:
- Perfect decimal arithmetic (financial calculations)
- Excellent file handling
- Self-documenting code
- Proven reliability (65+ years)
- Massive legacy codebase

**COBOL Weaknesses**:
- Verbose syntax
- Limited modern features (pre-2002)
- Aging developer base
- Mainframe dependency (commercial COBOL)
- Lack of modern tooling

**When to Use COBOL**:
- Maintaining legacy systems
- Financial applications (exact decimal math)
- Batch processing large datasets
- Integration with mainframe systems
- High-reliability requirements

**When to Avoid COBOL**:
- New greenfield projects (use modern languages)
- Web applications (use Python, Ruby, JavaScript)
- Real-time systems (use C, C++, Rust)
- Machine learning (use Python, R)
- Mobile apps (use Swift, Kotlin, Flutter)

**GNUcobol Use Cases**:
- Learning COBOL without mainframe access
- Migrating off mainframe
- Running COBOL on modern platforms
- Small-scale COBOL applications
- Integration/testing environments

**Future of COBOL**:
- Legacy maintenance will continue
- Gradual migration to modern languages
- Expensive COBOL developers
- Modernization efforts (JSON, OOP, APIs)
- Won't disappear soon (too much code to rewrite)
