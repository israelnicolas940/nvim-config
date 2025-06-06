local LazyVim = require("lazyvim")
local build_cmd = "make" -- Set this to your preferred build system
local telescope_builtin = require("telescope.builtin")

local config_dir = vim.fn.stdpath("config")
return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  version = "0.1.5", -- Specify a stable version instead of using HEAD
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = (build_cmd ~= "cmake") and "make"
          or
          "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      enabled = build_cmd ~= nil,
      config = function(plugin)
        vim.defer_fn(function()
          local ok, err = pcall(require("telescope").load_extension, "fzf")
          if not ok then
            local lib = plugin.dir .. "/build/libfzf." .. (LazyVim.is_win() and "dll" or "so")
            if not vim.uv.fs_stat(lib) then
              LazyVim.warn("`telescope-fzf-native.nvim` not built. Rebuilding...")
              require("lazy").build({ plugins = { plugin }, show = false }):wait(function()
                LazyVim.info("Rebuilding `telescope-fzf-native.nvim` done.\nPlease restart Neovim.")
              end)
            else
              LazyVim.error("Failed to load `telescope-fzf-native.nvim`:\n" .. err)
            end
          end
        end, 0)
      end,
    },
  },
  keys = {
    {
      "<leader>,",
      "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
      desc = "Switch Buffer",
    },
    { "<leader>/",       telescope_builtin.live_grep,          desc = "Grep (Root Dir)" },
    { "<leader>:",       "<cmd>Telescope command_history<cr>", desc = "Command History" },
    { "<leader><space>", telescope_builtin.find_files,         desc = "Find Files (Root Dir)" },
    -- find
    {
      "<leader>fb",
      "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
      desc = "Buffers",
    },
    {
      "<leader>fc",
      function()
        telescope_builtin.find_files({ cwd = config_dir })
      end,
      desc = "Find Config File",
    },
    {
      "<leader>ff",
      telescope_builtin.find_files,
      desc = "Find Files (Root Dir)",
    },
    {
      "<leader>fF",
      function()
        telescope_builtin.find_files({ cwd = vim.fn.getcwd() })
      end,
      desc = "Find Files (cwd)",
    },
    { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>",  desc = "Recent" },
    {
      "<leader>fR",
      function()
        telescope_builtin.oldfiles({ cwd = vim.fn.getcwd() })
      end,
      desc = "Recent (cwd)",
    },
    -- git
    { "<leader>gc", "<cmd>Telescope git_commits<CR>",               desc = "Commits" },
    { "<leader>gs", "<cmd>Telescope git_status<CR>",                desc = "Status" },
    -- search
    { '<leader>s"', "<cmd>Telescope registers<cr>",                 desc = "Registers" },
    { "<leader>sa", "<cmd>Telescope autocommands<cr>",              desc = "Auto Commands" },
    { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
    { "<leader>sc", "<cmd>Telescope command_history<cr>",           desc = "Command History" },
    { "<leader>sC", "<cmd>Telescope commands<cr>",                  desc = "Commands" },
    { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>",       desc = "Document Diagnostics" },
    { "<leader>sD", "<cmd>Telescope diagnostics<cr>",               desc = "Workspace Diagnostics" },
    { "<leader>sg", telescope_builtin.live_grep,                    desc = "Grep (Root Dir)" },
    {
      "<leader>sG",
      function()
        telescope_builtin.live_grep({ cwd = vim.fn.getcwd() })
      end,
      desc = "Grep (cwd)",
    },
    { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
    {
      "<leader>sH",
      "<cmd>Telescope highlights<cr>",
      desc = "Search Highlight Groups",
    },
    { "<leader>sj", "<cmd>Telescope jumplist<cr>",  desc = "Jumplist" },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>",   desc = "Key Maps" },
    {
      "<leader>sl",
      "<cmd>Telescope loclist<cr>",
      desc = "Location List",
    },
    { "<leader>sM", "<cmd>Telescope man_pages<cr>",   desc = "Man Pages" },
    {
      "<leader>sm",
      "<cmd>Telescope marks<cr>",
      desc = "Jump to Mark",
    },
    { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
    { "<leader>sR", "<cmd>Telescope resume<cr>",      desc = "Resume" },
    {
      "<leader>sq",
      "<cmd>Telescope quickfix<cr>",
      desc = "Quickfix List",
    },
    {
      "<leader>sw",
      function()
        telescope_builtin.grep_string({ word_match = "-w" })
      end,
      desc = "Word (Root Dir)",
    },
    {
      "<leader>sW",
      function()
        telescope_builtin.grep_string({ cwd = vim.fn.getcwd(), word_match = "-w" })
      end,
      desc = "Word (cwd)",
    },
    {
      "<leader>sw",
      telescope_builtin.grep_string,
      mode = "v",
      desc = "Selection (Root Dir)",
    },
    {
      "<leader>sW",
      function()
        telescope_builtin.grep_string({ cwd = vim.fn.getcwd() })
      end,
      mode = "v",
      desc = "Selection (cwd)",
    },
    {
      "<leader>uC",
      telescope_builtin.colorscheme,
      desc = "Colorscheme with Preview",
    },
    {
      "<leader>ss",
      function()
        require("telescope.builtin").lsp_document_symbols({
          symbols = LazyVim.config.get_kind_filter(),
        })
      end,
      desc = "Goto Symbol",
    },
    {
      "<leader>sS",
      function()
        telescope_builtin.lsp_dynamic_workspace_symbols({
          symbols = LazyVim.config.get_kind_filter(),
        })
      end,
      desc = "Goto Symbol (Workspace)",
    },
  },
  opts = function()
    local actions = require("telescope.actions")

    return {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        mappings = {
          i = {
            ["<C-Down>"] = actions.cycle_history_next,
            ["<C-Up>"] = actions.cycle_history_prev,
            ["<C-f>"] = actions.preview_scrolling_down,
            ["<C-b>"] = actions.preview_scrolling_up,
          },
          n = {
            ["q"] = actions.close,
          },
        },
      },
      pickers = {
        find_files = {
          find_command = { "rg", "--files", "--color", "never", "-g", "!.git" },
          hidden = true,
        },
        colorscheme = {
          enable_preview = true,
        },
      },
    }
  end,
}
