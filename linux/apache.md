# Apache Configuration

Practical Apache HTTP Server configuration examples.

## Installation

```bash
# Debian/Ubuntu
sudo apt update
sudo apt install apache2

# RHEL/CentOS
sudo yum install httpd

# Start and enable
sudo systemctl start apache2    # Debian/Ubuntu
sudo systemctl start httpd      # RHEL/CentOS
sudo systemctl enable apache2   # Debian/Ubuntu
sudo systemctl enable httpd     # RHEL/CentOS
```

## Directory Structure

### Debian/Ubuntu
```
/etc/apache2/
├── apache2.conf            # Main config
├── sites-available/        # Available sites
├── sites-enabled/          # Enabled sites (symlinks)
├── mods-available/         # Available modules
├── mods-enabled/           # Enabled modules
├── conf-available/         # Available configs
└── conf-enabled/           # Enabled configs
```

### RHEL/CentOS
```
/etc/httpd/
├── conf/
│   └── httpd.conf         # Main config
├── conf.d/                # Additional configs
└── conf.modules.d/        # Module configs
```

## Basic Virtual Host (HTTP)

```apache
# /etc/apache2/sites-available/example.com.conf (Debian/Ubuntu)
# /etc/httpd/conf.d/example.com.conf (RHEL/CentOS)

<VirtualHost *:80>
    ServerName example.com
    ServerAlias www.example.com
    ServerAdmin admin@example.com

    DocumentRoot /var/www/example.com

    <Directory /var/www/example.com>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/example.com-error.log
    CustomLog ${APACHE_LOG_DIR}/example.com-access.log combined
</VirtualHost>
```

```bash
# Enable site (Debian/Ubuntu)
sudo a2ensite example.com.conf
sudo systemctl reload apache2

# RHEL/CentOS - Just restart
sudo systemctl restart httpd
```

## SSL/TLS Virtual Host (HTTPS)

```apache
# HTTP to HTTPS redirect
<VirtualHost *:80>
    ServerName example.com
    ServerAlias www.example.com
    Redirect permanent / https://example.com/
</VirtualHost>

# HTTPS virtual host
<VirtualHost *:443>
    ServerName example.com
    ServerAlias www.example.com
    ServerAdmin admin@example.com

    DocumentRoot /var/www/example.com

    # SSL Configuration
    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/example.com/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/example.com/privkey.pem

    # Modern SSL configuration
    SSLProtocol all -SSLv3 -TLSv1 -TLSv1.1
    SSLCipherSuite HIGH:!aNULL:!MD5
    SSLHonorCipherOrder on
    SSLCompression off
    SSLSessionTickets off

    # HSTS (optional)
    Header always set Strict-Transport-Security "max-age=31536000"

    <Directory /var/www/example.com>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/example.com-ssl-error.log
    CustomLog ${APACHE_LOG_DIR}/example.com-ssl-access.log combined
</VirtualHost>
```

```bash
# Enable SSL module (Debian/Ubuntu)
sudo a2enmod ssl
sudo systemctl restart apache2

# Get Let's Encrypt certificate
sudo apt install certbot python3-certbot-apache
sudo certbot --apache -d example.com -d www.example.com
```

## Reverse Proxy Configuration

```apache
# Enable required modules first
# Debian/Ubuntu:
sudo a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests headers

<VirtualHost *:80>
    ServerName app.example.com

    # Proxy to backend application
    ProxyPreserveHost On
    ProxyPass / http://localhost:3000/
    ProxyPassReverse / http://localhost:3000/

    # Proxy headers
    RequestHeader set X-Forwarded-Proto "http"
    RequestHeader set X-Forwarded-Port "80"

    ErrorLog ${APACHE_LOG_DIR}/proxy-error.log
    CustomLog ${APACHE_LOG_DIR}/proxy-access.log combined
</VirtualHost>

# HTTPS reverse proxy
<VirtualHost *:443>
    ServerName app.example.com

    SSLEngine on
    SSLCertificateFile /path/to/cert.pem
    SSLCertificateKeyFile /path/to/key.pem

    ProxyPreserveHost On
    ProxyPass / http://localhost:3000/
    ProxyPassReverse / http://localhost:3000/

    # SSL headers
    RequestHeader set X-Forwarded-Proto "https"
    RequestHeader set X-Forwarded-Port "443"
</VirtualHost>
```

