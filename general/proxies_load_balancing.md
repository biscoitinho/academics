# Proxies, Reverse Proxies & Load Balancing

Understanding different types of proxies and traffic distribution systems.

## Forward Proxy

A proxy server that sits between clients and the internet.

### What It Does

```
Client -> Forward Proxy -> Internet Server
         (hides client)
```

**Client knows about the proxy, server doesn't**

### Use Cases

1. **Privacy/Anonymity** - Hide client IP
2. **Content filtering** - Block certain websites
3. **Caching** - Speed up repeated requests
4. **Bypass restrictions** - Access geo-blocked content

### Example Usage

```python
# Python with requests
import requests

proxies = {
    'http': 'http://proxy.example.com:8080',
    'https': 'https://proxy.example.com:8080'
}

response = requests.get('http://api.example.com', proxies=proxies)
```

```ruby
# Ruby with Net::HTTP
require 'net/http'

uri = URI('http://api.example.com')
proxy_uri = URI('http://proxy.example.com:8080')

Net::HTTP.start(
  uri.host, uri.port,
  proxy_uri.host, proxy_uri.port
) do |http|
  response = http.get(uri.path)
end
```

### Common Forward Proxy Tools

- **Squid** - Popular open-source proxy
- **Privoxy** - Privacy-focused proxy
- **SOCKS5** - Protocol for proxying (e.g., SSH tunneling)
- **Corporate proxies** - Filter/monitor traffic

## Reverse Proxy

A proxy server that sits in front of backend servers.

### What It Does

```
Client -> Reverse Proxy -> Backend Servers
         (hides backend)
```

**Server knows about proxy, client doesn't**

### Benefits

1. **Load balancing** - Distribute traffic across servers
2. **SSL termination** - Handle HTTPS at proxy level
3. **Caching** - Cache responses to reduce backend load
4. **Compression** - Gzip responses
5. **Security** - Hide backend topology
6. **Static file serving** - Offload from app servers

### Simple Nginx Reverse Proxy

```nginx
# Nginx config
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### Common Reverse Proxy Tools

- **Nginx** - Fast, popular, lightweight
- **Apache** - mod_proxy, traditional
- **HAProxy** - High-performance, TCP/HTTP
- **Traefik** - Cloud-native, auto-discovery
- **Envoy** - Modern, service mesh

## Load Balancing

Distributing traffic across multiple backend servers.

### Load Balancing Algorithms

#### 1. Round Robin (Default)

Requests distributed equally in rotation.

```
Request 1 -> Server A
Request 2 -> Server B
Request 3 -> Server C
Request 4 -> Server A  (back to start)
```

**Pros**: Simple, fair distribution
**Cons**: Ignores server load/capacity

```nginx
# Nginx round-robin (default)
upstream backend {
    server 192.168.1.10:3000;
    server 192.168.1.11:3000;
    server 192.168.1.12:3000;
}
```

#### 2. Least Connections

Send to server with fewest active connections.

```nginx
# Nginx least connections
upstream backend {
    least_conn;
    server 192.168.1.10:3000;
    server 192.168.1.11:3000;
}
```

**Pros**: Better for varying request durations
**Cons**: Slight overhead tracking connections

#### 3. IP Hash (Sticky Sessions)

Same client always goes to same server.

```nginx
# Nginx IP hash
upstream backend {
    ip_hash;
    server 192.168.1.10:3000;
    server 192.168.1.11:3000;
}
```

**Pros**: Session persistence without cookies
**Cons**: Uneven distribution if clients behind NAT

#### 4. Weighted Round Robin

Different servers get different amounts of traffic.

```nginx
# Nginx weighted
upstream backend {
    server 192.168.1.10:3000 weight=3;  # Gets 3x traffic
    server 192.168.1.11:3000 weight=2;  # Gets 2x traffic
    server 192.168.1.12:3000 weight=1;  # Gets 1x traffic
}
```

**Pros**: Utilize more powerful servers
**Cons**: Requires manual tuning

#### 5. Least Response Time

Send to server with fastest response (advanced).

**Pros**: Best user experience
**Cons**: Complex to implement

### Health Checks

Ensure traffic only goes to healthy servers.

```nginx
# Nginx with health checks
upstream backend {
    server 192.168.1.10:3000 max_fails=3 fail_timeout=30s;
    server 192.168.1.11:3000 max_fails=3 fail_timeout=30s;
    server 192.168.1.12:3000 backup;  # Only used if others fail
}
```

### HAProxy Load Balancer

```haproxy
# /etc/haproxy/haproxy.cfg
frontend http_front
    bind *:80
    default_backend http_back

