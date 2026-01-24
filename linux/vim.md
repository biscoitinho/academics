# Vim Cheatsheet

Comprehensive Vim reference with essential commands and plugins.

## Modes

```
Normal mode   - Default, for navigation (press Esc)
Insert mode   - For typing (press i, a, o)
Visual mode   - For selection (press v, V, Ctrl+v)
Command mode  - For commands (press :)
```

## Basic Operations

```vim
:w              Save
:q              Quit
:wq or :x       Save and quit
:q!             Quit without saving
:w filename     Save as
:e filename     Open file
:sav filename   Save as and edit new file
:wa             Save all files
:qa             Quit all
:wqa            Save and quit all
```

## Movement

### Basic Movement

```vim
h, j, k, l      Left, down, up, right
w               Next word start
b               Previous word start
e               Next word end
ge              Previous word end
W, B, E         Word movement (ignore punctuation)
```

### Line Navigation

```vim
0               Absolute beginning of line (column 0)
^               First non-blank character of line
$               End of line
g_              Last non-blank character of line
gg              First line of file
G               Last line of file
:n or nG        Go to line n
50%             Go to middle of file
```

**Common patterns**:
- `0` - Go to very start (useful for visual selection from start)
- `^` - Go to first character (useful for code editing)
- `$` - Go to end (useful with d$, y$, etc.)
- `I` - Insert at first non-blank character (same as `^i`)
- `A` - Insert at end of line (same as `$a`)

### Screen Movement

```vim
Ctrl+f          Page down (forward)
Ctrl+b          Page up (backward)
Ctrl+d          Half page down
Ctrl+u          Half page up
H               Top of screen (High)
M               Middle of screen
L               Bottom of screen (Low)
zz              Center screen on cursor
zt              Cursor to top of screen
zb              Cursor to bottom of screen
```

### Advanced Movement

```vim
%               Jump to matching bracket/paren
{               Previous paragraph
}               Next paragraph
(               Previous sentence
)               Next sentence
[[              Previous section
]]              Next section
gd              Go to definition (local)
gD              Go to definition (global)
*               Search word under cursor (forward)
#               Search word under cursor (backward)
f<char>         Find character forward in line
F<char>         Find character backward in line
t<char>         Till character forward
T<char>         Till character backward
;               Repeat last f/F/t/T
,               Repeat last f/F/t/T reversed
```

## Insert Mode

```vim
i               Insert before cursor
a               Insert after cursor
I               Insert at first non-blank of line
A               Insert at end of line
o               Open new line below
O               Open new line above
s               Substitute character (delete char and insert)
S               Substitute line (delete line and insert)
C               Change to end of line (delete to end and insert)
Esc             Exit insert mode
Ctrl+[          Exit insert mode (alternative)
```

## Editing

### Delete

```vim
x               Delete character under cursor
X               Delete character before cursor
dd              Delete line
dw              Delete word
d$              Delete to end of line
d0              Delete to start of line
D               Delete to end of line (same as d$)
dG              Delete to end of file
dgg             Delete to start of file
J               Join line below to current line
```

### Copy (Yank) and Paste

```vim
yy              Copy line
yw              Copy word
y$              Copy to end of line
y0              Copy to start of line
yG              Copy to end of file
ygg             Copy to start of file
p               Paste after cursor/line
P               Paste before cursor/line
```

### Change

```vim
cc              Change line (delete and enter insert)
cw              Change word
c$              Change to end of line
C               Change to end of line (same as c$)
ciw             Change inner word
ci"             Change inside quotes
ci(             Change inside parentheses
ci{             Change inside braces
```

### Undo/Redo

```vim
u               Undo
Ctrl+r          Redo
.               Repeat last command
U               Undo all changes on line
```

### Text Objects

```vim
iw              Inner word
aw              A word (includes whitespace)
is              Inner sentence
as              A sentence
ip              Inner paragraph
ap              A paragraph
i" or i'        Inside quotes
a" or a'        Around quotes (includes quotes)
i( or i)        Inside parentheses
a( or a)        Around parentheses
i{ or i}        Inside braces
a{ or a}        Around braces
it              Inside tag (HTML/XML)
at              Around tag
```

**Usage examples**:
- `diw` - Delete inner word
- `ci"` - Change text inside quotes
- `da(` - Delete around parentheses (including parens)
- `yit` - Yank inside HTML tag

## Visual Mode

```vim
v               Visual mode (character selection)
V               Visual mode (line selection)
Ctrl+v          Visual block mode
gv              Reselect last visual selection
o               Move to other end of selection
```

### Visual Mode Operations

