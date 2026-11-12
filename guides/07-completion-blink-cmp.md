# blink.cmp (completion)

**Intro:** Completion engine for insert mode (LSP, snippets, paths, buffer, etc. depending on defaults/sources).

## Config highlights
- Uses `keymap = { preset = "default" }`
- Pinned to version `1.*`

## Basic usage
- Start typing in insert mode to trigger completion suggestions (behavior depends on blink defaults and available sources).
- Use blink's default keymap preset for navigation/confirm actions.

## Tips
- If you're unsure of the exact keys in the default preset on your version, check `:h blink-cmp` or run `:Lazy` to inspect the plugin and its docs.
- Completion quality for code symbols depends on LSP servers being installed and attached (`:LspInfo`).
