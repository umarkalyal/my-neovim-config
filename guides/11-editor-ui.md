# Editor UI plugins (lualine, bufferline, which-key, gitsigns, nvim-autopairs)

**Intro:** Small quality-of-life plugins that improve statusline, buffer tabs, key hints, git signs, and auto-pairing.

## lualine.nvim
- **What it does:** statusline at the bottom.
- **Config:** uses `tokyonight` theme.
- **Usage:** automatic; shows mode/file/git/diagnostics info depending on defaults.

## bufferline.nvim
- **What it does:** buffer/tab-like line at the top.
- **Config:** adds an offset when `NvimTree` is open (`Explorer`).
- **Useful keymaps (from `lua/config/keymaps.lua`):**
  - `<S-l>` — next buffer
  - `<S-h>` — previous buffer
  - `<leader>x` — close current buffer
  - `<leader>w` — save buffer

## which-key.nvim
- **What it does:** popup hints for keybindings (helps discover leader mappings).
- **Config:** loads on `VeryLazy` with defaults.
- **Usage:** press `<leader>` (space) and pause to see available mappings.

## gitsigns.nvim
- **What it does:** git change indicators in the sign column (added/changed/removed hunks) and git hunk actions (defaults).
- **Config:** default setup.
- **Usage:** open a file in a git repo to see signs; explore `:Gitsigns` commands and `:h gitsigns` for hunk keymaps/actions.

## nvim-autopairs
- **What it does:** auto-inserts matching pairs (quotes, brackets, etc.) in insert mode.
- **Config:** loads on `InsertEnter` with defaults.
- **Usage:** automatic while typing.
