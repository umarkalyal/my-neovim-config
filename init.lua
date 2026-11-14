-- Set leader key early so plugin/keymap definitions use <Space> as <leader>.
vim.g.mapleader = " "

-- Load core editor options (numbers, tabs, clipboard, UI behavior, etc.).
require("config.options")

-- Load global/custom keymaps (file tree, terminal, telescope, LSP, buffers, etc.).
require("config.keymaps")

-- Load autocommands (startup behavior and editor automation).
require("config.autocmds")

-- Bootstrap/load lazy.nvim and import plugin specs from lua/plugins/.
require("config.lazy")
