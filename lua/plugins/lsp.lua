return {
  { "williamboman/mason.nvim", opts = {} },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
    opts = { ensure_installed = { "lua_ls", "pyright", "ts_ls", "html", "cssls" } },
  },
}