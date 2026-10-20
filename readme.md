# Neovim IDE Setup (Antigravity-style) on Arch Linux

**Goal:** Neovim ko Antigravity jaisa look dena:

- **Left:** folder tree (nvim-tree)
- **Center:** editor
- **Right:** opencode (AI coding agent)
- **Bottom:** terminal (`Ctrl+/`)

---

## 1. Required packages (Arch)

```bash
sudo pacman -S --needed neovim git base-devel ripgrep fd unzip curl nodejs npm \
  wl-clipboard xclip lazygit ttf-jetbrains-mono-nerd tree-sitter-cli gcc
```

opencode install (koi ek):

```bash
sudo pacman -S opencode      # agar repo mein ho
# ya
npm i -g opencode-ai
```

| Package | Kyun chahiye |
|---|---|
| `neovim` | editor (0.10+ better) |
| `git` | lazy.nvim plugins clone karta hai |
| `base-devel`, `gcc` | treesitter parsers compile karne ke liye |
| `tree-sitter-cli` | treesitter `main` branch ko zaroori hai |
| `ripgrep` | Telescope live grep |
| `fd` | Telescope fast file search |
| `nodejs`, `npm` | LSP servers (ts_ls, pyright) aur opencode |
| `wl-clipboard`, `xclip` | system clipboard (Wayland / X11) |
| `lazygit` | git UI (optional) |
| `ttf-jetbrains-mono-nerd` | icons ke liye Nerd Font |
| `unzip`, `curl` | Mason downloads |

> Terminal ka font **JetBrainsMono Nerd Font** set karna zaroori hai, warna icons toot jate hain.

---

## 2. Plugins (lazy.nvim auto-install karta hai)

| Plugin | Kaam |
|---|---|
| lazy.nvim | plugin manager |
| tokyonight | theme |
| nvim-tree | left folder tree |
| opencode.nvim + snacks.nvim | right side opencode |
| lualine | status bar |
| bufferline | tabs |
| telescope + plenary | file / text search |
| treesitter | syntax highlight |
| mason + mason-lspconfig + lspconfig | LSP servers |
| blink.cmp | autocomplete |
| which-key | key hints |
| gitsigns | git +/~ marks |
| nvim-autopairs | auto brackets |

---

## 3. Final `~/.config/nvim/init.lua` (sab fixes ke baad)

```lua
-- ===== Basics =====
vim.g.mapleader = " "
local o = vim.opt
o.number = true
o.relativenumber = true
o.mouse = "a"
o.clipboard = "unnamedplus"
o.termguicolors = true
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.ignorecase = true
o.smartcase = true
o.signcolumn = "yes"
o.cursorline = true
o.splitright = true
o.autoread = true -- opencode ki changes auto reload hon
o.updatetime = 250

-- ===== lazy.nvim bootstrap =====
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- ===== Plugins =====
require("lazy").setup({
  -- Theme
  { "folke/tokyonight.nvim", priority = 1000,
    config = function() vim.cmd.colorscheme("tokyonight-night") end },

  -- Left: file tree
  { "nvim-tree/nvim-tree.lua", lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 32, side = "left" },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
      })
    end },

  -- Right: opencode
  { "NickvanDyke/opencode.nvim",
    dependencies = { { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } } },
    config = function()
      vim.g.opencode_opts = {
        provider = {
          enabled = "snacks",
          snacks = { win = { position = "right", width = 0.35, enter = false } },
        },
      }
    end },

  -- UI
  { "nvim-lualine/lualine.nvim", opts = { options = { theme = "tokyonight" } } },
  { "akinsho/bufferline.nvim", version = "*",
    opts = { options = {
      offsets = { { filetype = "NvimTree", text = "Explorer", separator = true } } } } },
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },
  { "lewis6991/gitsigns.nvim", opts = {} },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },

  -- Search
  { "nvim-telescope/telescope.nvim", branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" } },

  -- Syntax (treesitter main branch)
  { "nvim-treesitter/nvim-treesitter", branch = "main", lazy = false, build = ":TSUpdate",
    config = function()
      local langs = { "lua", "python", "javascript", "typescript", "tsx", "html", "css", "json", "bash", "markdown" }
      require("nvim-treesitter").install(langs)

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          if pcall(vim.treesitter.start, ev.buf) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end },

  -- LSP
  { "williamboman/mason.nvim", opts = {} },
  { "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
    opts = { ensure_installed = { "lua_ls", "pyright", "ts_ls", "html", "cssls" } } },

  -- Autocomplete
  { "saghen/blink.cmp", version = "1.*",
    opts = { keymap = { preset = "default" } } },
})

-- ===== Keymaps =====
local map = vim.keymap.set

-- Tree
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "File tree" })
map("n", "<leader>E", "<cmd>NvimTreeFindFile<cr>", { desc = "Current file in tree" })

-- OpenCode
map({ "n", "t" }, "<C-.>", function() require("opencode").toggle() end, { desc = "Toggle opencode" })
map("n", "<leader>oo", function() require("opencode").toggle() end, { desc = "Toggle opencode" })
map({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode" })
map({ "n", "x" }, "<leader>os", function() require("opencode").select() end, { desc = "opencode actions" })

-- Terminal (bottom, built-in)
local term = { buf = nil, win = nil }
local function toggle_term()
  if term.win and vim.api.nvim_win_is_valid(term.win) then
    vim.api.nvim_win_hide(term.win)
    term.win = nil
    return
  end
  vim.cmd("botright 12split")
  term.win = vim.api.nvim_get_current_win()
  if term.buf and vim.api.nvim_buf_is_valid(term.buf) then
    vim.api.nvim_win_set_buf(term.win, term.buf)
  else
    vim.cmd("terminal")
    term.buf = vim.api.nvim_get_current_buf()
    vim.bo[term.buf].buflisted = false
  end
  vim.cmd("startinsert")
end
map({ "n", "t" }, "<C-/>", toggle_term, { desc = "Toggle terminal" })
map({ "n", "t" }, "<C-_>", toggle_term, { desc = "Toggle terminal" })
map("n", "<leader>tt", toggle_term, { desc = "Toggle terminal" })

-- Telescope
local tb = function(f) return function() require("telescope.builtin")[f]() end end
map("n", "<leader>ff", tb("find_files"), { desc = "Find files" })
map("n", "<leader>fg", tb("live_grep"), { desc = "Grep" })
map("n", "<leader>fb", tb("buffers"), { desc = "Buffers" })

-- Buffers / windows
map("n", "<S-l>", "<cmd>bnext<cr>")
map("n", "<S-h>", "<cmd>bprevious<cr>")
map("n", "<leader>x", "<cmd>bdelete<cr>", { desc = "Close buffer" })
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("t", "<Esc><Esc>", "<C-\\><C-n>")

-- LSP
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

-- ===== Startup layout: tree left + editor center =====
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local ok, api = pcall(require, "nvim-tree.api")
    if not ok then return end
    api.tree.open()
    vim.cmd("wincmd l")
  end,
})
```

