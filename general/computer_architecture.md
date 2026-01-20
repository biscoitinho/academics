# Computer Architecture

## Basic Components

```
┌─────────┐
│   CPU   │ ← Processes instructions
├─────────┤
│   RAM   │ ← Temporary storage (volatile)
├─────────┤
│ Storage │ ← Permanent storage (disk/SSD)
├─────────┤
│   I/O   │ ← Input/Output devices
└─────────┘
```

## CPU (Central Processing Unit)

### Components

```
┌──────────────────────────┐
│   Control Unit (CU)      │ ← Coordinates operations
├──────────────────────────┤
│   ALU (Arithmetic Logic) │ ← Performs calculations
├──────────────────────────┤
│   Registers              │ ← Tiny, ultra-fast storage
├──────────────────────────┤
│   Cache (L1, L2, L3)    │ ← Fast memory close to CPU
└──────────────────────────┘
```

### CPU Cycle

```
1. Fetch    - Get instruction from memory
2. Decode   - Understand what to do
3. Execute  - Perform operation
4. Store    - Save result
```

### CPU Specs

```
Clock Speed: 3.5 GHz = 3,500,000,000 cycles/second
Cores: 8 cores = 8 independent processors
Threads: 16 threads = 2 threads per core (hyper-threading)
Cache: L1 (fastest, smallest) → L2 → L3 (slower, larger)
```

```python
# Check CPU info
import os
import psutil

print(f"CPU cores: {os.cpu_count()}")
print(f"CPU percent: {psutil.cpu_percent()}%")
print(f"CPU freq: {psutil.cpu_freq().current} MHz")
```

```ruby
# Check CPU info (Ruby)
require 'etc'

puts "CPU cores: #{Etc.nprocessors}"
```

## Memory Hierarchy

```
Speed & Cost (Fastest → Slowest)

Registers       1 cycle      ~1 KB         (in CPU)
L1 Cache        ~4 cycles    32-64 KB      (per core)
L2 Cache        ~10 cycles   256-512 KB    (per core)
L3 Cache        ~40 cycles   8-32 MB       (shared)
RAM             ~100 cycles  8-64 GB
SSD             ~25,000 cycles  256 GB-2 TB
HDD             ~2,000,000 cycles  1-4 TB
Network         ~10,000,000+ cycles
```

## RAM (Random Access Memory)

- Volatile (loses data when power off)
- Stores running programs and data
- Fast access (compared to disk)

```python
# Check RAM
import psutil

mem = psutil.virtual_memory()
print(f"Total RAM: {mem.total / (1024**3):.2f} GB")
print(f"Available: {mem.available / (1024**3):.2f} GB")
print(f"Used: {mem.percent}%")
```

### Virtual Memory

- Uses disk space as extended RAM
- When RAM full, OS moves inactive data to disk (swap)
- Slower but prevents out-of-memory crashes

```
RAM full → OS swaps to disk → "Paging" or "Swapping"
```

## Cache

### Cache Levels

```python
# Simplified example of cache behavior

# L1 Cache (fastest, smallest)
l1_cache = {}  # 64 KB

# L2 Cache
l2_cache = {}  # 512 KB

# L3 Cache
l3_cache = {}  # 8 MB

def read_memory(address):
    # Try L1
    if address in l1_cache:
        return l1_cache[address]  # 1 nanosecond

    # Try L2
    if address in l2_cache:
        value = l2_cache[address]  # 3 nanoseconds
        l1_cache[address] = value  # Promote to L1
        return value

    # Try L3
    if address in l3_cache:
        value = l3_cache[address]  # 10 nanoseconds
        l2_cache[address] = value  # Promote to L2
        l1_cache[address] = value  # Promote to L1
        return value

    # Fetch from RAM (cache miss)
    value = ram[address]  # 100 nanoseconds
    # Populate caches
    l3_cache[address] = value
    l2_cache[address] = value
    l1_cache[address] = value
    return value
```

### Cache Line

```
CPU reads memory in chunks (cache lines)
Typical cache line: 64 bytes

If you read 1 byte, CPU loads 64 bytes into cache
Next 63 bytes are "free" (spatial locality)
```

### Cache Optimization

```python
# ❌ Bad: Poor cache locality
arr = [[0] * 1000 for _ in range(1000)]

total = 0
for col in range(1000):
    for row in range(1000):
        total += arr[row][col]  # Jumps around memory

# ✅ Good: Better cache locality
for row in range(1000):
    for col in range(1000):
        total += arr[row][col]  # Sequential access
```

## Storage

### HDD (Hard Disk Drive)

```
Mechanical spinning disk
Slower (100-200 MB/s)
Cheaper per GB
Moving parts (can fail)
```

### SSD (Solid State Drive)

```
Flash memory (no moving parts)
Faster (500-3500 MB/s)
More expensive per GB
More reliable
```

### NVMe SSD

```
Faster than SATA SSD (7000 MB/s+)
Connects via PCIe
```

