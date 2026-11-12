# telescope.nvim (fuzzy finder)

**Intro:** Fast fuzzy finder for files, text, buffers, and more. Depends on `plenary.nvim`.

## Keymaps (from `lua/config/keymaps.lua`)
- `<leader>ff` — find files
- `<leader>fg` — live grep (search text in project, uses `ripgrep`)
- `<leader>fb` — list/open buffers

## Common Telescope controls (defaults inside picker)
- `<C-n>/<C-p>` or arrows — move selection
- `<CR>` — open selection
- `<Esc>` — close picker
- `<C-x>` — open in horizontal split
- `<C-v>` — open in vertical split
- `<C-t>` — open in tab
- Type to filter results live

## Tips
- Make sure `ripgrep` is installed for `<leader>fg` to work properly.
- You can run `:Telescope` to explore more built-in pickers.