## Load Balancing

```apache
# Enable modules
sudo a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests lbmethod_bytraffic

<Proxy balancer://mycluster>
    BalancerMember http://192.168.1.10:3000 route=1
    BalancerMember http://192.168.1.11:3000 route=2
    BalancerMember http://192.168.1.12:3000 route=3 status=+H  # Hot standby

    # Load balancing method
    ProxySet lbmethod=byrequests
    # Other methods: bytraffic, bybusyness, heartbeat
</Proxy>

<VirtualHost *:80>
    ServerName app.example.com

    ProxyPreserveHost On
    ProxyPass / balancer://mycluster/
    ProxyPassReverse / balancer://mycluster/

    # Sticky sessions (optional)
    Header add Set-Cookie "ROUTEID=.%{BALANCER_WORKER_ROUTE}e; path=/" env=BALANCER_ROUTE_CHANGED
</VirtualHost>
```

## PHP Configuration

```apache
# Install PHP module
sudo apt install libapache2-mod-php  # Debian/Ubuntu
sudo yum install php                  # RHEL/CentOS

<VirtualHost *:80>
    ServerName php.example.com
    DocumentRoot /var/www/php-site

    <Directory /var/www/php-site>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted

        # PHP settings
        php_value upload_max_filesize 20M
        php_value post_max_size 20M
        php_value memory_limit 256M
        php_value max_execution_time 300
    </Directory>

    # Default PHP handler
    <FilesMatch \.php$>
        SetHandler application/x-httpd-php
    </FilesMatch>

    # Deny access to sensitive files
    <FilesMatch "(\.htaccess|\.htpasswd|\.ini|\.log|\.sh|\.inc|\.bak)$">
        Require all denied
    </FilesMatch>
</VirtualHost>
```

## .htaccess Files

Enable `.htaccess` by setting `AllowOverride All` in the `<Directory>` block.

### Common .htaccess Examples

```apache
# Force HTTPS
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

# Remove www
RewriteEngine On
RewriteCond %{HTTP_HOST} ^www\.(.*)$ [NC]
RewriteRule ^(.*)$ https://%1/$1 [R=301,L]

# Pretty URLs (remove .php extension)
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule ^([^\.]+)$ $1.php [NC,L]

# Deny access to files
<FilesMatch "\.(?i:git|env|log)$">
    Require all denied
</FilesMatch>

# Custom error pages
ErrorDocument 404 /404.html
ErrorDocument 500 /500.html

# Enable compression
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css text/javascript application/javascript
</IfModule>

# Browser caching
<IfModule mod_expires.c>
    ExpiresActive On
    ExpiresByType image/jpg "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
    ExpiresByType image/gif "access plus 1 year"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType text/css "access plus 1 month"
    ExpiresByType application/javascript "access plus 1 month"
</IfModule>

# Prevent directory listing
Options -Indexes

# Password protection
AuthType Basic
AuthName "Restricted Area"
AuthUserFile /etc/apache2/.htpasswd
Require valid-user
```

## URL Rewriting (mod_rewrite)

```apache
# Enable module
sudo a2enmod rewrite

<VirtualHost *:80>
    ServerName example.com
    DocumentRoot /var/www/example.com

    <Directory /var/www/example.com>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted

        RewriteEngine On

        # Force HTTPS
        RewriteCond %{HTTPS} off
        RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

        # Redirect old URLs
        RewriteRule ^old-page\.html$ /new-page.html [R=301,L]

        # Remove trailing slash
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule ^(.*)/$ /$1 [R=301,L]

        # Route all to index.php (framework pattern)
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule ^(.*)$ index.php [QSA,L]
    </Directory>
</VirtualHost>
```

## Security Configuration

