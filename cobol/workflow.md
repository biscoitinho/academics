# COBOL Workflow

How a generic development workflow looks when working with COBOL.

## Project Setup

### 1. Create Project Structure

```
myproject/
├── src/
│   ├── main-program.cob
│   └── sub-program.cob
├── copybooks/
│   ├── customer-record.cpy
│   └── file-status-codes.cpy
├── data/
│   ├── input/
│   └── output/
├── tests/
│   └── test-main-program.cut
├── Makefile
└── .gitignore
```

### 2. Set Up GnuCOBOL

```bash
# Install
sudo apt install gnucobol

# Verify
cobc --version

# Compile a test program
cobc -x hello.cob -o hello
./hello
```

### 3. Choose Source Format

COBOL has two source formats:

**Fixed format** (traditional, columns matter):
```
       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO.
       PROCEDURE DIVISION.
           DISPLAY "HELLO WORLD".
           STOP RUN.
```
- Columns 1-6: Sequence numbers (optional)
- Column 7: Indicator (* for comment, - for continuation)
- Columns 8-11: Area A (divisions, sections, paragraphs)
- Columns 12-72: Area B (statements)
- Columns 73-80: Ignored

**Free format** (modern, no column restrictions):
```cobol
IDENTIFICATION DIVISION.
PROGRAM-ID. HELLO.
PROCEDURE DIVISION.
    DISPLAY "HELLO WORLD".
    STOP RUN.
```

Compile with `-free` flag for free format: `cobc -x -free program.cob`

## Development Cycle

### Write Code

1. Define the program structure (IDENTIFICATION, ENVIRONMENT, DATA, PROCEDURE divisions)
2. Define data items in WORKING-STORAGE or FILE SECTION
3. Write the procedure logic using paragraphs and sections
4. Use COPY statements for shared copybooks

### Compile

```bash
# Basic compile
cobc -x src/main-program.cob -o main-program

# With copybook path
cobc -x -I ./copybooks src/main-program.cob -o main-program

# With all warnings
cobc -x -Wall -I ./copybooks src/main-program.cob -o main-program

# With debug mode
cobc -x -g -debug -I ./copybooks src/main-program.cob -o main-program
```

### Run

```bash
# Simple execution
./main-program

# With input file redirection
./main-program < data/input/customers.dat

# With environment variables (file assignments)
export DD_INFILE="data/input/customers.dat"
export DD_OUTFILE="data/output/report.dat"
./main-program
```

### Test

```bash
# Run and verify output
./main-program
diff data/output/report.dat data/expected/report.dat

# With COBOL-Check (if set up)
cobolcheck -p src/main-program
```

### Typical Cycle
```
write/modify code -> compile (fix errors) -> run with test data -> verify output -> commit
```

## Best Practices

### Program Structure
- Follow the four-division structure consistently
- Keep paragraphs short and focused (one task per paragraph)
- Use meaningful paragraph names: `PROCESS-CUSTOMER-RECORD` not `PARA-1`
- Use a main control paragraph that calls sub-paragraphs:

```cobol
       PROCEDURE DIVISION.
       MAIN-CONTROL.
           PERFORM INITIALIZE-PROGRAM
           PERFORM PROCESS-RECORDS UNTIL END-OF-FILE
           PERFORM FINALIZE-PROGRAM
           STOP RUN.
```

### Data Definitions
- Use level 88 condition names for flags and states:
  ```cobol
       01 WS-RECORD-STATUS    PIC X.
          88 RECORD-VALID      VALUE "Y".
          88 RECORD-INVALID    VALUE "N".
  ```
- Group related fields under a parent level:
  ```cobol
       01 WS-CUSTOMER.
          05 WS-CUST-NAME     PIC X(30).
          05 WS-CUST-EMAIL    PIC X(50).
          05 WS-CUST-AGE      PIC 9(3).
  ```
- Use descriptive prefixes: `WS-` for working storage, `FD-` for file data, `LS-` for linkage
- Define PIC clauses accurately for the data size you actually need

### File Handling
- Always check FILE STATUS after every file operation
- Use a standard file-status-checking paragraph:

```cobol
       CHECK-FILE-STATUS.
           IF WS-FILE-STATUS NOT = "00"
               DISPLAY "FILE ERROR: " WS-FILE-STATUS
               STOP RUN
           END-IF.
```