backend http_back
    balance roundrobin
    option httpchk GET /health
    server server1 192.168.1.10:3000 check
    server server2 192.168.1.11:3000 check
    server server3 192.168.1.12:3000 check
```

## API Gateways

Centralized entry point for all API traffic.

### What API Gateways Do

```
Client -> API Gateway -> Microservice A
                      -> Microservice B
                      -> Microservice C
```

**Functions**:
1. **Routing** - Direct requests to correct service
2. **Authentication** - Verify API keys, JWT tokens
3. **Rate limiting** - Prevent abuse
4. **Request/response transformation** - Modify data
5. **Logging/monitoring** - Track all API calls
6. **Caching** - Cache frequent responses
7. **Load balancing** - Distribute across instances
8. **Circuit breaking** - Stop cascading failures

### API Gateway vs Reverse Proxy

| Feature | Reverse Proxy | API Gateway |
|---------|--------------|-------------|
| Routing | Basic | Advanced (path-based, header-based) |
| Auth | Basic | JWT, OAuth, API keys |
| Rate limiting | Basic | Advanced (per-user, per-endpoint) |
| Transformation | No | Yes |
| Analytics | Basic | Detailed |
| Use case | General | APIs/Microservices |

### Common API Gateways

- **Kong** - Open-source, plugin-based (detailed below)
- **AWS API Gateway** - Managed AWS service
- **Azure API Management** - Microsoft managed service
- **Apigee** - Google Cloud (enterprise)
- **Tyk** - Open-source, Go-based
- **KrakenD** - Ultra-fast, stateless

## Kong API Gateway (Detailed)

Kong is the most popular open-source API gateway, built on Nginx.

### Kong Architecture

```
Client -> Kong Gateway -> Upstream Services
          (plugins)
          (database: PostgreSQL/Cassandra)
```

**Components**:
- **Kong Gateway** - Core proxy engine
- **Admin API** - Configure Kong (port 8001)
- **Proxy** - Handle client traffic (port 8000/8443)
- **Database** - Store configuration (PostgreSQL recommended)

### Installation

```bash
# Docker (quickest)
docker run -d --name kong \
  -e "KONG_DATABASE=off" \
  -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
  -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
  -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
  -p 8000:8000 \
  -p 8443:8443 \
  -p 8001:8001 \
  kong:latest

# Ubuntu/Debian
echo "deb [trusted=yes] https://packages.konghq.com/public/kong-gateway-oss/deb/ubuntu $(lsb_release -sc) main" \
  | sudo tee /etc/apt/sources.list.d/kong.list
sudo apt update
sudo apt install kong
```

### Kong Core Concepts

#### 1. Services

Upstream API or microservice.

```bash
# Create service
curl -i -X POST http://localhost:8001/services \
  --data name=my-service \
  --data url='http://example.com'
```

```python
# Python
import requests

service = {
    "name": "users-service",
    "url": "http://localhost:3000"
}
requests.post("http://localhost:8001/services", json=service)
```

#### 2. Routes

How clients reach services.

```bash
# Create route for service
curl -i -X POST http://localhost:8001/services/my-service/routes \
  --data 'paths[]=/api/users' \
  --data name=users-route
```

Now `http://kong:8000/api/users` routes to `http://localhost:3000`

#### 3. Consumers

API clients/users.

```bash
# Create consumer
curl -i -X POST http://localhost:8001/consumers \
  --data username=alice
```

#### 4. Plugins

Add functionality to services/routes.

```bash
# Add rate limiting
curl -i -X POST http://localhost:8001/services/my-service/plugins \
  --data name=rate-limiting \
  --data config.minute=100 \
  --data config.policy=local
```

### Kong Plugins (Popular Ones)

**Authentication**:
- `key-auth` - API key authentication
- `jwt` - JWT token validation
- `oauth2` - OAuth 2.0 flow
- `basic-auth` - Basic HTTP auth

**Security**:
- `cors` - CORS headers
- `ip-restriction` - Allow/deny IPs
- `bot-detection` - Block bots
- `acl` - Access control lists

