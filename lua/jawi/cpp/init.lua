-- Add this to your Neovim config (init.lua or a separate lua file)
function CreateCppAndSplitOpen()
    -- Get the current file path
    local hpp_file = vim.api.nvim_buf_get_name(0)

    -- Ensure it is an .hpp file
    if hpp_file:sub(-4) ~= ".hpp" then
        print("This is not an .hpp file!")
        return
    end

    -- Generate the .cpp file path
    local cpp_file = hpp_file:gsub("%.hpp$", ".cpp")

    -- Extract the file name (e.g., Foo.hpp)
    local hpp_filename = hpp_file:match("([^/]+)%.hpp") .. ".hpp"

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

        file:write("#include \"" .. hpp_filename .. "\"\n")
        file:close()
        print("Created " .. cpp_file)
    else
        print(cpp_file .. " already exists.")
    end

    -- Open the .cpp file in a vertical split
    vim.cmd("vsplit " .. cpp_file)
end

-- Map this function to a command or keybinding if you want
-- vim.api.nvim_set_keymap('n', '<leader>cc', ':lua CreateCppAndSplitOpen()<CR>', { noremap = true, silent = true })
