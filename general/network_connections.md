# Network Connections

## OSI Model (7 Layers)

```
7. Application  - HTTP, FTP, SMTP (user applications)
6. Presentation - Encryption, compression
5. Session      - Session management
4. Transport    - TCP, UDP (end-to-end delivery)
3. Network      - IP (routing between networks)
2. Data Link    - MAC addresses (local network)
1. Physical     - Cables, signals
```

**Practical: TCP/IP Model (4 Layers)**

```
4. Application  - HTTP, FTP, DNS
3. Transport    - TCP, UDP
2. Internet     - IP
1. Network      - Ethernet, WiFi
```

## TCP vs UDP

### TCP (Transmission Control Protocol)

- **Reliable**: Guarantees delivery
- **Ordered**: Packets arrive in order
- **Connection-oriented**: Handshake required
- **Slower**: Due to overhead

```python
# Python TCP server
import socket

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(('localhost', 8000))
server.listen(1)
print("Server listening...")

conn, addr = server.accept()
print(f"Connected by {addr}")

data = conn.recv(1024)
print(f"Received: {data.decode()}")

conn.sendall(b"Hello from server")
conn.close()
```

```python
# Python TCP client
import socket

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect(('localhost', 8000))

client.sendall(b"Hello from client")
data = client.recv(1024)
print(f"Received: {data.decode()}")

client.close()
```

**Use cases:**
- Web browsing (HTTP/HTTPS)
- Email (SMTP, IMAP)
- File transfer (FTP)
- SSH

### UDP (User Datagram Protocol)

- **Unreliable**: No delivery guarantee
- **Unordered**: Packets may arrive out of order
- **Connectionless**: No handshake
- **Faster**: Less overhead

```python
# Python UDP server
import socket

server = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
server.bind(('localhost', 8001))
print("UDP Server listening...")

data, addr = server.recvfrom(1024)
print(f"Received from {addr}: {data.decode()}")

server.sendto(b"Hello from UDP server", addr)
server.close()
```

```python
# Python UDP client
import socket

client = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
client.sendto(b"Hello from UDP client", ('localhost', 8001))

data, addr = client.recvfrom(1024)
print(f"Received: {data.decode()}")

client.close()
```

**Use cases:**
- Video streaming
- Online gaming
- DNS queries
- VoIP (Skype, Zoom)

## HTTP/HTTPS

### HTTP (HyperText Transfer Protocol)

- Port 80
- Stateless
- Request-response model

```python
# Simple HTTP request
import requests

response = requests.get('http://api.example.com/users')
print(response.status_code)  # 200
print(response.json())        # Parse JSON response
```

```ruby
# HTTP request in Ruby
require 'net/http'
require 'json'

uri = URI('http://api.example.com/users')
response = Net::HTTP.get(uri)
data = JSON.parse(response)
puts data
```

### HTTPS (HTTP Secure)

- Port 443
- Encrypted with SSL/TLS
- Certificate verification

```python
# HTTPS request
response = requests.get('https://api.github.com/users/octocat')
print(response.json())
```

### HTTP Methods

```
GET     - Retrieve data
POST    - Create new resource
PUT     - Update entire resource
PATCH   - Update partial resource
DELETE  - Delete resource
HEAD    - Get headers only
OPTIONS - Get allowed methods
```

```python
# HTTP methods
import requests

# GET
response = requests.get('https://api.example.com/users/1')

# POST
response = requests.post('https://api.example.com/users',
    json={'name': 'John', 'email': 'john@example.com'})

# PUT
response = requests.put('https://api.example.com/users/1',
    json={'name': 'John Updated', 'email': 'john@example.com'})

# DELETE
response = requests.delete('https://api.example.com/users/1')
```

### HTTP Status Codes

```
1xx - Informational
  100 Continue

2xx - Success
  200 OK
  201 Created
  204 No Content

3xx - Redirection
  301 Moved Permanently
  302 Found (temporary redirect)
  304 Not Modified

4xx - Client Error
  400 Bad Request
  401 Unauthorized
  403 Forbidden
  404 Not Found
  429 Too Many Requests

5xx - Server Error
  500 Internal Server Error
  502 Bad Gateway
  503 Service Unavailable
  504 Gateway Timeout
```

