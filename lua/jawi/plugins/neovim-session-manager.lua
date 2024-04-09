return {
  'Shatur/neovim-session-manager',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    { "<F5>", "<cmd>SessionManager save_current_session<CR>", desc = "Quick save current session" },
    { "<F9>", "<cmd>SessionManager load_current_dir_session<CR>", desc = "Quick load current dir session" },
  },
  config = function()
    require 'session_manager'.setup({

    })
  end
}
