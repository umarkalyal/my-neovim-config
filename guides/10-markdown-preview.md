# markdown-preview.nvim (browser Markdown preview)

**Intro:** Live Markdown preview in your browser, synced with the current buffer.

## Config highlights
- Loads for `markdown` filetype
- Provides commands: `MarkdownPreview`, `MarkdownPreviewToggle`, `MarkdownPreviewStop`
- Build step runs installer (`mkdp#util#install_sync`) so preview assets/deps are set up

## Usage
- Open a Markdown file
- `:MarkdownPreview` — open preview in browser
- `:MarkdownPreviewToggle` — toggle preview on/off
- `:MarkdownPreviewStop` — stop preview server

## Requirements / tips
- A browser must be available to open the local preview page.
- If it fails on first use, ensure Node/npm tooling is available if required by the installer in your environment, then try rebuilding/updating the plugin in `:Lazy`.
