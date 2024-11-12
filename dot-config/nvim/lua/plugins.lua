vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use('dmmulroy/tsc.nvim')
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'
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
  use 'github/copilot.vim'
  use 'prettier/vim-prettier'
  use 'yuezk/vim-js'
  use 'maxmellon/vim-jsx-pretty'
  use { 'CopilotC-Nvim/CopilotChat.nvim', branch = 'canary' }
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.6',
    -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use 'nvim-tree/nvim-web-devicons'
  use {
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      require("telescope").load_extension "frecency"
    end,
  }
  use {
    'ray-x/navigator.lua',
    requires = {
      { 'ray-x/guihua.lua', run = 'cd lua/fzy && make' },
      { 'neovim/nvim-lspconfig' },
    }
  }
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
require'navigator'.setup()
-- require("CopilotChat").setup()
require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "rubocop", "ruby_lsp" },
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = true
  end,
}
-- require('multicursors').start()

return
