# LSP, Mason, and mason-lspconfig

**Intro:** Language Server Protocol support for code intelligence (definitions, hover, rename, code actions, diagnostics). Mason manages installing LSP servers.

## Plugins
- `williamboman/mason.nvim` — LSP/tool installer UI
- `williamboman/mason-lspconfig.nvim` — bridge between Mason and lspconfig
- `neovim/nvim-lspconfig` — LSP configurations

## Config highlights
- Mason auto-ensures these servers: `lua_ls`, `pyright`, `ts_ls`, `html`, `cssls`

## Keymaps (from `lua/config/keymaps.lua`)
- `gd` — go to definition
- `K` — hover docs
- `<leader>rn` — rename symbol
- `<leader>ca` — code action

## Usage
- `:Mason` — open installer UI to manage servers/tools
- `:LspInfo` — see active LSP clients for current buffer
- `:checkhealth` — diagnose missing dependencies/providers

## Tips
- Some servers need external runtimes (e.g. Node.js for `ts_ls/html/cssls`, Python for `pyright`). Install those on your system if needed.
