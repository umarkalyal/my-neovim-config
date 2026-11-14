-- Plugin: NickvanDyke/opencode.nvim
-- Purpose: Integrates OpenCode into Neovim (ask/select actions and use an AI coding workflow).
-- Uses Snacks.nvim as the UI/provider backend (input, picker, terminal).
return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    {
      "folke/snacks.nvim",
      -- Enable Snacks modules used by opencode.nvim integration.
      opts = { input = {}, picker = {}, terminal = {} },
    },
  },
  config = function()
    -- Configure opencode.nvim to use Snacks as its provider and open on the right side.
    vim.g.opencode_opts = {
      provider = {
        enabled = "snacks",
        snacks = { win = { position = "right", width = 0.35, enter = false } },
      },
    }
  end,
}
