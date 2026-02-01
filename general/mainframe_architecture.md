# IBM Mainframe Architecture

Overview of modern IBM Z mainframes (z15 and z16), architecture, and use cases.

---

## Table of Contents

1. [Overview](#overview)
2. [Current Models - z16 and z15](#current-models---z16-and-z15)
3. [Architecture](#architecture)
4. [Processor and Memory](#processor-and-memory)
5. [I/O and Storage](#io-and-storage)
6. [Use Cases](#use-cases)
7. [Key Features](#key-features)

---

## Overview

**What is a Mainframe?**
- Large-scale computer for mission-critical operations
- Handles thousands of concurrent users and transactions
- Known for: reliability, security, backward compatibility
- Primary architecture: IBM Z (formerly System z)

**Why Still Relevant**:
```
Credit card transactions: 87% worldwide
Daily payments: $8 trillion
Fortune 500 usage: 90%
Uptime: 99.999% (5 minutes/year downtime)
Security: EAL5+ certification
Legacy code: 220+ billion lines COBOL still running
```

---

## Current Models - z16 and z16

### IBM z16 (2022 - Latest)

**Specifications**:
```
Processor: IBM Telum (7nm)
Cores: 200 configurable
Memory: 40 TB RAIM
AI Accelerator: On-chip (1ms latency)
I/O Bandwidth: 520 GB/s
LPARs: 85 max
```

**Key Innovations**:
- Real-time AI inference for fraud detection
- Quantum-safe cryptography (post-quantum algorithms)
- Cyber resilience with instant recovery
- Cloud-native development support
- TensorFlow on Z integration

**Use Case**: Real-time transaction AI (credit card fraud detection < 1ms)

### IBM z15 (2019)

**Specifications**:
```
Processor: 14nm FinFET
Cores: 190 configurable
Memory: 40 TB
I/O Drawers: 12 max
Encryption: Pervasive, transparent
```

**Key Features**:
- Data Privacy Passports (control data access anywhere)
- Instant recovery (< 1 second failover)
- Cloud native dev tools
- Pervasive encryption (encrypt everything)

**Use Case**: Data privacy compliance (GDPR, HIPAA) with built-in controls

---

## Architecture

### System Structure

```
┌──────────────────────────────────────┐
│        IBM Z MAINFRAME               │
├──────────────────────────────────────┤
│  ┌─────────┐ ┌─────────┐ ┌─────────┐│
│  │ CPU 1   │ │ CPU 2   │ │ CPU n   ││
│  │ Complex │ │ Complex │ │ Complex ││
│  └────┬────┘ └────┬────┘ └────┬────┘│
│       │           │           │     │
│  ┌────┴───────────┴───────────┴───┐ │
│  │    RAIM Memory (40 TB)         │ │
│  └────────────┬───────────────────┘ │
│               │                     │
│  ┌────────────┴───────────────────┐ │
│  │  I/O Subsystem (FICON, OSA)   │ │
│  └────────────┬───────────────────┘ │
│               │                     │
│  ┌────────────┴───────────────────┐ │
│  │  Storage (DASD, SAN, Tape)    │ │
│  └───────────────────────────────┘ │
└──────────────────────────────────────┘
```

**Components**:
1. **CPC** (Central Processor Complex): Multiple cores + cache
2. **RAIM**: Redundant Array of Independent Memory (fault-tolerant)
3. **I/O Subsystem**: FICON (storage), OSA (network), Crypto Express
4. **HMC**: Hardware Management Console (GUI for management)

---

## Processor and Memory

### IBM Telum Processor (z16)

```
Architecture: 8-way SMT (Simultaneous Multi-Threading)
Cache L1: 32 KB instruction + 32 KB data per core
Cache L2: 2 MB per core
Cache L3: 256 MB shared
Clock: 5.2 GHz
Technology: 7nm EUV
Transistors: 22 billion per chip
AI Accelerator: Integrated on-chip
```

**Processor Types**:
```
CP (Central Processor): General z/OS workloads
IFL (Integrated Facility for Linux): Dedicated Linux (no z/OS charges)
zIIP (z Integrated Information Processor): Java, XML, DB2 (80% cost reduction)
ICF (Internal Coupling Facility): Sysplex data sharing
SAP (System Assist Processor): I/O operations
```

### RAIM Memory

**Structure**:
```
Redundant Array of Independent Memory:
  - Multiple DIMMs in parallel
  - ECC (Error Correcting Code)
  - Automatic failover
  - Hot-swap capability
  - No downtime for failures

z16: 40 TB max
z15: 40 TB max
```

**Cache Hierarchy**:
```
L1: ~1 cycle (32 KB)
L2: ~10 cycles (2 MB)
L3: ~30 cycles (256 MB shared)
L4: ~100 cycles (2.8 GB optional)
Main Memory: ~200 cycles (TB range)
```

---

## I/O and Storage

### I/O Types

**1. FICON** (Fibre Connection):
```
Speed: 16 Gbps (FICON Express16)
Use: Storage connectivity (DASD)
Distance: Up to 100 km
Protocol: Fiber Channel
```

**2. OSA** (Open Systems Adapter):
```
Speed: 1/10/25 Gbps Ethernet
Use: Network (LAN/WAN)
Protocols: TCP/IP, HTTP, FTP
```

**3. HiperSockets**:
```
Type: Virtual high-speed network
Speed: Memory-to-memory (microseconds)
Use: LPAR-to-LPAR communication
Latency: Near-zero
```

**4. Crypto Express**:
```
Function: Hardware encryption/decryption
Performance: 100,000+ RSA ops/sec
Algorithms: AES, RSA, ECC, quantum-safe
Tamper-resistant: Yes
```

### Storage Systems

**DASD** (Direct Access Storage Device):
```
3390 Model 27:
  Capacity: ~1 TB per volume
  Cylinders: 65,520
  Tracks/Cylinder: 15
  Addressing: Cylinder/Track/Record
  Access Method: ECKD
```

**DS8000 Enterprise Storage**:
```
Capacity: Up to 4 PB
RAID: Protection built-in
Cache: Up to 2 TB
Snapshot/Replication: Yes
Thin Provisioning: Yes
```

**Virtual Tape** (TS7700):
```
Disk Cache: 895 TB
Capacity: 2.5 PB total
Deduplication: Built-in
Compression: Hardware accelerated
```

---

## Use Cases

### 1. Banking and Financial Services

**Why Mainframes**:
- Process billions of transactions/day
- Real-time fraud detection (AI on z16)
- Regulatory compliance (audit trails)
- 99.999% availability required

**Workload Example**:
```
ATM transactions: Millions/hour
Credit cards: Real-time authorization
Online banking: Millions concurrent
Fraud detection: < 1ms (z16 AI)
Batch: End-of-day settlement
```

### 2. Insurance

**Applications**:
- Policy administration
- Claims processing
- Actuarial calculations

**Scale**:
```
Customer records: Hundreds of millions
Retention: 50+ years
Compliance: HIPAA, SOX, GDPR
```

### 3. Retail and E-commerce

**Functions**:
- POS (Point of Sale) processing
- Inventory management
- Supply chain

**Peak Handling**:
```
Black Friday: 10x normal volume (handled gracefully)
Flash sales: Sudden spikes
24/7 global: No downtime windows
```

### 4. Airlines

**Systems**:
- Reservations (legacy SABRE, Amadeus)
- Ticketing
- Frequent flyer programs

**Requirements**:
```
Searches/second: Thousands
Concurrent bookings: Millions
Legacy integration: 50+ year old code
Global: 24/7 worldwide
```

### 5. Government

**Applications**:
- Social Security
- Tax processing
- Census
- National databases

**Characteristics**:
```
Security: Classified data
Scale: Entire populations
Retention: Decades
Availability: Critical infrastructure
```

---

## Key Features

### 1. Reliability (RAS)

**Availability**:
```
MTBF: Decades
Uptime: 99.999% (5 minutes/year)
Redundancy: Duplicate everything
Self-healing: Automatic recovery
Hot-swap: Replace components online
```

**Fault Tolerance**:
- Redundant processors
- RAIM memory (survives DIMM failures)
- Duplicate I/O paths
- Automatic failover

### 2. Security

**Pervasive Encryption** (z15/z16):
```
Crypto Express: Hardware acceleration
CPACF: On-chip cryptographic functions
Dataset encryption: Transparent to apps
Network encryption: TLS/SSL offload
Quantum-safe: Post-quantum algorithms (z16)
```

**Certifications**:
- EAL5+ (Common Criteria)
- FIPS 140-2 Level 4
- PCI DSS compliance

### 3. Virtualization

**PR/SM** (Processor Resource/Systems Manager):
```
LPARs: Up to 85 per system
Isolation: Complete separation
Dynamic: Online resource changes
```

**z/VM** (Hypervisor):
```
Guests: Thousands per LPAR
OS Support: z/OS, Linux, z/VSE, z/TPF
Resource Pooling: Efficient sharing
```

### 4. Parallel Sysplex

**Architecture**:
```
┌──────┐  ┌──────┐  ┌──────┐
│ z/OS │──│ z/OS │──│ z/OS │
└───┬──┘  └───┬──┘  └───┬──┘
    └────────┼────────┘
       ┌─────┴─────┐
       │ Coupling  │
       │ Facility  │
       └─────┬─────┘
       ┌─────┴─────┐
       │Shared DASD│
       └───────────┘

Up to 32 systems clustered
Workload balancing: Automatic
Data sharing: Via Coupling Facility
Failover: Automatic
```

**Benefits**:
- Near-continuous availability
- No single point of failure
- Workload distribution
- Planned outages eliminated

### 5. Backward Compatibility

**Application Longevity**:
```
1960s COBOL: Still runs on z16
Binary compatibility: 40+ years
Investment protection: No rewrites needed
Gradual modernization: Add new while keeping old
```

**Instruction Set Evolution**:
```
S/360 (1964): Base instructions still supported
Extensions: Continuous additions
z/Architecture: 64-bit (2000+)
New features: AI, crypto, compression
```

---

## Performance and Cost

### Performance Metrics

**Transaction Processing**:
```
CICS: 1+ million transactions/second
Response time: Milliseconds
Throughput: Billions per day
```

**Batch Processing**:
```
Job scheduling: Thousands of jobs
Data: TB per hour
Sort: GB per second
Parallelism: Multiple processors
```

### Cost Considerations

**Pricing Models**:
```
MIPS-based: Traditional capacity pricing
Capacity on Demand: Temporary activation
Tailored Fit: Workload-based pricing
```

**Specialty Engines** (Cost Reduction):
```
zIIP: 80% savings for eligible workloads (Java, DB2)
IFL: Linux with no z/OS charges
Consolidation: 10:1 or more vs distributed servers
```

**TCO** (Total Cost of Ownership):
```
High initial: Expensive hardware
Low ongoing: Energy efficient, fewer admins
Consolidation savings: Reduces datacenter footprint
Software optimization: Use specialty engines
```

---

## Modernization

### Cloud Integration

**Hybrid Cloud**:
```
IBM Cloud: z/OS as a Service
Containers: Docker on z/Linux
Kubernetes: Red Hat OpenShift
APIs: REST services from mainframe
```

### Modern Development

**Languages**:
```
Traditional: COBOL, PL/I, Assembler
Modern: Java, Python, Node.js, Go
JVM: Runs on zIIP (cost savings)
```

**Tools**:
```
IDz: Eclipse-based IDE
Git: Source control integration
Jenkins: CI/CD pipelines
z/OSMF: Web-based management
```

**DevOps**:
```
Automated builds
Continuous integration
REST APIs: Expose mainframe services
GraphQL: Modern data access
```

---

## Key Takeaways

**Modern Mainframes (z15/z16)**:
- AI integration (z16 on-chip accelerator)
- Quantum-safe cryptography
- 40 TB memory, 200 cores
- Pervasive encryption standard
- Cloud-native development support

**When to Use**:
- Mission-critical (99.999% uptime required)
- Massive scale (billions of transactions/day)
- Strong security/compliance
- Financial applications (exact decimal math)
- Legacy system maintenance

**Strengths**:
- Unmatched reliability
- Superior I/O bandwidth
- Built-in redundancy
- Pervasive encryption
- 40+ years backward compatibility
- Vertical and horizontal scaling

**Industry Position**:
- 90% of credit card transactions
- 71% of Fortune 500 transaction systems
- $8 trillion daily payments
- Won't disappear (too much code to rewrite)

**Evolution**:
- Continuously modernized (not "legacy")
- AI/ML integration (z16 Telum)
- Quantum-safe future-proofing
- Hybrid cloud support
- Linux and container support
