-- LSP/tooling plugins: install and manage language servers.
return {
  -- Plugin: williamboman/mason.nvim
  -- Purpose: UI/tool installer for LSP servers, formatters, linters, and DAPs.
  { "williamboman/mason.nvim", opts = {} },

  -- Plugin: williamboman/mason-lspconfig.nvim
  -- Purpose: Bridges Mason-installed servers with nvim-lspconfig and ensures required servers are installed.
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
    opts = {
      -- Automatically install these language servers if missing.
      ensure_installed = { "lua_ls", "pyright", "ts_ls", "html", "cssls" },
    },
  },
}
