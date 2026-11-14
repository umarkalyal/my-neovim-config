-- Plugin: iamcco/markdown-preview.nvim
-- Purpose: Opens a live, synchronized Markdown preview in the browser.
return {
  "iamcco/markdown-preview.nvim",
  -- Lazy-load on preview commands.
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  -- Lazy-load for Markdown files.
  ft = { "markdown" },
  -- Install/update preview app assets after plugin install/update.
  build = function(plugin)
    vim.opt.rtp:prepend(plugin.dir)
    vim.fn["mkdp#util#install_sync"](true)
  end,
}