**Traffic Control**:
- `rate-limiting` - Request rate limits
- `request-size-limiting` - Max request size
- `response-ratelimiting` - Limit by response

**Transformations**:
- `request-transformer` - Modify requests
- `response-transformer` - Modify responses
- `correlation-id` - Add tracking IDs

**Analytics & Monitoring**:
- `prometheus` - Metrics export
- `datadog` - Datadog integration
- `file-log` - Log to file

**Caching**:
- `proxy-cache` - Cache responses

### Kong Example: Full API Setup

```bash
# 1. Create service
curl -X POST http://localhost:8001/services \
  --data name=user-api \
  --data url='http://localhost:3000'

# 2. Create route
curl -X POST http://localhost:8001/services/user-api/routes \
  --data 'paths[]=/users'

# 3. Add API key authentication
curl -X POST http://localhost:8001/services/user-api/plugins \
  --data name=key-auth

# 4. Add rate limiting (100 req/min)
curl -X POST http://localhost:8001/services/user-api/plugins \
  --data name=rate-limiting \
  --data config.minute=100

# 5. Create consumer
curl -X POST http://localhost:8001/consumers \
  --data username=app-client

# 6. Create API key for consumer
curl -X POST http://localhost:8001/consumers/app-client/key-auth \
  --data key=my-secret-api-key
```

**Test it**:
```bash
# Without API key - fails
curl -i http://localhost:8000/users

# With API key - works
curl -i http://localhost:8000/users \
  -H 'apikey: my-secret-api-key'
```

### Kong Configuration with Python

```python
import requests

KONG_ADMIN = "http://localhost:8001"

# Create service
service = requests.post(f"{KONG_ADMIN}/services", json={
    "name": "product-api",
    "url": "http://localhost:4000"
}).json()

# Create route
route = requests.post(f"{KONG_ADMIN}/services/product-api/routes", json={
    "paths": ["/products"],
    "methods": ["GET", "POST"]
}).json()

# Add JWT plugin
jwt_plugin = requests.post(f"{KONG_ADMIN}/services/product-api/plugins", json={
    "name": "jwt"
}).json()

# Add rate limiting
rate_limit = requests.post(f"{KONG_ADMIN}/services/product-api/plugins", json={
    "name": "rate-limiting",
    "config": {
        "minute": 100,
        "hour": 1000,
        "policy": "local"
    }
}).json()

print("Kong configured!")
```

### Kong vs Other Gateways

| Feature | Kong | AWS API Gateway | Tyk |
|---------|------|----------------|-----|
| **Open Source** | Yes | No | Yes |
| **Self-hosted** | Yes | No | Yes |
| **Cloud** | Kong Cloud | AWS only | Tyk Cloud |
| **Plugins** | 100+ | Limited | Many |
| **Performance** | Excellent | Good | Excellent |
| **Learning curve** | Medium | Easy | Medium |
| **Cost** | Free (OSS) | Pay per request | Free (OSS) |

### Kong Use Cases

1. **Microservices Gateway**
   - Route to different services
   - Centralized authentication
   - Rate limiting per service

2. **API Versioning**
   ```bash
   # v1 route
   curl -X POST http://localhost:8001/routes \
     --data 'paths[]=/v1/users' \
     --data 'service.id=service-v1'

   # v2 route
   curl -X POST http://localhost:8001/routes \
     --data 'paths[]=/v2/users' \
     --data 'service.id=service-v2'
   ```

3. **Legacy System Modernization**
   - Add authentication to legacy APIs
   - Rate limit old systems
   - Transform requests/responses

4. **Multi-tenant SaaS**
   - Different rate limits per tenant
   - Tenant-specific routing
   - Per-tenant analytics

### Kong Declarative Configuration

Instead of API calls, use YAML config (Kong 1.1+).

```yaml
# kong.yml
_format_version: "3.0"

services:
  - name: user-service
    url: http://localhost:3000
    routes:
      - name: user-route
        paths:
          - /users
    plugins:
      - name: rate-limiting
        config:
          minute: 100
      - name: key-auth

consumers:
  - username: app-client
    keyauth_credentials:
      - key: my-secret-key
```

```bash
# Apply config
kong config db_import kong.yml
```

## CDN (Content Delivery Network)

Distributed network of servers that cache content close to users.

### How CDN Works

```
User in Europe -> European CDN node (cached)
User in Asia   -> Asian CDN node (cached)
                       ↓ (if not cached)
                  Origin Server
```