## WebSockets

- Full-duplex communication
- Persistent connection
- Real-time data transfer

```python
# Python WebSocket server (using websockets library)
import asyncio
import websockets

async def handler(websocket):
    async for message in websocket:
        print(f"Received: {message}")
        await websocket.send(f"Echo: {message}")

async def main():
    async with websockets.serve(handler, "localhost", 8765):
        await asyncio.Future()  # Run forever

asyncio.run(main())
```

```python
# Python WebSocket client
import asyncio
import websockets

async def client():
    async with websockets.connect("ws://localhost:8765") as websocket:
        await websocket.send("Hello WebSocket")
        response = await websocket.recv()
        print(response)

asyncio.run(client())
```

**Use cases:**
- Chat applications
- Live notifications
- Real-time dashboards
- Online gaming

## Connection Types

### Short-Lived (HTTP)

```
Client -> Server: Open connection
Client -> Server: Send request
Server -> Client: Send response
Client -> Server: Close connection
```

### Long-Lived (WebSocket)

```
Client -> Server: Upgrade to WebSocket
Client <-> Server: Bidirectional communication
(connection stays open)
```

### Keep-Alive (HTTP/1.1)

```
Client -> Server: Open connection
Client -> Server: Request 1
Server -> Client: Response 1
Client -> Server: Request 2 (same connection)
Server -> Client: Response 2
(reuse connection)
```

## DNS (Domain Name System)

- Translates domain names to IP addresses
- Port 53
- Uses UDP (sometimes TCP)

```python
# Resolve domain to IP
import socket

ip = socket.gethostbyname('google.com')
print(ip)  # 142.250.185.46

# Reverse lookup
hostname = socket.gethostbyaddr('8.8.8.8')
print(hostname)  # dns.google
```

```ruby
# DNS lookup in Ruby
require 'resolv'

ip = Resolv.getaddress('google.com')
puts ip

hostname = Resolv.getname('8.8.8.8')
puts hostname
```

## Ports

```
Well-known ports (0-1023):
  20/21 - FTP
  22    - SSH
  23    - Telnet
  25    - SMTP (email)
  53    - DNS
  80    - HTTP
  110   - POP3 (email)
  143   - IMAP (email)
  443   - HTTPS
  3306  - MySQL
  5432  - PostgreSQL
  6379  - Redis
  27017 - MongoDB

Registered ports (1024-49151):
  3000  - Common dev server
  5000  - Flask default
  8000  - Django default
  8080  - Alternative HTTP

Dynamic ports (49152-65535):
  Assigned by OS for client connections
```

## IP Addresses

### IPv4

```
Format: 0.0.0.0 to 255.255.255.255
Example: 192.168.1.1

Private ranges (not routable on internet):
  10.0.0.0    - 10.255.255.255
  172.16.0.0  - 172.31.255.255
  192.168.0.0 - 192.168.255.255

Special:
  127.0.0.1   - Localhost
  0.0.0.0     - All interfaces
  255.255.255.255 - Broadcast
```

### IPv6

```
Format: 8 groups of 4 hex digits
Example: 2001:0db8:85a3:0000:0000:8a2e:0370:7334

Shorthand:
  2001:0db8:85a3::8a2e:0370:7334

Localhost: ::1
```

## SSL/TLS

- Encrypts data in transit
- Certificate-based authentication
- Handshake process

```
1. Client Hello
2. Server Hello + Certificate
3. Key Exchange
4. Client verifies certificate
5. Encrypted communication begins
```

```python
# Python HTTPS with certificate verification
import requests

# Verify SSL certificate (default)
response = requests.get('https://api.github.com')

# Disable verification (not recommended)
response = requests.get('https://example.com', verify=False)

# Use custom CA bundle
response = requests.get('https://example.com', verify='/path/to/ca-bundle.crt')
```

## Proxies

### Forward Proxy

```
Client -> Proxy -> Internet
(hides client IP)
```

```python
# Use proxy
proxies = {
    'http': 'http://proxy.example.com:8080',
    'https': 'https://proxy.example.com:8080'
}
response = requests.get('http://example.com', proxies=proxies)
```

