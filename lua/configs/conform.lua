local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    csharp = { "csharpier" },
    kotlin = { "ktfmt" },
    java = { "google-java-format" },
    rust = { "rustfmt" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

return options
