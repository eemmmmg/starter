return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "html-lsp",
        "prettier",
        "stylua",
        "kotlin-language-server",
        "jdtls",
        "ktlint",
        "ktfmt",
        "kotlin-debug-adapter",
        "java-debug-adapter",
        "csharp-language-server",
        "csharpier",
        "google-java-format"
      },
      automatic_installation = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css", "kotlin", "java", "c_sharp"
      },
    },
  }
}
