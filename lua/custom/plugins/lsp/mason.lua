return {
    'williamboman/mason.nvim',
    dependencies = {
        'williamboman/mason-lspconfig.nvim',
        'mfussenegger/nvim-dap',
        'jay-babu/mason-nvim-dap.nvim',
    },
    config = function()
        -- import mason
        local mason = require 'mason'

        -- import mason-lspconfig
        local mason_lspconfig = require 'mason-lspconfig'

        -- enable mason and configure icons
        mason.setup {
            ui = {
                icons = {
                    package_installed = '✓',
                    package_pending = '➜',
                    package_uninstalled = '✗',
                },
            },
        }

        mason_lspconfig.setup {
            -- list of servers for mason to install
            ensure_installed = {
                'html',
                'htmx',
                'lua_ls',
                'ruff',
                'julials',
                'basedpyright',
            },
            automatic_installation = true,
        }

        local mason_dapconfig = require 'mason-nvim-dap'

        mason_dapconfig.setup {
            ensure_installed = { 'codelldb' },
            automatic_installation = true,
        }
    end,
}