```apache
# Security headers
<IfModule mod_headers.c>
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-XSS-Protection "1; mode=block"
    Header always set Referrer-Policy "no-referrer-when-downgrade"
    Header always set Content-Security-Policy "default-src 'self'"
</IfModule>

# Hide Apache version
ServerTokens Prod
ServerSignature Off

# Disable TRACE method
TraceEnable Off

# Limit request size
LimitRequestBody 10485760  # 10MB

# IP-based access control
<Directory /var/www/admin>
    Require ip 192.168.1.0/24
    Require ip 10.0.0.0/8
</Directory>

# Deny access to sensitive directories
<DirectoryMatch "^/.*/\.(git|svn|hg)/">
    Require all denied
</DirectoryMatch>

# Disable directory browsing
<Directory /var/www>
    Options -Indexes
</Directory>
```

## Basic Authentication

```bash
# Create password file
sudo htpasswd -c /etc/apache2/.htpasswd username

# Add more users (without -c flag)
sudo htpasswd /etc/apache2/.htpasswd anotheruser
```

```apache
<Directory /var/www/admin>
    AuthType Basic
    AuthName "Admin Area"
    AuthUserFile /etc/apache2/.htpasswd
    Require valid-user
</Directory>

# Or in .htaccess
AuthType Basic
AuthName "Restricted Access"
AuthUserFile /var/www/.htpasswd
Require valid-user
```

## Performance Tuning

```apache
# /etc/apache2/apache2.conf (Debian/Ubuntu)
# /etc/httpd/conf/httpd.conf (RHEL/CentOS)

# Use event MPM (better than prefork)
# Enable with: sudo a2dismod mpm_prefork && sudo a2enmod mpm_event

<IfModule mpm_event_module>
    StartServers             2
    MinSpareThreads          25
    MaxSpareThreads          75
    ThreadLimit              64
    ThreadsPerChild          25
    MaxRequestWorkers        150
    MaxConnectionsPerChild   3000
</IfModule>

# Enable compression
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css
    AddOutputFilterByType DEFLATE text/javascript application/javascript application/json
</IfModule>

# Enable caching
<IfModule mod_expires.c>
    ExpiresActive On
    ExpiresDefault "access plus 1 month"
    ExpiresByType text/html "access plus 1 hour"
    ExpiresByType image/gif "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType text/css "access plus 1 month"
    ExpiresByType application/javascript "access plus 1 month"
</IfModule>

# Cache control headers
<IfModule mod_headers.c>
    <FilesMatch "\.(jpg|jpeg|png|gif|ico)$">
        Header set Cache-Control "max-age=31536000, public"
    </FilesMatch>
    <FilesMatch "\.(css|js)$">
        Header set Cache-Control "max-age=2592000, public"
    </FilesMatch>
</IfModule>

# Keep-Alive settings
KeepAlive On
MaxKeepAliveRequests 100
KeepAliveTimeout 5
```

## Common Apache Modules

```bash
# List enabled modules
apache2ctl -M           # Debian/Ubuntu
httpd -M                # RHEL/CentOS

# Enable module (Debian/Ubuntu)
sudo a2enmod rewrite    # URL rewriting
sudo a2enmod ssl        # SSL/TLS
sudo a2enmod headers    # HTTP headers
sudo a2enmod expires    # Expiration headers
sudo a2enmod deflate    # Compression
sudo a2enmod proxy      # Reverse proxy
sudo a2enmod proxy_http # HTTP proxy

# Disable module (Debian/Ubuntu)
sudo a2dismod module_name

# RHEL/CentOS - Edit /etc/httpd/conf.modules.d/
# Comment out LoadModule lines
```

## Log Configuration

```apache
# Define log format
LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
LogFormat "%h %l %u %t \"%r\" %>s %b" common

# Per-VirtualHost logs
<VirtualHost *:80>
    ServerName example.com

    ErrorLog ${APACHE_LOG_DIR}/example-error.log
    CustomLog ${APACHE_LOG_DIR}/example-access.log combined

    # Log level
    LogLevel warn
</VirtualHost>

# Rotate logs (using logrotate)
# /etc/logrotate.d/apache2
/var/log/apache2/*.log {
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    create 640 root adm
    sharedscripts
    postrotate
        systemctl reload apache2 > /dev/null
    endscript
}
```

## Multiple Sites on One Server

