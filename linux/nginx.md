# Nginx Configuration

Practical nginx web server configuration examples.

## Installation

```bash
# Debian/Ubuntu
sudo apt update
sudo apt install nginx

# RHEL/CentOS
sudo yum install nginx

# Start and enable
sudo systemctl start nginx
sudo systemctl enable nginx
```

## Directory Structure

```
/etc/nginx/
├── nginx.conf              # Main config
├── sites-available/        # Available sites
├── sites-enabled/          # Enabled sites (symlinks)
├── conf.d/                 # Additional configs
└── snippets/               # Reusable config snippets
```

## Basic nginx.conf

```nginx
user www-data;
worker_processes auto;
pid /run/nginx.pid;

events {
    worker_connections 1024;
    use epoll;
}

http {
    # Basic settings
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    # MIME types
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    # Logging
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml;

    # Virtual hosts
    include /etc/nginx/sites-enabled/*;
}
```

## Simple Static Site

```nginx
# /etc/nginx/sites-available/example.com
server {
    listen 80;
    listen [::]:80;
    server_name example.com www.example.com;

    root /var/www/example.com;
    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }

    # Deny access to hidden files
    location ~ /\. {
        deny all;
    }
}
```

```bash
# Enable site
sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

## SSL/TLS with Let's Encrypt

```nginx
# HTTP to HTTPS redirect
server {
    listen 80;
    listen [::]:80;
    server_name example.com www.example.com;
    return 301 https://$server_name$request_uri;
}

# HTTPS server
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name example.com www.example.com;

    # SSL certificates
    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

    # SSL configuration
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    root /var/www/example.com;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

```bash
# Get Let's Encrypt certificate
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d example.com -d www.example.com
```

## Reverse Proxy (Node.js, Python, Ruby)

```nginx
# Proxy to backend application
server {
    listen 80;
    server_name app.example.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;

        # Proxy headers
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # WebSocket support
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";

        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
}
```

## Load Balancing

```nginx
# Define upstream servers
upstream backend {
    least_conn;  # Load balancing method

    server 192.168.1.10:3000 weight=3;
    server 192.168.1.11:3000 weight=2;
    server 192.168.1.12:3000 weight=1;
    server 192.168.1.13:3000 backup;  # Backup server
}

server {
    listen 80;
    server_name app.example.com;

    location / {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

**Load balancing methods**:
- `round_robin` (default) - Distribute requests evenly
- `least_conn` - Send to server with fewest connections
- `ip_hash` - Same client always goes to same server

## PHP-FPM Configuration

```nginx
server {
    listen 80;
    server_name php.example.com;
    root /var/www/php-app;
    index index.php index.html;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    # PHP processing
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    # Deny access to .php files in specific directories
    location ~* /(?:uploads|files)/.*\.php$ {
        deny all;
    }

    # Deny access to hidden files
    location ~ /\. {
        deny all;
    }
}
```

## Static Files & Caching

```nginx
server {
    listen 80;
    server_name static.example.com;
    root /var/www/static;

    # Cache static assets
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        access_log off;
    }

    # Serve precompressed files
    location ~* \.(css|js)$ {
        gzip_static on;
        expires max;
        add_header Cache-Control "public";
    }
}
```

## Rate Limiting

```nginx
# Define rate limit zone
http {
    limit_req_zone $binary_remote_addr zone=api_limit:10m rate=10r/s;
    limit_req_zone $binary_remote_addr zone=login_limit:10m rate=5r/m;
}

server {
    listen 80;
    server_name api.example.com;

    # Apply rate limit to API
    location /api/ {
        limit_req zone=api_limit burst=20 nodelay;
        proxy_pass http://localhost:3000;
    }

    # Strict rate limit for login
    location /login {
        limit_req zone=login_limit burst=5;
        proxy_pass http://localhost:3000;
    }
}
```

## Security Headers

```nginx
server {
    listen 443 ssl http2;
    server_name secure.example.com;

    # Security headers
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' https:;" always;

    # Hide nginx version
    server_tokens off;

    location / {
        proxy_pass http://localhost:3000;
    }
}
```

## Basic Authentication

```nginx
server {
    listen 80;
    server_name admin.example.com;

    # Protect entire site
    auth_basic "Restricted Access";
    auth_basic_user_file /etc/nginx/.htpasswd;

    # Or protect specific location
    location /admin {
        auth_basic "Admin Area";
        auth_basic_user_file /etc/nginx/.htpasswd;
        proxy_pass http://localhost:3000;
    }
}
```

```bash
# Create password file
sudo apt install apache2-utils
sudo htpasswd -c /etc/nginx/.htpasswd username
```

## Custom Error Pages

```nginx
server {
    listen 80;
    server_name example.com;

    # Custom error pages
    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;

    location = /404.html {
        root /var/www/errors;
        internal;
    }

    location = /50x.html {
        root /var/www/errors;
        internal;
    }
}
```

## Redirects

```nginx
server {
    listen 80;
    server_name example.com;

    # Redirect www to non-www
    if ($host = www.example.com) {
        return 301 https://example.com$request_uri;
    }

    # Redirect old URLs
    rewrite ^/old-page$ /new-page permanent;
    rewrite ^/blog/(.*)$ /articles/$1 permanent;

    # Redirect to HTTPS
    return 301 https://$server_name$request_uri;
}
```

## Multiple Applications on Same Server

```nginx
# Main site
server {
    listen 80;
    server_name example.com;
    root /var/www/main-site;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}

