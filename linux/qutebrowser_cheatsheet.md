# Qutebrowser Cheatsheet - Bare Essentials

Minimal keyboard-driven browser navigation guide.

---

## Core Concept

Qutebrowser is **vim-like** and **keyboard-driven**:
- **Normal mode**: Navigation (default)
- **Insert mode**: Typing in forms
- **Hint mode**: Clicking links

Press `Esc` to return to Normal mode.

---

## Navigation

### Basic Movement

```
j / k          Scroll down / up
h / l          Scroll left / right
gg             Scroll to top of page
G              Scroll to bottom
d              Scroll half page down
u              Scroll half page up

H              Go back in history
L              Go forward in history
r              Reload page
Shift+r        Hard reload (bypass cache)
```

### Opening Pages

```
o              Open URL (in current tab)
O              Open URL (edit current URL)
go             Open URL in current tab (keep focus in address bar)

t              Open URL (in new tab)
T              Open URL (edit current URL in new tab)

w              Open URL (in new window)
```

---

## Tabs

### Tab Management

```
t              Open new tab
d              Close current tab
u              Undo close tab (reopen last closed)

J              Next tab (or gt)
K              Previous tab (or gT)
g0 / g$        First / last tab

1-8            Go to tab 1-8
9              Go to last tab
```

### Moving Tabs

```
gm             Move tab left
gM             Move tab right
```

---

## Links (Hint Mode)

### Following Links

```
f              Open link in current tab
F              Open link in new tab
;f             Open link in new background tab

Hint mode workflow:
1. Press 'f' to enter hint mode
2. Type the hint letters shown on links
3. Link opens automatically
```

**Example**:
```
1. Press 'f'
2. See hints: [as] [sd] [df] on links
3. Type 'sd' to click that link
```

### Other Hint Actions

```
;y             Yank (copy) link URL
;Y             Yank (copy) link text
;i             Open image in current tab
;I             Open image in new tab
```

---

## Forms and Input

### Entering Insert Mode

```
i              Enter insert mode (focus first input)
gi             Enter insert mode (focus last used input)

Click in input field:
1. Press 'f' (hint mode)
2. Type hint for input field
3. Automatically enters insert mode

Esc            Exit insert mode (return to normal mode)
```

### Form Navigation

```
<Tab>          Next input field (in insert mode)
<Shift+Tab>    Previous input field (in insert mode)
```

### Autofill

```
;t             Fill form with userscript (if configured)
```

---

## Bookmarks / Favorites

### Quick Marks (Simple Bookmarks)

```
m<key>         Set quickmark (e.g., mg = quickmark 'g')
b<key>         Open quickmark (e.g., bg = open quickmark 'g')
M<key>         Set quickmark in new tab
```

**Example**:
```
1. On GitHub: press 'mg' (quickmark as 'g')
2. Later: press 'bg' to open GitHub
```

### Bookmarks (Persistent)

```
:bookmark-add            Add current page to bookmarks
:bookmark-load           Open bookmark
:bookmark-list           List all bookmarks

Shortcut:
gb             Open bookmark (interactive selection)
gB             Open bookmark in new tab
```

---

## Search

### Page Search

```
/              Search forward on page
?              Search backward on page
n              Next search result
N              Previous search result
```

**Example**:
```
1. Press '/'
2. Type 'linux'
3. Press Enter
4. Press 'n' for next match
```

### Web Search

```
o              Open prompt, type search
  Example: 'o' then 'python tutorial'
  (uses default search engine)

Set search engine in config:
  c.url.searchengines = {'DEFAULT': 'https://google.com/search?q={}'}
```

---

## Copy/Paste

```
yy             Yank (copy) current URL
yt             Yank (copy) current tab title
pp             Paste and open URL (current tab)
pP             Paste and open URL (new tab)
```

---

## Zoom

```
+              Zoom in
-              Zoom out
=              Reset zoom to 100%
```

---

## Command Mode

```
:              Enter command mode

Common commands:
:open <url>           Open URL
:open -t <url>        Open URL in new tab
:quit                 Quit qutebrowser
:close                Close current tab
:set-cmd-text -s :open  Open with URL prefilled
```