```python
# Check disk usage
import psutil

disk = psutil.disk_usage('/')
print(f"Total: {disk.total / (1024**3):.2f} GB")
print(f"Used: {disk.used / (1024**3):.2f} GB")
print(f"Free: {disk.free / (1024**3):.2f} GB")
print(f"Usage: {disk.percent}%")
```

## Bits and Bytes

```
Bit: 0 or 1
Byte: 8 bits
Kilobyte (KB): 1,024 bytes
Megabyte (MB): 1,024 KB = 1,048,576 bytes
Gigabyte (GB): 1,024 MB
Terabyte (TB): 1,024 GB
```

```python
# Size conversions
def format_bytes(bytes):
    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if bytes < 1024:
            return f"{bytes:.2f} {unit}"
        bytes /= 1024

print(format_bytes(1024))           # 1.00 KB
print(format_bytes(1048576))        # 1.00 MB
print(format_bytes(1073741824))     # 1.00 GB
```

## CPU Architectures

### x86/x64 (Intel, AMD)

```
32-bit: x86 (max 4 GB RAM)
64-bit: x64 or x86-64 (much more RAM)
CISC: Complex Instruction Set
Used in: Desktop, laptop, servers
```

### ARM

```
RISC: Reduced Instruction Set
Power efficient
Used in: Phones, tablets, Apple M1/M2
```

```python
# Check architecture
import platform

print(platform.machine())  # 'x86_64' or 'arm64'
print(platform.architecture())  # ('64bit', 'ELF')
```

## Instruction Set

### RISC vs CISC

```
RISC (ARM):
  Simple instructions
  Fixed length
  More instructions needed
  Faster per instruction
  Power efficient

CISC (x86):
  Complex instructions
  Variable length
  Fewer instructions needed
  Slower per instruction
  More power
```

## Multi-Core Processing

```
Single Core:
  Task 1 → Task 2 → Task 3

Dual Core:
  Core 1: Task 1 → Task 3
  Core 2: Task 2 → Task 4

Quad Core:
  Core 1: Task 1
  Core 2: Task 2
  Core 3: Task 3
  Core 4: Task 4
```

```python
# Use multiple cores
from multiprocessing import Pool, cpu_count

def task(n):
    return n * n

if __name__ == '__main__':
    # Use all CPU cores
    with Pool(cpu_count()) as pool:
        results = pool.map(task, range(1000))
```

## Endianness

### Big Endian vs Little Endian

```
Number: 0x12345678

Big Endian (network byte order):
  Memory: 12 34 56 78

Little Endian (x86):
  Memory: 78 56 34 12
```

```python
import sys

print(sys.byteorder)  # 'little' or 'big'

# Convert between endianness
num = 0x12345678

# Little to big endian
big_endian = int.from_bytes(num.to_bytes(4, 'little'), 'big')
print(hex(big_endian))
```

## Memory Addressing

```
32-bit address space: 2^32 = 4 GB max
64-bit address space: 2^64 = 18 exabytes max

Address example:
  0x00000000 - Bottom of memory
  0x12345678 - Some location
  0xFFFFFFFF - Top of memory (32-bit)
```

```python
# Memory address of object
x = 42
print(id(x))  # Memory address (decimal)
print(hex(id(x)))  # Memory address (hex)
```

## Stack vs Heap

### Stack

```
Fast allocation
LIFO (Last In First Out)
Fixed size
Local variables
Automatically managed
```

```python
def function():
    x = 10  # On stack
    y = 20  # On stack
    return x + y
# x and y removed from stack when function returns
```

### Heap

```
Slower allocation
Dynamic size
Objects, arrays
Manually managed (or garbage collected)
```

```python
def function():
    arr = [1, 2, 3, 4, 5]  # On heap
    return arr
# arr remains on heap after function returns
# Garbage collector cleans it up later
```

## CPU Pipeline

```
Instruction pipeline (simplified):

Time 1: Fetch I1
Time 2: Fetch I2, Decode I1
Time 3: Fetch I3, Decode I2, Execute I1
Time 4: Fetch I4, Decode I3, Execute I2, Store I1

Multiple instructions processed simultaneously
```

### Pipeline Hazards

```
Branch Prediction:
  if x > 0:
      # Path A
  else:
      # Path B

CPU predicts which path to take
Starts processing predicted path
If wrong, flushes pipeline (expensive)
```

## Memory Alignment

```
32-bit system: Data aligned on 4-byte boundaries
64-bit system: Data aligned on 8-byte boundaries

Unaligned access:
  Slower
  May require multiple memory reads

struct {
    char a;    // 1 byte
    // 3 bytes padding
    int b;     // 4 bytes (aligned to 4-byte boundary)
    char c;    // 1 byte
    // 3 bytes padding
}  // Total: 12 bytes (not 6!)
```

## Vectorization (SIMD)