# Blog subdomain
server {
    listen 80;
    server_name blog.example.com;

    location / {
        proxy_pass http://localhost:3000;
    }
}

# API subdomain
server {
    listen 80;
    server_name api.example.com;

    location / {
        proxy_pass http://localhost:4000;
    }
}
```

## WebSocket Support

```nginx
server {
    listen 80;
    server_name ws.example.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_read_timeout 86400;
    }
}
```

## Common Commands

```bash
# Test configuration
sudo nginx -t

# Reload without downtime
sudo nginx -s reload
# or
sudo systemctl reload nginx

# Restart
sudo systemctl restart nginx

# Stop
sudo systemctl stop nginx

# Check status
sudo systemctl status nginx

# View error log
sudo tail -f /var/log/nginx/error.log

# View access log
sudo tail -f /var/log/nginx/access.log

# Enable site
sudo ln -s /etc/nginx/sites-available/site /etc/nginx/sites-enabled/

# Disable site
sudo rm /etc/nginx/sites-enabled/site
```

## Performance Tuning

```nginx
# /etc/nginx/nginx.conf
worker_processes auto;
worker_rlimit_nofile 65535;

events {
    worker_connections 4096;
    use epoll;
    multi_accept on;
}

http {
    # Buffers
    client_body_buffer_size 128k;
    client_max_body_size 10m;
    client_header_buffer_size 1k;
    large_client_header_buffers 4 4k;
    output_buffers 1 32k;
    postpone_output 1460;

    # Timeouts
    client_body_timeout 12;
    client_header_timeout 12;
    keepalive_timeout 15;
    send_timeout 10;

    # Gzip
    gzip on;
    gzip_comp_level 5;
    gzip_min_length 256;
    gzip_proxied any;
    gzip_vary on;
    gzip_types text/plain text/css application/json application/javascript;

    # Open file cache
    open_file_cache max=200000 inactive=20s;
    open_file_cache_valid 30s;
    open_file_cache_min_uses 2;
    open_file_cache_errors on;
}
```

## Troubleshooting

### Permission Denied

```bash
# Check nginx user
ps aux | grep nginx

# Fix permissions
sudo chown -R www-data:www-data /var/www/site
sudo chmod -R 755 /var/www/site
```

### Port Already in Use

```bash
# Check what's using port 80
sudo netstat -tulpn | grep :80
sudo lsof -i :80

# Kill process
sudo systemctl stop apache2  # If Apache is running
```

### Configuration Test Fails

```bash
# Test config and see errors
sudo nginx -t

# Common issues:
# - Missing semicolons
# - Unclosed brackets
# - Invalid directives
# - Typos in file paths
```

### 502 Bad Gateway

- Backend application not running
- Wrong proxy_pass port
- Firewall blocking connection
- Backend crashed

```bash
# Check backend is running
sudo systemctl status your-app

# Check nginx error log
sudo tail -f /var/log/nginx/error.log
```

## Security Best Practices

```nginx
# Disable unused HTTP methods
if ($request_method !~ ^(GET|HEAD|POST)$ ) {
    return 405;
}

# Limit request size
client_max_body_size 10m;

# Hide server version
server_tokens off;

# Prevent clickjacking
add_header X-Frame-Options "SAMEORIGIN" always;

# Prevent MIME sniffing
add_header X-Content-Type-Options "nosniff" always;

# Enable XSS filter
add_header X-XSS-Protection "1; mode=block" always;

# Deny access to sensitive files
location ~ /\.(git|env|htaccess) {
    deny all;
}
```

## SSL Best Practices

```nginx
# Modern SSL configuration
ssl_protocols TLSv1.2 TLSv1.3;
ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384';
ssl_prefer_server_ciphers off;

# OCSP Stapling
ssl_stapling on;
ssl_stapling_verify on;
ssl_trusted_certificate /etc/letsencrypt/live/example.com/chain.pem;

# Session cache
ssl_session_cache shared:SSL:50m;
ssl_session_timeout 1d;
ssl_session_tickets off;

# HSTS
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
```

## Quick Reference

**Common Locations**:
- Config: `/etc/nginx/nginx.conf`
- Sites: `/etc/nginx/sites-available/`
- Logs: `/var/log/nginx/`

**Key Variables**:
- `$host` - Hostname from request
- `$uri` - Current URI
- `$remote_addr` - Client IP
- `$scheme` - http or https
- `$request_uri` - Full original request URI
- `$server_name` - Server name

**Useful Snippets**:
- Force HTTPS: `return 301 https://$server_name$request_uri;`
- Deny all: `deny all;`
- Allow IP: `allow 192.168.1.0/24;`
- Block user agent: `if ($http_user_agent ~* (bot|crawler)) { return 403; }`

**Remember**: Always test config with `nginx -t` before reloading!