```vim
y               Yank (copy) selection
d               Delete selection
c               Change selection (delete and enter insert)
>               Indent right
<               Indent left
=               Auto-indent
~               Toggle case
u               Lowercase
U               Uppercase
:               Enter command mode for selection
```

### Visual Block Mode

```vim
Ctrl+v          Enter visual block mode
I               Insert before block
A               Insert after block
c               Change block
d               Delete block
y               Yank block
```

**Example workflow** - Add `//` comment to multiple lines:
1. `Ctrl+v` - Enter visual block
2. Select lines with `j`
3. `I` - Insert mode
4. Type `// `
5. `Esc` - Apply to all lines

## Search and Replace

### Search

```vim
/pattern        Search forward
?pattern        Search backward
n               Next match
N               Previous match
*               Search word under cursor (forward)
#               Search word under cursor (backward)
:noh            Clear search highlighting
/\cpattern      Case-insensitive search
/\Cpattern      Case-sensitive search
```

### Replace

```vim
:s/old/new              Replace first occurrence in line
:s/old/new/g            Replace all in line
:%s/old/new/g           Replace all in file
:%s/old/new/gc          Replace all with confirmation
:5,10s/old/new/g        Replace in lines 5-10
:'<,'>s/old/new/g       Replace in visual selection
:%s/old/new/gi          Replace all (case-insensitive)
:%s/\<old\>/new/g       Replace whole word only
```

## Spell Checking

### Enable Spell Checking

```vim
:set spell              Enable spell checking
:set nospell            Disable spell checking
:set spell spelllang=en_us    English (US)
:set spell spelllang=en_gb    English (UK)
:set spell spelllang=pl       Polish
:set spell spelllang=en_us,pl Both English and Polish
```

### Polish Spell Checking Setup

```vim
# In ~/.vimrc
set spelllang=pl,en_us    " Polish first, then English
set spell                  " Enable by default

# Or toggle with F6
nnoremap <F6> :setlocal spell! spelllang=pl,en_us<CR>
```

**Download Polish dictionary** (if not installed):
```bash
mkdir -p ~/.vim/spell
cd ~/.vim/spell
wget http://ftp.vim.org/vim/runtime/spell/pl.utf-8.spl
wget http://ftp.vim.org/vim/runtime/spell/pl.utf-8.sug
```

### Spell Checking Navigation

```vim
]s              Next misspelled word
[s              Previous misspelled word
z=              Suggest corrections
zg              Add word to dictionary
zG              Add word to temporary dictionary
zw              Mark word as misspelled
zW              Mark word as misspelled (temporary)
zug             Remove word from dictionary
```

**Common workflow**:
1. `]s` - Jump to next misspelled word
2. `z=` - See suggestions
3. Select number to replace
4. Or `zg` to add to dictionary if correct

### Spell Check in Insert Mode

```vim
Ctrl+x s        Show spelling suggestions in insert mode
```

## Word Count

```vim
g Ctrl+g        Show detailed file stats (words, chars, lines)
:!wc %          Use external wc command (words, lines, bytes)
:!wc -w %       Word count only
:!wc -l %       Line count only
```

**Visual selection word count**:
```vim
# Select text in visual mode, then:
:w !wc          Word count of selection
:w !wc -w       Just word count
```

**Add word count to status line** (~/.vimrc):
```vim
set statusline=%F%m%r%h%w\ [%l/%L,%v]\ [%p%%]\ %{wordcount().words}\ words
set laststatus=2
```

**Quick word count function** (~/.vimrc):
```vim
function! WordCount()
    let s:old_status = v:statusmsg
    exe "silent normal g\<c-g>"
    let s:word_count = str2nr(split(v:statusmsg)[11])
    let v:statusmsg = s:old_status
    return s:word_count
endfunction

" Map to F3
nnoremap <F3> :echo "Words:" WordCount()<CR>
```

## Multiple Files & Buffers

```vim
:e file         Edit file
:bn             Next buffer
:bp             Previous buffer
:bd             Close buffer
:ls or :buffers List buffers
:b<n>           Go to buffer n
:b filename     Go to buffer by name (tab-complete works)
:ball           Open all buffers in windows
```

## Windows & Splits

### Creating Splits

```vim
:sp file        Horizontal split
:vsp file       Vertical split
:new            New horizontal split
:vnew           New vertical split
Ctrl+w s        Split current window horizontally
Ctrl+w v        Split current window vertically
```

### Navigating Windows

```vim
Ctrl+w w        Switch to next window
Ctrl+w h        Move to left window
Ctrl+w j        Move to bottom window
Ctrl+w k        Move to top window
Ctrl+w l        Move to right window
Ctrl+w p        Move to previous window
```

### Resizing Windows

