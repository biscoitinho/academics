## Linux Networking

Comprehensive guide to network setup, usage, and debugging.

### Basic Network Commands

#### ip - Modern network configuration

```bash
# Show all interfaces
ip addr show
ip a

# Show specific interface
ip addr show eth0

# Show routing table
ip route show
ip route

# Show ARP cache
ip neigh show
ip neigh

# Show network statistics
ip -s link
```

#### ifconfig - Legacy network configuration

```bash
# Show all interfaces
ifconfig

# Show specific interface
ifconfig eth0

# Bring interface up/down
sudo ifconfig eth0 up
sudo ifconfig eth0 down

# Assign IP address
sudo ifconfig eth0 192.168.1.100 netmask 255.255.255.0
```

### Network Interface Management

#### Bring interface up/down

```bash
# Modern way (ip command)
sudo ip link set eth0 up
sudo ip link set eth0 down

# Alternative (ifconfig)
sudo ifconfig eth0 up
sudo ifconfig eth0 down

# Alternative (nmcli - NetworkManager)
nmcli device disconnect eth0
nmcli device connect eth0
```

#### Assign IP address

```bash
# Temporary (lost on reboot)
sudo ip addr add 192.168.1.100/24 dev eth0

# Remove IP address
sudo ip addr del 192.168.1.100/24 dev eth0

# DHCP (NetworkManager)
sudo dhclient eth0
nmcli device connect eth0
```

#### Set default gateway

```bash
# Add default route
sudo ip route add default via 192.168.1.1

# Delete default route
sudo ip route del default

# Show current gateway
ip route | grep default
```

### DNS Configuration

#### /etc/resolv.conf

```bash
# View DNS servers
cat /etc/resolv.conf

# Example content:
nameserver 8.8.8.8
nameserver 8.8.4.4
search example.com
```

#### systemd-resolved

```bash
# Check DNS status
resolvectl status

# Flush DNS cache
sudo resolvectl flush-caches

# Query DNS
resolvectl query google.com
```

### Testing Connectivity

#### ping - Test reachability

```bash
# Ping host
ping google.com
ping 8.8.8.8

# Ping specific count
ping -c 4 google.com

# Ping with interval
ping -i 2 google.com

# Ping with timeout
ping -W 2 google.com
```

#### traceroute - Trace packet path

```bash
# Trace route to host
traceroute google.com

# With UDP (default)
traceroute google.com

# With ICMP
traceroute -I google.com

# With TCP
traceroute -T google.com
```

#### netcat (nc) - Network Swiss Army knife

```bash
# Test port connectivity
nc -zv google.com 80
nc -zv 192.168.1.1 22

# Port scan
nc -zv 192.168.1.1 20-80

# Listen on port
nc -l 8080

# Send data to port
echo "Hello" | nc localhost 8080

# Transfer file
# Receiver:
nc -l 8080 > received_file
# Sender:
nc 192.168.1.100 8080 < file_to_send
```

### Network Diagnostics

#### ss - Socket statistics (modern)

```bash
# Show all sockets
ss -a

# Show listening ports
ss -l

# Show TCP connections
ss -t

# Show UDP connections
ss -u

# Show listening TCP ports
ss -tln

# Show process using port
ss -tlnp

# Show specific port
ss -tln | grep :80
```

#### netstat - Network statistics (legacy)

```bash
# Show all connections
netstat -a

# Show listening ports
netstat -l

# Show listening TCP ports with PID
netstat -tlnp

# Show routing table
netstat -r

# Show network statistics
netstat -s
```

#### lsof - List open files/ports

```bash
# Show network connections
lsof -i

# Show specific port
lsof -i :80
lsof -i :22

# Show process listening on port
sudo lsof -i -P -n | grep LISTEN

# Show connections for specific process
lsof -p 1234
```

### Network Configuration Files

#### /etc/network/interfaces (Debian/Ubuntu)

```bash
# Static IP
auto eth0
iface eth0 inet static
    address 192.168.1.100
    netmask 255.255.255.0
    gateway 192.168.1.1
    dns-nameservers 8.8.8.8 8.8.4.4

# DHCP
auto eth0
iface eth0 inet dhcp

# Restart networking
sudo systemctl restart networking
```

#### /etc/sysconfig/network-scripts/ifcfg-eth0 (RHEL/CentOS)

```bash
DEVICE=eth0
BOOTPROTO=static
ONBOOT=yes
IPADDR=192.168.1.100
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS1=8.8.8.8
DNS2=8.8.4.4

# Restart networking
sudo systemctl restart network
```

#### Netplan (Ubuntu 18.04+)

```yaml
# /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: false
      addresses:
        - 192.168.1.100/24
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]

# Apply configuration
sudo netplan apply

# Test configuration
sudo netplan try
```

### Network Manager (nmcli)

```bash
# Show connections
nmcli connection show

# Show devices
nmcli device status

# Connect to WiFi
nmcli device wifi connect "SSID" password "password"

# Show WiFi networks
nmcli device wifi list

# Create new connection
nmcli connection add type ethernet con-name eth0-static \
  ifname eth0 ip4 192.168.1.100/24 gw4 192.168.1.1

# Modify connection
nmcli connection modify eth0-static ipv4.dns "8.8.8.8 8.8.4.4"

# Activate connection
nmcli connection up eth0-static

# Deactivate connection
nmcli connection down eth0-static
```

### Firewall (iptables)