---

## Help

```
:help                 Open help page
:help <topic>         Help on specific topic
:bind <key>           Show what key does
```

---

## Quick Reference Card

### Essential Workflow

```
OPENING PAGES:
  o           → Type URL/search
  t           → New tab, type URL

NAVIGATION:
  H / L       → Back / Forward
  j / k       → Scroll down / up
  gg / G      → Top / Bottom

LINKS:
  f           → Click link (current tab)
  F           → Click link (new tab)

TABS:
  J / K       → Next / Previous tab
  d           → Close tab
  u           → Undo close tab

FORMS:
  i           → Enter insert mode
  Esc         → Exit insert mode

SEARCH:
  /           → Find in page
  n / N       → Next / Previous match

BOOKMARKS:
  m<key>      → Save quickmark
  b<key>      → Open quickmark
  gb          → Open bookmark

COPY:
  yy          → Copy URL
  pp          → Paste & open URL
```

---

## Configuration Basics

**Config file**: `~/.config/qutebrowser/config.py`

**Essential settings**:
```python
# Set default search engine
c.url.searchengines = {
    'DEFAULT': 'https://google.com/search?q={}',
    'ddg': 'https://duckduckgo.com/?q={}',
    'gh': 'https://github.com/search?q={}'
}

# Start page
c.url.start_pages = ['https://google.com']

# Download directory
c.downloads.location.directory = '~/Downloads'

# Enable dark mode
c.colors.webpage.darkmode.enabled = True
```

**Apply changes**: Restart qutebrowser or `:config-source`

---

## Tips

**Hints**:
- Uppercase hint keys (F instead of f) open in new tab
- `;` prefix for special hint actions

**Tabs**:
- `d` closes, `u` undoes (like vim)
- Numbers 1-9 jump to tabs

**Insert Mode**:
- Any time you need to type, press `i` or click input with `f`
- Always press `Esc` to go back to normal mode

**Learning Curve**:
- Day 1: Use mouse (click inputs, links)
- Day 2: Try `f` for links, `o` for URLs
- Day 3: Add `J/K` for tabs, `/` for search
- Week 2: Fully keyboard-driven

---

## Common Workflows

### Opening a Website

```
1. Press 'o'
2. Type 'github.com'
3. Press Enter
```

### Clicking a Link

```
1. Press 'f'
2. Type hint letters shown on desired link
3. Page opens
```

### Opening Link in Background Tab

```
1. Press ';f'
2. Type hint letters
3. Tab opens in background (stay on current page)
```

### Searching on Page

```
1. Press '/'
2. Type 'documentation'
3. Press 'n' to jump to next match
```

### Filling a Form

```
1. Press 'f' and click input field (or press 'i')
2. Type your text
3. Press Tab to move to next field
4. Press Esc when done
```

### Managing Tabs

```
1. Press 't' to open new tab
2. Type URL or search
3. Press 'J' or 'K' to switch tabs
4. Press 'd' to close unwanted tabs
```

---

## Keybinding Customization

**Add custom keybindings** in `config.py`:

```python
# Remap keys
config.bind('J', 'tab-next')
config.bind('K', 'tab-prev')

# Custom search
config.bind(',g', 'open -t https://github.com')
config.bind(',r', 'open -t https://reddit.com')

# Unbind key
config.unbind('d', mode='normal')
```

---

## Key Takeaways

**Core Habits**:
- `Esc` always returns to normal mode
- `o` opens URLs, `f` clicks links
- `J/K` switches tabs, `d` closes
- `i` for typing in forms
- `/` searches page

**Why Qutebrowser**:
- Blazing fast (all keyboard)
- No mouse needed
- Vim muscle memory transfers
- Highly customizable
- Lightweight

**Getting Started**:
1. Install: `sudo pacman -S qutebrowser` (Arch) or `sudo apt install qutebrowser` (Debian/Ubuntu)
2. Launch: `qutebrowser`
3. Practice with `f` and `o` for first day
4. Add more keys gradually
5. Read `:help` when stuck

**Resource**: Press `:help` in qutebrowser for full documentation.
