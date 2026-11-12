# opencode.nvim + snacks.nvim (OpenCode integration)

**Intro:** Integrates OpenCode into Neovim using Snacks for input/picker/terminal UI. Lets you toggle an OpenCode terminal and ask/select actions with context.

## Config highlights
- Provider: `snacks`
- OpenCode terminal opens on the right (`width = 0.35`, does not auto-enter)
- Depends on `folke/snacks.nvim` (input, picker, terminal enabled)

## Keymaps (from `lua/config/keymaps.lua`)
- `<C-.>` (normal/terminal) — toggle OpenCode terminal
- `<leader>oo` — toggle OpenCode terminal
- `<leader>oa` (normal/visual) — ask OpenCode with `@this:` context prompt
- `<leader>os` (normal/visual) — open OpenCode actions selector

## Requirements
- OpenCode must be installed/configured separately on your system (`opencode` command available).
- If it doesn't open, verify the command works in your shell and check `:checkhealth`/plugin errors.
