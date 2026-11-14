-- Editor options (Neovim behavior and UI defaults)
local o = vim.opt

-- Line numbers: show absolute current line and relative numbers for others.
o.number = true
o.relativenumber = true

-- Enable mouse support in all modes.
o.mouse = "a"

-- Use system clipboard for yank/delete/paste operations.
o.clipboard = "unnamedplus"

-- Enable true color support in terminal UI.
o.termguicolors = true

-- Indentation: use spaces instead of tabs, 2-space width.
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2

-- Searching: case-insensitive by default, smart-case when uppercase is used.
o.ignorecase = true
o.smartcase = true

-- Always show sign column (diagnostics/git signs) to avoid text shifting.
o.signcolumn = "yes"

-- Highlight the current cursor line.
o.cursorline = true

-- Open vertical splits to the right by default.
o.splitright = true

-- Automatically reload files changed outside Neovim.
o.autoread = true

-- Faster update time for events like CursorHold and diagnostics.
o.updatetime = 250

-- Soft-wrap long lines and wrap at word boundaries when possible.
o.wrap = true
o.linebreak = true
