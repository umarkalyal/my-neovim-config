-- UI and editor enhancement plugins (statusline, buffer tabs, key hints, git signs, autopairs).
return {
  -- Plugin: nvim-lualine/lualine.nvim
  -- Purpose: Configurable statusline showing mode, file, git, diagnostics, etc.
  { "nvim-lualine/lualine.nvim", opts = { options = { theme = "tokyonight" } } },

  -- Plugin: akinsho/bufferline.nvim
  -- Purpose: Displays open buffers in a top tab-like line.
  {
    "akinsho/bufferline.nvim",
    version = "*",
    opts = {
      options = {
        -- Leave space when NvimTree is open so the bufferline aligns with the editor area.
        offsets = { { filetype = "NvimTree", text = "Explorer", separator = true } },
      },
    },
  },

  -- Plugin: folke/which-key.nvim
  -- Purpose: Shows available keybinding hints/popups (useful for <leader> mappings).
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },

  -- Plugin: lewis6991/gitsigns.nvim
  -- Purpose: Shows git change indicators in the sign column and provides git hunk utilities.
  { "lewis6991/gitsigns.nvim", opts = {} },

  -- Plugin: windwp/nvim-autopairs
  -- Purpose: Automatically inserts matching pairs ((), {}, "", '', etc.) while typing.
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
}
