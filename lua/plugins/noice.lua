-- Plugin: folke/noice.nvim
-- Purpose: Replaces/enhances Neovim's messages, cmdline, and popup UI for a cleaner experience.
return {
  "folke/noice.nvim",
  -- Load later to reduce startup cost.
  event = "VeryLazy",
  opts = {
    -- Add custom Noice options here if needed.
  },
  dependencies = {
    -- UI component library required by Noice.
    "MunifTanjim/nui.nvim",
    -- Notification backend used by Noice's notification views (optional/fallback behavior supported).
    "rcarriga/nvim-notify",
  },
}
