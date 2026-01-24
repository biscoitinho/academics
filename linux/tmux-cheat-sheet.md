# tmux Cheat Sheet

Comprehensive tmux reference for terminal multiplexing.

## Quick Start

```bash
# Start new session
tmux

# Start new named session
tmux new -s session-name

# List sessions
tmux ls

# Attach to session
tmux attach -t session-name

# Detach from session (inside tmux)
Ctrl+b d
```

**Default prefix**: `Ctrl+b` (shown as `C-b` below)

All commands require prefix first, then the key.

## Sessions

| Key | Action |
|-----|--------|
| `C-b d` | Detach from current session |
| `C-b s` | List sessions and switch |
| `C-b $` | Rename current session |
| `C-b (` | Switch to previous session |
| `C-b )` | Switch to next session |

```bash
# Command line session management
tmux new -s dev                    # Create session named 'dev'
tmux attach -t dev                 # Attach to session 'dev'
tmux switch -t dev                 # Switch to session 'dev'
tmux kill-session -t dev           # Kill session 'dev'
tmux kill-server                   # Kill all sessions
tmux list-sessions                 # List all sessions
```

## Windows (Tabs)

| Key | Action |
|-----|--------|
| `C-b c` | Create new window |
| `C-b ,` | Rename current window |
| `C-b w` | List windows (interactive) |
| `C-b p` | Previous window |
| `C-b n` | Next window |
| `C-b 0-9` | Switch to window 0-9 |
| `C-b l` | Toggle last active window |
| `C-b &` | Kill current window |
| `C-b f` | Find window by name |

## Panes (Splits)

### Creating Panes

| Key | Action |
|-----|--------|
| `C-b %` | Split pane vertically (left/right) |
| `C-b "` | Split pane horizontally (top/bottom) |
| `C-b x` | Kill current pane |
| `C-b q` | Show pane numbers (then press number to jump) |
| `C-b z` | Toggle pane zoom (fullscreen) |

**Better split bindings** (add to `~/.tmux.conf`):
```bash
bind | split-window -h    # C-b | for vertical split
bind - split-window -v    # C-b - for horizontal split
```

### Navigating Between Panes

| Key | Action |
|-----|--------|
| `C-b ←` | Move to left pane |
| `C-b →` | Move to right pane |
| `C-b ↑` | Move to pane above |
| `C-b ↓` | Move to pane below |
| `C-b o` | Cycle through panes |
| `C-b ;` | Toggle between current and previous pane |
| `C-b {` | Swap current pane with previous |
| `C-b }` | Swap current pane with next |

**Vim-style navigation** (add to `~/.tmux.conf`):
```bash
bind h select-pane -L     # C-b h to go left
bind j select-pane -D     # C-b j to go down
bind k select-pane -U     # C-b k to go up
bind l select-pane -R     # C-b l to go right
```

### Resizing Panes

**Default** (slow, one cell at a time):

| Key | Action |
|-----|--------|
| `C-b C-←` | Resize pane left |
| `C-b C-→` | Resize pane right |
| `C-b C-↑` | Resize pane up |
| `C-b C-↓` | Resize pane down |

**Better resize bindings** (add to `~/.tmux.conf`):
```bash
# Resize panes with arrow keys (bigger steps)
bind -r Left resize-pane -L 5
bind -r Right resize-pane -R 5
bind -r Up resize-pane -U 5
bind -r Down resize-pane -D 5

# Or with Shift + arrow keys
bind -n S-Left resize-pane -L 2
bind -n S-Right resize-pane -R 2
bind -n S-Up resize-pane -U 2
bind -n S-Down resize-pane -D 2
```

**Vim-style resizing** (add to `~/.tmux.conf`):
```bash
bind -r H resize-pane -L 5    # C-b H to resize left
bind -r J resize-pane -D 5    # C-b J to resize down
bind -r K resize-pane -U 5    # C-b K to resize up
bind -r L resize-pane -R 5    # C-b L to resize right
```

### Pane Layouts

| Key | Action |
|-----|--------|
| `C-b Space` | Cycle through layouts |
| `C-b Alt+1` | Even horizontal layout |
| `C-b Alt+2` | Even vertical layout |
| `C-b Alt+3` | Main horizontal layout |
| `C-b Alt+4` | Main vertical layout |
| `C-b Alt+5` | Tiled layout |

## Copy Mode & Scrolling

**This is essential for scrolling through terminal output!**

| Key | Action |
|-----|--------|
| `C-b [` | Enter copy mode (scroll mode) |
| `q` or `Esc` | Exit copy mode |

### In Copy Mode (Default Emacs-style)

| Key | Action |
|-----|--------|
| `↑` / `↓` | Scroll up/down |
| `PgUp` / `PgDn` | Page up/down |
| `g` | Go to top of history |
| `G` | Go to bottom of history |
| `Space` | Start selection |
| `Enter` | Copy selection and exit |
| `/` | Search forward |
| `?` | Search backward |
| `n` | Next search result |
| `N` | Previous search result |

### Vi-style Copy Mode (Recommended)

Add to `~/.tmux.conf`:
```bash
# Use vim keybindings in copy mode
setw -g mode-keys vi

# Better copy mode bindings
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
bind-key -T copy-mode-vi r send-keys -X rectangle-toggle
```

**Vi copy mode keys**:

