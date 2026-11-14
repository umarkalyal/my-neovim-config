-- Plugin: nvim-telescope/telescope.nvim
-- Purpose: Fuzzy finder/picker for files, grep results, buffers, and more.
return {
  "nvim-telescope/telescope.nvim",
  -- Use the stable 0.1.x branch.
  branch = "0.1.x",
  dependencies = {
    -- Lua utility library required by Telescope.
    "nvim-lua/plenary.nvim",
  },
}