- Close files in the finalize paragraph
- Handle end-of-file condition properly with `AT END` or status check

### Copybooks
- Put shared record layouts in copybooks
- Put shared constants and working-storage fields in copybooks
- Keep copybooks focused (one record layout or one set of related fields per copybook)
- Use REPLACING clause when copybooks need slight variations:
  ```cobol
  COPY "customer-record.cpy" REPLACING ==:PREFIX:== BY ==WS==.
  ```

### Naming Conventions
- Use uppercase for COBOL reserved words and data names (traditional)
- Use hyphens to separate words: `PROCESS-CUSTOMER-RECORD`
- Prefix working-storage items with `WS-`
- Prefix file description items with the file abbreviation
- Keep names under 30 characters (COBOL limit)

### Error Handling
- Check all file statuses
- Validate input data before processing
- Use condition names (level 88) for readable validation
- Log errors with enough context to diagnose: record number, field values, error type
- Have a central error-handling paragraph

## What to Avoid

### Common Mistakes
- **Not checking FILE STATUS** - File operations fail silently without status checks
- **GO TO** - Use `PERFORM` instead; GO TO creates spaghetti code
- **Hardcoded values** - Use WORKING-STORAGE constants or copybooks
- **Ignoring compiler warnings** - Fix all warnings; they often indicate real bugs
- **Modifying loop counters inside PERFORM VARYING** - Leads to unpredictable behavior
- **Missing periods** - In fixed format, periods terminate statements; a missing period can change program flow entirely

### Design Anti-Patterns
- **Monolithic procedure division** - Break logic into focused paragraphs
- **Reusing data items for different purposes** - Define separate items even if they have the same PIC clause
- **Not using level 88 conditions** - Using `IF WS-STATUS = "Y"` instead of `IF STATUS-ACTIVE`
- **Deeply nested IF statements** - Use EVALUATE (COBOL's case/switch) or separate paragraphs
- **PERFORM THRU** without care - The range between paragraphs can accidentally include new code added later
- **ALTER statement** - Never use it; it's obsolete and makes code flow impossible to follow

### Data Definition Anti-Patterns
- **PIC X(9999)** - Overly large fields waste memory and mask bugs
- **Ambiguous data names** - `WS-FLAG` says nothing; use `WS-CUSTOMER-ACTIVE-FLAG`
- **Not using FILLER** - Use FILLER for unused portions of records to document the layout
- **Packed decimal misuse** - Ensure PIC 9 COMP-3 fields have the right size for the data

## Debugging Workflow

### Compile-Time Errors
1. Read the compiler message carefully - GnuCOBOL gives line numbers
2. Check for missing periods, unclosed IF/END-IF, or mismatched levels
3. Verify column alignment (fixed format): code in Area A vs Area B

### Runtime Errors
1. **Add DISPLAY statements** at key points:
   ```cobol
   DISPLAY "DEBUG: PROCESSING RECORD " WS-RECORD-COUNT
   DISPLAY "DEBUG: CUSTOMER NAME = " WS-CUST-NAME
   ```
2. **Compile with debug mode**: `cobc -x -g -debug -ftraceall program.cob`
3. **Run with debug**: `COB_SET_DEBUG=Y ./program`
4. **Check file statuses** if data seems wrong
5. **Inspect data files** with hex viewer if packed decimal or EBCDIC data looks wrong:
   ```bash
   xxd data/output/report.dat | head
   ```

### Data Issues
- Verify record lengths match between file definition and actual file
- Check for truncation (field too small for the data)
- Verify COMP and COMP-3 fields are being used correctly
- Use DISPLAY to print suspect fields with their full length

## Working with Existing COBOL

Most COBOL work is maintaining existing programs, not writing new ones.

### Reading Legacy Code
1. Start with the PROCEDURE DIVISION main control paragraph
2. Follow the PERFORM calls to understand the flow
3. Look at the DATA DIVISION to understand the record layouts
4. Find the copybooks to understand shared structures
5. Check the FILE-CONTROL for file assignments

### Making Changes
1. Understand the existing flow before changing anything
2. Make the smallest change possible
3. Test with the same data the production system uses
4. Verify output matches expected results exactly (byte for byte for fixed-width files)
5. Keep backup copies of working code
