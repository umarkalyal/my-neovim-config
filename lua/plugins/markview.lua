return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  priority = 900,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    preview = {
      icon_provider = "devicons",
    },
  },
}
