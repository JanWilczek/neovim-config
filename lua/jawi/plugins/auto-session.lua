return {
  "rmagatti/auto-session",
  dependencies = {
    "nvim-telescope/telescope.nvim"
  },
  config = function()
    require("auto-session").setup {
      log_level = "error"
    }
  end
}

