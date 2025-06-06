return {
  "stevearc/conform.nvim",
  opts = {},
  config = {
    -- format_on_save = {
    --   lsp_format = "fallback",
    --   timeout_ms = 500,
    -- },

    formatters_by_ft = {
      lua = { "stylua" },
      -- Conform will run multiple formatters sequentially
      python = { "isort", "black" },
      -- You can customize some of the format options for the filetype (:help conform.format)
      rust = { "rustfmt", lsp_format = "fallback" },
      -- Conform will run the first available formatter
      javascript = { "prettierd", "prettier", stop_after_first = true },
      c = { "clang_format" },
      cpp = { "clang_format" },
      go = { "golines", "goimports_reviser", "gofumpt" },
      typescript = { "prettier", "prettier", stop_after_first = true },
    },
  },
}
