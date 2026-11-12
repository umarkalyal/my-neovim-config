# Comment.nvim (commenting)

**Intro:** Quickly toggle comments for lines/selections using motions and operators.

## Config highlights
- Loaded with default options (`opts = {}`)

## Basic usage (defaults)
- `gcc` — toggle comment on current line
- `gc{motion}` — toggle comment over a motion (e.g. `gc3j`, `gcap`)
- `gbc` — toggle block comment on current line (in supported languages)
- Visual mode: select lines then `gc` (line comments) or `gb` (block comments)

## Tips
- Works with Treesitter-aware commentstrings in many setups; if a filetype comments oddly, check filetype/commentstring settings.
- See `:h comment-nvim` for all mappings and options.
