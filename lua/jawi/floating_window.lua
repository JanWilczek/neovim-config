-- Create a module or a standalone function
local floating_window = {}

function floating_window.open_floating_window(filename)
  -- Set the window dimensions to proportion of the editor's width and height
  local width = math.floor(vim.o.columns * 0.5)
  local height = math.floor(vim.o.lines * 0.5)

  -- Calculate the center position
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Set the floating window options
  local win_opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded'
  }

  -- Open the floating window
  local buf = vim.api.nvim_create_buf(false, true)   -- Create a buffer
  vim.api.nvim_open_win(buf, true, win_opts)         -- Open it in a floating window
  vim.api.nvim_command('edit ' .. filename)          -- Open the specified file in the buffer
end

function floating_window.create_todo_file(file_path)
  -- File doesn't exist, create it with the header
  local f = io.open(file_path, "w")
  if f then
    -- Write the fancy header to the file
    f:write([[
╔═════════════════════════════════════════╗
║    ✅ / 🧠  LOCAL TODO FILE 🧠 / ✅     ║
╚═════════════════════════════════════════╝

]])
    f:close()
  else
    print("Failed to create todo file!")
  end
end

function floating_window.file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function floating_window.open_todo_file(file_path)
  if not floating_window.file_exists(file_path) then
    floating_window.create_todo_file(file_path)
  end

  floating_window.open_floating_window(file_path)
end

return floating_window
