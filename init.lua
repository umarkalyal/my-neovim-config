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

  -- Syntax
  { "nvim-treesitter/nvim-treesitter", branch = "master", build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "python", "javascript", "typescript", "tsx", "html", "css", "json", "bash", "markdown" },
        highlight = { enable = true },
        indent = { enable = true },
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

-- Terminal (bottom)

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
