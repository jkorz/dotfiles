-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "dmmulroy/tsc.nvim",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "nvim-treesitter/nvim-treesitter",
  "flazz/vim-colorschemes",
  "bling/vim-airline",
  "airblade/vim-gitgutter",
  "mileszs/ack.vim",
  "tpope/vim-commentary",
  "tpope/vim-fugitive",
  "rbong/vim-flog",
  "jgdavey/vim-blockle",
  "tpope/vim-surround",
  "tpope/vim-unimpaired",
  "tpope/vim-repeat",
  "tpope/vim-eunuch",
  { "github/copilot.vim", branch = "release" },
  "prettier/vim-prettier",
  "yuezk/vim-js",
  "maxmellon/vim-jsx-pretty",

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  "nvim-tree/nvim-web-devicons",

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      { "github/copilot.vim", branch = "release" },
    },
    opts = {
      model = "claude-opus-4.6",
    },
  },

  {
    "smoka7/multicursors.nvim",
    dependencies = { "nvimtools/hydra.nvim" },
    opts = {},
  },
})

require("tsc").setup({})

require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = { "rubocop", "ruby_lsp" },
})

-- I would not auto-start multicursors on launch.
-- Use the plugin's mappings/commands instead.
-- require("multicursors").start()

local function start_ruby_lsp(bufnr)
  local root = vim.fs.root(bufnr, { "Gemfile", ".git" }) or vim.fn.getcwd()
  local cmd = { "ruby-lsp" }

  for _, client in ipairs(vim.lsp.get_clients({ name = "ruby_lsp", bufnr = bufnr })) do
    if client.config and client.config.root_dir == root then
      return
    end
  end

  vim.lsp.config("ruby_lsp", {})
  vim.lsp.config("rubocop", {})
  vim.diagnostic.config({ jump = { float = true } })

  vim.lsp.start({
    name = "ruby_lsp",
    cmd = cmd,
    root_dir = root,
    settings = {
      rubyLsp = {
        formatter = "rubocop",
        inlayHints = { enabled = true },
        diagnostics = { enabled = true },
      },
    },
    on_attach = function(_, b)
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = b, silent = true, desc = desc })
      end

      map("n", "<leader>f", function()
        vim.lsp.buf.format({ async = false })
      end, "Format buffer")

      map("n", "gd", vim.lsp.buf.definition, "Go to definition")
      map("n", "gr", vim.lsp.buf.references, "References")
      map("n", "K", vim.lsp.buf.hover, "Hover")
      map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
      map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
      map("n", "<leader>e", function()
        vim.diagnostic.open_float(nil, { scope = "line" })
      end, "Line diagnostics")
    end,
  })
end

vim.g.copilot_no_tab_map = true
vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "ruby", "eruby" },
  callback = function(args)
    start_ruby_lsp(args.buf)
  end,
})

vim.lsp.config("eslint", {})
vim.lsp.config("rubocop", {})
vim.lsp.config("ruby_lsp", {})
vim.lsp.config("stimulus_ls", {})
