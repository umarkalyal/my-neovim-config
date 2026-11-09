local map = vim.keymap.set
local toggle_term = require("config.terminal")
local opencode_cmd = "opencode"
local opencode_terminal_opts = {
  win = { position = "right", width = 0.35, enter = false },
}
local function toggle_opencode()
  require("snacks.terminal").toggle(opencode_cmd, opencode_terminal_opts)
end

map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "File tree" })
map("n", "<leader>E", "<cmd>NvimTreeFindFile<cr>", { desc = "Current file in tree" })

map({ "n", "t" }, "<C-.>", toggle_opencode, { desc = "Toggle opencode" })
map("n", "<leader>oo", toggle_opencode, { desc = "Toggle opencode" })
map({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ") end, { desc = "Ask opencode" })
map({ "n", "x" }, "<leader>os", function() require("opencode").select() end, { desc = "opencode actions" })

map({ "n", "t" }, "<C-/>", toggle_term, { desc = "Toggle terminal" })
map({ "n", "t" }, "<C-_>", toggle_term, { desc = "Toggle terminal" })
map("n", "<leader>tt", toggle_term, { desc = "Toggle terminal" })

local telescope_builtin = function(name)
  return function() require("telescope.builtin")[name]() end
end
map("n", "<leader>ff", telescope_builtin("find_files"), { desc = "Find files" })
map("n", "<leader>fg", telescope_builtin("live_grep"), { desc = "Grep" })
map("n", "<leader>fb", telescope_builtin("buffers"), { desc = "Buffers" })

map("n", "<S-l>", "<cmd>bnext<cr>")
map("n", "<S-h>", "<cmd>bprevious<cr>")
map("n", "<leader>x", "<cmd>bdelete<cr>", { desc = "Close buffer" })
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("t", "<Esc><Esc>", "<C-\\><C-n>")

map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })