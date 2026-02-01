# COBOL Basics and Comparison

COBOL programming fundamentals with comparisons to modern languages (primarily Python).

---

## Table of Contents

1. [Overview](#overview)
2. [COBOL Structure](#cobol-structure)
3. [Data Types](#data-types)
4. [Control Structures](#control-structures)
5. [File Handling](#file-handling)
6. [GNUcobol vs IBM COBOL](#gnucobol-vs-ibm-cobol)
7. [Modern COBOL](#modern-cobol)

---

## Overview

### What is COBOL?

**COBOL** (Common Business-Oriented Language)
```
Created: 1959 (65+ years old)
Designer: Grace Hopper (influenced)
Purpose: Business data processing
Philosophy: Self-documenting, English-like
```

**Current Usage**:
```
Active COBOL: 220+ billion lines
Daily transactions: 3 trillion
ATM transactions: 95%
Credit card systems: 80%
Fortune 500 using COBOL: 92%
```

**Why Still Used**:
- Proven reliability (decades of testing)
- Perfect decimal arithmetic (no floating-point errors)
- Excellent batch processing
- Banks reluctant to rewrite mission-critical code
- COBOL programmers expensive

---

## COBOL Structure

### Four Divisions

```cobol
       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO-WORLD.

       ENVIRONMENT DIVISION.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MESSAGE    PIC X(20) VALUE 'Hello, COBOL!'.

       PROCEDURE DIVISION.
           DISPLAY WS-MESSAGE.
           STOP RUN.
```

**Python Equivalent**:
```python
# No divisions needed
message = "Hello, COBOL!"
print(message)
```

### Division Breakdown

**1. IDENTIFICATION**:
```cobol
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PROGRAM-NAME.
       AUTHOR. DEVELOPER-NAME.
       DATE-WRITTEN. 2026-02-01.
```
- Program metadata
- Not executed

**2. ENVIRONMENT**:
```cobol
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INPUT-FILE ASSIGN TO 'INPUT.DAT'
               ORGANIZATION IS LINE SEQUENTIAL.
```
- File assignments
- Device mappings

**3. DATA**:
```cobol
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-COUNTER        PIC 9(4) VALUE ZERO.
       01  WS-NAME           PIC X(30).
```
- Variable declarations
- File layouts

**4. PROCEDURE**:
```cobol
       PROCEDURE DIVISION.
       MAIN-PARA.
           PERFORM INIT-PARA.
           PERFORM PROCESS-PARA.
           STOP RUN.

       INIT-PARA.
           DISPLAY 'Initializing...'.
```
- Executable code
- Paragraph-based organization

---

## Data Types

### PICTURE Clause (PIC)

**Numeric**:
```cobol
      *> Integers
       01  WS-COUNT          PIC 9(4).          *> 0000-9999
       01  WS-PRICE          PIC 9(5)V99.       *> 00000.00-99999.99
       01  WS-SIGNED         PIC S9(4).         *> -9999 to +9999

      *> Packed decimal (mainframe)
       01  WS-AMOUNT         PIC 9(7)V99 COMP-3.
```

**Python Equivalent**:
```python
count = 0               # Dynamic typing
price = 0.0
signed_val = 0

# For exact decimal (like COBOL COMP-3)
from decimal import Decimal
amount = Decimal('0.00')
```

**Alphanumeric**:
```cobol
       01  WS-NAME           PIC X(30).         *> 30 characters
       01  WS-ADDRESS        PIC X(50).
```

**Python**:
```python
name = ""               # No size limit
address = ""
```

### Level Numbers and Hierarchical Data

**COBOL**:
```cobol
       01  EMPLOYEE-RECORD.
           05  EMP-ID            PIC 9(6).
           05  EMP-NAME.
               10  FIRST-NAME    PIC X(15).
               10  LAST-NAME     PIC X(20).
           05  EMP-SALARY        PIC 9(7)V99.
```

**Python Equivalent** (dictionary or dataclass):
```python
# Dictionary
employee = {
    'emp_id': 0,
    'emp_name': {
        'first_name': '',
        'last_name': ''
    },
    'emp_salary': 0.0
}

# Or dataclass (Python 3.7+)
from dataclasses import dataclass

@dataclass
class EmployeeName:
    first_name: str
    last_name: str

@dataclass
class Employee:
    emp_id: int
    emp_name: EmployeeName
    emp_salary: float
```

### Condition Names (88 Level)

**COBOL**:
```cobol
       01  WS-STATUS         PIC X(1).
           88  STATUS-ACTIVE     VALUE 'A'.
           88  STATUS-INACTIVE   VALUE 'I'.

       PROCEDURE DIVISION.
           MOVE 'A' TO WS-STATUS.
           IF STATUS-ACTIVE
               DISPLAY 'User is active'
           END-IF.

           SET STATUS-INACTIVE TO TRUE.
```

**Python**:
```python
status = 'A'

# Using constants
STATUS_ACTIVE = 'A'
STATUS_INACTIVE = 'I'

if status == STATUS_ACTIVE:
    print('User is active')

status = STATUS_INACTIVE  # Set
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

      *> Multiple conditions
       IF (WS-AGE > 18) AND (WS-STATUS = 'A')
           PERFORM PROCESS-ADULT
       END-IF.
```

**Python**:
```python
if age > 18:
    print('Adult')
else:
    print('Minor')

# Multiple conditions
if age > 18 and status == 'A':
    process_adult()
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
           WHEN OTHER
               DISPLAY 'Invalid'
       END-EVALUATE.

      *> Range-based
       EVALUATE TRUE
           WHEN WS-SCORE >= 90
               MOVE 'A' TO WS-GRADE
           WHEN WS-SCORE >= 80
               MOVE 'B' TO WS-GRADE
           WHEN OTHER
               MOVE 'F' TO WS-GRADE
       END-EVALUATE.
```

**Python** (3.10+):
```python
# Pattern matching
match grade:
    case 'A':
        print('Excellent')
    case 'B':
        print('Good')
    case 'C':
        print('Average')
    case _:
        print('Invalid')

# Range-based (traditional if-elif)
if score >= 90:
    grade = 'A'
elif score >= 80:
    grade = 'B'
else:
    grade = 'F'
```

### Loops

**COBOL**:
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
```

---

## File Handling

### Sequential File

**COBOL**:
```cobol
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INPUT-FILE ASSIGN TO 'INPUT.DAT'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  INPUT-FILE.
       01  INPUT-RECORD      PIC X(80).

       WORKING-STORAGE SECTION.
       01  WS-EOF            PIC X VALUE 'N'.
       01  WS-COUNTER        PIC 9(5) VALUE ZERO.

       PROCEDURE DIVISION.
           OPEN INPUT INPUT-FILE.

           PERFORM UNTIL WS-EOF = 'Y'
               READ INPUT-FILE
                   AT END
                       MOVE 'Y' TO WS-EOF
                   NOT AT END
                       ADD 1 TO WS-COUNTER
               END-READ
           END-PERFORM.

           DISPLAY 'Records: ' WS-COUNTER.
           CLOSE INPUT-FILE.
           STOP RUN.
```

**Python**:
```python
def process_file():
    counter = 0
    
    with open('INPUT.DAT', 'r') as input_file:
        for line in input_file:
            counter += 1
    
    print(f'Records: {counter}')

process_file()
```

**Key Difference**: COBOL is verbose but explicit; Python is concise.

### Indexed File (VSAM)

**COBOL**:
```cobol
       FILE-CONTROL.
           SELECT CUSTOMER-FILE ASSIGN TO 'CUSTFILE'
               ORGANIZATION IS INDEXED
               ACCESS MODE IS RANDOM
               RECORD KEY IS CUST-ID.

       FILE SECTION.
       FD  CUSTOMER-FILE.
       01  CUSTOMER-RECORD.
           05  CUST-ID           PIC 9(6).
           05  CUST-NAME         PIC X(30).
           05  CUST-BALANCE      PIC S9(7)V99.

       PROCEDURE DIVISION.
           OPEN I-O CUSTOMER-FILE.

          *> Random read by key
           MOVE 123456 TO CUST-ID.
           READ CUSTOMER-FILE
               KEY IS CUST-ID
               INVALID KEY
                   DISPLAY 'Not found'
               NOT INVALID KEY
                   DISPLAY 'Name: ' CUST-NAME
           END-READ.

           CLOSE CUSTOMER-FILE.
```

**Python** (using SQLite as equivalent):
```python
import sqlite3

def read_customer(customer_id):
    conn = sqlite3.connect('customers.db')
    cursor = conn.cursor()
    
    cursor.execute('''
        SELECT name, balance 
        FROM customers 
        WHERE id = ?
    ''', (customer_id,))
    
    row = cursor.fetchone()
    
    if row:
        name, balance = row
        print(f'Name: {name}')
    else:
        print('Not found')
    
    conn.close()

read_customer(123456)
```

---

## GNUcobol vs IBM COBOL

### IBM COBOL (Commercial)

**Platform**: z/OS mainframe
**Cost**: Expensive (mainframe licensing)
**Version**: 6.4 (latest)

**Features**:
```
Target: Large enterprises, banks
Optimization: IBM Z hardware
Integration: CICS, IMS, DB2, JCL
File Support: VSAM (native)
Extensions: IBM-specific
```

**Example** (IBM-specific):
```cobol
      *> IBM COBOL with CICS
       EXEC CICS RECEIVE
           INTO(WS-DATA)
           LENGTH(WS-LENGTH)
       END-EXEC.

       EXEC SQL
           SELECT NAME INTO :WS-NAME
           FROM EMPLOYEE
           WHERE ID = :WS-ID
       END-EXEC.
```

### GNUcobol (Open Source)

**Platform**: Linux, Windows, macOS, Unix
**Cost**: Free (GPL)
**Version**: 3.2+

**Features**:
```
Target: Learning, migration, open source
Compilation: Generates C code
Standards: COBOL 85, 2002, 2014
Databases: SQLite, PostgreSQL, MySQL
No Mainframe Required
```

**Installation**:
```bash
# Ubuntu/Debian
sudo apt-get install gnucobol

# Compile and run
cobc -x program.cob
./program
```

### Comparison

| Feature | IBM COBOL | GNUcobol |
|---------|-----------|----------|
| **Cost** | Expensive | Free |
| **Platform** | z/OS | Linux/Windows/macOS/Unix |
| **CICS** | Full support | Limited |
| **VSAM** | Native | Emulated (B-tree) |
| **SQL** | DB2, IMS | SQLite, PostgreSQL, MySQL |
| **Performance** | Optimized hardware | Good (C compiler dependent) |
| **Learning** | Requires mainframe | Any computer |
| **Production** | Fortune 500 banks | Small-medium business |

**File Differences**:

IBM (JCL DD statements):
```cobol
       SELECT FILE1 ASSIGN TO 'DD:INPUT'.
```

GNUcobol (direct paths):
```cobol
       SELECT FILE1 ASSIGN TO 'input.dat'.
```

---

## Modern COBOL

### Object-Oriented (COBOL 2002+)

**Class Definition**:
```cobol
       CLASS-ID. BankAccount.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  account-balance PIC 9(9)V99 PRIVATE.

       METHOD-ID. deposit.
       DATA DIVISION.
       LINKAGE SECTION.
       01  amount PIC 9(7)V99.

       PROCEDURE DIVISION USING BY VALUE amount.
           ADD amount TO account-balance.
           DISPLAY 'New balance: ' account-balance.
       END METHOD deposit.

       END CLASS BankAccount.
```

**Python Equivalent**:
```python
class BankAccount:
    def __init__(self):
        self.__account_balance = 0.0  # Private
    
    def deposit(self, amount):
        self.__account_balance += amount
        print(f'New balance: {self.__account_balance}')
```

### JSON Support (COBOL 2014)

**COBOL**:
```cobol
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  JSON-TEXT    PIC X(500).
       01  EMPLOYEE-DATA.
           05  EMP-NAME     PIC X(30).
           05  EMP-SALARY   PIC 9(7)V99.

       PROCEDURE DIVISION.
          *> Generate JSON
           MOVE 'John Doe' TO EMP-NAME.
           MOVE 75000.00 TO EMP-SALARY.
           JSON GENERATE JSON-TEXT FROM EMPLOYEE-DATA.
           DISPLAY JSON-TEXT.

          *> Parse JSON
           JSON PARSE JSON-TEXT INTO EMPLOYEE-DATA.
```

**Python**:
```python
import json

employee_data = {
    'emp_name': 'John Doe',
    'emp_salary': 75000.00
}

# Generate JSON
json_text = json.dumps(employee_data)
print(json_text)

# Parse JSON
employee_data = json.loads(json_text)
```

---

## Decimal Arithmetic (COBOL's Superpower)

### Why COBOL Excels

**COBOL**:
```cobol
       01  WS-PRICE      PIC 9(5)V99 VALUE 123.45.
       01  WS-QUANTITY   PIC 9(3) VALUE 10.
       01  WS-TOTAL      PIC 9(7)V99.

       COMPUTE WS-TOTAL = WS-PRICE * WS-QUANTITY.
       *> WS-TOTAL = 1234.50 (EXACT, no rounding errors)
```

**Python** (float has errors):
```python
price = 123.45
quantity = 10
total = price * quantity
# total = 1234.5000000000002  ← Floating point error!

# Fix with Decimal
from decimal import Decimal
price = Decimal('123.45')
quantity = Decimal('10')
total = price * quantity
# total = Decimal('1234.50')  ← Exact!
```

**Why COBOL Wins**:
- COMP-3 (packed decimal) stores exact values
- No floating-point representation
- Perfect for financial calculations
- Hardware support on mainframes

---

## Comparison Summary

| Feature | COBOL | Python |
|---------|-------|--------|
| **Typing** | Static, strict | Dynamic |
| **Syntax** | Verbose, English-like | Concise |
| **Decimal Math** | Native (perfect) | Requires Decimal library |
| **File Handling** | Built-in, powerful | Simple libraries |
| **OOP** | Limited (2002+) | Full, first-class |
| **Performance** | Fast (compiled) | Slower (interpreted) |
| **Readability** | Very high (verbose) | High (concise) |
| **Learning Curve** | Moderate | Easy |
| **Age** | 65+ years | 33 years |

---

## Key Takeaways

**COBOL Strengths**:
- Perfect decimal arithmetic (no rounding errors)
- Excellent file handling (sequential, indexed, VSAM)
- Self-documenting code (verbose but clear)
- Proven reliability (65+ years, 220 billion lines)
- Massive legacy codebases

**COBOL Weaknesses**:
- Verbose syntax (200 lines vs 20 in Python)
- Limited modern features (pre-2002)
- Aging developer base
- Mainframe dependency (commercial COBOL)

**When to Use COBOL**:
- Maintaining legacy mainframe systems
- Financial applications (exact decimal required)
- Batch processing large datasets
- High-reliability requirements (banking, insurance)

**When to Avoid COBOL**:
- New projects (use Python, Java, etc.)
- Web applications
- Real-time systems
- Machine learning
- Mobile apps

**GNUcobol Use Cases**:
- Learning COBOL without mainframe
- Migrating off mainframe
- Running legacy code on Linux/Windows
- Small-scale COBOL applications

**Future**:
- Legacy maintenance continues (decades more)
- Gradual migration to modern languages
- COBOL developers increasingly expensive
- Won't disappear (too much code to rewrite)
- Modernization: JSON, OOP, APIs
