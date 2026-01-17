# 🐧 Linux & Server Cheat Sheets

A complete reference of Linux commands, Ubuntu server operations, shell power tools, deployment patterns, and Python on Linux.

---

## 📁 File & Directory Operations

| Command | What it does | Example |
|--------|--------------|---------|
| ls | Lists files and directories | ls -lh /srv/app |
| cd | Changes current directory | cd /srv/app |
| pwd | Prints current directory | pwd |
| mkdir | Creates a directory | mkdir logs |
| rmdir | Removes empty directory | rmdir tmp |
| rm | Deletes files | rm file.txt |
| rm -r | Deletes directories recursively | rm -r old_dir |
| cp | Copies files or directories | cp src.py dst.py |
| mv | Moves or renames files | mv old.txt new.txt |
| touch | Creates empty file or updates timestamp | touch app.py |
| stat | Shows detailed file metadata | stat app.py |
| file | Detects file type | file app.py |
| tree | Displays directory structure | tree -L 2 /srv/app |

---

## 🔐 Permissions & Ownership

| Command | What it does | Example |
|--------|--------------|---------|
| chmod | Changes file permissions | chmod 640 config.ini |
| chown | Changes file owner | chown mike:dev app.py |
| chgrp | Changes group ownership | chgrp devs app.py |
| umask | Sets default permission mask | umask 022 |
| id | Shows user identity | id |
| groups | Lists user groups | groups mike |
| getfacl | Displays ACL permissions | getfacl app.py |
| setfacl | Sets ACL permissions | setfacl -m u:mike:rw app.py |
| chattr | Sets special file attributes | sudo chattr +i /srv/app |
| lsattr | Shows file attributes | lsattr /srv/app |

### Numeric Permissions (octal)

| Numeric | Permission | Meaning |
|--------|------------|---------|
| 400 | r-- | Read only for owner |
| 600 | rw- | Read & write for owner, nothing else |
| 644 | rw- r-- r-- | Owner read/write, group & others read |
| 700 | rwx | Owner full access, nothing for group/others |
| 755 | rwx r-x r-x | Owner full, group/others read+execute |
| 777 | rwx rwx rwx | Everyone full access (dangerous) |

Example usage:
chmod 644 file.txt   # read/write owner, read others
chmod 755 script.sh  # full owner, readable/executable by group/others

### Symbolic (letter) Permissions

| Symbolic | Meaning | Example |
|----------|---------|---------|
| u | user/owner | chmod u+x script.sh  # add execute to owner |
| g | group | chmod g-w file.txt    # remove write from group |
| o | others | chmod o+r file.txt    # add read for others |
| a | all (user+group+others) | chmod a+r file.txt |

Combining symbolic permissions:
chmod u+x,g-w,o-r file.txt

Special flags:
+ add permission
- remove permission
= set exact permission

---

## 🗜 Compression & Archiving

| Command | What it does | Example |
|--------|--------------|---------|
| tar -czf | Creates compressed tar archive | tar -czf app.tar.gz /srv/app |
| tar -xzf | Extracts tar.gz archive | tar -xzf app.tar.gz |
| zip | Creates ZIP archive | zip -r app.zip /srv/app |
| unzip | Extracts ZIP archive | unzip app.zip |
| gzip | Compresses file | gzip app.log |
| gunzip | Decompresses file | gunzip app.log.gz |

---

## 🧠 Process Management

| Command | What it does | Example |
|--------|--------------|---------|
| ps aux | Lists all running processes | ps aux |
| top | Shows live process usage | top |
| htop | Enhanced interactive process viewer | htop |
| kill | Sends signal to process | kill 1234 |
| pkill | Kills process by name | pkill python |
| pgrep | Finds process ID | pgrep python |
| nice | Starts process with priority | nice -n 10 python app.py |
| renice | Changes running priority | renice +5 1234 |
| watch | Repeats command periodically | watch df -h |

---

## 📊 System Information

| Command | What it does | Example |
|--------|--------------|---------|
| uname -a | Shows kernel info | uname -a |
| uptime | Shows system runtime | uptime |
| free -h | Displays memory usage | free -h |
| df -h | Disk space usage | df -h |
| df -i | Inode usage | df -i |
| du -sh | Directory size | du -sh /srv/app |
| lsblk | Lists block devices | lsblk |
| mount | Mounts filesystem | mount /dev/sdb1 /mnt |
| umount | Unmounts filesystem | umount /mnt |
| blkid | Shows disk UUIDs | blkid /dev/sdb1 |

---

## 🌐 Networking

| Command | What it does | Example |
|--------|--------------|---------|
| ip a | Shows network interfaces | ip a |
| ip r | Shows routing table | ip r |
| ss -tuln | Lists listening ports | ss -tuln |
| ping | Tests network reachability | ping google.com |
| traceroute | Shows packet path | traceroute google.com |
| ssh | Remote secure login | ssh mike@server |
| scp | Secure file copy | scp file.txt mike@server:/srv/app |
| rsync | Efficient file sync | rsync -av /src /dst |
| curl | Fetches URL content | curl http://example.com |
| wget | Downloads files | wget http://example.com/file.zip |

---

## 🔍 Search & Text Processing

| Command | What it does | Example |
|--------|--------------|---------|
| grep | Searches text patterns | grep "ERROR" /var/log/app.log |
| sed | Inline text replacement | sed 's/foo/bar/g' file.txt |
| awk | Column-based processing | awk '{print $1}' file.txt |
| cut | Extracts columns | cut -d: -f1 /etc/passwd |
| sort | Sorts input | sort names.txt |
| uniq | Removes duplicates | sort names.txt | uniq |
| tr | Translates characters | echo "abc" | tr a-z A-Z |
| wc | Counts lines/words/bytes | wc -l file.txt |
| xargs | Converts input to arguments | find . -name "*.log" | xargs rm |

Find example:
find /srv/app -name "*.py"   # finds all Python files

---

## 🔄 Redirection & Pipes

| Syntax | What it does | Example |
|------|--------------|---------|
| > | Redirects output (overwrite) | echo "hello" > file.txt |
| >> | Redirects output (append) | echo "hello" >> file.txt |
| < | Redirects input | wc -l < file.txt |
| 2> | Redirects stderr | command 2> error.log |
| &> | Redirects all output | command &> output.log |
| \| | Pipes output to next command | cat file.txt | grep "ERROR" |

---

## 👥 User Management

| Command | What it does | Example |
|--------|--------------|---------|
| adduser | Creates new user | adduser mike |
| deluser | Removes user | deluser mike |
| passwd | Changes password | passwd mike |
| usermod | Modifies user | usermod -aG sudo mike |
| su | Switches user | su - mike |
| sudo -l | Shows sudo permissions | sudo -l |

---

## ⌨️ Shell Shortcuts

Ctrl+A  move to start of line  
Ctrl+E  move to end of line  
Ctrl+R  search command history  
Ctrl+C  cancel command  
Ctrl+Z  suspend process  
Ctrl+D  exit shell  

---

## 🧰 Ubuntu Server Commands

### Package Management (APT)

| Command | What it does | Example |
|--------|--------------|---------|
| apt update | Updates package index | sudo apt update |
| apt upgrade | Upgrades installed packages | sudo apt upgrade -y |
| apt install | Installs package | sudo apt install nginx |
| apt remove | Removes package | sudo apt remove nginx |
| apt purge | Removes package and config | sudo apt purge nginx |
| apt autoremove | Cleans unused dependencies | sudo apt autoremove |
| apt-cache policy | Shows package versions | apt-cache policy python3 |
| dpkg -l | Lists installed packages | dpkg -l | grep nginx |
| dpkg -i | Installs .deb file | sudo dpkg -i package.deb |

---

### systemd / Services

| Command | What it does | Example |
|--------|--------------|---------|
| systemctl status | Shows service status | systemctl status nginx |
| systemctl start | Starts service | sudo systemctl start nginx |
| systemctl stop | Stops service | sudo systemctl stop nginx |
| systemctl restart | Restarts service | sudo systemctl restart nginx |
| systemctl reload | Reloads config | sudo systemctl reload nginx |
| systemctl enable | Enables at boot | sudo systemctl enable nginx |
| systemctl disable | Disables at boot | sudo systemctl disable nginx |
| systemctl daemon-reload | Reloads unit files | sudo systemctl daemon-reload |

Logs:
journalctl -u nginx       # shows service logs
journalctl -f             # follows logs live

---

### Firewall (ufw)

| Command | What it does | Example |
|--------|--------------|---------|
| ufw status | Shows firewall rules | sudo ufw status verbose |
| ufw allow | Opens port | sudo ufw allow 22/tcp |
| ufw delete | Removes rule | sudo ufw delete allow 22/tcp |
| ufw enable | Enables firewall | sudo ufw enable |
| ufw disable | Disables firewall | sudo ufw disable |

---

## 🧠 Shell Power Tools

| Tool | What it does | Example |
|------|--------------|---------|
| pipe (|) | Chains commands | cat file.txt | grep "ERROR" |
| find | Searches filesystem | find /srv/app -name "*.py" |
| exec | Executes command on results | find . -name "*.log" -exec rm {} \; |
| sed | Inline text replacement | sed 's/foo/bar/g' file.txt |
| awk | Column-based processing | awk '{print $1}' file.txt |
| xargs | Converts input to arguments | find . -name "*.log" | xargs rm |

Safety Tips:
set -euo pipefail   # fail fast on errors in shell scripts

---

## 🚀 Deployment Cheatsheet

| Concept | What it does | Example |
|---------|-------------|---------|
| releases | Versioned deploys | /srv/app/releases/v1.2.3 |
| symlink | Atomic switch between releases | ln -sfn /srv/app/releases/v1.2.3 /srv/app/current |
| rollback | Instant revert | ln -sfn /srv/app/releases/v1.2.2 /srv/app/current |
| chattr +i | Prevent deletion | sudo chattr +i /srv/app |
| systemctl | Manage service | sudo systemctl restart app.service |

Golden rule:
Never deploy directly into production directory. Always use release directories and symlinks.

---

## 🐍 Python on Linux

| Command | What it does | Example |
|--------|--------------|---------|
| python -m venv | Creates virtual environment | python3 -m venv venv |
| source venv/bin/activate | Activates virtual environment | source venv/bin/activate |
| pip install | Installs Python package | pip install requests |
| pip freeze | Exports dependencies | pip freeze > requirements.txt |
| gunicorn | Production WSGI server | gunicorn app:app |
| journalctl | Reads app logs | journalctl -u myapp.service |

Notes:
- Always use virtual environments to isolate project dependencies.
- For production, use systemd + gunicorn or similar WSGI server.

