return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter")
    local languages = {
      "lua",
      "python",
      "javascript",
      "typescript",
      "tsx",
      "html",
      "css",
      "json",
      "bash",
      "markdown",
      "markdown_inline",
    }

    treesitter.setup()
    treesitter.install(languages)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = languages,
      callback = function(event)
        pcall(vim.treesitter.start, event.buf)
        vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}