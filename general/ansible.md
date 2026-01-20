# Ansible

## What is Ansible?

Configuration management and automation tool.

```
Agentless: No software on managed nodes
SSH-based: Uses SSH to connect
YAML: Playbooks in YAML format
Idempotent: Safe to run multiple times
```

## Installation

```bash
# Install
pip install ansible

# Or
apt install ansible  # Ubuntu
brew install ansible  # Mac

# Verify
ansible --version
```

## Inventory

```ini
# inventory.ini
[webservers]
web1.example.com
web2.example.com

[databases]
db1.example.com

[all:vars]
ansible_user=admin
ansible_ssh_private_key_file=~/.ssh/id_rsa
```

### YAML Inventory

```yaml
# inventory.yml
all:
  children:
    webservers:
      hosts:
        web1.example.com:
        web2.example.com:
    databases:
      hosts:
        db1.example.com:
  vars:
    ansible_user: admin
```

## Ad-Hoc Commands

```bash
# Ping all hosts
ansible all -i inventory.ini -m ping

# Run command
ansible webservers -i inventory.ini -a "uptime"

# Install package
ansible webservers -i inventory.ini -m apt -a "name=nginx state=present" --become

# Copy file
ansible webservers -i inventory.ini -m copy -a "src=file.txt dest=/tmp/file.txt"

# Restart service
ansible webservers -i inventory.ini -m service -a "name=nginx state=restarted" --become
```

## Playbook Basics

```yaml
# playbook.yml
---
- name: Configure web servers
  hosts: webservers
  become: yes  # Run as sudo

  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present
        update_cache: yes

    - name: Start nginx
      service:
        name: nginx
        state: started
        enabled: yes

    - name: Copy config
      copy:
        src: nginx.conf
        dest: /etc/nginx/nginx.conf
      notify: Restart nginx

  handlers:
    - name: Restart nginx
      service:
        name: nginx
        state: restarted
```

### Run Playbook

```bash
ansible-playbook -i inventory.ini playbook.yml

# Check mode (dry run)
ansible-playbook -i inventory.ini playbook.yml --check

# Verbose
ansible-playbook -i inventory.ini playbook.yml -v
ansible-playbook -i inventory.ini playbook.yml -vvv  # More verbose
```

## Common Modules

### apt (Package Management)

```yaml
- name: Install packages
  apt:
    name:
      - nginx
      - git
      - python3-pip
    state: present
    update_cache: yes
```

### copy (Copy Files)

```yaml
- name: Copy file
  copy:
    src: /local/file.txt
    dest: /remote/file.txt
    owner: www-data
    group: www-data
    mode: '0644'
```

### template (Jinja2 Templates)

```yaml
- name: Copy config template
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: Restart nginx
```

```jinja2
# nginx.conf.j2
server {
    listen {{ nginx_port }};
    server_name {{ server_name }};
}
```

### service

```yaml
- name: Ensure nginx is running
  service:
    name: nginx
    state: started
    enabled: yes
```

### command / shell

```yaml
- name: Run command
  command: /usr/bin/some-command

- name: Run shell command
  shell: echo $PATH > /tmp/path.txt
```

### file

```yaml
- name: Create directory
  file:
    path: /opt/myapp
    state: directory
    mode: '0755'

- name: Remove file
  file:
    path: /tmp/old-file.txt
    state: absent
```

### git

```yaml
- name: Clone repository
  git:
    repo: https://github.com/user/repo.git
    dest: /opt/myapp
    version: main
```

### user

```yaml
- name: Create user
  user:
    name: deploy
    shell: /bin/bash
    groups: sudo
    append: yes
```

## Variables

```yaml
# In playbook
---
- name: Example
  hosts: webservers
  vars:
    nginx_port: 80
    server_name: example.com

  tasks:
    - name: Use variables
      debug:
        msg: "Port: {{ nginx_port }}, Server: {{ server_name }}"
```

### External Variables

```yaml
# vars.yml
nginx_port: 80
server_name: example.com
```

```yaml
# playbook.yml
---
- name: Example
  hosts: webservers
  vars_files:
    - vars.yml

  tasks:
    - name: Use variables
      debug:
        msg: "Port: {{ nginx_port }}"
```

### Command Line

```bash
ansible-playbook playbook.yml -e "nginx_port=8080"
```

## Conditionals

```yaml
- name: Install on Debian
  apt:
    name: nginx
    state: present
  when: ansible_os_family == "Debian"

- name: Install on RedHat
  yum:
    name: nginx
    state: present
  when: ansible_os_family == "RedHat"
```

## Loops

```yaml
- name: Install multiple packages
  apt:
    name: "{{ item }}"
    state: present
  loop:
    - nginx
    - git
    - vim

- name: Create multiple users
  user:
    name: "{{ item.name }}"
    groups: "{{ item.groups }}"
  loop:
    - { name: 'alice', groups: 'sudo' }
    - { name: 'bob', groups: 'developers' }
```