```vim
Ctrl+w =        Make all windows equal size
Ctrl+w _        Maximize height
Ctrl+w |        Maximize width
Ctrl+w +        Increase height
Ctrl+w -        Decrease height
Ctrl+w >        Increase width
Ctrl+w <        Decrease width
:resize 20      Set height to 20 lines
:vertical resize 80  Set width to 80 columns
```

### Closing Windows

```vim
:q              Close current window
Ctrl+w q        Close current window
Ctrl+w c        Close current window
Ctrl+w o        Close all other windows (only keep current)
```

## Tabs

```vim
:tabnew file    Open file in new tab
:tabclose       Close current tab
:tabnext or gt  Next tab
:tabprev or gT  Previous tab
:tabfirst       First tab
:tablast        Last tab
:tabs           List all tabs
:tabm n         Move tab to position n
```

## Macros

```vim
qa              Start recording to register a
q               Stop recording
@a              Play macro from register a
@@              Repeat last macro
100@a           Execute macro 100 times
```

**Example** - Add semicolon to end of multiple lines:
1. `qa` - Start recording to register 'a'
2. `A;` - Go to end of line and add semicolon
3. `Esc` - Exit insert mode
4. `j` - Move to next line
5. `q` - Stop recording
6. `10@a` - Apply to next 10 lines

## Marks

```vim
ma              Set mark 'a' at current position
'a              Jump to line of mark 'a'
`a              Jump to exact position of mark 'a'
:marks          Show all marks
``              Jump to position before last jump
'.              Jump to last change
'^              Jump to last insert
'[              Jump to start of last change/yank
']              Jump to end of last change/yank
```

## Registers

```vim
"ayy            Yank line to register a
"ap             Paste from register a
"Ayy            Append line to register a
:reg            Show all registers
:reg a          Show register a
"+y             Yank to system clipboard (X11)
"+p             Paste from system clipboard
"*y             Yank to selection clipboard
"*p             Paste from selection clipboard
```

## NERDTree Plugin

Popular file explorer plugin for Vim.

### Installation

Using vim-plug (~/.vimrc):
```vim
call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree'
call plug#end()

" Auto-open NERDTree
autocmd VimEnter * NERDTree | wincmd p

" Toggle with Ctrl+n
nnoremap <C-n> :NERDTreeToggle<CR>

" Close vim if only NERDTree is left
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
```

Using Vundle:
```vim
Plugin 'preservim/nerdtree'
```

### NERDTree Commands

```vim
:NERDTree       Open NERDTree
:NERDTreeToggle Toggle NERDTree
:NERDTreeFind   Find current file in NERDTree
:NERDTreeClose  Close NERDTree
```

### NERDTree Navigation

```vim
o               Open file/directory
t               Open in new tab
T               Open in new tab (stay in NERDTree)
i               Open in horizontal split
s               Open in vertical split
x               Close parent directory
X               Close all child directories
p               Go to parent directory
P               Go to root directory
K               Go to first child
J               Go to last child
Ctrl+w w        Switch between NERDTree and file
m               Show menu (add, delete, move, copy files)
r               Refresh current directory
R               Refresh root directory
q               Close NERDTree
?               Toggle help
```

### NERDTree Menu (press 'm')

```
a               Add new file/directory (end with / for directory)
m               Move/rename file
d               Delete file
c               Copy file
l               List current directory
```

### Useful NERDTree Settings

```vim
" ~/.vimrc
let NERDTreeShowHidden=1              " Show hidden files
let NERDTreeIgnore=['\.pyc$', '\~$']  " Ignore certain files
let NERDTreeQuitOnOpen=0              " Don't close after opening file
let NERDTreeMinimalUI=1               " Minimal UI
let NERDTreeDirArrows=1               " Use arrows instead of + ~
```

## Supertab Plugin

Auto-completion using Tab key.

### Installation

Using vim-plug (~/.vimrc):
```vim
call plug#begin('~/.vim/plugged')
Plug 'ervandew/supertab'
call plug#end()
```

Using Vundle:
```vim
Plugin 'ervandew/supertab'
```

### Supertab Usage

```vim
# In Insert mode:
Tab             Trigger auto-completion
Shift+Tab       Scroll backward through completions
```

### Supertab Configuration

```vim
" ~/.vimrc

" Completion from top to bottom
let g:SuperTabDefaultCompletionType = "<c-n>"

" Context-aware completion
let g:SuperTabDefaultCompletionType = "context"

" Completion menu length
let g:SuperTabLongestEnhanced = 1
let g:SuperTabLongestHighlight = 1

