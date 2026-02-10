# Assembly Workflow

How a generic development workflow looks when working with assembly language.

## Project Setup

### 1. Create Project Structure

```
myproject/
├── src/
│   ├── main.asm
│   └── io.asm
├── include/
│   └── io.inc       # Macro definitions
├── build/            # Build output (gitignored)
├── Makefile
└── .gitignore
```

### 2. Choose Assembler and Syntax

| Assembler | Syntax | Best For |
|-----------|--------|----------|
| NASM | Intel | Standalone assembly, learning |
| GAS | AT&T (default) | Integration with C/GCC |
| FASM | Intel | Self-contained builds |

### 3. Set Up Build

Makefile for NASM (Linux x86-64):
```makefile
ASM = nasm
ASMFLAGS = -f elf64 -g -F dwarf
LD = ld

SRCS = $(wildcard src/*.asm)
OBJS = $(patsubst src/%.asm,build/%.o,$(SRCS))
TARGET = build/program

all: $(TARGET)

$(TARGET): $(OBJS)
	$(LD) -o $@ $^

build/%.o: src/%.asm | build
	$(ASM) $(ASMFLAGS) $< -o $@

build:
	mkdir -p build

clean:
	rm -rf build

.PHONY: all clean
```

## Development Cycle

### Write Code

1. Write the assembly source (`.asm`)
2. Define data in the `.data` or `.bss` section
3. Write logic in the `.text` section
4. Use comments extensively - assembly needs more documentation than high-level code

### Assemble and Link

```bash
# NASM
nasm -f elf64 -g -F dwarf src/main.asm -o build/main.o
ld build/main.o -o build/program

# Or with Make
make
```

### Run and Test

```bash
# Run
./build/program

# Check exit code
echo $?

# Trace system calls
strace ./build/program
```

### Debug

```bash
gdb ./build/program

# In GDB
(gdb) layout asm
(gdb) layout regs
(gdb) break _start
(gdb) run
(gdb) si              # step one instruction
(gdb) info registers
(gdb) x/10x $rsp     # examine stack
```

### Typical Cycle
```
write code -> assemble -> link -> run -> debug with gdb -> fix -> repeat
```

## Best Practices

### Code Organization
- One logical module per file (I/O routines, string operations, math, etc.)
- Use labels with meaningful names: `calculate_sum` not `L1`
- Prefix local labels with a dot: `.loop`, `.done` (NASM scopes them to the parent label)
- Group related data together in the data section
- Put the entry point (`_start` or `main`) in a dedicated file

### Commenting
Assembly needs more comments than any other language. Comment on intent, not mechanics:

```asm
; Bad: move 1 into eax
mov eax, 1

; Good: syscall number for sys_write
mov eax, 1

; Good: loop counter - process 10 elements
mov ecx, 10
```

Comment blocks before each function/routine explaining:
- Purpose
- Input (which registers hold arguments)
- Output (which registers hold results)
- Registers clobbered

```asm
; print_string - Write a null-terminated string to stdout
; Input:  rsi = pointer to string
; Output: none
; Clobbers: rax, rdi, rdx, rcx
print_string:
    ...
```

### Register Usage
- Follow the System V AMD64 ABI calling convention when interfacing with C:
  - Arguments: rdi, rsi, rdx, rcx, r8, r9
  - Return value: rax
  - Callee-saved: rbx, rbp, r12-r15
  - Caller-saved: rax, rcx, rdx, rsi, rdi, r8-r11
- Preserve callee-saved registers (push/pop) in functions
- Use `xor reg, reg` instead of `mov reg, 0` (shorter, faster)

### Stack Management
- Always align the stack to 16 bytes before `call` instructions
- Use `push`/`pop` in matching pairs
- Clean up the stack before returning
- Use `rbp` as frame pointer for easier debugging (optional but helpful)

