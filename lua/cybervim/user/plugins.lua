-->> Automatically install packer
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd('packadd packer.nvim')
end

-->> Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-->> Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-->> Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
    non_interactive = false, -- If true, disable display windows for all operations
    compact = false, -- If true, fold updates results by default

    working_sym   = '羽', -- The symbol for a plugin being installed/updated
    error_sym     = '✗', -- The symbol for a plugin with an error in installation/updating
    done_sym      = '✓', -- The symbol for a plugin which has completed installation/updating
    removed_sym   = '-', -- The symbol for an unused plugin which was removed
    moved_sym     = '→', -- The symbol for a plugin which was moved (e.g. from opt to start)
    header_sym    = '━', -- The symbol for the header line in packer's display

    show_all_info = true, -- Should packer show all update details automatically?
    prompt_border = 'double', -- Border style of prompt popups.
    keybindings   = { -- Keybindings for the display window
      quit = 'q',
      toggle_update = 'u', -- only in preview
      continue = 'c', -- only in preview
      toggle_info = '<CR>',
      diff = 'd',
      prompt_revert = 'r',
    }
  },
})

-->> Install your plugins here
return packer.startup(function(use)
  use { "wbthomason/packer.nvim",               nothing = "dac4088c70f4337c6c40d1a2751266a324765797"  } -- Have packer manage itself
  use { "nvim-lua/plenary.nvim",                nothing = "bb444796dc5746d969f0718913a31c8075741e36"  } -- Useful lua functions used by lots of plugins
  use { "windwp/nvim-autopairs",                nothing = "03580d758231956d33c8dd91e2be195106a79fa4"  } -- Autopairs, integrates with both cmp and treesitter
  use { "numToStr/Comment.nvim",                nothing = "7bb563ff2d811a63b207e9de63e3e9c0877cb6d5"  }
  use { "kyazdani42/nvim-web-devicons",         nothing = "05e1072f63f6c194ac6e867b567e6b437d3d4622"  }
  -- MAYBE use file browser instead https://github.com/nvim-telescope/telescope-file-browser.nvim
  use { "kyazdani42/nvim-tree.lua",             nothing = "bac962caf472a4404ed3ce1ba2fcaf32f8002951"  }
  use { "akinsho/bufferline.nvim", --[[ tag = "v3.*", ]] nothing = "c7492a76ce8218e3335f027af44930576b561013"  } -- Yay buffer
	use { "moll/vim-bbye",                        nothing = "25ef93ac5a87526111f43e5110675032dbcacf56"  } -- Avoid messing with windwos layouts when closing buffers
  use { "nvim-lualine/lualine.nvim",            nothing = "3497c6c6b3eead069e408ade1c9ff31f8550d66b"  }
  --use { "akinsho/toggleterm.nvim",  } -- Toggle Terminal
  use { "NvChad/nvterm",                        nothing = "29a70ef608a8cc5db3a5fc300d39a39d1a44a863"  } --Nv Chad Toggle Terminal, just another option
  use { "ahmedkhalf/project.nvim",              nothing = "685bc8e3890d2feb07ccf919522c97f7d33b94e4"  } -- Discover your projects Automatically
  use { "lewis6991/impatient.nvim",             nothing = --[["c90e273f7b8c50a02f956c24ce4804a47f18162e"older--]] "d3dd30ff0b811756e735eb9020609fa315bfbbcc" } -- Cache
  use { "lukas-reineke/indent-blankline.nvim",  nothing = "c4c203c3e8a595bc333abaf168fcb10c13ed5fb7"  } -- Show identations lines
  use { "goolord/alpha-nvim",                   nothing = "0bb6fc0646bcd1cdb4639737a1cee8d6e08bcc31"  } -- UI Library with dashboard
	use { "folke/which-key.nvim",                 nothing = "5ffa07bc53294db5cd87c4cc741b7f586fa253f7"} -- Show Key popup

	-->> Cmp 
	-->> LSP

  use {
	  'VonHeikemen/lsp-zero.nvim',
	  requires = {
		  -- LSP Support
		  {'neovim/nvim-lspconfig'},
		  {'williamboman/mason.nvim'},
		  {'williamboman/mason-lspconfig.nvim'},

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-buffer'},
		  {'hrsh7th/cmp-path'},
		  {'saadparwaiz1/cmp_luasnip'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'hrsh7th/cmp-nvim-lua'},

		  -- Snippets
		  {'L3MON4D3/LuaSnip'},
		  {'rafamadriz/friendly-snippets'},
	  }
  }
  use { "onsails/lspkind.nvim",} -- better lsp cmp icons
	use { "jose-elias-alvarez/null-ls.nvim",      nothing = "d09d7d82cc26d63673cef85cb62895dd68aab6d8"  } -- for formatters and linters
  use { "RRethy/vim-illuminate",                nothing = "462b07609c850a4c4cb3dd9ac935d42abc7b85ed"  }
  use { "folke/trouble.nvim",                   nothing = "83ec606e7065adf134d17f4af6bae510e3c491c1"} -- LPS Diagnostic with colors and shit
  use { 'folke/lsp-colors.nvim',                nothing = "750d59b643865b906996028147675e9af216ea95"} -- LSP colors that might be missings
  --use { 'jackguo380/vim-lsp-cxx-highlight',     nothing = "0e7476ff41cd65e55f92fdbc7326335ec33b59b0"} -- LSP based cpp highlighting
	-->> Telescope
	use { "nvim-telescope/telescope.nvim",        nothing = "a606bd10c79ec5989c76c49cc6f736e88b63f0da"  }
  
  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', 
    nothing = "fab3e2212e206f4f8b3bbaa656e129443c9b802e", 
    run = 'make', 
    cond = vim.fn.executable 'make' == 1 
  }
  
  use {'NvChad/nvim-colorizer.lua',             nothing = "760e27df4dd966607e8fb7fd8b6b93e3c7d2e193"}
	
  -->> Treesitter
