# z/OS Overview

Guide to IBM z/OS - the operating system for IBM Z mainframes (z15 and z16).

---

## Table of Contents

1. [Overview](#overview)
2. [Current Versions](#current-versions)
3. [Architecture](#architecture)
4. [File Systems](#file-systems)
5. [Job Control (JCL)](#job-control-jcl)
6. [Security](#security)
7. [Subsystems](#subsystems)

---

## Overview

**What is z/OS?**
- 64-bit OS for IBM Z mainframes
- Evolution: OS/360 (1964) → MVS → OS/390 → z/OS (2001)
- Designed for mission-critical enterprise workloads
- 99.999% availability (5 minutes/year downtime)
- Backward compatible (runs 40+ year old programs)

**Key Characteristics**:
```
Time-sharing: Multiple concurrent users
Batch processing: Billions of jobs/day
Transaction processing: Millions/second
Reliability: Decades of uptime
Security: EAL5+ certified
```

---

## Current Versions

### z/OS 3.1 (September 2022 - Latest)

**New Features**:
```
Container Support: Enhanced Docker/OCI
AI Integration: TensorFlow on z/OS
Quantum-safe Crypto: Post-quantum algorithms
Cloud Integration: Hybrid cloud
Python 3.11: Native runtime
Java 11: Latest LTS
```

**Hardware**: z16, z15

### z/OS 2.5 (2021)

**Features**:
```
Containers: Docker support
DevOps: Jenkins, Git integration
Open Source: Python, Node.js, Go
REST APIs: Expose mainframe services
AI/ML: TensorFlow, scikit-learn
```

---

## Architecture

### System Layout

```
┌─────────────────────────────────────┐
│             z/OS                    │
├─────────────────────────────────────┤
│  Base Control Program (BCP)         │
│  ├── Supervisor                     │
│  ├── Master Scheduler (JES)         │
│  └── System Resource Manager        │
├─────────────────────────────────────┤
│  Storage Management (DFSMS)         │
│  ├── VSAM                           │
│  ├── Catalog                        │
│  └── SMS                            │
├─────────────────────────────────────┤
│  Security (RACF)                    │
├─────────────────────────────────────┤
│  Subsystems (CICS, IMS, DB2, MQ)   │
├─────────────────────────────────────┤
│  Unix System Services (USS)         │
└─────────────────────────────────────┘
```

### Address Spaces

**Virtual Storage**:
```
0 MB ───────────────────
     │ PSA (Prefixed)    │
16 MB─────────────────── ← "The Line" (24-bit limit)
     │ Below the line    │
     │ (Legacy)          │
16 MB───────────────────
     │ Extended Private  │
     │ (31-bit)          │
2 GB ─────────────────── ← "The Bar" (31-bit limit)
     │ 64-bit            │
     │ (Modern apps)     │
16 EB───────────────────
```

**Types**:
```
System: JES2/JES3, TSO, VTAM, CATALOG
User: Batch jobs, TSO users, Started tasks
Subsystem: CICS regions, IMS, DB2
```

---

## File Systems

### MVS Datasets

**Dataset Types**:

**1. PS** (Physical Sequential):
```
//DD1 DD DSN=USER.DATA.FILE,
//    DISP=(NEW,CATLG,DELETE),
//    SPACE=(TRK,(10,5)),
//    DCB=(RECFM=FB,LRECL=80,BLKSIZE=800)
```

**2. PDS/PDSE** (Partitioned Dataset):
```
Structure: Directory + Members
Use: Source libraries, JCL, load modules
```

**3. VSAM** (Virtual Storage Access Method):
```
KSDS: Key Sequenced (indexed)
ESDS: Entry Sequenced (sequential)
RRDS: Relative Record
LDS: Linear
```

**Dataset Naming**:
```
Format: HLQ.QUALIFIER.QUALIFIER
Example: PROD.PAYROLL.MASTER
Rules: 1-44 chars, qualifiers 1-8 chars
```

**DCB Parameters**:
```
RECFM:  F (Fixed), FB (Fixed Blocked), V (Variable), VB
LRECL:  Logical record length
BLKSIZE: Block size (half-track optimal)
```

### Unix System Services (USS)

**File System**:
```
Hierarchical (HFS/zFS)

/
├── bin/
├── dev/
├── etc/
├── home/
├── tmp/
├── usr/
└── var/

Access: OMVS command, BPXWUNIX, ISHELL
```

---

## Job Control (JCL)

### Basic Structure

```jcl
//JOBNAME  JOB  (ACCT),'DESCRIPTION',
//         CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID
//STEP1    EXEC PGM=IEFBR14
//DD1      DD   DSN=USER.TEST.DATA,
//         DISP=(NEW,CATLG,DELETE),
//         SPACE=(TRK,(10,5)),
//         DCB=(RECFM=FB,LRECL=80,BLKSIZE=800)
```

**Components**:

**1. JOB Card**:
```jcl
//JOBNAME  JOB  (ACCOUNT),'NAME',
//         CLASS=A,           # Job class
//         MSGCLASS=X,        # Output class
//         NOTIFY=&SYSUID,    # Notify user
//         TIME=1440,         # Time limit
//         REGION=0M          # Memory
```

**2. EXEC Statement**:
```jcl
//STEP1  EXEC PGM=MYPROG      # Run program
//STEP2  EXEC PROC=MYPROC     # Run procedure
```

**3. DD (Data Definition)**:
```jcl
//INPUT   DD DSN=DATA.FILE,DISP=SHR
//OUTPUT  DD DSN=OUT.FILE,DISP=(NEW,CATLG)
//SYSOUT  DD SYSOUT=*
//SYSIN   DD *
Input data
/*
```

**Common Programs**:
```
IEFBR14:  Do nothing (create/delete datasets)
IEBGENER: Copy sequential files
IEBCOPY:  Copy PDS members
SORT:     Sort/merge data
IDCAMS:   VSAM utility
```

**Condition Codes**:
```
0:  Success
4:  Warning
8:  Error
12: Severe error
16: Terminal error
```

### File Processing Example

```jcl
//FILEJOB  JOB  (ACCT),'FILE COPY'
//STEP1    EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DUMMY
//SYSUT1   DD DSN=INPUT.FILE,DISP=SHR
//SYSUT2   DD DSN=OUTPUT.FILE,
//         DISP=(NEW,CATLG,DELETE),
//         SPACE=(TRK,(10,5)),
//         DCB=(RECFM=FB,LRECL=80)
```

---

## Security

### RACF (Resource Access Control Facility)

**User Management**:
```
# Define user
ADDUSER USERID NAME('JOHN SMITH')
  PASSWORD(SECRET) OWNER(ADMIN) DFLTGRP(USERS)

# Alter user
ALTUSER USERID PASSWORD(NEW) RESUME

# Delete user
DELUSER USERID
```

**Dataset Protection**:
```
# Generic profile
ADDSD 'PROD.**' UACC(NONE) OWNER(ADMIN)
PERMIT 'PROD.**' ID(USER1) ACCESS(READ)
PERMIT 'PROD.**' ID(GROUP1) ACCESS(UPDATE)

# Discrete profile
ADDSD 'PROD.PAYROLL.MASTER' UACC(NONE)
PERMIT 'PROD.PAYROLL.MASTER' ID(PAYUSER) ACCESS(ALTER)

# Activate
SETROPTS RACLIST(DATASET) REFRESH
```

**Encryption**:
```
Dataset Encryption: Pervasive, transparent
Crypto Express: Hardware acceleration
RACF Key Management: Centralized
Policy-based: Automatic application
```

---

## Subsystems

### CICS (Transaction Processing)

**Purpose**: Online transaction processing

**Example**:
```cobol
IDENTIFICATION DIVISION.
PROGRAM-ID. MYAPP.

PROCEDURE DIVISION.
    EXEC CICS RECEIVE
        INTO(INPUT-AREA)
        LENGTH(INPUT-LEN)
    END-EXEC.

    *> Process data

    EXEC CICS SEND
        FROM(OUTPUT-AREA)
        LENGTH(OUTPUT-LEN)
    END-EXEC.

    EXEC CICS RETURN
    END-EXEC.
```

**Capabilities**:
```
TPS: 1+ million/second
Response: Milliseconds
Users: Millions concurrent
```

### IMS (Information Management System)

**Components**:

**IMS DB** (Hierarchical Database):
```
Tree structure
Fast access
High performance
```

**IMS TM** (Transaction Manager):
```
Message processing
Transaction routing
Queue management
```

**Example**:
```cobol
*> DL/I calls
CALL 'CBLTDLI' USING DLI-GU
                     PCB
                     SEGMENT-IO
                     SSA.
```

### DB2 (Relational Database)

**SQL Example**:
```sql
-- Create table
CREATE TABLE EMPLOYEE (
    EMPNO CHAR(6) NOT NULL PRIMARY KEY,
    FIRSTNAME VARCHAR(12),
    LASTNAME VARCHAR(15),
    SALARY DECIMAL(9,2)
);

-- Query
SELECT EMPNO, LASTNAME, SALARY
FROM EMPLOYEE
WHERE SALARY > 50000
ORDER BY LASTNAME;
```

**COBOL Integration**:
```cobol
EXEC SQL
    SELECT LASTNAME, SALARY
    INTO :WS-LASTNAME, :WS-SALARY
    FROM EMPLOYEE
    WHERE EMPNO = :WS-EMPNO
END-EXEC.

IF SQLCODE = 0
    DISPLAY 'FOUND: ' WS-LASTNAME
END-IF.
```

### MQ (Message Queuing)

**Concepts**:
```
Queue Manager: Controls queues
Queue: Holds messages
Channel: Connection between managers
```

**Message Types**:
```
Datagram: Fire and forget
Request: Expects reply
Reply: Response to request
```

---

## System Management

### TSO/E (Time Sharing Option)

**Commands**:
```
LOGON USERID              - Log in
LISTDS                    - List datasets
ALLOCATE/DELETE           - Manage datasets
SUBMIT                    - Submit job
STATUS                    - Check job status
OUTPUT                    - View job output
EDIT                      - Edit dataset
```

### ISPF (Interactive System Productivity Facility)

**Primary Menu**:
```
0: Settings
1: View - Browse datasets
2: Edit - Edit datasets
3: Utilities - Dataset utilities
4: Foreground - Compile/run
5: Batch - Submit jobs
6: Command - TSO commands
```

**Edit Commands**:
```
Line Commands:
  I:  Insert
  D:  Delete
  R:  Repeat
  C:  Copy
  M:  Move

Primary Commands:
  FIND 'string'
  CHANGE 'old' 'new' ALL
  SAVE
  SUBMIT
```

### SDSF (System Display and Search Facility)

**Commands**:
```
DA:  Display active jobs
I:   Input queue
O:   Output queue
H:   Held output
ST:  System status
LOG: System log
```

### z/OSMF (Web-based Management)

**Features**:
```
Task management
Workflows
Resource monitoring
Incident log
REST APIs

Access: https://hostname:port/zosmf
```

---

## Programming

### Languages

**Traditional**:
```
COBOL: Business applications (most common)
PL/I:  Systems and applications
Assembler: Performance-critical
REXX: Scripting, automation
```

**Modern**:
```
Java: zIIP-eligible (cost savings)
Python: AI/ML, scripting
Node.js: Web applications
Go: Cloud native
C/C++: System programming
```

### Compile Example (COBOL)

```jcl
//COMPILE EXEC PGM=IGYCRCTL,PARM='LIB'
//STEPLIB  DD DSN=IGY.V6R3M0.SIGYCOMP,DISP=SHR
//SYSLIB   DD DSN=USER.COPYLIB,DISP=SHR
//SYSIN    DD DSN=USER.SOURCE(PROGRAM),DISP=SHR
//SYSLIN   DD DSN=&&OBJMOD,DISP=(NEW,PASS)
//SYSPRINT DD SYSOUT=*
```

**Link Edit**:
```jcl
//LKED    EXEC PGM=IEWL
//SYSLIB  DD DSN=CEE.SCEELKED,DISP=SHR
//SYSLIN  DD DSN=&&OBJMOD,DISP=(OLD,DELETE)
//SYSLMOD DD DSN=USER.LOADLIB(PROGRAM),DISP=SHR
```

---

## Key Takeaways

**z/OS Strengths**:
- 99.999% uptime (5 min/year)
- Billions of transactions/day
- 40+ years backward compatible
- EAL5+ security
- Vertical and horizontal scaling

**Modern Capabilities**:
- Containers (Docker, OCI)
- AI/ML (TensorFlow, PyTorch)
- Modern languages (Python, Node.js)
- DevOps (Git, Jenkins)
- REST APIs, microservices
- Hybrid cloud integration

**Core Concepts**:
- Address spaces (isolation)
- JCL (batch processing)
- Datasets (not files)
- Catalogs (not directories)
- Subsystems (CICS, IMS, DB2)
- RACF (security)

**Use Cases**:
```
Banking: Transaction processing
Insurance: Policy management
Retail: Inventory, POS
Airlines: Reservations
Government: Citizen services
```

**Learning Path**:
1. Understand MVS concepts (datasets, JCL)
2. Learn TSO/ISPF navigation
3. Master JCL job submission
4. Study subsystems (CICS, DB2)
5. Explore USS (Unix)
6. Learn COBOL or modern language
