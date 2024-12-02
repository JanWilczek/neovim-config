return {
  'Shatur/neovim-session-manager',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    { "<leader>ss", "<cmd>SessionManager save_current_session<CR>", desc = "Quick save current session" },
    { "<leader>ls", "<cmd>SessionManager load_current_dir_session<CR>", desc = "Quick load current dir session" },
  },
  config = function()
    require 'session_manager'.setup({
      autoload_mode = require('session_manager.config').AutoloadMode.Disabled, -- other don't work as expected
      autosave_last_session = false, -- enable quick opening and closing without messing up the saved session
    })
  end
}
