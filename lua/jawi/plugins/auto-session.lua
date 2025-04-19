return {
  "rmagatti/auto-session",
  enabled = false,
  dependencies = {
    "nvim-telescope/telescope.nvim"
  },
  config = function()
    require("auto-session").setup {
      log_level = "warning",
      auto_save_enabled = true,
      auto_session_enabled = true,
      auto_restore_enabled = true,
      auto_session_use_git_branch = false,
      auto_session_create_enabled = true,
      auto_session_enable_last_session = true,
      auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
    }
  end
}

