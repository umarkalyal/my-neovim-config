# Neovim Configuration

Hi, hope you are doing well, this is my personal Neovim configuation.
> **Credit:** The modularization of the configuration structure was inspired by [NeuralNine](https://github.com/NeuralNine). The plugin choices, settings, keymaps, and overall configuration are my personal setup.

## Features

- TokyoNight theme
- NvimTree file explorer with a startup editor layout
- OpenCode integration using Snacks
- Built-in terminal toggle
- Telescope file, text, and buffer search
- Treesitter syntax highlighting and indentation
- Mason-managed LSP servers
- In-buffer and side-by-side Markdown rendering with `markview.nvim`
- Browser-based Markdown preview with `iamcco/markdown-preview.nvim`
- Blink completion
- Lualine, Bufferline, Which-Key, Gitsigns, and nvim-autopairs

## Yapping

> I use arch btw!!!, and suggest you to use that as well. This configuration is best for linux, for windows it may break as i've not checkt it.

## Structure

```text
.
├── init.lua
├── lazy-lock.json
├── lua/
│   ├── config/
│   │   ├── autocmds.lua
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   ├── options.lua
│   │   └── terminal.lua
│   └── plugins/
│       ├── colorscheme.lua
│       ├── completion.lua
│       ├── editor-ui.lua
│       ├── lsp.lua
│       ├── markview.lua
│       ├── markdown-preview.lua
│       ├── nvim-tree.lua
│       ├── opencode.lua
│       ├── telescope.lua
│       └── treesitter.lua
└── old guide.md
```

- `init.lua` loads the core modules.
- `lua/config/` contains editor options, general keymaps, autocommands, terminal behavior, and Lazy.nvim bootstrap.
- `lua/plugins/` contains Lazy.nvim plugin specifications, automatically imported by `lua/config/lazy.lua`.
- `lazy-lock.json` records installed plugin revisions for reproducible plugin versions.
- `old guide.md` preserves the previous setup notes.

## Requirements

Install Neovim, Git, a C compiler/build tools, `ripgrep`, and `fd`. Node.js/npm and a Nerd Font are useful for language tooling and icons. Install and configure OpenCode separately if you want to use its Neovim integration.

On first launch, Lazy.nvim bootstraps and installs the declared plugins. Open `:Lazy` to inspect plugin status and `:checkhealth` to diagnose missing external dependencies.

## Markdown Preview

`markview.nvim` renders Markdown inside Neovim. Open a Markdown buffer and run `:Markview` to toggle rendering in the current view, or `:Markview splitToggle` for a side-by-side editor and preview. It uses the configured Treesitter `markdown` and `markdown_inline` parsers.

`iamcco/markdown-preview.nvim` is also available for a synchronized browser preview. Run `:MarkdownPreview` to open it, `:MarkdownPreviewToggle` to toggle it, or `:MarkdownPreviewStop` to stop it. A browser must be available to open the local preview page.

## Notes

Treesitter uses its `main` branch API for Neovim 0.12. Keep the plugin branch and setup API in sync when updating it.
