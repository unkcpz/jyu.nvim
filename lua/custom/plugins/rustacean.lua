return {
    'mrcjkb/rustaceanvim',
    dependencies = {
        'neovim/nvim-lspconfig',
        'mfussenegger/nvim-dap',
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
    },
    version = '^4',
    ft = { 'rust', 'lalrpop', 'rs' },
    tools = {
        float_win_config = {
            border = 'rounded',
        },
    },
    init = function()
        vim.g.rustaceanvim = vim.tbl_deep_extend('keep', vim.g.rustaceanvim or {}, {})
        if vim.fn.executable 'rust-analyzer' == 0 then
            LazyVim = require 'lazyvim.util'
            LazyVim.error('**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/', { title = 'rustaceanvim' })
        end
        vim.g.rustaceanvim = function()
            -- Manually specify CodeLLDB adapter paths to avoid Mason registry calls
            local mason_pkg_path = vim.fn.stdpath 'data' .. '/mason/packages/'
            -- Mason's codelldb install path
            local extension_path = mason_pkg_path .. 'codelldb/extension/'
            local codelldb_path = extension_path .. 'adapter/codelldb'
            local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'

            -- Use rustaceanvim’s helper to build the DAP adapter config
            local rust_cfg = require 'rustaceanvim.config'
            return {
                -- Configure DAP adapter for debugging (uses codelldb)
                dap = {
                    adapter = rust_cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
                },
                -- LSP server config: use system rust-analyzer (no Mason).
                server = {
                    on_attach = function(_, bufnr)
                        vim.keymap.set('n', '<leader>rd', function()
                            vim.cmd.RustLsp 'debuggables'
                        end, { desc = 'Rust Debuggables', buffer = bufnr })
                        vim.keymap.set('n', '<leader>rr', function()
                            vim.cmd.RustLsp 'runnables'
                        end, { desc = 'Rust Runnables', buffer = bufnr })
                        -- Use rustfmt set in generic-formatter.lua not here
                        -- vim.keymap.set('n', '<leader>rf', function()
                        --     vim.cmd 'RustFmt'
                        -- end, { desc = 'Rust formatting', buffer = bufnr })
                    end,
                    settings = {
                        -- rust-analyzer language server configuration
                        ['rust-analyzer'] = {
                            cargo = {
                                allFeatures = true,
                                loadOutDirsFromCheck = true,
                                buildScripts = {
                                    enable = true,
                                },
                            },
                            -- Add clippy lints for Rust.
                            checkOnSave = {
                                allFeatures = true,
                                command = 'clippy',
                                extraArgs = {
                                    '--',
                                    '--no-deps',
                                    '-Dclippy::correctness',
                                    '-Dclippy::complexity',
                                    '-Wclippy::perf',
                                    '-Wclippy::pedantic',
                                },
                            },
                            procMacro = {
                                enable = true,
                                ignored = {
                                    ['async-trait'] = vim.NIL,
                                    ['napi-derive'] = { 'napi' },
                                    ['async-recursion'] = { 'async_recursion' },
                                },
                            },
                        },
                    },
                },
            }
        end
    end,
    config = function(_, _) end,
}
