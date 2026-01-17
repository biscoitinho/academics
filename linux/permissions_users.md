## Linux Permissions and Users

### File Permissions

#### Understanding permissions

```bash
ls -l file.txt
# -rw-r--r-- 1 user group 1234 Jan 1 12:00 file.txt
# |  |  |  |
# |  |  |  └── Others (world)
# |  |  └───── Group
# |  └──────── User (owner)
# └──────────── File type (- = file, d = directory, l = link)

# Permission values:
# r = read (4)
# w = write (2)
# x = execute (1)
```

#### chmod - Change permissions

```bash
# Symbolic mode
chmod u+x file.txt      # Add execute for user
chmod g+w file.txt      # Add write for group
chmod o-r file.txt      # Remove read for others
chmod a+x file.txt      # Add execute for all

# Numeric mode
chmod 755 file.txt      # rwxr-xr-x
chmod 644 file.txt      # rw-r--r--
chmod 600 file.txt      # rw-------
chmod 777 file.txt      # rwxrwxrwx (dangerous!)

# Recursive
chmod -R 755 directory/

# Common permissions:
# 644 - Files (rw-r--r--)
# 755 - Directories and executables (rwxr-xr-x)
# 600 - Private files (rw-------)
# 700 - Private directories (rwx------)
```

#### chown - Change ownership

```bash
# Change owner
sudo chown user file.txt

# Change owner and group
sudo chown user:group file.txt

# Change only group
sudo chown :group file.txt
# or
sudo chgrp group file.txt

# Recursive
sudo chown -R user:group directory/
```

#### Special permissions

```bash
# SUID (Set User ID) - 4000
# Runs with owner's permissions
chmod u+s file
chmod 4755 file

# SGID (Set Group ID) - 2000
# Runs with group's permissions
# New files inherit directory group
chmod g+s directory
chmod 2755 directory

# Sticky bit - 1000
# Only owner can delete files
chmod +t directory
chmod 1777 directory

# Example: /tmp has sticky bit
ls -ld /tmp
# drwxrwxrwt
```

#### umask - Default permissions

```bash
# Show current umask
umask

# Set umask
umask 022    # New files: 644, directories: 755
umask 027    # New files: 640, directories: 750

# Calculate permissions:
# Files: 666 - umask
# Directories: 777 - umask
```

### User Management

#### Creating users

```bash
# Create user
sudo useradd username
sudo useradd -m username          # Create home directory
sudo useradd -m -s /bin/bash username  # With shell

# Create user with specific UID
sudo useradd -u 1500 username

# Set password
sudo passwd username

# Create user interactively
sudo adduser username  # Debian/Ubuntu
```

#### Modifying users

```bash
# Change shell
sudo usermod -s /bin/zsh username

# Add to group
sudo usermod -aG group username
sudo usermod -aG sudo username    # Add to sudo group

# Change home directory
sudo usermod -d /new/home username

# Change username
sudo usermod -l newname oldname

# Lock/unlock user
sudo usermod -L username  # Lock
sudo usermod -U username  # Unlock
```

#### Deleting users

```bash
# Delete user
sudo userdel username

# Delete user and home directory
sudo userdel -r username

# Delete user and all files
sudo userdel -r -f username
```

#### User information

```bash
# Current user
whoami
id

# User information
id username
finger username
getent passwd username

# Last login
last
lastlog
```

### Group Management

#### Creating groups

```bash
# Create group
sudo groupadd groupname

# Create with specific GID
sudo groupadd -g 1500 groupname
```

#### Modifying groups

```bash
# Add user to group
sudo usermod -aG groupname username
sudo gpasswd -a username groupname

# Remove user from group
sudo gpasswd -d username groupname

# Change group name
sudo groupmod -n newname oldname
```

#### Deleting groups

```bash
sudo groupdel groupname
```

#### Group information

```bash
# Show groups for user
groups username
id username

# Show all groups
cat /etc/group
getent group

# Show group members
getent group groupname
```

### sudo - Super user do

#### /etc/sudoers

```bash
# Edit sudoers file (ALWAYS use visudo!)
sudo visudo

# Grant full sudo access
username ALL=(ALL:ALL) ALL

# Grant specific command
username ALL=(ALL) /usr/bin/systemctl

# No password required
username ALL=(ALL) NOPASSWD: ALL

# Group access
%groupname ALL=(ALL:ALL) ALL
```

#### sudo usage

```bash
# Run command as root
sudo command

# Run command as another user
sudo -u username command

# Run shell as root
sudo -i      # Login shell
sudo -s      # Current shell

# Run previous command with sudo
sudo !!

# Edit file as root
sudo nano /etc/config
sudoedit /etc/config  # Better - uses EDITOR
```

### ACL - Access Control Lists

```bash
# View ACL
getfacl file.txt

# Set ACL for user
setfacl -m u:username:rwx file.txt

# Set ACL for group
setfacl -m g:groupname:rx file.txt

# Set default ACL for directory
setfacl -d -m u:username:rwx directory/

# Remove specific ACL
setfacl -x u:username file.txt

# Remove all ACL
setfacl -b file.txt

# Copy ACL from one file to another
getfacl file1 | setfacl --set-file=- file2
```

### File Attributes

```bash
# View attributes
lsattr file.txt

# Set immutable (cannot be deleted/modified)
sudo chattr +i file.txt

# Remove immutable
sudo chattr -i file.txt

# Append only
sudo chattr +a file.txt

# Common attributes:
# i - Immutable
# a - Append only
# c - Compressed
# s - Secure deletion
# u - Undeletable
```

### Password Management

```bash
# Change password
passwd
sudo passwd username

# Force password change at next login
sudo passwd -e username
sudo chage -d 0 username

# Password expiry
sudo chage -l username         # View
sudo chage -M 90 username      # Max 90 days
sudo chage -m 7 username       # Min 7 days
sudo chage -W 14 username      # Warn 14 days before

# Lock/unlock account
sudo passwd -l username  # Lock
sudo passwd -u username  # Unlock

# Password aging
/etc/login.defs         # Default settings
```

### Configuration Files

```bash
# User accounts
/etc/passwd
# Format: username:x:UID:GID:comment:home:shell

# User passwords (hashed)
/etc/shadow
# Format: username:hash:lastchange:min:max:warn:inactive:expire

# Groups
/etc/group
# Format: groupname:x:GID:members

# Group passwords
/etc/gshadow

# Sudo configuration
/etc/sudoers
/etc/sudoers.d/

# Login defaults
/etc/login.defs

# User skeleton files
/etc/skel/
```

### Best Practices

```bash
# 1. Principle of Least Privilege
# Give minimum necessary permissions

# 2. Use groups for permission management
sudo groupadd developers
sudo usermod -aG developers alice

# 3. Regular permission audits
find / -perm -4000 2>/dev/null  # Find SUID files
find / -perm -2000 2>/dev/null  # Find SGID files

# 4. Secure sensitive files
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
chmod 700 ~/.ssh

# 5. Use sudo instead of root login
# Disable root login:
sudo passwd -l root

# 6. Monitor user activity
last
lastlog
who
w

# 7. Remove unused accounts
sudo userdel -r olduser
```
