-- Autocommands for editor/startup behavior.

-- On Neovim startup, open NvimTree if available and move focus back to the editor window.
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Safely require nvim-tree API so startup doesn't fail if plugin isn't loaded yet.
    local ok, api = pcall(require, "nvim-tree.api")
    if not ok then
      return
    end

    -- Open the file explorer sidebar.
    api.tree.open()

    -- Jump to the right window so the main editing area is focused.
    vim.cmd("wincmd l")
  end,
})
