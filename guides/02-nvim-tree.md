# nvim-tree.lua (file explorer)

**Intro:** File tree/explorer in a left sidebar. Opens automatically on Neovim startup and lets you browse/edit the project tree.

## Config highlights
- Width: 32, side: left
- Groups empty folders
- Shows dotfiles

## Keymaps (from `lua/config/keymaps.lua`)
- `<leader>e` — toggle file tree
- `<leader>E` — reveal current file in tree

## Common nvim-tree keys (defaults)
When focused in the tree:
- `<CR>` / `o` — open file/folder
- `a` — create file/folder
- `d` — delete
- `r` — rename
- `x` / `c` / `p` — cut/copy/paste
- `R` — refresh
- `q` — close tree window
- `g?` — show help with all mappings

## Notes
- On startup, an autocmd opens the tree and moves focus back to the editor window (`lua/config/autocmds.lua`).