```bash
# Show rules
sudo iptables -L -n -v

# Allow incoming SSH
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow incoming HTTP/HTTPS
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Block IP address
sudo iptables -A INPUT -s 192.168.1.100 -j DROP

# Delete rule by number
sudo iptables -L --line-numbers
sudo iptables -D INPUT 3

# Save rules
sudo iptables-save > /etc/iptables/rules.v4

# Restore rules
sudo iptables-restore < /etc/iptables/rules.v4
```

### Firewall (ufw - Ubuntu)

```bash
# Enable firewall
sudo ufw enable

# Disable firewall
sudo ufw disable

# Check status
sudo ufw status
sudo ufw status verbose

# Allow port
sudo ufw allow 22
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Deny port
sudo ufw deny 23

# Allow from specific IP
sudo ufw allow from 192.168.1.100

# Delete rule
sudo ufw delete allow 80

# Reset firewall
sudo ufw reset
```

### Firewall (firewalld - RHEL/CentOS)

```bash
# Check status
sudo firewall-cmd --state

# List zones
sudo firewall-cmd --get-zones

# List active zones
sudo firewall-cmd --get-active-zones

# Add service
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --add-service=https --permanent

# Add port
sudo firewall-cmd --add-port=8080/tcp --permanent

# Remove service
sudo firewall-cmd --remove-service=http --permanent

# Reload firewall
sudo firewall-cmd --reload

# List all rules
sudo firewall-cmd --list-all
```

### Network Bandwidth Monitoring

```bash
# iftop - Real-time bandwidth usage
sudo iftop

# nethogs - Per-process bandwidth
sudo nethogs

# vnstat - Network traffic monitor
vnstat
vnstat -h    # Hourly
vnstat -d    # Daily
vnstat -m    # Monthly

# nload - Network load
nload

# bmon - Bandwidth monitor
bmon
```

### Download/Upload Tools

```bash
# wget - Download files
wget https://example.com/file.zip
wget -O custom_name.zip https://example.com/file.zip
wget -c https://example.com/file.zip  # Continue

# curl - Transfer data
curl https://example.com
curl -O https://example.com/file.zip
curl -o custom_name.zip https://example.com/file.zip

# scp - Secure copy
scp file.txt user@remote:/path/
scp user@remote:/path/file.txt .
scp -r directory user@remote:/path/

# rsync - Sync files
rsync -avz source/ user@remote:/dest/
rsync -avz user@remote:/source/ dest/
rsync -avz --delete source/ dest/  # Delete in dest
```

### Network Troubleshooting

#### Check if port is open

```bash
# Using telnet
telnet google.com 80

# Using netcat
nc -zv google.com 80

# Using nmap
nmap -p 80 google.com
nmap -p 1-1000 192.168.1.1

# Using curl
curl -v telnet://google.com:80
```

#### Check DNS resolution

```bash
# nslookup
nslookup google.com
nslookup google.com 8.8.8.8

# dig
dig google.com
dig @8.8.8.8 google.com
dig google.com +short

# host
host google.com
host 8.8.8.8
```

#### Check routing

```bash
# Show routing table
ip route
route -n
netstat -rn

# Trace route
traceroute google.com
mtr google.com  # Better than traceroute

# Test specific route
ip route get 8.8.8.8
```

#### Network performance testing

```bash
# iperf3 - Bandwidth testing
# Server:
iperf3 -s

# Client:
iperf3 -c server_ip

# speedtest-cli - Internet speed test
speedtest-cli
```

### Common Network Issues

**Issue: No internet connectivity**
```bash
# Check interface is up
ip link show

# Check IP address
ip addr show

# Check routing
ip route

# Check DNS
cat /etc/resolv.conf
ping 8.8.8.8  # Test DNS server

# Check gateway
ping $(ip route | grep default | awk '{print $3}')
```

**Issue: Slow network**
```bash
# Check bandwidth usage
iftop
nethogs

# Check packet loss
ping -c 100 google.com

# Check MTU size
ip link show eth0

# Test with different MTU
ping -M do -s 1472 google.com
```

**Issue: DNS not resolving**
```bash
# Test DNS
nslookup google.com
dig google.com

# Check resolv.conf
cat /etc/resolv.conf

# Flush DNS cache
sudo systemd-resolve --flush-caches
# or
sudo resolvectl flush-caches

# Try different DNS
dig @8.8.8.8 google.com
```

### SSH Configuration

```bash
# Connect to remote host
ssh user@hostname
ssh user@192.168.1.100

# Connect with specific port
ssh -p 2222 user@hostname

# Connect with key
ssh -i ~/.ssh/id_rsa user@hostname

# Copy SSH key to remote
ssh-copy-id user@hostname

# SSH config (~/.ssh/config)
Host myserver
    HostName 192.168.1.100
    User admin
    Port 22
    IdentityFile ~/.ssh/id_rsa

# Connect using alias
ssh myserver
```

### Network Bridges

```bash
# Create bridge
sudo ip link add br0 type bridge

# Add interface to bridge
sudo ip link set eth0 master br0

# Show bridge
ip link show br0
brctl show
```

### VLANs

```bash
# Create VLAN
sudo ip link add link eth0 name eth0.10 type vlan id 10

# Assign IP to VLAN
sudo ip addr add 192.168.10.1/24 dev eth0.10

# Bring VLAN up
sudo ip link set eth0.10 up
```

### Network Bonding/Teaming

```bash
# Create bond
sudo ip link add bond0 type bond mode active-backup

# Add slaves to bond
sudo ip link set eth0 master bond0
sudo ip link set eth1 master bond0

# Bring bond up
sudo ip link set bond0 up
```
