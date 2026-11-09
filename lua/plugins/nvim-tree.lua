return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup({
      view = { width = 32, side = "left" },
      renderer = { group_empty = true },
      filters = { dotfiles = false },
    })
  end,
}