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
                -- You can customize some of the format options for the filetype (:help conform.format)
                rust = { 'rustfmt', lsp_format = 'fallback' },
                -- Use "yamlfmt" as primary
                yaml = { 'yamlfmt' },
                html = { 'htmlbeautifier' },
            },
        }

        local keymap = vim.keymap -- for conciseness

        keymap.set('n', '<leader>pf', function()
            require('conform').format { bufnr = vim.api.nvim_get_current_buf() }
        end, { noremap = true, silent = true, desc = 'Format buffer with Conform' })
    end,
}
