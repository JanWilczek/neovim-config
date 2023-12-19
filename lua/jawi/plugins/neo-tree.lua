return {
	{
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function ()
      require("neo-tree").setup({
	close_if_last_window = true,
	default_component_configs = {
	  window = {
	    filesystem = {
	      hijack_netrw_behavior = "open_current",
	    },
	  },
	},
      })
    end
}
}