```
SIMD: Single Instruction, Multiple Data

Regular:
  a[0] + b[0] = c[0]
  a[1] + b[1] = c[1]
  a[2] + b[2] = c[2]
  a[3] + b[3] = c[3]
  (4 instructions)

SIMD:
  [a[0], a[1], a[2], a[3]] + [b[0], b[1], b[2], b[3]]
  = [c[0], c[1], c[2], c[3]]
  (1 instruction)
```

```python
import numpy as np

# NumPy uses SIMD internally
a = np.array([1, 2, 3, 4])
b = np.array([5, 6, 7, 8])
c = a + b  # Vectorized operation
print(c)  # [6 8 10 12]
```

## Bus

```
Data Bus: Transfers data
Address Bus: Specifies memory location
Control Bus: Control signals (read/write)

Bus width: 64-bit = 64 bits transferred per cycle
```

## I/O (Input/Output)

```
Memory-Mapped I/O:
  Device registers mapped to memory addresses
  Read/write to address = communicate with device

Port-Mapped I/O:
  Separate I/O address space
  Special instructions (IN/OUT)

DMA (Direct Memory Access):
  Device transfers data directly to/from RAM
  CPU not involved (efficient)
```

## Interrupts

```
Hardware Interrupt:
  Device needs attention
  CPU pauses current task
  Handles interrupt
  Resumes task

Example:
  Keyboard press → Interrupt → CPU reads key → Resume
```

## Performance Metrics

```python
# CPU time
import time

start = time.time()
# ... do work ...
elapsed = time.time() - start
print(f"Elapsed: {elapsed:.2f} seconds")

# Instructions per second
# IPS = Instructions / Time

# FLOPS (Floating Point Operations Per Second)
# Measure of computational performance

# Throughput vs Latency
# Throughput: Operations per second
# Latency: Time for one operation
```

## Memory Bandwidth

```
RAM bandwidth: 25 GB/s (typical)
L3 cache bandwidth: 200 GB/s
L1 cache bandwidth: 1000 GB/s

Bandwidth = Data size / Time
```

```python
# Measure memory bandwidth (rough)
import time

size = 100_000_000
data = bytearray(size)

start = time.time()
for i in range(size):
    data[i] = i % 256
elapsed = time.time() - start

bandwidth = size / elapsed / (1024**2)  # MB/s
print(f"Bandwidth: {bandwidth:.2f} MB/s")
```

## Power Consumption

```
CPU power: 65W - 250W (desktop)
           5W - 45W (laptop)
           1W - 5W (phone)

Dynamic power: Increases with clock speed
Static power: Leakage (always present)

Lower voltage = Lower power = Less heat
```

## Moore's Law

```
Transistor count doubles every ~2 years
More transistors = More powerful CPUs
Slowing down in recent years
```

## CPU Bottleneck vs I/O Bottleneck

```python
# CPU-bound (calculation intensive)
def cpu_bound():
    total = 0
    for i in range(100_000_000):
        total += i * i
    return total

# I/O-bound (waiting for I/O)
def io_bound():
    with open('file.txt', 'r') as f:
        data = f.read()
    return data

# CPU-bound: Faster with more cores
# I/O-bound: Faster with async or threading
```

## Common Optimizations

```python
# 1. Cache-friendly code
# Access memory sequentially

# 2. Avoid branches in tight loops
# CPU pipeline stalls on misprediction

# 3. Use appropriate data types
# Smaller types = Better cache utilization

# 4. Batch operations
# Reduce function call overhead

# 5. Profile before optimizing
import cProfile
cProfile.run('my_function()')
```

## System Information

```python
import platform
import psutil

print(f"System: {platform.system()}")
print(f"Architecture: {platform.machine()}")
print(f"Processor: {platform.processor()}")
print(f"CPU cores: {psutil.cpu_count()}")
print(f"RAM: {psutil.virtual_memory().total / (1024**3):.2f} GB")
print(f"Disk: {psutil.disk_usage('/').total / (1024**3):.2f} GB")
```

```ruby
require 'etc'

puts "CPU cores: #{Etc.nprocessors}"
puts "System: #{RUBY_PLATFORM}"
```

## Von Neumann Architecture

```
┌──────────────────┐
│   Input Device   │
└────────┬─────────┘
         │
┌────────▼─────────┐
│   Memory (RAM)   │ ← Stores both data and instructions
└────────┬─────────┘
         │
┌────────▼─────────┐
│       CPU        │
│  ┌────────────┐  │
│  │Control Unit│  │
│  └────────────┘  │
│  ┌────────────┐  │
│  │    ALU     │  │
│  └────────────┘  │
└────────┬─────────┘
         │
┌────────▼─────────┐
│  Output Device   │
└──────────────────┘
```

## Real-World Example

```python
# Why is this slow?
data = []
for i in range(1_000_000):
    data.append(i)  # Heap allocation on each append

# Why is this fast?
data = [i for i in range(1_000_000)]  # Pre-allocated

# Why is NumPy fast?
import numpy as np
data = np.arange(1_000_000)
# Contiguous memory, CPU cache-friendly, SIMD
```
