return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    vim.g.opencode_opts = {
      provider = {
        enabled = "snacks",
        snacks = { win = { position = "right", width = 0.35, enter = false } },
      },
    }
  end,
}