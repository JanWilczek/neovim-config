-- Add this to your Neovim config (init.lua or a separate lua file)
function CreateCppAndSplitOpen()
  -- Get the current file path
  local header_file = vim.api.nvim_buf_get_name(0)

  -- Extract the file name (e.g., Foo.hpp or Foo.h)
  local header_filename = header_file:match("([^/]+%.hp*)$")

  -- Ensure it is an .hpp or .h file
  if header_filename == nil then
    print("This is not a .hpp or .h file!")
    return
  end

  -- Generate the .cpp file path
  local extension = header_file:match("(%.hp*)$")
  local cpp_file = header_file:gsub(extension, ".cpp")

  -- Check if the .cpp file already exists
  local cpp_exists = vim.fn.filereadable(cpp_file) == 1

  -- If the file doesn't exist, create it
  if not cpp_exists then
    -- Create the file
    local file = io.open(cpp_file, "w")

    if file == nil then
      print("Failed to create " .. cpp_file)
      return
    end

    file:write("#include \"" .. header_filename .. "\"\n\n")
    file:close()
    print("Created " .. cpp_file)
  else
    print(cpp_file .. " already exists.")
  end

  -- Open the .cpp file in a vertical split
  vim.cmd("split " .. cpp_file)
end

-- Map this function to a command or keybinding if you want
vim.api.nvim_set_keymap('n', '<leader>cx', ':lua CreateCppAndSplitOpen()<CR>',
  { noremap = true, silent = true, desc = 'Create .cpp file in the same directory as current header file' })

-- Specific spaces per tab in C++ files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cpp",
  callback = function()
    -- vim.opt_local.tabstop = 4
    -- vim.opt_local.softtabstop = 4
    -- vim.opt_local.shiftwidth = 4
  end
})
