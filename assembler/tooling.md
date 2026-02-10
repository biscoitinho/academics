# Assembly Tooling

Recommended tools for working with assembly language.

## Assemblers

### NASM (Netwide Assembler)
The most popular assembler for x86/x86-64 on Linux. Intel syntax.

```bash
# Assemble to object file
nasm -f elf64 program.asm -o program.o

# Link
ld program.o -o program

# Common output formats
# -f elf64   Linux 64-bit
# -f elf32   Linux 32-bit
# -f win64   Windows 64-bit
# -f macho64 macOS 64-bit
```

### GAS (GNU Assembler)
Part of GNU Binutils. Uses AT&T syntax by default. Comes with GCC.

```bash
# Assemble
as program.s -o program.o

# Or through GCC (allows mixing C and assembly)
gcc program.s -o program
gcc -c program.s -o program.o

# Use Intel syntax in GAS
.intel_syntax noprefix
```

**NASM vs GAS**: NASM uses Intel syntax (`mov eax, 1`), GAS uses AT&T syntax by default (`movl $1, %eax`). Intel syntax is generally considered more readable. NASM is preferred for standalone assembly; GAS is useful when integrating with C via GCC.

### FASM (Flat Assembler)
Self-hosting assembler. Fast, no external linker needed for simple programs.

```bash
fasm program.asm program
```

### MASM (Microsoft Macro Assembler)
Microsoft's assembler for Windows. Intel syntax.

### YASM
NASM-compatible assembler with some additional features. Drop-in replacement.

## Linkers

### ld (GNU Linker)
Standard linker on Linux.

```bash
# Link object file
ld program.o -o program

# Link with C library
ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc program.o -o program
```

### GCC as Linker
Using GCC to link handles C library and startup code automatically.

```bash
gcc program.o -o program -nostartfiles  # No C startup, just linking
gcc program.o -o program                # Full C runtime
```

## Debugging

### GDB
The primary debugger for assembly. Essential.

```bash
# Compile with debug info
nasm -f elf64 -g -F dwarf program.asm -o program.o
ld program.o -o program

# Start debugging
gdb ./program
```

Useful GDB commands for assembly:
```
layout asm          # Show assembly view
layout regs         # Show registers
info registers      # Print all registers
print $rax          # Print specific register
x/10x $rsp         # Examine memory at stack pointer
x/s 0x402000       # Examine memory as string
stepi (si)         # Step one instruction
nexti (ni)         # Step over call
break _start       # Breakpoint at label
disassemble main   # Show disassembly
```

### strace
Trace system calls made by a program. Invaluable for debugging assembly that uses syscalls.

```bash
strace ./program
strace -e trace=write ./program  # Filter specific syscalls
```

### ltrace
Trace library calls.

```bash
ltrace ./program
```

## Disassemblers and Reverse Engineering

### objdump
Display information about object files. Part of GNU Binutils.

```bash
# Disassemble with Intel syntax
objdump -d -M intel program

# Show all sections
objdump -h program

# Show symbol table
objdump -t program
```

### ndisasm (NASM Disassembler)
Flat disassembler included with NASM.

```bash
ndisasm -b 64 program
```

### radare2
Advanced reverse engineering framework with disassembler, debugger, and analysis.

```bash
r2 program
# Visual mode: V
# Analysis: aaa
# Disassemble function: pdf @ main
```

### Ghidra
NSA's open-source reverse engineering tool. GUI-based decompiler and disassembler.

## Binary Inspection

### readelf
Display information about ELF files.

```bash
# Show file header
readelf -h program

# Show section headers
readelf -S program

# Show symbol table
readelf -s program

# Show program headers
readelf -l program
```

### nm
List symbols from object files.

```bash
nm program
nm -n program  # Sort by address
```

### file
Identify file type and architecture.

```bash
file program
# program: ELF 64-bit LSB executable, x86-64, ...
```

### size
Display section sizes.

```bash
size program
```

## Hex Editors

### xxd
Simple hex dump utility (comes with vim).

```bash
# Hex dump
xxd program | head

# Convert hex back to binary
xxd -r hexfile.txt binary
```

### hexdump
Another hex viewing utility.

```bash
hexdump -C program | head
```

## Emulators and Simulators

### QEMU
Full system emulator. Useful for testing assembly targeting different architectures.

```bash
# Run ARM binary on x86
qemu-arm ./arm_program

# Run with GDB server for remote debugging
qemu-arm -g 1234 ./arm_program
```

### DOSBox
For running 16-bit x86 DOS assembly programs.

### MARS / SPIM
MIPS architecture simulators, common in academic settings.

### Ripes
Visual RISC-V simulator with pipeline visualization.

## Documentation References

### System Call References
- Linux syscall table: `/usr/include/asm/unistd_64.h` or online references
- `man 2 syscall_name` for individual syscall documentation

### Instruction Set References
- Intel Software Developer Manual (SDM)
- AMD Programmer's Manual
- Online: felixcloutier.com/x86 (quick x86 instruction reference)

## Recommended Stack

| Purpose | Tool |
|---------|------|
| Assembler | NASM (standalone) or GAS (with C) |
| Linker | ld or GCC |
| Debugging | GDB (with `layout asm` + `layout regs`) |
| Syscall tracing | strace |
| Disassembly | objdump -d -M intel |
| Binary inspection | readelf + nm |
| Hex viewing | xxd |
| Reverse engineering | radare2 or Ghidra |
| Emulation | QEMU (cross-architecture) |
