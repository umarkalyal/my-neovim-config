# nvim-treesitter (syntax & indentation)

**Intro:** Better syntax highlighting, parsing, and indentation using Tree-sitter. Configured on the `main` branch API for Neovim 0.12.

## Config highlights
- Auto-installs parsers for: lua, python, javascript, typescript, tsx, html, css, json, bash, markdown, markdown_inline
- Starts Tree-sitter highlighting on matching filetypes
- Sets Tree-sitter-based indentation (`indentexpr`)

## Usage
- Parsers install/update via `:TSUpdate` (also used as build step).
- Open a supported file and highlighting/indent should work automatically.
- Check status/logs with `:checkhealth nvim-treesitter` (and general `:checkhealth`).

## Notes
- Because Neovim 0.12 + Treesitter `main` API can change, keep plugin version and setup API in sync when updating.