" Close preview window after completion
let g:SuperTabClosePreviewOnPopupClose = 1
```

### Supertab Completion Types

Supertab can trigger different types of completion:

```vim
Ctrl+n          Next completion
Ctrl+p          Previous completion
Ctrl+x Ctrl+o   Omni completion (language-aware)
Ctrl+x Ctrl+f   File path completion
Ctrl+x Ctrl+l   Line completion
Ctrl+x Ctrl+]   Tag completion
```

## Other Useful Plugins

### Plugin Manager (vim-plug)

```vim
" Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

" In ~/.vimrc
call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree'        " File explorer
Plug 'ervandew/supertab'         " Tab completion
Plug 'tpope/vim-fugitive'        " Git integration
Plug 'vim-airline/vim-airline'   " Status line
Plug 'tpope/vim-commentary'      " Easy commenting
Plug 'tpope/vim-surround'        " Surround text
Plug 'junegunn/fzf.vim'          " Fuzzy finder

call plug#end()

" Install plugins: :PlugInstall
" Update plugins: :PlugUpdate
" Remove unused: :PlugClean
```

## Advanced Operations

### Folding

```vim
zf              Create fold
zo              Open fold
zc              Close fold
za              Toggle fold
zR              Open all folds
zM              Close all folds
zd              Delete fold
```

### Indentation

```vim
>>              Indent line right
<<              Indent line left
==              Auto-indent line
gg=G            Auto-indent entire file
>%              Indent block (cursor on bracket)
```

### Sorting

```vim
:sort           Sort lines
:sort!          Sort reverse
:sort u         Sort and remove duplicates
:sort n         Sort numerically
```

### Other

```vim
Ctrl+a          Increment number under cursor
Ctrl+x          Decrement number under cursor
gq              Format paragraph
gf              Open file under cursor
Ctrl+o          Go to previous position
Ctrl+i          Go to next position
:!command       Execute shell command
:r !command     Insert command output
:w !sudo tee %  Save file with sudo
```

## Essential ~/.vimrc Configuration

```vim
" Basic settings
set number                    " Line numbers
set relativenumber            " Relative line numbers
set ruler                     " Show cursor position
set showcmd                   " Show command in status line
set showmode                  " Show current mode
set wildmenu                  " Command-line completion
set laststatus=2              " Always show status line

" Indentation
set tabstop=4                 " Tab width
set shiftwidth=4              " Indent width
set expandtab                 " Spaces instead of tabs
set autoindent                " Auto indent
set smartindent               " Smart indent

" Search
set hlsearch                  " Highlight search
set incsearch                 " Incremental search
set ignorecase                " Case insensitive search
set smartcase                 " Case sensitive if caps used

" Interface
syntax on                     " Syntax highlighting
set mouse=a                   " Mouse support
set cursorline                " Highlight current line
set scrolloff=8               " Keep 8 lines visible above/below cursor
set wrap                      " Wrap lines
set linebreak                 " Break at word boundaries

" Clipboard
set clipboard=unnamedplus     " System clipboard

" Spell checking (Polish + English)
set spelllang=pl,en_us        " Polish and English
" set spell                   " Uncomment to enable by default
nnoremap <F6> :setlocal spell! spelllang=pl,en_us<CR>

" File encoding
set encoding=utf-8
set fileencoding=utf-8

" Backup and undo
set nobackup                  " No backup files
set noswapfile                " No swap files
set undofile                  " Persistent undo
set undodir=~/.vim/undodir    " Undo directory

" Performance
set lazyredraw                " Don't redraw during macros
set ttyfast                   " Faster scrolling

" Key mappings
let mapleader = ","           " Leader key
nnoremap <Leader>w :w<CR>     " Quick save
nnoremap <Leader>q :q<CR>     " Quick quit
nnoremap <C-n> :NERDTreeToggle<CR>  " Toggle NERDTree

" Clear search highlighting with Esc
nnoremap <silent> <Esc> :noh<CR>

" Move lines up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
```

## Quick Reference

```vim
# Essential
i, a, o         Enter insert mode
Esc             Exit to normal mode
:w              Save
:q              Quit
:wq             Save and quit

# Movement
0, ^, $         Start, first char, end of line
gg, G           First, last line of file
w, b            Word forward/backward

# Editing
dd              Delete line
yy              Copy line
p               Paste
u               Undo
Ctrl+r          Redo

# Spell checking (Polish)
:set spell spelllang=pl,en_us  Enable Polish spell check
]s, [s          Next/previous misspelled word
z=              Spelling suggestions
zg              Add to dictionary

# Word count
g Ctrl+g        Detailed stats including word count

# NERDTree
:NERDTreeToggle Toggle file explorer
o               Open file/directory
t               Open in new tab
i/s             Open in split

# Supertab
Tab             Auto-complete (in insert mode)
```

**Remember**: Most commands work with counts (e.g., `3dd` deletes 3 lines, `5w` moves 5 words forward)!
