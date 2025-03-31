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

        vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'DAP Continue/Start' })
        vim.keymap.set('n', '<leader>ds', dap.step_over, { desc = 'DAP Step Over' })
        vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'DAP Step Into' })
        vim.keymap.set('n', '<leader>do', dap.step_out, { desc = 'DAP Step Out' })
        vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'DAP Toggle Breakpoint' })
        vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'DAP REPL' })
        vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = 'DAP Run Last' })
        vim.keymap.set('n', '<leader>dt', function()
            if dap.session() then
                dap.terminate()
                dapui.close()
            else
                dap.continue()
                dapui.open()
            end
        end, { desc = 'DAP Toggle Start/Stop' })
    end,
}
