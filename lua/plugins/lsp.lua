local util = require("lspconfig.util")
local async = require("lspconfig.async")
local mod_cache = nil

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
  },
  config = function()
    local lspconfig = require("lspconfig")
    lspconfig.lua_ls.setup({})

    lspconfig.clangd.setup({})

    lspconfig.cmake.setup({})

    lspconfig.bashls.setup({})

    lspconfig.pyright.setup({})

    lspconfig.ts_ls.setup({})

    lspconfig.texlab.setup({})

    lspconfig.dockerls.setup({
      cmd = { "docker-langserver", "--stdio" },
      filetypes = { "dockerfile" },
      single_file_support = true,
      settings = {
        docker = {
          languageserver = {
            formatter = {
              ignoreMultilineInstructions = true,
            },
          },
        },
      },
    })

    lspconfig.rust_analyzer.setup({
      cmd = { "rust-analyzer" },
      filetypes = { "rust" },
      settings = {
        ["rust-analyzer"] = {
          diagnostics = {
            enable = false,
          },
        },
      },
      single_file_support = true,
    })

    lspconfig.gopls.setup({
      cmd = { "gopls" },
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
      root_dir = function(fname)
        -- see: https://github.com/neovim/nvim-lspconfig/issues/804
        if not mod_cache then
          local result = async.run_command({ "go", "env", "GOMODCACHE" })
          if result and result[1] then
            mod_cache = vim.trim(result[1])
          else
            mod_cache = vim.fn.system("go env GOMODCACHE")
          end
        end
        if mod_cache and fname:sub(1, #mod_cache) == mod_cache then
          local clients = util.get_lsp_clients({ name = "gopls" })
          if #clients > 0 then
            return clients[#clients].config.root_dir
          end
        end
        return util.root_pattern("go.work", "go.mod", ".git")(fname)
      end,
      single_file_support = true,
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
          return
        end

        -- if client.supports_method("textDocument/formatting") then
        --   vim.api.nvim_create_autocmd("BufWritePre", {
        --     buffer = args.buf,
        --     callback = function()
        --       require("conform").format({ bufnr = args.buf })
        --       vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        --     end,
        --   })
        -- end
      end,
    })
  end,
  servers = {
    clangd = {
      keys = { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
      root_dir = function(fname)
        return require("lspconfig.util").root_pattern(
          "Makefile",
          "configure.ac",
          "configure.in",
          "config.h.in",
          "meson.build",
          "meson_options.txt",
          "build.ninja"
        )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(fname) or require(
          "lspconfig.util"
        ).find_git_ancestor(fname) or require("lspconfig.util").root_pattern(
          "CMakeLists.txt",
          "build",
          ".git",
          "compile_commands.json"
        )(fname)
      end,
      capabilities = {
        offsetEncoding = { "utf-16" },
      },
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
      },
      init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
      },
    },
    -- other server
  },
}
