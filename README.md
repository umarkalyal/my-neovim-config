# Neovim Configuration

Hi, hope you are doing well, this is my personal Neovim configuation.
> **Credit:** The modularization of the configuration structure was inspired by [NeuralNine](https://github.com/NeuralNine). The plugin choices, settings, keymaps, and overall configuration are my personal setup.

## Features

- TokyoNight theme
- NvimTree file explorer with a startup editor layout
- OpenCode integration using Snacks
- Custom terminal manager panel (active terminal on the left, terminal list on the right) with multi-terminal support
- Telescope file, text, and buffer search
- Treesitter syntax highlighting and indentation
- Mason-managed LSP servers
- In-buffer and side-by-side Markdown rendering with `markview.nvim`
- Browser-based Markdown preview with `iamcco/markdown-preview.nvim`
- Blink completion
- Lualine, Bufferline, Which-Key, Gitsigns, nvim-autopairs, Comment.nvim, Noice, and smooth scrolling with Neoscroll

## Yapping

> I use arch btw!!!, and suggest you to use that as well. This configuration is best for linux, for windows it may break as i've not checkt it.

## Structure

```text
.
├── init.lua
├── lazy-lock.json
├── guides/
├── lua/
│   ├── config/
│   │   ├── autocmds.lua
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   ├── options.lua
│   │   ├── terminal.lua
│   │   └── terminal-manager.lua
│   └── plugins/
│       ├── colorscheme.lua
│       ├── comments-nvim.lua
│       ├── completion.lua
│       ├── editor-ui.lua
│       ├── lsp.lua
│       ├── markdown-preview.lua
│       ├── markview.lua
│       ├── neoscroll.lua
│       ├── noice.lua
│       ├── nvim-tree.lua
│       ├── opencode.lua
│       ├── telescope.lua
│       ├── toggle-term.lua
│       └── treesitter.lua
└── old guide.md
```

- `init.lua` loads the core modules.
- `lua/config/` contains editor options, general keymaps, autocommands, terminal behavior, the custom terminal manager, and Lazy.nvim bootstrap.
- `lua/plugins/` contains Lazy.nvim plugin specifications, automatically imported by `lua/config/lazy.lua`.
- `guides/` has short guides for the plugins/config pieces I use, so I (or you) can quickly remember what does what.
- `lazy-lock.json` records installed plugin revisions for reproducible plugin versions.
- `old guide.md` preserves the previous setup notes.

## Requirements

Install Neovim, Git, a C compiler/build tools, `ripgrep`, and `fd`. Node.js/npm and a Nerd Font are useful for language tooling and icons. Install and configure OpenCode separately if you want to use its Neovim integration.

On first launch, Lazy.nvim bootstraps and installs the declared plugins. Open `:Lazy` to inspect plugin status and `:checkhealth` to diagnose missing external dependencies.

## Terminal Manager

I added a custom terminal manager (kind of a VS Code-ish workflow) because I wanted an active terminal on the left and a terminal list on the right.

- Toggle panel: `<C-/>`, `<C-_>`, or `<leader>tt`
- New terminal: `<C-S-\`>` / Ctrl+Shift+\` (or `a` in the terminal list)
- Remove selected terminal: `<leader>tx` (or `x` in the terminal list, removes only that terminal)
- Select/open terminal from list: `<CR>` (moves focus to the terminal pane)
- Focus list sidebar from terminal: `<M-l>` (Alt+l)
- Focus terminal pane from list: `<M-h>` (Alt+h)
- Hide panel: `q` in the terminal list
- Switch terminals: `<S-j>` (next) / `<S-k>` (previous)

If a shell exits (like typing `exit`), that terminal is removed from the list automatically.

## Markdown Preview

`markview.nvim` renders Markdown inside Neovim. Open a Markdown buffer and run `:Markview` to toggle rendering in the current view, or `:Markview splitToggle` for a side-by-side editor and preview. It uses the configured Treesitter `markdown` and `markdown_inline` parsers.

`iamcco/markdown-preview.nvim` is also available for a synchronized browser preview. Run `:MarkdownPreview` to open it, `:MarkdownPreviewToggle` to toggle it, or `:MarkdownPreviewStop` to stop it. A browser must be available to open the local preview page.

## Notes

Treesitter uses its `main` branch API for Neovim 0.12. Keep the plugin branch and setup API in sync when updating it.
