-- lazy.nvim bootstrap and plugin loader setup.

-- Path where lazy.nvim will be installed (inside Neovim's data directory).
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Clone lazy.nvim if it is not already installed.
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

-- Prepend lazy.nvim to runtime path so `require("lazy")` works.
vim.opt.rtp:prepend(lazypath)

-- Initialize lazy.nvim and import all plugin specs from the `lua/plugins/` folder.
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
})
