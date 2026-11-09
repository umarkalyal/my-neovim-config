return {
  { "nvim-lualine/lualine.nvim", opts = { options = { theme = "tokyonight" } } },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    opts = {
      options = {
        offsets = { { filetype = "NvimTree", text = "Explorer", separator = true } },
      },
    },
  },
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },
  { "lewis6991/gitsigns.nvim", opts = {} },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
}