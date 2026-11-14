-- Plugin: saghen/blink.cmp
-- Purpose: Completion engine for insert mode (LSP/buffer/path/snippet suggestions, depending on sources/defaults).
return {
  "saghen/blink.cmp",
  -- Pin to major version 1.x for stability.
  version = "1.*",
  opts = {
    -- Use blink.cmp's default keymap preset.
    keymap = { preset = "default" },
  },
}
