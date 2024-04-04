return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    -- REQUIRED
    harpoon:setup({})
    -- REQUIRED

    -- basic telescope configuration
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
            table.insert(file_paths, item.value)
        end

        require("telescope.pickers").new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
                results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
        }):find()
    end

    vim.keymap.set("n", "<leader>hw", function() toggle_telescope(harpoon:list()) end,
                   { desc = "Open [H]arpoon [W]indow" })

    vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "[H]arpoon [A]dd" })
    vim.keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "[H]arpoon [L]ist" })

    vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "[H]arpoon select [1]st on the list" })
    vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "[H]arpoon select [2]nd on the list" })
    vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "[H]arpoon select [3]rd on the list" })
    vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "[H]arpoon select [4]th on the list" })
    vim.keymap.set("n", "<leader>h5", function() harpoon:list():select(5) end, { desc = "[H]arpoon select [5]th on the list" })
    vim.keymap.set("n", "<leader>h6", function() harpoon:list():select(6) end, { desc = "[H]arpoon select [6]th on the list" })
    vim.keymap.set("n", "<leader>h7", function() harpoon:list():select(7) end, { desc = "[H]arpoon select [7]th on the list" })
    vim.keymap.set("n", "<leader>h8", function() harpoon:list():select(8) end, { desc = "[H]arpoon select [8]th on the list" })
    vim.keymap.set("n", "<leader>h9", function() harpoon:list():select(9) end, { desc = "[H]arpoon select [9]th on the list" })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "[H]arpoon go to [P]revious buffer in the list" })
    vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, { desc = "[H]arpoon go to [N]ext buffer in the list" })
  end
}
