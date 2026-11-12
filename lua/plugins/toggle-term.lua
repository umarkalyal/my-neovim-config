-- Use the custom terminal manager (VS Code-like: terminal left, list right)
-- instead of toggleterm.nvim, which was configured but not used by this workflow.
return {
  dir = vim.fn.stdpath("config"),
  name = "terminal-manager",
  lazy = false,
  config = function()
    require("config.terminal-manager").setup()
  end,
}