--[[
  use {
		"nvim-treesitter/nvim-treesitter",
    nothing = 
    --"12e95e160d7d45b76a36bca6303dd8447ab77490" -- nothings on Jan 2, 2023
    --"d31c71c959348b7b15f7e69608a47aea05ed7bc6" -- nothings on Dec 14, 2022
    --"256802258084fcf6c7011dae4c3fbfaaf4b61518" -- nothings on Dec 1, 2022
    --"4b900527045c49af5f43291d2cb13ae27a3bc7be" -- Nov 30, 2022
    --"d1eaf23c9ec9aca91e219ed82ae98c96d93dd407" -- 29 nov 2022
    --"1a767376cdb968f43af690ccac7001d2efbefb87" --ObserverOfTime nothingted on Nov 26, 2022
    --"79705a1f80297d1f3178d2b30423760c060afa4a" --highlights(cpp): use more specific groups ObserverOfTime nothingted on Nov 26, 2022
    --"7ce62670b2e0946e3f586f3f07a584f642b02b9b" --highlights(c): use more specific groups 
    --"00b42ac6d4c852d34619eaf2ea822266588d75e3" --[Does Not Work] @type.qualifier and @storageclass on Nov 6, 2022
    --"ae104a057fc4164af8884f0b5540c79be95f5fc5"  --[does not work] fix: update scheme queries to parser change
    --"1fa45d8c793282d9a65044666e977220f91a2dd7"  --web-flow authored and clason nothingted on Nov 6, 2022
    --"dd89cafd2bc5ddbb201b6b1ea72ecd11acbe4e31" -- nov 5 2022
    --"a4b10b60c16ca141ca1dae538479889dd6932270" -- nov 2 2022
    --"c6992f69d303cee0b43fd59125cb7afb0262d8fe" -- [Does Not Work]nov 1 2022 Update lockfile.jason 
    --"e7bdcee167ae41295a3e99ad460ae80d2bb961d7" -- [Turning Point][Does Not Work]nov 1 2022 lua: update queries

  ------ USE THE nothing BELLOW --------------
    --"5f85a0a2b5c8e385c1232333e50c55ebdd0e0791" -- [Works] one nothing later and it stops working help: update queries nov 1 2022
  ------- USE THE nothing ABOVE --------------

    --"7709eb4b47b8ee19e760aa2771c5735fda2798e1" -- [Works]Disable folding at startup nov 1
    -- "80503a99104e461599ef8810a64bce1b6d235f6a" -- [Works]31 oct 2022
    --"287ffdccc1dd7ed017d844a4fad069fd3340fa94" --[Works] Add regex injections for php (Verified) on Oct 28, 2022
    --"c9241287719ccd38741850765649a25b09bdb4c2" --[Works] highlights(python): add "except*" Oct 25, 2022
    --"9b43ab819c756f01d2977cd481bdcaead6867174" --highlights: use @preproc where appropriate Oct 15, 2022
	  --"b945aa0aab03d4817a42cbcb27059217d8e56ed8" --highlights(c): highlight standard streams on Oct 15, 2022
    --"179a06bc8b4b028960dc105feceb5a4b1cbcb41d" --style: fix code styling according to Stylua  Oct 3, 2022
    --"8e763332b7bf7b3a426fd8707b7f5aa85823a5ac" --[Works] nothings [stable] - works with every plugin] Oct 2, 2022 
	}
--]]

  use {'evertonse/nvim-treesitter'}
  --Optionally use mine https://github.com/evertonse/nvim-treesitter, removed bug with windows that wasnt adressed nor have I seen any issues opened
  --use {'evertonse/nvim-treesitter',                       nothing = '599dab1fa26b398b37271cd67b4f57c4be4e25fe',       branch = 'main'}
  use {"JoosepAlviste/nvim-ts-context-commentstring",     nothing = "0ecf92fe5ef5cac9892bf20c9579b5f06f85c277"} -- Nice Vim commenting --  context_commentstring { enable = true }
  --use {'David-Kunz/markid',                               nothing = ""                                        } -- Every identifier has the same color
  use {'nvim-treesitter/playground',                      nothing = "8a887bcf66017bd775a0fb19c9d8b7a4d6759c48"}

  -- Argument Coloring
  --use {'octol/vim-cpp-enhanced-highlight',                nothing = '4b7314a497ea2dd0a6911ccb94ce83b2d8684617'} -- still haven't used but adds cpp keywords for highlight tweak even further
  use {'m-demare/hlargs.nvim',                            nothing = '88b925d699fb39633cdda02c24f0b3ba5d0e6964'}

	-->> Git
	use {"lewis6991/gitsigns.nvim",                         nothing = '81641791439bc8f0ceb3691d62b95c8e646f3771'}

	-->> Colorschemes
  --use 'marko-cerovac/material.nvim'
  --use { "folke/tokyonight.nvim",  }
  --use { "lunarvim/darkplus.nvim",  }
  --use 'tomasiser/vim-code-dark'
  --use 'shaunsingh/nord.nvim'
  -- Another vs code theme:
  -- for more options see: https://github.com/Mofiqul/vscode.nvim
  --use 'Mofiqul/vscode.nvim'

  --[[ 
    Using my fork of Mofiqul vscode nvim theme, 
    but my theme is Focusing on Visual Studio Theme, rather tha vs code
  --]]
  --use {'evertonse/vs.nvim', branch = "base",            nothing = 'a87ad02da3892247a355193837d90efa63581d33'} -- use this for bare minimum, first commit and base branch
  use {'evertonse/vs.nvim', branch = "dev"}

  -->> Utils
  use {'dstein64/vim-startuptime',                      nothing = 'cb4c112b9e0f224236ee4eab6bf5153406b3f88b'}
  use {'tpope/vim-surround',                            nothing = 'cb4c112b9e0f224236ee4eab6bf5153406b3f88b'}
  use {
      --https://github.com/andymass/vim-matchup
    'andymass/vim-matchup',
    setup = function()
      -- may set any options here
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end
  }
  
  -->> Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
