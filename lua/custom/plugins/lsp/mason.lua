return {
    'williamboman/mason.nvim',
    dependencies = {
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
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

        -- used to enable autocompletion (assign to every lsp server config)
        local cmp_nvim_lsp = require 'cmp_nvim_lsp'
        local capabilities = cmp_nvim_lsp.default_capabilities()

        mason_lspconfig.setup {
            -- list of servers for mason to install
            automatic_enable = true,
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
        vim.lsp.config('lua_ls', {
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = { globals = { 'vim' } },
                    completion = { callSnippet = 'Replace' },
                },
            },
        })

        local mason_dapconfig = require 'mason-nvim-dap'

        mason_dapconfig.setup {
            ensure_installed = { 'codelldb' },
            automatic_installation = true,
        }
    end,
}
