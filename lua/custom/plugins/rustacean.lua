-- get from https://github.com/appelgriebsch/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/rust.lua
return {
    'mrcjkb/rustaceanvim',
    version = '^4', -- Recommended
    ft = { 'rust', 'lalrpop' },
    opts = {
        server = {
            tools = {
                float_win_config = {
                    border = 'rounded',
                },
            },
            on_attach = function(_, bufnr)
                vim.keymap.set('n', '<leader>rd', function()
                    vim.cmd.RustLsp 'debuggables'
                end, { desc = 'Rust Debuggables', buffer = bufnr })
                vim.keymap.set('n', '<leader>rr', function()
                    vim.cmd.RustLsp 'runnables'
                end, { desc = 'Rust Runnables', buffer = bufnr })
                -- Use rustfmt set in generic-formatter.lua
                -- vim.keymap.set('n', '<leader>rf', function()
                --     vim.cmd 'RustFmt'
                -- end, { desc = 'Rust formatting', buffer = bufnr })
            end,
            default_settings = {
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
                            ['async-trait'] = { 'async_trait' },
                            ['napi-derive'] = { 'napi' },
                            ['async-recursion'] = { 'async_recursion' },
                        },
                    },
                },
            },
        },
    },
    config = function(_, opts)
        vim.g.rustaceanvim = vim.tbl_deep_extend('keep', vim.g.rustaceanvim or {}, opts or {})
        if vim.fn.executable 'rust-analyzer' == 0 then
            LazyVim = require 'lazyvim.util'
            LazyVim.error('**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/', { title = 'rustaceanvim' })
        end
    end,
}
