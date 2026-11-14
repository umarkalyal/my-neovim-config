-- Global keymaps (editor navigation, plugins, terminal, LSP, etc.).
local map = vim.keymap.set

-- Wrapper to toggle the custom terminal manager panel (left terminal, right terminal list).
local toggle_term = function()
  require("config.terminal-manager").toggle()
end

-- OpenCode terminal command/options (used with snacks.terminal integration).
local opencode_cmd = "opencode"
local opencode_terminal_opts = {
  win = { position = "right", width = 0.35, enter = false },
}

-- Toggle the OpenCode terminal in a right-side split.
local function toggle_opencode()
  require("snacks.terminal").toggle(opencode_cmd, opencode_terminal_opts)
end

-- File explorer (nvim-tree)
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "File tree" })
map("n", "<leader>E", "<cmd>NvimTreeFindFile<cr>", { desc = "Current file in tree" })

-- OpenCode integration keymaps
map({ "n", "t" }, "<C-.>", toggle_opencode, { desc = "Toggle opencode" })
map("n", "<leader>oo", toggle_opencode, { desc = "Toggle opencode" })
map({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ") end, { desc = "Ask opencode" })
map({ "n", "x" }, "<leader>os", function() require("opencode").select() end, { desc = "opencode actions" })

-- Custom terminal manager toggle keymaps
map({ "n", "t" }, "<C-/>", toggle_term, { desc = "Toggle terminal" })
map({ "n", "t" }, "<C-_>", toggle_term, { desc = "Toggle terminal" }) -- Some terminals send Ctrl+/ as Ctrl+_
map("n", "<leader>tt", toggle_term, { desc = "Toggle terminal" })

-- Helper to lazily call Telescope builtins.
local telescope_builtin = function(name)
  return function()
    require("telescope.builtin")[name]()
  end
end

-- Telescope pickers
map("n", "<leader>ff", telescope_builtin("find_files"), { desc = "Find files" })
map("n", "<leader>fg", telescope_builtin("live_grep"), { desc = "Grep" })
map("n", "<leader>fb", telescope_builtin("buffers"), { desc = "Buffers" })

-- Buffer navigation and basic file actions
map("n", "<S-l>", "<cmd>bnext<cr>")
map("n", "<S-h>", "<cmd>bprevious<cr>")
map("n", "<leader>x", "<cmd>bdelete<cr>", { desc = "Close buffer" })
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })

-- Window navigation (normal mode)
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")

-- Exit terminal insert mode quickly
map("t", "<Esc><Esc>", "<C-\\><C-n>")

-- LSP keymaps (work when an LSP client is attached/provides capabilities)
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
