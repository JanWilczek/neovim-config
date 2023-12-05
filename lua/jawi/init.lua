vim.g.mapleader = ' '
vim.g.maplocalleader = '-'

vim.wo.number = true
vim.wo.relativenumber = true

-- [[ Install lazy.nvim plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Install plugins ]]
require('lazy').setup({
	-- TODO: no idea what these do
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',
	'tpope/vim-sleuth',

	-- LSP plugins
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			{ 'j-hui/fidget.nvim', opts = {} },

			'folke/neodev.nvim',
		},
	},

	{
	  -- Autocompletion
	  'hrsh7th/nvim-cmp',
	  dependencies = {
	    -- Snippet Engine & its associated nvim-cmp source
	    'L3MON4D3/LuaSnip',
	    'saadparwaiz1/cmp_luasnip',

	    -- Adds LSP completion capabilities
	    'hrsh7th/cmp-nvim-lsp',

	    -- Adds a number of user-friendly snippets
	    'rafamadriz/friendly-snippets',
	  },
	},


})

-- [[ Plugin config ]]
require('mason').setup()
require('mason-lspconfig').setup()

local servers = {
	clangd = {},
	pyright = {},
	rust_analyzer = {},
	tsserver = {},

	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},

}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

-- All good, print the hello message
print("Hello from jawi!")
