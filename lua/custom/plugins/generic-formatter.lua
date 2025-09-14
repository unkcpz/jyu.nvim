return {
    'stevearc/conform.nvim',
    opts = {},
    config = function()
        -- Define a custom formatter called "rustywind"
        local formatters = {
            rustywind = {
                command = 'rustywind',
                args = { '--stdin', '--quiet' },
                stdin = true,
            },
            clang_format = {
                command = 'clang-format',
                args = { '--assume-filename', '$FILENAME', '--style=Google' },
                stdin = true,
            },
        }

        require('conform').setup {
            formatters = formatters,
            formatters_by_ft = {
                lua = { 'stylua' },
                -- Conform will run multiple formatters sequentially
                python = function(bufnr)
                    if require('conform').get_formatter_info('ruff_format', bufnr).available then
                        return { 'ruff_format' }
                    else
                        return { 'isort', 'black' }
                    end
                end,
                rust = { 'rustfmt', lsp_format = 'fallback' },
                typescript = { 'deno_fmt' },
                -- Use "yamlfmt" as primary
                yaml = { 'yamlfmt' },
                html = { 'htmlbeautifier' },
                eml = { 'htmlbeautifier' },
                cpp = { 'clang_format' },
                c = { 'clang_format' },
                nix = { 'nixfmt' },
            },
        }
        -- This in order to make html formatter works for .eml
        vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
            pattern = '*.eml',
            command = 'set filetype=html',
        })

        local keymap = vim.keymap -- for conciseness

        keymap.set('n', '<leader>pf', function()
            require('conform').format { bufnr = vim.api.nvim_get_current_buf() }
        end, { noremap = true, silent = true, desc = 'Format buffer with Conform' })

        -- select in visual mode and format
        keymap.set('v', '<leader>pf', function()
            vim.lsp.buf.format { range = { ['start'] = vim.api.nvim_buf_get_mark(0, '<'), ['end'] = vim.api.nvim_buf_get_mark(0, '>') } }
        end, { desc = 'Format Selection' })
    end,
}
