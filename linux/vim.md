## Vim Cheatsheet

### Modes

```
Normal mode   - Default, for navigation (press Esc)
Insert mode   - For typing (press i, a, o)
Visual mode   - For selection (press v, V, Ctrl+v)
Command mode  - For commands (press :)
```

### Basic Operations

```vim
:w              Save
:q              Quit
:wq or :x       Save and quit
:q!             Quit without saving
:w filename     Save as
:e filename     Open file
:sav filename   Save as and edit new file
```

### Movement

```vim
h, j, k, l      Left, down, up, right
w               Next word start
b               Previous word start
e               Next word end
0               Start of line
^               First non-blank character
$               End of line
gg              First line
G               Last line
:n or nG        Go to line n
Ctrl+f          Page down
Ctrl+b          Page up
%               Jump to matching bracket
```

### Insert Mode

```vim
i               Insert before cursor
a               Insert after cursor
I               Insert at start of line
A               Insert at end of line
o               Open new line below
O               Open new line above
Esc             Exit insert mode
```

### Editing

```vim
x               Delete character
dd              Delete line
dw              Delete word
d$              Delete to end of line
d0              Delete to start of line
D               Delete to end of line
u               Undo
Ctrl+r          Redo
.               Repeat last command
yy              Copy line
yw              Copy word
y$              Copy to end of line
p               Paste after cursor
P               Paste before cursor
```

### Visual Mode

```vim
v               Visual mode (character)
V               Visual mode (line)
Ctrl+v          Visual block mode
y               Yank (copy) selection
d               Delete selection
c               Change selection
>               Indent right
<               Indent left
~               Toggle case
```

### Search and Replace

```vim
/pattern        Search forward
?pattern        Search backward
n               Next match
N               Previous match
*               Search word under cursor
:%s/old/new/g   Replace all in file
:s/old/new/g    Replace all in line
:%s/old/new/gc  Replace with confirmation
:noh            Clear search highlighting
```

### Multiple Files

```vim
:e file         Edit file
:bn             Next buffer
:bp             Previous buffer
:bd             Close buffer
:ls             List buffers
:sp file        Horizontal split
:vsp file       Vertical split
Ctrl+w w        Switch window
Ctrl+w q        Close window
Ctrl+w h/j/k/l  Navigate windows
```

### Advanced

```vim
.               Repeat last change
:r file         Insert file contents
:r !command     Insert command output
:!command       Execute shell command
!!command       Replace line with command output
:set number     Show line numbers
:set nonumber   Hide line numbers
:set hlsearch   Highlight search
:set nohlsearch No highlight search
:syntax on      Enable syntax highlighting
:set paste      Paste mode (no auto-indent)
```

### Macros

```vim
qa              Start recording to register a
q               Stop recording
@a              Play macro from register a
@@              Repeat last macro
```

### Marks

```vim
ma              Set mark 'a' at current position
'a              Jump to mark 'a'
``              Jump to last position
'.              Jump to last change
```

### Registers

```vim
"ayy            Yank line to register a
"ap             Paste from register a
:reg            Show all registers
"+y             Yank to system clipboard
"+p             Paste from system clipboard
```

### Common Workflows

```vim
# Find and replace
:%s/foo/bar/g

# Delete blank lines
:g/^$/d

# Sort lines
:sort

# Remove duplicate lines
:sort u

# Increment numbers
Ctrl+a          (on number)

# Decrement numbers
Ctrl+x          (on number)

# Format paragraph
gq

# Auto-indent
gg=G

# Comment multiple lines
Ctrl+v, select, I, #, Esc

# Uncomment multiple lines
Ctrl+v, select, d
```

### Configuration (~/.vimrc)

```vim
set number              " Line numbers
set relativenumber      " Relative line numbers
set tabstop=4           " Tab width
set shiftwidth=4        " Indent width
set expandtab           " Spaces instead of tabs
set autoindent          " Auto indent
set smartindent         " Smart indent
set hlsearch            " Highlight search
set incsearch           " Incremental search
set ignorecase          " Case insensitive search
set smartcase           " Case sensitive if caps used
syntax on               " Syntax highlighting
set mouse=a             " Mouse support
set clipboard=unnamedplus " System clipboard
```