### Benefits

1. **Speed** - Content served from nearby servers
2. **Reduced load** - Origin server handles less traffic
3. **DDoS protection** - Absorb malicious traffic
4. **Availability** - Content available if origin down

### Popular CDNs

- **Cloudflare** - Free tier, DDoS protection
- **AWS CloudFront** - Integrates with AWS
- **Fastly** - Real-time purging
- **Akamai** - Enterprise, huge network
- **Cloudinary** - Specialized for images/video

### When to Use CDN

✅ **Use CDN for**:
- Static assets (images, CSS, JS)
- Global user base
- High traffic sites
- Video streaming

❌ **Don't need CDN for**:
- Local/regional users only
- Dynamic personalized content
- Low traffic sites
- Internal tools

## NAT (Network Address Translation)

Allows multiple devices to share one public IP.

```
Private IPs (192.168.1.x) -> Router (NAT) -> Public IP -> Internet
```

**Types**:
- **SNAT** (Source NAT) - Modify source IP (typical home router)
- **DNAT** (Destination NAT) - Modify destination IP (port forwarding)
- **PAT** (Port Address Translation) - Most common, uses ports

### Port Forwarding Example

```
External: 203.0.113.5:80 -> NAT -> Internal: 192.168.1.10:8080
```

Allows accessing internal server from internet.

## VPN (Virtual Private Network)

Encrypted tunnel between client and server.

### How VPN Works

```
Your Device -> Encrypted Tunnel (VPN) -> VPN Server -> Internet
             (ISP can't see traffic)
```

### VPN Types

1. **Remote Access VPN** - Connect to corporate network
2. **Site-to-Site VPN** - Connect two offices
3. **SSL/TLS VPN** - Browser-based (no client)

### Common VPN Protocols

- **WireGuard** - Modern, fast, simple
- **OpenVPN** - Popular, open-source
- **IPSec** - Secure, complex
- **L2TP/IPSec** - Common, older

### VPN Use Cases

- Access company resources remotely
- Hide browsing from ISP
- Access geo-restricted content
- Secure public WiFi usage

## Real-World Architecture Examples

### Simple Web App

```
Internet -> Nginx (reverse proxy, SSL) -> App Server
```

### Microservices with Kong

```
Internet -> Kong Gateway (auth, rate limit)
              ├── User Service (Python)
              ├── Product Service (Ruby)
              └── Order Service (Node.js)
```

### High Availability Setup

```
Internet -> CDN (Cloudflare)
              ↓
        Load Balancer (HAProxy)
         ├── Nginx 1 -> App Server 1
         ├── Nginx 2 -> App Server 2
         └── Nginx 3 -> App Server 3
                           ↓
                      Database (Primary + Replica)
```

### Enterprise API Platform

```
Internet -> WAF (Security)
              ↓
           Kong API Gateway
         ├── Plugin: Authentication
         ├── Plugin: Rate Limiting
         ├── Plugin: Logging
         └── Plugin: Caching
              ↓
        Service Mesh (Istio/Linkerd)
         ├── Service A (multiple instances)
         ├── Service B (multiple instances)
         └── Service C (multiple instances)
```

## Quick Comparison

| Technology | Purpose | Example |
|------------|---------|---------|
| **Forward Proxy** | Hide client | Squid, corporate proxy |
| **Reverse Proxy** | Hide backend | Nginx, Apache |
| **Load Balancer** | Distribute traffic | HAProxy, AWS ELB |
| **API Gateway** | API management | Kong, AWS API Gateway |
| **CDN** | Cache globally | Cloudflare, CloudFront |
| **NAT** | Share public IP | Home router |
| **VPN** | Encrypted tunnel | WireGuard, OpenVPN |

## Key Takeaways

1. **Forward proxy** - Client knows, server doesn't
2. **Reverse proxy** - Server knows, client doesn't
3. **Load balancing** - Distribute across multiple servers
4. **API Gateway** - Reverse proxy + auth + rate limiting + more
5. **Kong** - Most popular open-source API gateway
6. **Health checks** - Essential for load balancing
7. **Sticky sessions** - Same client to same server
8. **CDN** - Cache content close to users
9. **Choose the right tool** - Don't over-engineer

**Remember**: Start simple (reverse proxy), add complexity (load balancer, API gateway) only when needed!
