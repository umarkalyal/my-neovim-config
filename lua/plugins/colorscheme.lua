-- Plugin: folke/tokyonight.nvim
-- Purpose: Provides the TokyoNight colorscheme (theme) for Neovim UI and syntax highlighting.
return {
  "folke/tokyonight.nvim",
  -- Load early so the colorscheme is applied before other UI plugins render.
  priority = 1000,
  config = function()
    -- Apply the TokyoNight Night variant.
    vim.cmd.colorscheme("tokyonight-night")
  end,
}
