vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'dmmulroy/tsc.nvim'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  -- use { 'neovim/nvim-lspconfig',
  --   init_options = {
  --     addonSettings = {
  --       ["Ruby LSP Rails"] = {
  --         enablePendingMigrationsPrompt = false
  --       }
  --     }
  --   }
  -- }
  use 'nvim-treesitter/nvim-treesitter'
  use 'flazz/vim-colorschemes'
  use 'bling/vim-airline'
  use 'airblade/vim-gitgutter'
  use 'mileszs/ack.vim'
  use 'tpope/vim-commentary'
  use 'tpope/vim-fugitive'
  use 'rbong/vim-flog'
  use 'jgdavey/vim-blockle'
  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-repeat'
  use 'tpope/vim-eunuch'
  -- use { 'github/copilot.vim', branch = 'release' }
  use 'prettier/vim-prettier'
  use 'yuezk/vim-js'
  use 'maxmellon/vim-jsx-pretty'
  use {
    'CopilotC-Nvim/CopilotChat.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope.nvim' },
      { 'github/copilot.vim' }
    },
    branch = 'main'
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use 'nvim-tree/nvim-web-devicons'
  -- use {
  --   'ray-x/navigator.lua',
  --   requires = {
  --     { 'ray-x/guihua.lua', run = 'cd lua/fzy && make' },
  --     { 'neovim/nvim-lspconfig' },
  --   }
  -- }
  use {
    "smoka7/multicursors.nvim",
    requires = { 'nvimtools/hydra.nvim' }
  }

end)
require('tsc').setup {
  -- enable = true,
  -- enable_ts = true,
  -- enable_ts_imports = true,
  -- enable_formatting = true,
}
-- require'navigator'.setup()
-- require("CopilotChat").setup()
require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "rubocop", "ruby_lsp" },
}
require('multicursors').start()

local function start_ruby_lsp(bufnr)
  -- project root (Gemfile preferred, else .git)
  local root = vim.fs.root(bufnr, { "Gemfile", ".git" }) or vim.fn.getcwd()
  -- prefer Bundler-exec if available
  -- local cmd = (vim.fn.executable("bundle") == 1) and { "bundle", "exec", "ruby-lsp" } or { "ruby-lsp" }
  local cmd = { "ruby-lsp" }

  -- avoid starting twice for the same root
  for _, client in ipairs(vim.lsp.get_clients({ name = "ruby_lsp", bufnr = bufnr })) do
    if client.config and client.config.root_dir == root then return end
  end

  vim.lsp.config('ruby_lsp', {})
  vim.lsp.config('rubocop', {})

  vim.lsp.start({
    name = "ruby_lsp",
    cmd = cmd,
    root_dir = root,
    -- capabilities = capabilities,
    -- keep formatting capability enabled (we won't auto-run it)
    settings = {
      rubyLsp = {
        formatter = 'rubocop',
        -- tweak as you like:
        inlayHints = { enabled = true },
        diagnostics = { enabled = true },
      },
    },
    on_attach = function(client, b)
      -- KEYMAPS (buffer-local)
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = b, silent = true, desc = desc })
      end

      -- Manual format on demand (no auto-format)
      map("n", "<leader>f", function() vim.lsp.buf.format({ async = false }) end, "Format buffer")

      -- Handy LSP maps
      map("n", "gd", vim.lsp.buf.definition, "Go to definition")
      map("n", "gr", vim.lsp.buf.references, "References")
      map("n", "K", vim.lsp.buf.hover, "Hover")
      map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
      map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
      map("n", "<leader>e", function() vim.diagnostic.open_float(nil, { scope = "line" }) end, "Line diagnostics")
      map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
      map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
    end,
  })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "ruby", "eruby" },
  callback = function(args) start_ruby_lsp(args.buf) end,
})

return
