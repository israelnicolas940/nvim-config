-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "grn", vim.lsp.buf.rename, { desc = "LSP: Rename symbol" })
vim.keymap.set("n", "gra", vim.lsp.buf.code_action, { desc = "LSP: Code actions" })
vim.keymap.set("n", "grr", vim.lsp.buf.references, { desc = "LSP: Find references" })

-- quickfix
vim.keymap.set("n", "<M-l>", "<cmd>cnext<CR>", { desc = "Quickfix next" })
vim.keymap.set("n", "<M-h>", "<cmd>cprev<CR>", { desc = "Quickfix prev" })

-- Open registers in the bottom.
vim.keymap.set("n", "gd", function()
  vim.lsp.buf.definition()
end, { desc = "Go to Definition" })
