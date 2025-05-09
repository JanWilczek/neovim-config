return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "theHamsta/nvim-dap-virtual-text",
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio"
  },
  config = function()
    local dap = require("dap")

    local dap_virtual_text_status = require("nvim-dap-virtual-text")

    local dapui = require("dapui")

    local file = require("utils.file")
    local codelldb = require("utils.codelldb")

    dap_virtual_text_status.setup({
      enabled = true,                        -- enable this plugin (the default)
      enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
      highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
      highlight_new_as_changed = false,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
      show_stop_reason = true,               -- show stop reason when stopped for exceptions
      commented = true,                      -- prefix virtual text with comment string
      only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
      all_references = false,                -- show virtual text on all all references of the variable (not only definitions)
      filter_references_pattern = "<module", -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
      -- experimental features:
      virt_text_pos = "eol",                 -- position of virtual text, see `:h nvim_buf_set_extmark()`
      all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
      virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
      virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
      -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
    })

    dapui.setup({
      layouts = {
        {
          elements = {
            "watches",
          },
          size = 0.2,
          position = "left",
        },
      },
      controls = {
        enabled = false,
      },
      render = {
        max_value_lines = 3,
      },
      floating = {
        max_height = nil,  -- These can be integers or a float between 0 and 1.
        max_width = nil,   -- Floats will be treated as percentage of your screen.
        border = "single", -- Border style. Can be "single", "double" or "rounded"
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
    })

    local icons = require("utils.icons")
    vim.api.nvim_set_hl(0, "DapStoppedLinehl", { bg = "#555530" })
    vim.fn.sign_define("DapBreakpoint", { text = icons.ui.TinyCircle, texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition",
      { text = icons.ui.CircleWithGap, texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = icons.ui.LogPoint, texthl = "DapLogPoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped",
      { text = icons.ui.ChevronRight, texthl = "Error", linehl = "DapStoppedLinehl", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected",
      { text = icons.diagnostics.Error, texthl = "Error", linehl = "", numhl = "" })

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    dap.defaults.fallback.terminal_win_cmd = "10split new"

    -- cpp
    dap.configurations.cpp = {
      {
        name = "C++ Debug And Run",
        type = "codelldb",
        request = "launch",
        program = function()
          -- First, check if exists CMakeLists.txt
          local cwd = vim.fn.getcwd()
          if file.exists(cwd, "CMakeLists.txt") then
            -- Then invoke cmake commands
            -- Then ask user to provide execute file
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          else
            local fileName = vim.fn.expand("%:t:r")
            -- create this directory
            os.execute("mkdir -p " .. "bin")
            local cmd = "!g++ -g % -o bin/" .. fileName
            -- First, compile it
            vim.cmd(cmd)
            -- Then, return it
            return "${fileDirname}/bin/" .. fileName
          end
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        runInTerminal = true,
        console = "integratedTerminal",
      },
      {
        name = '(lldb) Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = function()
          return vim.fn.input('Arguments to the executable: ', '')
        end,

        -- 💀
        -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
        --
        --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
        --
        -- Otherwise you might get the following error:
        --
        --    Error on launch: Failed to attach to the target process
        --
        -- But you should be aware of the implications:
        -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
        -- runInTerminal = false,
      },
      {
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopAtEntry = true,
        setupCommands = {
          {
            text = '-enable-pretty-printing',
            description = 'enable pretty printing',
            ignoreFailures = false
          },
        },
      },
      {
        name = 'Attach to gdbserver :1234',
        type = 'cppdbg',
        request = 'launch',
        MIMode = 'gdb',
        miDebuggerServerAddress = 'localhost:1234',
        miDebuggerPath = '/usr/bin/gdb',
        cwd = '${workspaceFolder}',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        setupCommands = {
          {
            text = '-enable-pretty-printing',
            description = 'enable pretty printing',
            ignoreFailures = false
          },
        },
      },
    }

    -- c
    dap.configurations.c = {
      {
        name = "C Debug And Run",
        type = "codelldb",
        request = "launch",
        program = function()
          -- First, check if exists CMakeLists.txt
          local cwd = vim.fn.getcwd()
          if (file.exists(cwd, "CMakeLists.txt")) then
            -- Todo. Then invoke cmake commands
            -- Then ask user to provide execute file
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          else
            local fileName = vim.fn.expand("%:t:r")
            if (not file.exists(cwd, "bin")) then
              -- create this directory
              os.execute("mkdir " .. "bin")
            end
            local cmd = "!gcc -g % -o bin/" .. fileName
            -- First, compile it
            vim.cmd(cmd)
            -- Then, return it
            return "${fileDirname}/bin/" .. fileName
          end
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false
      },
    }

    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        -- CHANGE THIS to your path!
        command = codelldb.codelldb_path,
        args = { "--port", "${port}" },

        -- On windows you may have to uncomment this:
        -- detached = false,
      }
    }
    dap.adapters.lldb = {
      type = 'executable',
      command = '/opt/homebrew/opt/llvm/bin/lldb-dap',
      name = 'lldb',
    }
    dap.adapters.cppdbg = {
      id = 'cppdbg',
      type = 'executable',
      command = '/Users/jawi/dev/tools/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
    }

    vim.keymap.set('n', '<F5>', function() require('dap').continue() end, { desc = "(Debugger) Continue" })
    vim.keymap.set('n', '<F10>', function() require('dap').step_over() end, { desc = "(Debugger) Step Over" })
    vim.keymap.set('n', '<F11>', function() require('dap').step_into() end, {desc = "(Debugger) Step Into" })
    vim.keymap.set('n', '<S-F11>', function() require('dap').step_out() end, { desc = "(Debugger) Step Out" })
    vim.keymap.set('n', '<F9>', function() require('dap').toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
    -- <F17> corresponds to Shift + F5 (<S-F5>)
    -- See here: https://github.com/mfussenegger/nvim-dap/issues/1113#issuecomment-1850472163
    vim.keymap.set('n', '<F17>', function() require('dap').close() end, { desc =  "(Debugger) Stop" })
    vim.keymap.set('n', '<Leader>lp',
      function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
    vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
    vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
    vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
      require('dap.ui.widgets').hover()
    end)
    vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
      require('dap.ui.widgets').preview()
    end)
    vim.keymap.set('n', '<Leader>df', function()
      local widgets = require('dap.ui.widgets')
      widgets.centered_float(widgets.frames)
    end)
    vim.keymap.set('n', '<Leader>ds', function()
      local widgets = require('dap.ui.widgets')
      widgets.centered_float(widgets.scopes)
    end)
  end
}
