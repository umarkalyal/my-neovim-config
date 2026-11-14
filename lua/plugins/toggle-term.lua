-- Plugin spec (local module): loads the custom terminal manager implementation.
-- Purpose: Initializes `lua/config/terminal-manager.lua` (VS Code-like terminal panel: terminal left, list right).
-- Note: This replaces the previous toggleterm.nvim-based workflow for this config.
return {
  -- Treat the Neovim config directory as the plugin source (local module setup).
  dir = vim.fn.stdpath("config"),
  name = "terminal-manager",
  -- Load on startup so terminal keymaps/autocmds are available immediately.
  lazy = false,
  config = function()
    -- Set up global keymaps and autocmds for the custom terminal manager.
    require("config.terminal-manager").setup()
  end,
}
