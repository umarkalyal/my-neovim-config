-- Plugin: OXY2DEV/markview.nvim
-- Purpose: Renders Markdown directly inside Neovim (inline preview / enhanced reading view).
return {
  "OXY2DEV/markview.nvim",
  -- Load eagerly so Markdown rendering is ready immediately.
  lazy = false,
  -- High priority to initialize before related UI rendering where needed.
  priority = 900,
  dependencies = {
    -- Used for Markdown parsing/highlighting support.
    "nvim-treesitter/nvim-treesitter",
    -- Provides filetype/dev icons used by the preview.
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    preview = {
      -- Use devicons for preview icons.
      icon_provider = "devicons",
    },
  },
}
