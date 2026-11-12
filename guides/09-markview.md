# markview.nvim (in-buffer Markdown rendering)

**Intro:** Renders Markdown nicely inside Neovim (inline/in-buffer preview) so notes/docs are easier to read while editing.

## Config highlights
- Loaded eagerly (`lazy = false`, high priority)
- Uses `nvim-web-devicons` as icon provider
- Depends on Treesitter (`markdown` / `markdown_inline` parsers configured in this setup)

## Usage
- Open a Markdown file (`.md`)
- `:Markview` — toggle rendering in the current view
- `:Markview splitToggle` — toggle side-by-side editor/preview style view

## Tips
- If rendering looks off, make sure Markdown Treesitter parsers are installed/working.
- Use `:help markview.nvim` (if available) for more commands/options.
