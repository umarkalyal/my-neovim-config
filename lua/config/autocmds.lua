vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local ok, api = pcall(require, "nvim-tree.api")
    if not ok then return end
    api.tree.open()
    vim.cmd("wincmd l")
  end,
})