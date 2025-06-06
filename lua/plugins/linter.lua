local lspconfig = require("lspconfig")

return {
  lspconfig.eslint.setup({
    settings = {
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          command = "EslintFixAll",
        })
      end,
    },
  }),
  -- lspconfig.vale.setup({}),
}
