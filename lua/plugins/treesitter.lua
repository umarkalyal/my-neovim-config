-- Plugin: nvim-treesitter/nvim-treesitter
-- Purpose: Tree-sitter based parsing for better syntax highlighting and indentation.
return {
  "nvim-treesitter/nvim-treesitter",
  -- Use the `main` branch (Neovim 0.12+ API style in this config).
  branch = "main",
  -- Load eagerly so parsing/highlighting setup is available.
  lazy = false,
  -- Update/install parsers when the plugin is installed/updated.
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter")

    -- Languages/parsers to install and enable Tree-sitter features for.
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

    -- Initialize nvim-treesitter core.
    treesitter.setup()

    -- Ensure configured parsers are installed.
    treesitter.install(languages)

    -- Start Tree-sitter highlighting and configure indentation per supported filetype.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = languages,
      callback = function(event)
        -- Start parser for the buffer (pcall avoids errors if parser is unavailable).
        pcall(vim.treesitter.start, event.buf)
        -- Use Tree-sitter's indent expression for better indentation.
        vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
