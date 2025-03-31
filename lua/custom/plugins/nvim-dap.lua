return {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    config = function()
        local dap, dapui = require 'dap', require 'dapui'

        -- codelldb adapter for Rust
        dap.adapters.lldb = {
            type = 'executable',
            command = 'codelldb',
            name = 'lldb',
        }

        dap.configurations.rust = {
            {
                name = 'Launch',
                type = 'lldb',
                request = 'launch',
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
                args = {},
            },
        }

        dapui.setup()

        -- Auto open and close dap-ui
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        vim.keymap.set('n', '<leader>bc', dap.continue, { desc = 'DAP Continue/Start' })
        vim.keymap.set('n', '<leader>bs', dap.step_over, { desc = 'DAP Step Over' })
        vim.keymap.set('n', '<leader>bi', dap.step_into, { desc = 'DAP Step Into' })
        vim.keymap.set('n', '<leader>bo', dap.step_out, { desc = 'DAP Step Out' })
        vim.keymap.set('n', '<leader>bb', dap.toggle_breakpoint, { desc = 'DAP Toggle Breakpoint' })
        vim.keymap.set('n', '<leader>br', dap.repl.open, { desc = 'DAP REPL' })
        vim.keymap.set('n', '<leader>bl', dap.run_last, { desc = 'DAP Run Last' })
        vim.keymap.set('n', '<leader>bt', dap.terminate, { desc = 'DAP terminate' })
    end,
}
