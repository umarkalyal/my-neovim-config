-- Plugin: nvim-tree/nvim-tree.lua
-- Purpose: File explorer sidebar for browsing and managing project files.
return {
  "nvim-tree/nvim-tree.lua",
  -- Load on startup so it can be opened automatically (see autocmds).
  lazy = false,
  dependencies = {
    -- File icons in the tree.
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      view = {
        width = 32,  -- Sidebar width.
        side = "left", -- Open tree on the left.
      },
      renderer = {
        group_empty = true, -- Compact display for nested empty folders.
      },
      filters = {
        dotfiles = false, -- Show dotfiles by default.
      },
    })
  end,
}