## Handlers

```yaml
tasks:
  - name: Copy nginx config
    copy:
      src: nginx.conf
      dest: /etc/nginx/nginx.conf
    notify: Restart nginx

  - name: Update systemd
    command: systemctl daemon-reload
    notify: Restart nginx

handlers:
  - name: Restart nginx
    service:
      name: nginx
      state: restarted
```

## Roles

```
roles/
  webserver/
    tasks/
      main.yml
    handlers/
      main.yml
    templates/
      nginx.conf.j2
    files/
      index.html
    vars/
      main.yml
    defaults/
      main.yml
```

```yaml
# roles/webserver/tasks/main.yml
---
- name: Install nginx
  apt:
    name: nginx
    state: present

- name: Copy config
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: Restart nginx
```

```yaml
# playbook.yml
---
- name: Configure web servers
  hosts: webservers
  roles:
    - webserver
```

## Tags

```yaml
- name: Install nginx
  apt:
    name: nginx
    state: present
  tags:
    - install
    - nginx

- name: Configure nginx
  copy:
    src: nginx.conf
    dest: /etc/nginx/nginx.conf
  tags:
    - config
    - nginx
```

```bash
# Run specific tags
ansible-playbook playbook.yml --tags "install"
ansible-playbook playbook.yml --tags "nginx"
ansible-playbook playbook.yml --skip-tags "config"
```

## Vault (Secrets)

```bash
# Create encrypted file
ansible-vault create secrets.yml

# Edit encrypted file
ansible-vault edit secrets.yml

# Encrypt existing file
ansible-vault encrypt secrets.yml

# Decrypt
ansible-vault decrypt secrets.yml
```

```yaml
# secrets.yml
db_password: secret123
api_key: abc123xyz
```

```bash
# Run with vault
ansible-playbook playbook.yml --ask-vault-pass

# Or use password file
ansible-playbook playbook.yml --vault-password-file ~/.vault_pass
```

## Example: Full Playbook

```yaml
---
- name: Deploy web application
  hosts: webservers
  become: yes
  vars:
    app_name: myapp
    app_user: deploy
    app_port: 5000

  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes

    - name: Install dependencies
      apt:
        name:
          - python3
          - python3-pip
          - nginx
        state: present

    - name: Create app user
      user:
        name: "{{ app_user }}"
        shell: /bin/bash

    - name: Clone repository
      git:
        repo: https://github.com/user/myapp.git
        dest: /opt/{{ app_name }}
        version: main
      become_user: "{{ app_user }}"

    - name: Install Python dependencies
      pip:
        requirements: /opt/{{ app_name }}/requirements.txt
        virtualenv: /opt/{{ app_name }}/venv

    - name: Copy systemd service
      template:
        src: myapp.service.j2
        dest: /etc/systemd/system/myapp.service
      notify: Restart myapp

    - name: Copy nginx config
      template:
        src: nginx.conf.j2
        dest: /etc/nginx/sites-available/myapp
      notify: Restart nginx

    - name: Enable nginx site
      file:
        src: /etc/nginx/sites-available/myapp
        dest: /etc/nginx/sites-enabled/myapp
        state: link

    - name: Start services
      service:
        name: "{{ item }}"
        state: started
        enabled: yes
      loop:
        - myapp
        - nginx

  handlers:
    - name: Restart myapp
      service:
        name: myapp
        state: restarted

    - name: Restart nginx
      service:
        name: nginx
        state: restarted
```

## Best Practices

```yaml
# 1. Use roles for organization
# 2. Use variables for configuration
# 3. Use vault for secrets
# 4. Use tags for selective runs
# 5. Use handlers for service restarts
# 6. Test with --check first
# 7. Use version control for playbooks
# 8. Document playbooks
# 9. Keep playbooks idempotent
# 10. Use meaningful names
```

## Common Tasks

```yaml
# Install Docker
- name: Install Docker
  apt:
    name: docker.io
    state: present

# Add user to docker group
- name: Add user to docker group
  user:
    name: "{{ ansible_user }}"
    groups: docker
    append: yes

# Create cron job
- name: Schedule backup
  cron:
    name: "daily backup"
    hour: "2"
    minute: "0"
    job: "/usr/local/bin/backup.sh"

# Check if file exists
- name: Check if file exists
  stat:
    path: /etc/myapp/config.yml
  register: config_file

- name: Create config if not exists
  copy:
    src: config.yml
    dest: /etc/myapp/config.yml
  when: not config_file.stat.exists
```

## Tips

```bash
# List all hosts
ansible all -i inventory.ini --list-hosts

# Check syntax
ansible-playbook playbook.yml --syntax-check

# Gather facts
ansible webservers -i inventory.ini -m setup

# See available facts
ansible localhost -m setup | less

# Run on specific host
ansible-playbook playbook.yml --limit web1.example.com

# Start at specific task
ansible-playbook playbook.yml --start-at-task="Install nginx"
```
