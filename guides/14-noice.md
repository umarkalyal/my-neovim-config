# noice.nvim (UI for messages/cmdline/popups)

**Intro:** Replaces/enhances parts of Neovim's UI (messages, cmdline, notifications/popups) for a cleaner look.

## Config highlights
- Loads on `VeryLazy`
- Uses default options
- Dependencies: `nui.nvim`, `nvim-notify` (with fallback behavior if notify not available, per plugin comment)

## Usage
- Works automatically in the background once loaded.
- Command-line/messages/notifications will appear using Noice's UI.
- Useful commands (common): `:Noice`, `:Noice history`, `:Noice dismiss` (availability may vary by version/config).

## Tips
- If a message UI behaves unexpectedly, check `:checkhealth noice` and plugin docs (`:h noice.nvim`).
- Can be customized later for routes/views, but current config keeps it simple.
