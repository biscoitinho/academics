# Assembly Language Tutorial and Reference

Comprehensive guide to x86-64 assembly programming with tutorial, cheatsheet, and reference tables.

---

## Table of Contents

1. [Overview](#overview)
2. [Getting Started](#getting-started)
3. [Registers](#registers)
4. [Basic Instructions](#basic-instructions)
5. [Memory Addressing](#memory-addressing)
6. [Control Flow](#control-flow)
7. [Functions and Stack](#functions-and-stack)
8. [System Calls](#system-calls)
9. [Complete Programs](#complete-programs)
10. [Instruction Reference](#instruction-reference)
11. [Cheatsheet](#cheatsheet)

---

## Overview

### What is Assembly Language?

**Definition**: Low-level programming language with one-to-one correspondence to machine code.

**Characteristics**:
- Direct hardware control
- Maximum performance
- Minimal abstraction
- Architecture-specific

**Common Architectures**:
```
x86: Intel/AMD 32-bit (legacy)
x86-64: Intel/AMD 64-bit (modern, most common)
ARM: Mobile devices, Apple Silicon
RISC-V: Open-source, emerging
Z/Architecture: IBM mainframes
MIPS: Embedded systems, education
```

**This Tutorial Focuses On**: x86-64 (AMD64/Intel 64) using AT&T syntax with GAS (GNU Assembler)

### Why Learn Assembly?

**Pros**:
- Understand how computers work
- Ultimate performance optimization
- Reverse engineering
- System programming
- Security research
- Embedded systems

**Cons**:
- Time-consuming
- Platform-specific
- Error-prone
- Hard to maintain
- No high-level abstractions

### Syntax Flavors

**Intel Syntax**:
```nasm
mov eax, 1          ; Destination first
add eax, ebx        ; eax = eax + ebx
```

**AT&T Syntax** (used in this tutorial):
```gas
movl $1, %eax       # Source first
addl %ebx, %eax     # eax = eax + ebx
```

**Key Differences**:
| Feature | Intel | AT&T |
|---------|-------|------|
| **Order** | dest, src | src, dest |
| **Constants** | 1 | $1 |
| **Registers** | eax | %eax |
| **Size Suffix** | None | l (long), w (word), b (byte) |
| **Memory** | [eax] | (%eax) |

---

## Getting Started

### Tools Needed

**Assembler**:
```bash
# GNU Assembler (GAS) - part of binutils
# Usually pre-installed on Linux

# Check version
as --version

# macOS (Xcode Command Line Tools)
xcode-select --install
```

**Linker**:
```bash
# ld - GNU linker
# Also part of binutils

# Check version
ld --version
```

**Debugger**:
```bash
# GDB - GNU Debugger
sudo apt-get install gdb  # Ubuntu/Debian
```

**Disassembler** (optional):
```bash
# objdump - display object file information
objdump -d program
```

### First Program - Hello World

**hello.s** (AT&T syntax):
```gas
.section .data
msg:
    .ascii "Hello, World!\n"
    msg_len = . - msg

.section .text
.globl _start

_start:
    # write(1, msg, msg_len)
    movq $1, %rax          # syscall: sys_write
    movq $1, %rdi          # fd: stdout
    movq $msg, %rsi        # buf: msg
    movq $msg_len, %rdx    # count: msg_len
    syscall

    # exit(0)
    movq $60, %rax         # syscall: sys_exit
    movq $0, %rdi          # status: 0
    syscall
```

**Compile and Run**:
```bash
# Assemble
as -o hello.o hello.s

# Link
ld -o hello hello.o

# Run
./hello
# Output: Hello, World!
```

**What's Happening**:
1. `.section .data` - Define data section (initialized data)
2. `msg:` - Label for string
3. `.ascii` - Define string (no null terminator)
4. `msg_len = . - msg` - Calculate string length
5. `.section .text` - Define code section
6. `.globl _start` - Make _start visible to linker
7. `_start:` - Entry point
8. `syscall` - Invoke kernel system call

---

## Registers

### General Purpose Registers (64-bit)

**Full Register Set**:
```
┌─────────────────────────────────────────────┐
│                    RAX (64-bit)              │
│                    ┌────────────────────────┤
│                    │      EAX (32-bit)      │
│                    │      ┌─────────────────┤
│                    │      │  AX (16-bit)    │
│                    │      │  ┌────┬─────────┤
│                    │      │  │ AH │   AL    │
└────────────────────┴──────┴──┴────┴─────────┘
```

**Register Table**:
| 64-bit | 32-bit | 16-bit | 8-bit | Purpose |
|--------|--------|--------|-------|---------|
| RAX | EAX | AX | AL/AH | Accumulator (return value) |
| RBX | EBX | BX | BL/BH | Base (general purpose) |
| RCX | ECX | CX | CL/CH | Counter (loop counter) |
| RDX | EDX | DX | DL/DH | Data (I/O, multiplication) |
| RSI | ESI | SI | SIL | Source index (string ops) |
| RDI | EDI | DI | DIL | Destination index (string ops) |
| RBP | EBP | BP | BPL | Base pointer (stack frame) |
| RSP | ESP | SP | SPL | Stack pointer |
| R8-R15 | R8D-R15D | R8W-R15W | R8B-R15B | Additional (64-bit only) |

**Special Registers**:
```
RIP: Instruction pointer (program counter)
RFLAGS: Status flags (ZF, CF, SF, OF, etc.)
```

### Calling Convention (System V AMD64 ABI)

**Function Arguments** (Linux/macOS):
```
1st argument:  RDI
2nd argument:  RSI
3rd argument:  RDX
4th argument:  RCX
5th argument:  R8
6th argument:  R9
7+ arguments:  Stack

Return value:  RAX
```

**Callee-saved** (must preserve):
```
RBX, RBP, R12, R13, R14, R15
```

**Caller-saved** (can be clobbered):
```
RAX, RCX, RDX, RSI, RDI, R8, R9, R10, R11
```

---

## Basic Instructions

### Data Movement

**MOV** - Move data:
```gas
movq $42, %rax         # rax = 42 (immediate to register)
movq %rax, %rbx        # rbx = rax (register to register)
movq $0, (%rdi)        # *rdi = 0 (immediate to memory)
movq (%rsi), %rax      # rax = *rsi (memory to register)
movq %rax, (%rdi)      # *rdi = rax (register to memory)

# Size suffixes
movb $1, %al           # Move byte (8-bit)
movw $1, %ax           # Move word (16-bit)
movl $1, %eax          # Move long (32-bit)
movq $1, %rax          # Move quad (64-bit)
```

**LEA** - Load Effective Address:
```gas
leaq 8(%rsp), %rax     # rax = rsp + 8 (address calculation)
leaq (%rdi,%rsi,4), %rax  # rax = rdi + rsi*4
```

**PUSH/POP** - Stack operations:
```gas
pushq %rax             # rsp -= 8; *rsp = rax
popq %rax              # rax = *rsp; rsp += 8
```

### Arithmetic

**ADD/SUB** - Addition/Subtraction:
```gas
addq $10, %rax         # rax += 10
addq %rbx, %rax        # rax += rbx
subq $5, %rax          # rax -= 5
subq %rbx, %rax        # rax -= rbx
```

**INC/DEC** - Increment/Decrement:
```gas
incq %rax              # rax++
decq %rax              # rax--
```

**MUL/IMUL** - Unsigned/Signed multiplication:
```gas
# IMUL (signed)
imulq $10, %rax        # rax *= 10
imulq %rbx, %rax       # rax *= rbx
imulq %rbx             # rdx:rax = rax * rbx (128-bit result)

# MUL (unsigned)
mulq %rbx              # rdx:rax = rax * rbx
```

**DIV/IDIV** - Unsigned/Signed division:
```gas
# Setup: dividend in rdx:rax, divisor in register
movq $100, %rax        # Dividend low
xorq %rdx, %rdx        # Dividend high (zero for positive)
movq $10, %rbx         # Divisor
idivq %rbx             # rax = quotient, rdx = remainder
```

**NEG** - Negate:
```gas
negq %rax              # rax = -rax
```

### Logical and Bitwise

**AND/OR/XOR**:
```gas
andq $0xFF, %rax       # rax &= 0xFF
orq $0x80, %rax        # rax |= 0x80
xorq %rax, %rax        # rax = 0 (common idiom)
xorq %rbx, %rax        # rax ^= rbx
```

**NOT**:
```gas
notq %rax              # rax = ~rax
```

**Shifts**:
```gas
shlq $1, %rax          # rax <<= 1 (shift left)
shrq $1, %rax          # rax >>= 1 (shift right, unsigned)
sarq $1, %rax          # rax >>= 1 (shift right, signed)
rolq $1, %rax          # Rotate left
rorq $1, %rax          # Rotate right
```

### Comparison

**CMP** - Compare:
```gas
cmpq $0, %rax          # Compare rax with 0 (sets flags)
cmpq %rbx, %rax        # Compare rax with rbx
```

**TEST** - Bitwise AND (sets flags):
```gas
testq %rax, %rax       # Test if rax is zero
testq $1, %rax         # Test if bit 0 is set
```

---

## Memory Addressing

### Addressing Modes

**Immediate**:
```gas
movq $42, %rax         # rax = 42
```

**Register**:
```gas
movq %rbx, %rax        # rax = rbx
```

**Direct**:
```gas
movq variable, %rax    # rax = variable
```

**Indirect**:
```gas
movq (%rbx), %rax      # rax = *rbx
```

**Base + Displacement**:
```gas
movq 8(%rbx), %rax     # rax = *(rbx + 8)
movq -16(%rbp), %rax   # rax = *(rbp - 16)
```

**Base + Index**:
```gas
movq (%rbx,%rcx), %rax    # rax = *(rbx + rcx)
```

**Base + Index * Scale + Displacement**:
```gas
movq 8(%rbx,%rcx,4), %rax   # rax = *(rbx + rcx*4 + 8)
#    ↑  ↑    ↑    ↑
#    disp base index scale (1,2,4,8)
```

**Examples**:
```gas
# Array access: array[index]
leaq array, %rbx           # rbx = &array
movq $5, %rcx              # rcx = index (5)
movq (%rbx,%rcx,8), %rax   # rax = array[5] (8-byte elements)

# Struct member: struct.member
# struct { int a; long b; }
leaq mystruct, %rbx
movl (%rbx), %eax          # eax = mystruct.a (offset 0)
movq 8(%rbx), %rax         # rax = mystruct.b (offset 8)
```

---

## Control Flow

### Unconditional Jump

**JMP** - Jump:
```gas
jmp label              # Jump to label
```

### Conditional Jumps

**Based on Comparison** (after CMP):
```gas
cmpq $10, %rax         # Compare rax with 10
je equal               # Jump if equal (rax == 10)
jne not_equal          # Jump if not equal (rax != 10)
jg greater             # Jump if greater (rax > 10, signed)
jge greater_equal      # Jump if >= (signed)
jl less                # Jump if less (rax < 10, signed)
jle less_equal         # Jump if <= (signed)
ja above               # Jump if above (unsigned >)
jb below               # Jump if below (unsigned <)
```

**Based on Flags**:
```gas
jz zero                # Jump if zero flag set
jnz not_zero           # Jump if zero flag clear
jc carry               # Jump if carry flag set
jnc no_carry           # Jump if carry flag clear
jo overflow            # Jump if overflow flag set
js sign                # Jump if sign flag set
```

**Common Jump Instructions**:
| Instruction | Condition | Flags | Signed/Unsigned |
|-------------|-----------|-------|-----------------|
| JE/JZ | Equal/Zero | ZF=1 | Both |
| JNE/JNZ | Not Equal/Not Zero | ZF=0 | Both |
| JG/JNLE | Greater | ZF=0 and SF=OF | Signed |
| JGE/JNL | Greater or Equal | SF=OF | Signed |
| JL/JNGE | Less | SF≠OF | Signed |
| JLE/JNG | Less or Equal | ZF=1 or SF≠OF | Signed |
| JA/JNBE | Above | CF=0 and ZF=0 | Unsigned |
| JAE/JNB | Above or Equal | CF=0 | Unsigned |
| JB/JNAE | Below | CF=1 | Unsigned |
| JBE/JNA | Below or Equal | CF=1 or ZF=1 | Unsigned |

### Loops

**Example: Count from 1 to 10**:
```gas
movq $1, %rcx          # rcx = 1 (counter)
loop_start:
    # Loop body
    movq %rcx, %rax
    # ... do something ...

    incq %rcx          # rcx++
    cmpq $10, %rcx     # Compare with limit
    jle loop_start     # Jump if rcx <= 10
```

**Using LOOP instruction** (decrements RCX):
```gas
movq $10, %rcx         # Loop counter
loop_start:
    # Loop body
    loop loop_start    # Decrement rcx, jump if rcx != 0
```

---

## Functions and Stack

### Stack Frame

**Layout**:
```
High addresses
┌─────────────────┐
│  Arguments 7+   │  (if more than 6 args)
├─────────────────┤
│  Return address │  ← RSP after call
├─────────────────┤
│  Saved RBP      │  ← RBP points here (after push rbp)
├─────────────────┤
│  Local vars     │
├─────────────────┤
│  Saved regs     │
├─────────────────┤
│  ...            │  ← RSP points here
└─────────────────┘
Low addresses
```

### Function Prologue and Epilogue

**Prologue** (setup stack frame):
```gas
pushq %rbp             # Save old frame pointer
movq %rsp, %rbp        # New frame pointer = current stack
subq $32, %rsp         # Allocate 32 bytes for locals
```

**Epilogue** (restore stack):
```gas
movq %rbp, %rsp        # Restore stack pointer
popq %rbp              # Restore frame pointer
ret                    # Return (pop return address, jump)
```

### Calling a Function

**C Declaration**:
```c
long add(long a, long b) {
    return a + b;
}
```

**Assembly Implementation**:
```gas
.globl add
add:
    # Arguments: rdi = a, rsi = b
    # Return: rax = result

    movq %rdi, %rax    # rax = a
    addq %rsi, %rax    # rax += b
    ret                # Return rax
```

**Calling the Function**:
```gas
movq $10, %rdi         # 1st argument: a = 10
movq $20, %rsi         # 2nd argument: b = 20
call add               # result in rax (30)
```

### Example: Function with Local Variables

**C Code**:
```c
long calculate(long x, long y) {
    long temp = x * 2;
    long result = temp + y;
    return result;
}
```

**Assembly**:
```gas
.globl calculate
calculate:
    pushq %rbp         # Prologue
    movq %rsp, %rbp
    subq $16, %rsp     # Allocate 16 bytes (temp, result)

    # temp = x * 2
    movq %rdi, %rax    # rax = x
    imulq $2, %rax     # rax *= 2
    movq %rax, -8(%rbp)  # temp = rax (local var at rbp-8)

    # result = temp + y
    movq -8(%rbp), %rax  # rax = temp
    addq %rsi, %rax      # rax += y
    movq %rax, -16(%rbp) # result = rax (local var at rbp-16)

    # Return result
    movq -16(%rbp), %rax # rax = result

    movq %rbp, %rsp    # Epilogue
    popq %rbp
    ret
```

---

## System Calls

### Linux System Call Convention

**Registers**:
```
Syscall number: RAX
Arguments:      RDI, RSI, RDX, R10, R8, R9
Return value:   RAX
Instruction:    syscall
```

**Common System Calls** (x86-64 Linux):
| Number | Name | Arguments |
|--------|------|-----------|
| 0 | read | (fd, buf, count) |
| 1 | write | (fd, buf, count) |
| 2 | open | (filename, flags, mode) |
| 3 | close | (fd) |
| 60 | exit | (status) |
| 231 | exit_group | (status) |

### Examples

**Read from stdin**:
```gas
.section .bss
buffer:
    .skip 100          # Reserve 100 bytes

.section .text
.globl _start
_start:
    # read(0, buffer, 100)
    movq $0, %rax      # syscall: sys_read
    movq $0, %rdi      # fd: stdin
    movq $buffer, %rsi # buf: buffer
    movq $100, %rdx    # count: 100
    syscall

    # rax now contains number of bytes read
```

**Write to file**:
```gas
.section .data
filename:
    .ascii "/tmp/test.txt"
    filename_len = . - filename
content:
    .ascii "Hello, file!\n"
    content_len = . - content

.section .text
.globl _start
_start:
    # fd = open("/tmp/test.txt", O_WRONLY|O_CREAT, 0644)
    movq $2, %rax      # syscall: sys_open
    movq $filename, %rdi  # filename
    movq $0x241, %rsi  # flags: O_WRONLY|O_CREAT|O_TRUNC
    movq $0644, %rdx   # mode: 0644
    syscall
    movq %rax, %r12    # Save fd

    # write(fd, content, content_len)
    movq $1, %rax      # syscall: sys_write
    movq %r12, %rdi    # fd
    movq $content, %rsi  # buf
    movq $content_len, %rdx  # count
    syscall

    # close(fd)
    movq $3, %rax      # syscall: sys_close
    movq %r12, %rdi    # fd
    syscall

    # exit(0)
    movq $60, %rax
    movq $0, %rdi
    syscall
```

---

## Complete Programs

### Program 1: Sum of Numbers

**C Equivalent**:
```c
long sum(long n) {
    long total = 0;
    for (long i = 1; i <= n; i++) {
        total += i;
    }
    return total;
}
```

**Assembly**:
```gas
.globl sum
sum:
    # Argument: rdi = n
    # Return: rax = sum

    movq $0, %rax      # total = 0
    movq $1, %rcx      # i = 1

loop_start:
    cmpq %rdi, %rcx    # Compare i with n
    jg loop_end        # if i > n, exit loop

    addq %rcx, %rax    # total += i
    incq %rcx          # i++
    jmp loop_start     # Continue loop

loop_end:
    ret                # Return total
```

### Program 2: String Length

**C Equivalent**:
```c
size_t strlen(const char *str) {
    size_t len = 0;
    while (str[len] != '\0') {
        len++;
    }
    return len;
}
```

**Assembly**:
```gas
.globl strlen
strlen:
    # Argument: rdi = str
    # Return: rax = length

    movq $0, %rax      # len = 0

loop:
    cmpb $0, (%rdi,%rax,1)  # Compare str[len] with '\0'
    je done            # if str[len] == '\0', done

    incq %rax          # len++
    jmp loop           # Continue

done:
    ret                # Return len
```

### Program 3: Factorial

**C Equivalent**:
```c
long factorial(long n) {
    if (n <= 1)
        return 1;
    return n * factorial(n - 1);
}
```

**Assembly (Recursive)**:
```gas
.globl factorial
factorial:
    pushq %rbp
    movq %rsp, %rbp

    # Base case: n <= 1
    cmpq $1, %rdi
    jg recursive       # if n > 1, do recursion

    # Return 1
    movq $1, %rax
    jmp done

recursive:
    # Save n
    pushq %rdi

    # factorial(n - 1)
    decq %rdi          # n - 1
    call factorial     # rax = factorial(n - 1)

    # Restore n
    popq %rdi

    # n * factorial(n - 1)
    imulq %rdi, %rax   # rax = n * rax

done:
    movq %rbp, %rsp
    popq %rbp
    ret
```

---

## Instruction Reference

### Data Movement

| Instruction | Description | Example |
|-------------|-------------|---------|
| **MOV** | Move data | `movq %rax, %rbx` |
| **LEA** | Load effective address | `leaq 8(%rax), %rbx` |
| **PUSH** | Push onto stack | `pushq %rax` |
| **POP** | Pop from stack | `popq %rax` |
| **XCHG** | Exchange | `xchg %rax, %rbx` |

### Arithmetic

| Instruction | Description | Example |
|-------------|-------------|---------|
| **ADD** | Add | `addq %rbx, %rax` |
| **SUB** | Subtract | `subq %rbx, %rax` |
| **INC** | Increment | `incq %rax` |
| **DEC** | Decrement | `decq %rax` |
| **IMUL** | Signed multiply | `imulq %rbx, %rax` |
| **IDIV** | Signed divide | `idivq %rbx` |
| **NEG** | Negate | `negq %rax` |

### Logical

| Instruction | Description | Example |
|-------------|-------------|---------|
| **AND** | Bitwise AND | `andq %rbx, %rax` |
| **OR** | Bitwise OR | `orq %rbx, %rax` |
| **XOR** | Bitwise XOR | `xorq %rbx, %rax` |
| **NOT** | Bitwise NOT | `notq %rax` |
| **SHL/SAL** | Shift left | `shlq $1, %rax` |
| **SHR** | Shift right (unsigned) | `shrq $1, %rax` |
| **SAR** | Shift right (signed) | `sarq $1, %rax` |
| **ROL** | Rotate left | `rolq $1, %rax` |
| **ROR** | Rotate right | `rorq $1, %rax` |

### Control Flow

| Instruction | Description | Example |
|-------------|-------------|---------|
| **JMP** | Unconditional jump | `jmp label` |
| **JE/JZ** | Jump if equal/zero | `je label` |
| **JNE/JNZ** | Jump if not equal/zero | `jne label` |
| **JG/JNLE** | Jump if greater | `jg label` |
| **JL/JNGE** | Jump if less | `jl label` |
| **CALL** | Call function | `call func` |
| **RET** | Return from function | `ret` |
| **LOOP** | Loop (decrement RCX) | `loop label` |

### Comparison

| Instruction | Description | Example |
|-------------|-------------|---------|
| **CMP** | Compare | `cmpq %rbx, %rax` |
| **TEST** | Bitwise AND (sets flags) | `testq %rax, %rax` |

### String Operations

| Instruction | Description | Example |
|-------------|-------------|---------|
| **MOVS** | Move string | `movsb` (byte), `movsq` (quad) |
| **STOS** | Store string | `stosb`, `stosq` |
| **LODS** | Load string | `lodsb`, `lodsq` |
| **SCAS** | Scan string | `scasb`, `scasq` |
| **CMPS** | Compare strings | `cmpsb`, `cmpsq` |
| **REP** | Repeat (with RCX) | `rep movsb` |

---

## Cheatsheet

### Quick Reference Card

**Registers**:
```
General: RAX, RBX, RCX, RDX, RSI, RDI, RBP, RSP, R8-R15
Special: RIP (instruction pointer), RFLAGS

Function args (Linux): RDI, RSI, RDX, RCX, R8, R9
Return value: RAX
```

**Sizes**:
```
b = byte (8-bit)
w = word (16-bit)
l = long (32-bit)
q = quad (64-bit)
```

**Common Patterns**:
```gas
# Zero a register
xorq %rax, %rax

# Set register to -1
movq $-1, %rax

# Conditional move
cmpq $0, %rax
cmoveq %rbx, %rax      # rax = rbx if rax == 0

# Swap without temp
xorq %rbx, %rax
xorq %rax, %rbx
xorq %rbx, %rax
```

**Stack Operations**:
```gas
pushq %rax             # Push
popq %rax              # Pop
call func              # Push RIP, jump
ret                    # Pop RIP, jump
```

**Memory Access**:
```gas
(%rax)                 # *rax
8(%rax)                # *(rax + 8)
(%rax,%rbx,4)          # *(rax + rbx*4)
8(%rax,%rbx,4)         # *(rax + rbx*4 + 8)
```

**Flags** (RFLAGS):
```
ZF: Zero flag
CF: Carry flag
SF: Sign flag
OF: Overflow flag
PF: Parity flag
```

**System Call Numbers** (Linux x86-64):
```
0:  read
1:  write
2:  open
3:  close
60: exit
```

**Assembly Template**:
```gas
.section .data
# Initialized data

.section .bss
# Uninitialized data

.section .text
.globl _start

_start:
    # Code here

    # Exit
    movq $60, %rax
    movq $0, %rdi
    syscall
```

**GDB Debugging**:
```bash
# Compile with debug info
as -g -o program.o program.s
ld -o program program.o

# Debug
gdb program

# GDB commands
(gdb) break _start     # Set breakpoint
(gdb) run              # Run program
(gdb) stepi            # Step one instruction
(gdb) info registers   # Show registers
(gdb) x/10x $rsp       # Examine stack (10 hex values)
(gdb) disas            # Disassemble current function
```

---

## Key Takeaways

**When to Use Assembly**:
- Performance-critical code (after profiling!)
- System programming (OS kernels, drivers)
- Embedded systems (limited resources)
- Reverse engineering
- Security research
- Understanding low-level concepts

**When to Avoid Assembly**:
- General application development (use C, C++, Rust)
- Cross-platform software
- Rapid prototyping
- Large codebases
- Maintainability concerns

**Learning Path**:
1. Understand computer architecture
2. Learn one architecture (x86-64 recommended)
3. Practice with simple programs
4. Study compiled C code (gcc -S)
5. Read system code (Linux kernel)
6. Optimize hot paths in real programs

**Best Practices**:
- Comment extensively
- Use meaningful labels
- Follow calling conventions
- Preserve callee-saved registers
- Align data properly
- Use macros for repetitive code
- Test thoroughly

**Performance Tips**:
- Minimize memory access
- Use registers when possible
- Avoid pipeline stalls
- Leverage SIMD instructions (SSE, AVX)
- Profile before optimizing
- Consider cache effects

**Resources**:
- Intel/AMD manuals (reference)
- "Programming from the Ground Up" (book)
- "Computer Systems: A Programmer's Perspective" (book)
- godbolt.org (Compiler Explorer)
- Linux kernel source code