```apache
# Site 1
<VirtualHost *:80>
    ServerName site1.com
    DocumentRoot /var/www/site1
    <Directory /var/www/site1>
        Require all granted
    </Directory>
</VirtualHost>

# Site 2
<VirtualHost *:80>
    ServerName site2.com
    DocumentRoot /var/www/site2
    <Directory /var/www/site2>
        Require all granted
    </Directory>
</VirtualHost>

# Subdomain
<VirtualHost *:80>
    ServerName blog.site1.com
    DocumentRoot /var/www/blog
    <Directory /var/www/blog>
        Require all granted
    </Directory>
</VirtualHost>
```

## Common Commands

```bash
# Test configuration
sudo apache2ctl configtest   # Debian/Ubuntu
sudo apachectl configtest    # RHEL/CentOS

# Graceful reload (no downtime)
sudo systemctl reload apache2   # Debian/Ubuntu
sudo systemctl reload httpd     # RHEL/CentOS

# Restart
sudo systemctl restart apache2
sudo systemctl restart httpd

# Stop/Start
sudo systemctl stop apache2
sudo systemctl start apache2

# Check status
sudo systemctl status apache2

# View error log
sudo tail -f /var/log/apache2/error.log    # Debian/Ubuntu
sudo tail -f /var/log/httpd/error_log      # RHEL/CentOS

# View access log
sudo tail -f /var/log/apache2/access.log   # Debian/Ubuntu
sudo tail -f /var/log/httpd/access_log     # RHEL/CentOS

# List virtual hosts
sudo apache2ctl -S     # Debian/Ubuntu
sudo apachectl -S      # RHEL/CentOS

# Enable/disable sites (Debian/Ubuntu only)
sudo a2ensite example.com.conf
sudo a2dissite example.com.conf
```

## Troubleshooting

### Configuration Test Fails

```bash
# Test configuration
sudo apache2ctl configtest

# Common errors:
# - Syntax errors in config files
# - Missing modules
# - Duplicate VirtualHost definitions
# - Invalid directory paths
```

### Permission Denied

```bash
# Check file ownership
ls -la /var/www/

# Fix ownership
sudo chown -R www-data:www-data /var/www/site  # Debian/Ubuntu
sudo chown -R apache:apache /var/www/site      # RHEL/CentOS

# Fix permissions
sudo chmod -R 755 /var/www/site

# Check SELinux (RHEL/CentOS)
sudo setenforce 0  # Temporarily disable
sudo setsebool -P httpd_read_user_content 1
```

### Port Already in Use

```bash
# Check what's using port 80
sudo netstat -tulpn | grep :80
sudo lsof -i :80

# Stop conflicting service
sudo systemctl stop nginx
```

### 403 Forbidden

- Check directory permissions
- Check `Require all granted` in Directory block
- Verify DocumentRoot exists
- Check SELinux (RHEL/CentOS)

### 500 Internal Server Error

- Check error log
- Common causes: .htaccess syntax errors, PHP errors, permission issues

```bash
sudo tail -50 /var/log/apache2/error.log
```

## Apache vs Nginx

| Feature | Apache | Nginx |
|---------|--------|-------|
| **Configuration** | More verbose | More concise |
| **.htaccess** | Supported | Not supported |
| **Static files** | Good | Excellent |
| **Dynamic content** | Good (mod_php) | Good (proxy) |
| **Memory usage** | Higher | Lower |
| **Concurrent connections** | Good | Excellent |
| **Modules** | More available | Fewer |
| **Learning curve** | Easier | Moderate |

**Use Apache when**:
- Need .htaccess support
- Using shared hosting
- Need specific Apache modules
- Team familiar with Apache

**Use Nginx when**:
- High traffic expected
- Serving static files
- Need reverse proxy
- Memory is limited

## Quick Reference

**Config Files**:
- Debian/Ubuntu: `/etc/apache2/apache2.conf`
- RHEL/CentOS: `/etc/httpd/conf/httpd.conf`

**Document Root**: Usually `/var/www/` or `/var/www/html/`

**Logs**:
- Debian/Ubuntu: `/var/log/apache2/`
- RHEL/CentOS: `/var/log/httpd/`

**Common Directives**:
- `DocumentRoot` - Root directory for site
- `ServerName` - Primary domain name
- `ServerAlias` - Alternative domain names
- `Directory` - Per-directory configuration
- `Require all granted` - Allow access
- `Require all denied` - Deny access

**Remember**: Test configuration with `apache2ctl configtest` before reloading!