---

## 4. Hum ne kya kya kiya (step by step)

1. Arch par zaroori packages install kiye (neovim, git, ripgrep, fd, node, nerd font, etc.).
2. opencode install kiya (`pacman` ya `npm i -g opencode-ai`).
3. `~/.config/nvim/init.lua` banayi lazy.nvim ke saath. Plugins first launch par khud install hue.
4. Layout: nvim-tree (left), editor (center), opencode (right, `snacks` provider se 35% width).
5. Errors aaye, unke fixes kiye (neeche section 5 mein).
6. Test kiya: `:checkhealth`, `:Lazy`, `:Mason`, aur `test.py` par features.
7. opencode pehle terminal mein test kiya, phir Neovim ke andar.
8. `Ctrl+/` terminal toggle add kiya.

---

## 5. Errors aur unke fixes

| Error | Wajah | Fix |
|---|---|---|
| `module 'nvim-treesitter.configs' not found` | treesitter ka naya `main` branch rewrite ho gaya, `configs` module nahi raha | `branch = "main"`, `require("nvim-treesitter").install(...)`, aur `tree-sitter-cli` + `gcc` install |
| `module 'nvim-tree.api' not found` (VimEnter) | startup autocmd plugin load hone se pehle chala | nvim-tree par `lazy = false` aur `pcall(require, ...)` |
| `attempt to call field 'toggle' (a nil value)` | snacks terminal ka `toggle` is version mein nahi mila | Neovim ka built-in terminal use kiya (custom `toggle_term`) |
| `Ctrl+/` kaam nahi kar raha | key map hi nahi thi; kai terminals `Ctrl+/` ko `Ctrl+_` bhejte hain | dono `<C-/>` aur `<C-_>` map kiye, backup `Space t t` |

---

## 6. Keybindings cheat sheet

`Space` = leader key.

| Key | Kaam |
|---|---|
| `Space e` | tree toggle |
| `Space E` | current file tree mein dikhao |
| `Space ff` | file search |
| `Space fg` | text search (grep) |
| `Space fb` | open buffers |
| `Shift+L` / `Shift+H` | next / previous tab |
| `Space x` | buffer close |
| `Space w` | save |
| `Ctrl+h` / `Ctrl+l` | windows ke beech switch |
| `Space o o` | opencode toggle |
| `Space o a` | selected code opencode se poocho |
| `Space o s` | opencode actions menu |
| `Ctrl+/` ya `Space t t` | terminal toggle |
| `Esc Esc` | terminal se normal mode |
| `gd` | go to definition |
| `K` | hover info |
| `Space r n` | rename |
| `Space c a` | code action |
| `Space` (ruko) | which-key help |

---

## 7. Test kaise karen

```
:checkhealth
:Lazy
:Mason
```

```bash
mkdir -p ~/test && cd ~/test
printf 'def hello(name):\n    print("hi", name)\n\nhello("umar")\n' > test.py
nvim .
```

- Tree: `Space e`
- Search: `Space ff`, `Space fg`
- LSP: `K` aur `gd` function par
- Autocomplete: insert mode mein `pri`
- Terminal: `Ctrl+/`

### opencode test

```bash
opencode --version
opencode auth login    # ya TUI mein /connect
opencode               # terminal mein pehle test
```

Phir Neovim mein `Space o o` aur prompt do, jaise: `test.py mein goodbye function add karo`.
File na reload ho to `:checktime`.

Panel na khule to:

```
:checkhealth opencode
```

---

## 8. Troubleshooting

- Icons toot gaye: terminal ka font Nerd Font set karo.
- Plugins ka masla: `:Lazy sync`, phir restart.
- Treesitter reset: `rm -rf ~/.local/share/nvim/lazy/nvim-treesitter`, phir `nvim`.
- `Ctrl+/` na chale: insert mode mein `Ctrl+v` dabake `Ctrl+/` dabao, jo likha aaye wo map karo.
- opencode terminal mein pehle chalna chahiye, warna Neovim mein bhi nahi chalega.
- `opencode.nvim` ki API kabhi kabhi badalti hai, uska README check karte raho.