```asm
my_function:
    push rbp
    mov rbp, rsp
    sub rsp, 16          ; allocate local space (16-byte aligned)

    ; function body...

    mov rsp, rbp
    pop rbp
    ret
```

### Interfacing with C
When calling C functions or being called from C:

```asm
; Calling printf from assembly
extern printf

section .data
    fmt: db "Value: %d", 10, 0

section .text
global main
main:
    push rbp
    mov rbp, rsp

    lea rdi, [fmt]       ; first arg: format string
    mov esi, 42          ; second arg: value
    xor eax, eax         ; zero FP args in xal for varargs
    call printf

    xor eax, eax         ; return 0
    pop rbp
    ret
```

Compile with: `nasm -f elf64 program.asm && gcc program.o -o program -no-pie`

## What to Avoid

### Common Mistakes
- **Forgetting to preserve callee-saved registers** - Will corrupt the caller's data
- **Stack misalignment** - Causes segfaults when calling C functions (stack must be 16-byte aligned at `call`)
- **Off-by-one in loops** - Double-check loop counters and conditions
- **Forgetting the null terminator** - C strings and syscalls expect null-terminated strings
- **Wrong syscall numbers** - x86 and x86-64 have different syscall numbers; Linux and macOS have different numbers
- **Mixing 32-bit and 64-bit operations** - Writing to `eax` zeroes the upper 32 bits of `rax`; writing to `ax` does not
- **Not checking syscall return values** - Syscalls return negative values on error (in `rax`)

### Design Anti-Patterns
- **No comments** - Assembly without comments is unreadable, even to the author after a week
- **Unnamed labels** - Using `L1`, `L2` instead of descriptive names
- **Monolithic files** - Split large programs into modules
- **Hardcoded magic numbers** - Use `%define` (NASM) or `.equ` (GAS) for constants
- **Ignoring the ABI** - Even for personal projects, following the calling convention makes debugging easier and allows C interop

### Debugging Pitfalls
- **Not compiling with debug info** - Always use `-g -F dwarf` during development
- **Debugging optimized code** - Behavior may differ from source; debug without optimization first
- **Assuming register values persist across function calls** - Only callee-saved registers are guaranteed

## Debugging Workflow

1. **Assemble with debug symbols**: `nasm -f elf64 -g -F dwarf ...`
2. **Run in GDB** with `layout asm` and `layout regs`
3. **Set breakpoint** at the suspect label: `break my_function`
4. **Single-step** with `si` (step instruction) and watch registers
5. **Examine memory**: `x/10x $rsp` for stack, `x/s address` for strings
6. **Use strace** if the issue is in syscall arguments
7. **Compare with working reference** - Write the same logic in C, compile with `gcc -S -masm=intel`, and compare the generated assembly

## Testing Assembly

Assembly doesn't have standard test frameworks. Common approaches:

### Exit Code Testing
```bash
./program
if [ $? -eq 0 ]; then echo "PASS"; else echo "FAIL"; fi
```

### Output Comparison
```bash
./program > output.txt
diff expected.txt output.txt
```

### Shell Script Test Runner
```bash
#!/bin/bash
PASS=0
FAIL=0

run_test() {
    local name="$1"
    local expected="$2"
    local actual
    actual=$(./build/program "$3" 2>&1)
    if [ "$actual" = "$expected" ]; then
        echo "PASS: $name"
        ((PASS++))
    else
        echo "FAIL: $name (expected '$expected', got '$actual')"
        ((FAIL++))
    fi
}

run_test "basic output" "Hello, World!" ""
run_test "with argument" "Hello, Alice!" "Alice"

echo "Results: $PASS passed, $FAIL failed"
```

### Test via C Wrapper
Write tests in C that call your assembly functions:

```c
// test_math.c
#include <assert.h>
extern int add(int a, int b);  // Defined in assembly

int main(void) {
    assert(add(2, 3) == 5);
    assert(add(-1, 1) == 0);
    return 0;
}
```