### Reverse Proxy

```
Client -> Reverse Proxy -> Backend Server
(load balancing, caching)

Examples: Nginx, HAProxy
```

## Load Balancing

### Round Robin

```
Request 1 -> Server A
Request 2 -> Server B
Request 3 -> Server C
Request 4 -> Server A (repeat)
```

### Least Connections

```
Send to server with fewest active connections
```

### IP Hash

```
Hash client IP, always route to same server
```

## CDN (Content Delivery Network)

```
User in Europe -> European CDN edge server
User in Asia -> Asian CDN edge server

Benefits:
- Reduced latency
- Reduced bandwidth costs
- Improved availability
```

## Network Tools

```bash
# Test connectivity
ping google.com

# Trace route
traceroute google.com    # Linux/Mac
tracert google.com       # Windows

# DNS lookup
nslookup google.com
dig google.com

# Check open ports
netstat -tuln           # Linux
netstat -an             # Windows

# Network scan
nmap 192.168.1.0/24

# Test HTTP endpoint
curl https://api.github.com/users/octocat
wget https://example.com

# Monitor network traffic
tcpdump                 # Linux
wireshark              # GUI tool
```

## NAT (Network Address Translation)

```
Private network:
  Device A: 192.168.1.10
  Device B: 192.168.1.11

Router public IP: 203.0.113.5

Outgoing connection:
  192.168.1.10:5000 -> Router translates -> 203.0.113.5:50000 -> Internet
```

## Firewall

```
Incoming rules:
  Allow: Port 80 (HTTP)
  Allow: Port 443 (HTTPS)
  Allow: Port 22 (SSH) from specific IPs
  Deny: All other ports

Outgoing rules:
  Usually allow all
```

```bash
# Linux firewall (ufw)
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 22/tcp
sudo ufw enable
```

## Connection States

### TCP States

```
LISTEN      - Server waiting for connection
SYN_SENT    - Client sent connection request
ESTABLISHED - Connection active
FIN_WAIT    - Closing connection
CLOSE_WAIT  - Remote closed, local app hasn't
CLOSED      - Connection closed
```

### 3-Way Handshake (TCP)

```
Client -> Server: SYN
Server -> Client: SYN-ACK
Client -> Server: ACK
(Connection established)
```

### 4-Way Termination (TCP)

```
Client -> Server: FIN
Server -> Client: ACK
Server -> Client: FIN
Client -> Server: ACK
(Connection closed)
```

## Bandwidth vs Latency

**Bandwidth**: How much data per second
```
10 Mbps - slow
100 Mbps - medium
1 Gbps - fast
```

**Latency**: How long for data to travel
```
< 20ms - excellent
20-50ms - good
50-100ms - acceptable
> 100ms - noticeable lag
```

```python
# Measure latency
import time
import requests

start = time.time()
response = requests.get('https://google.com')
latency = (time.time() - start) * 1000
print(f"Latency: {latency:.2f}ms")
```

## Connection Pooling

```python
# Without pooling - creates new connection each time
for i in range(100):
    response = requests.get('https://api.example.com/data')

# With pooling - reuses connections
session = requests.Session()
for i in range(100):
    response = session.get('https://api.example.com/data')
session.close()
```

```ruby
# Connection pooling in Ruby
require 'net/http'

Net::HTTP.start('api.example.com', 443, use_ssl: true) do |http|
  100.times do
    response = http.get('/data')
  end
end
```

## Timeouts

```python
# Set timeouts to avoid hanging
try:
    response = requests.get('https://slow-api.com',
        timeout=5)  # 5 seconds
except requests.Timeout:
    print("Request timed out")

# Separate connect and read timeout
response = requests.get('https://api.com',
    timeout=(3.0, 10.0))  # 3s connect, 10s read
```

## Common Issues

```python
# Connection refused
# - Server not running
# - Wrong port
# - Firewall blocking

# Timeout
# - Server too slow
# - Network issue
# - Incorrect timeout value

# DNS resolution failed
# - Domain doesn't exist
# - DNS server unreachable

# SSL certificate error
# - Expired certificate
# - Self-signed certificate
# - Hostname mismatch
```