| Key | Action |
|-----|--------|
| `h/j/k/l` | Move left/down/up/right |
| `w` / `b` | Forward/backward word |
| `Ctrl+f` / `Ctrl+b` | Page down/up |
| `gg` | Go to top |
| `G` | Go to bottom |
| `v` | Start selection |
| `V` | Select line |
| `y` | Copy selection |
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` / `N` | Next/previous match |

## Help & Information

| Key | Action |
|-----|--------|
| `C-b ?` | List all key bindings |
| `C-b :` | Enter command prompt |
| `C-b t` | Show time |
| `C-b i` | Display pane info |

## Essential Commands

```bash
# Inside tmux command prompt (C-b :)
:set mouse on                      # Enable mouse
:set mouse off                     # Disable mouse
:setw synchronize-panes on         # Send commands to all panes
:setw synchronize-panes off        # Disable synchronization
:list-keys                         # Show all keybindings
:list-commands                     # Show all commands
:source-file ~/.tmux.conf          # Reload config
```

## Mouse Support

Add to `~/.tmux.conf`:
```bash
# Enable mouse support
set -g mouse on
```

With mouse enabled:
- Click to select pane
- Drag pane border to resize
- Scroll wheel to scroll through history
- Click window in status bar to switch
- Right-click pane border for menu

## Basic Workflow

### Development Workflow

```bash
# 1. Create new session for project
tmux new -s myproject

# 2. Create windows for different tasks
C-b c          # New window for editor
C-b ,          # Rename to "vim"

C-b c          # New window for server
C-b ,          # Rename to "server"

C-b c          # New window for git
C-b ,          # Rename to "git"

# 3. Split panes in server window
C-b 1          # Go to window 1 (server)
C-b "          # Split horizontally
C-b o          # Switch to new pane
# Run server in top pane, logs in bottom

# 4. Work and detach when needed
C-b d          # Detach
tmux attach -t myproject  # Reattach later
```

### Monitoring Workflow

```bash
# Create 4-pane layout for monitoring
tmux new -s monitor

C-b "          # Split horizontal
C-b %          # Split vertical
C-b o C-b %    # Switch and split again

# Now you have 4 panes:
# - Top-left: htop
# - Top-right: tail -f app.log
# - Bottom-left: watch docker ps
# - Bottom-right: interactive shell
```

## Essential ~/.tmux.conf

```bash
# Change prefix from C-b to C-a (like screen)
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# Enable mouse support
set -g mouse on

# Start windows and panes at 1, not 0
set -g base-index 1
setw -g pane-base-index 1

# Renumber windows when one is closed
set -g renumber-windows on

# Increase scrollback buffer
set -g history-limit 10000

# Enable vi mode
setw -g mode-keys vi

# Split panes using | and -
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %

# Vim-style pane navigation
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Vim-style pane resizing
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# Reload config easily
bind r source-file ~/.tmux.conf \; display "Config reloaded!"

# Don't rename windows automatically
set-option -g allow-rename off

# Increase display time for messages
set -g display-time 2000

# Enable activity alerts
setw -g monitor-activity on
set -g visual-activity on

# Better colors
set -g default-terminal "screen-256color"

# Status bar
set -g status-style 'bg=colour235 fg=colour255'
set -g status-left-length 20
set -g status-right '%Y-%m-%d %H:%M '
```

## Copy to System Clipboard

### macOS

```bash
# In ~/.tmux.conf
bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"
```

### Linux

```bash
# In ~/.tmux.conf (requires xclip)
bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -selection clipboard -i"
bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -selection clipboard -i"
```

## Common Issues

### Can't scroll with mouse wheel

Enable mouse mode: `set -g mouse on` in `~/.tmux.conf`

### Arrow keys not working

Check your `$TERM` variable. Add to `~/.tmux.conf`:
```bash
set -g default-terminal "screen-256color"
```

### Colors look wrong

```bash
# In ~/.tmux.conf
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",xterm-256color:Tc"
```

### Can't paste from system clipboard

Use the clipboard integration shown above, or:
- Hold `Shift` and middle-click (Linux)
- Hold `Option` and middle-click (macOS)

## Quick Reference Commands

```bash
# Sessions
tmux new -s name                   # Create session
tmux attach -t name                # Attach to session
tmux switch -t name                # Switch session
tmux ls                            # List sessions
tmux detach                        # Detach from session
tmux kill-session -t name          # Kill session

# Windows
C-b c                              # Create window
C-b w                              # List windows
C-b n/p                            # Next/previous window
C-b 0-9                            # Switch to window number

# Panes
C-b %                              # Vertical split
C-b "                              # Horizontal split
C-b o                              # Cycle panes
C-b x                              # Kill pane
C-b z                              # Toggle zoom
C-b arrow                          # Navigate panes
C-b C-arrow                        # Resize pane
C-b [                              # Enter copy mode
```

## Plugins (TPM - Tmux Plugin Manager)

```bash
# Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Add to ~/.tmux.conf
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'  # Save/restore sessions
set -g @plugin 'tmux-plugins/tmux-continuum'  # Auto-save sessions

# Initialize TPM (keep at bottom of config)
run '~/.tmux/plugins/tpm/tpm'

# Inside tmux:
# Install plugins: C-b I
# Update plugins: C-b U
# Remove plugins: C-b alt+u
```

## Tips & Tricks

1. **Use named sessions** - `tmux new -s project-name`
2. **Detach often** - Keep work sessions running
3. **Use windows for contexts** - One window per logical task
4. **Use panes for related tasks** - Split within a context
5. **Enable mouse mode** - Easier for beginners
6. **Learn copy mode** - Essential for scrolling
7. **Customize prefix** - `C-a` often preferred over `C-b`
8. **Use synchronize-panes** - Run commands on all panes at once

## Resources

- Official docs: https://github.com/tmux/tmux/wiki
- tmux book: https://leanpub.com/the-tao-of-tmux
- Awesome tmux: https://github.com/rothgar/awesome-tmux
- TPM plugins: https://github.com/tmux-plugins

**Remember**: All commands require prefix (`C-b` by default) first!
