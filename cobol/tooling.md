# COBOL Tooling

Recommended tools for working with COBOL.

## Compilers

### GnuCOBOL (OpenCOBOL)
Free, open-source COBOL compiler. Compiles COBOL to C, then to native code via GCC.

```bash
# Compile and link
cobc -x program.cob -o program

# Compile only (create object file)
cobc -c program.cob

# Compile as module (for calling from other programs)
cobc -m module.cob

# Compile with debugging
cobc -x -g -debug program.cob -o program

# Compile with specific COBOL dialect
cobc -x -std=ibm program.cob      # IBM mainframe compatibility
cobc -x -std=mf program.cob       # Micro Focus compatibility
cobc -x -std=cobol2014 program.cob # COBOL 2014 standard
```

Common flags:
- `-x` - Build executable
- `-m` - Build dynamic module
- `-g` - Include debug symbols
- `-debug` - Enable runtime checks
- `-Wall` - Enable all warnings
- `-free` - Free-format source (not fixed column layout)
- `-fixed` - Fixed-format source (traditional)

### IBM Enterprise COBOL
The industry standard for z/OS mainframes. Not freely available.

### Micro Focus Visual COBOL
Commercial COBOL compiler and IDE for Windows, Linux, and cloud.

## Editors and IDE Support

### Vim / Neovim
Good lightweight setup for COBOL development.

- Built-in COBOL syntax highlighting (ships with Vim's runtime files)
- **vim-cobol** plugin - Improved syntax highlighting and indentation
- **coc.nvim** or **nvim-lspconfig** with a COBOL language server for completion

Configuration for fixed-format COBOL in `.vimrc`:
```vim
autocmd FileType cobol setlocal colorcolumn=7,8,12,73
autocmd FileType cobol setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType cobol setlocal textwidth=72
```

### IBM Developer for z/OS (IDz)
Eclipse-based IDE for mainframe development. Full COBOL support with remote compile and debug.

### Micro Focus Enterprise Developer
Full IDE for COBOL development with mainframe emulation.

## Debugging

### GnuCOBOL Debug Mode
GnuCOBOL's built-in runtime debugging.

```bash
# Compile with debug flags
cobc -x -g -debug -ftraceall program.cob -o program

# Run with debugging
COB_SET_DEBUG=Y ./program
```

### GDB with GnuCOBOL
Since GnuCOBOL compiles through C, GDB works.

```bash
cobc -x -g program.cob -o program
gdb ./program
```

Note: You will see the generated C code in GDB, not the COBOL source directly. The `-debug` flag with GnuCOBOL provides better source mapping.

### DISPLAY Statements
The COBOL equivalent of printf debugging. Simple and effective.

```cobol
DISPLAY "DEBUG: WS-COUNTER = " WS-COUNTER
DISPLAY "DEBUG: ENTERING PARAGRAPH PROCESS-RECORD"
```

## Testing

### COBOL-Check
Unit testing framework for COBOL. Write tests in COBOL-like syntax alongside your code.

```cobol
      TESTSUITE "User Validation Tests"

      TESTCASE "Valid age returns true"
          MOVE 25 TO WS-AGE
          PERFORM VALIDATE-AGE
          EXPECT WS-VALID TO BE "Y"

      TESTCASE "Negative age returns false"
          MOVE -1 TO WS-AGE
          PERFORM VALIDATE-AGE
          EXPECT WS-VALID TO BE "N"
```

### zUnit (IBM)
Unit testing for COBOL on z/OS. Integrated with IDz.

### Application-Level Testing
In practice, COBOL programs are often tested through:
- Job Control Language (JCL) test jobs
- Batch job output comparison
- Integration tests that verify file and database output
- Manual test scripts with known input/output pairs

## Data and File Tools

### File Handling Utilities
COBOL works heavily with fixed-width files and sequential data.

```bash
# View fixed-width file with column alignment
column -t datafile.dat

# Count records
wc -l datafile.dat

# View specific columns (fixed-width)
cut -c1-10,20-30 datafile.dat
```

### Hex Viewers
For examining EBCDIC or packed decimal data:

```bash
xxd datafile.dat | head
hexdump -C datafile.dat | head
```

### iconv
Convert between EBCDIC and ASCII character encodings.

```bash
# EBCDIC to ASCII
iconv -f EBCDIC-US -t ASCII datafile.dat > output.txt

# ASCII to EBCDIC
iconv -f ASCII -t EBCDIC-US input.txt > output.dat
```

## Copybook Management

Copybooks are COBOL's equivalent of header files.

```cobol
      * In your program
       COPY "customer-record.cpy".
```

Keep copybooks organized:
```
project/
├── src/
│   ├── main-program.cob
│   └── sub-program.cob
├── copybooks/
│   ├── customer-record.cpy
│   ├── ws-common-fields.cpy
│   └── file-status-codes.cpy
└── data/
    ├── input/
    └── output/
```

Set copybook path in GnuCOBOL:
```bash
cobc -x -I ./copybooks program.cob -o program
```

## Build Automation

### Make with GnuCOBOL
```makefile
COBC = cobc
COBFLAGS = -x -Wall -std=ibm
COPYPATH = -I ./copybooks

PROGRAMS = main-program report-generator

all: $(PROGRAMS)

main-program: src/main-program.cob
	$(COBC) $(COBFLAGS) $(COPYPATH) $< -o $@

clean:
	rm -f $(PROGRAMS)

.PHONY: all clean
```

### JCL (Job Control Language)
On mainframes, JCL manages compilation and execution:
```jcl
//COMPILE  EXEC IGYWCL
//COBOL.SYSIN DD DSN=USER.SOURCE(MYPROG),DISP=SHR
//LKED.SYSLMOD DD DSN=USER.LOAD(MYPROG),DISP=SHR
```

## Mainframe Emulation

### Hercules
Open-source mainframe emulator. Runs z/OS (with valid license) or free z/OS alternatives.

### z/OS Container Extensions (zCX)
Run Linux containers on z/OS for modern tooling alongside COBOL.

## Recommended Stack

| Purpose | Tool |
|---------|------|
| Compiler | GnuCOBOL |
| Editor | Vim + vim-cobol |
| Debugging | GnuCOBOL debug mode + DISPLAY |
| Testing | COBOL-Check |
| Build automation | Make |
| Data inspection | xxd, hexdump |
| Encoding conversion | iconv |
| Mainframe emulation | Hercules (if needed) |
