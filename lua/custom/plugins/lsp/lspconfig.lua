return {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        { 'antosha417/nvim-lsp-file-operations', config = true },
        { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
        -- import lspconfig plugin
        local lspconfig = require 'lspconfig'
        vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
        vim.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]

        local border = {
            { '┏', 'FloatBorder' },
            { '━', 'FloatBorder' },
            { '┓', 'FloatBorder' },
            { '┃', 'FloatBorder' },
            { '┛', 'FloatBorder' },
            { '━', 'FloatBorder' },
            { '┗', 'FloatBorder' },
            { '┃', 'FloatBorder' },
        }

        -- To instead override globally
        local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
        function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
            opts = opts or {}
            opts.border = opts.border or border
            return orig_util_open_floating_preview(contents, syntax, opts, ...)
        end

        local keymap = vim.keymap -- for conciseness

        -- julials
        lspconfig.julials.setup {
            cmd = {
                'julia',
                '--startup-file=no',
                '--history-file=no',
                '-e',
                [[
        using LanguageServer;
        using Pkg;
        import StaticLint;
        import SymbolServer;
        env_path = dirname(Pkg.Types.Context().env.project_file);
        server = LanguageServer.LanguageServerInstance(stdin, stdout, env_path, "");
        server.runlinter = true;
        run(server);
      ]],
            },
            filetypes = { 'julia' },
            root_dir = lspconfig.util.root_pattern('.git', 'Project.toml'),
        }

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf, silent = true }

                local toggleInlay = function()
                    local current_value = vim.lsp.inlay_hint.is_enabled { bufnr = 0 }
                    vim.lsp.inlay_hint.enable(not current_value, { bufnr = 0 })
                end

                -- set keybinds
                opts.desc = 'Show LSP references'
                keymap.set('n', 'gR', '<cmd>Telescope lsp_references<CR>', opts) -- show definition, references

                opts.desc = 'Toggle Inlay Hint'
                keymap.set('n', '<leader>ri', toggleInlay, opts) -- toggle inlay hint

                opts.desc = 'Go to declaration'
                keymap.set('n', 'gD', vim.lsp.buf.declaration, opts) -- go to declaration

                opts.desc = 'Show LSP definitions'
                keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts) -- show lsp definitions

                opts.desc = 'Show LSP implementations'
                keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts) -- show lsp implementations

                opts.desc = 'Show LSP type definitions'
                keymap.set('n', 'gt', '<cmd>Telescope lsp_type_definitions<CR>', opts) -- show lsp type definitions

                opts.desc = 'See available code actions'
                keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

                opts.desc = 'Smart rename'
                keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts) -- smart rename

                -- replaced by conform plugin set in generic-formamater.lua
                -- opts.desc = 'Buf formatter'
                -- keymap.set('n', '<leader>pf', vim.lsp.buf.format, opts) -- smart rename

                opts.desc = 'Show buffer diagnostics'
                keymap.set('n', '<leader>D', '<cmd>Telescope diagnostics bufnr=0<CR>', opts) -- show  diagnostics for file

                opts.desc = 'Show line diagnostics'
                keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts) -- show diagnostics for line

                opts.desc = 'Go to previous diagnostic'
                keymap.set('n', '[d', vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

                opts.desc = 'Go to next diagnostic'
                keymap.set('n', ']d', vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

                opts.desc = 'Show documentation for what is under cursor'
                keymap.set('n', 'K', vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

                opts.desc = 'Restart LSP'
                keymap.set('n', '<leader>rs', ':LspRestart<CR>', opts) -- mapping to restart lsp if necessary
            end,
        })

        -- Change the Diagnostic symbols in the sign column (gutter)
        -- (not in youtube nvim video)
        local signs = { Error = 'x ', Warn = '! ', Hint = '> ', Info = 'i ' }
        for type, icon in pairs(signs) do
            local hl = 'DiagnosticSign' .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
        end

        vim.diagnostic.config {
            virtual_text = false, -- Disable inline diagnostic messages
            signs = false, -- Disable default sign handling
            underline = true,
            update_in_insert = false,
        }

        local virtual_text_enabled = false -- Start with virtual text disabled

        function ToggleVirtualText()
            virtual_text_enabled = not virtual_text_enabled
            vim.diagnostic.config {
                virtual_text = virtual_text_enabled,
            }
            print('Virtual Text: ' .. (virtual_text_enabled and 'Enabled' or 'Disabled'))
        end

        -- Keybinding to toggle virtual text (adjust as needed)
        vim.keymap.set('n', '<leader>dt', ToggleVirtualText, { noremap = true, silent = true })

        -- Custom function to force Error to take precedence
        vim.api.nvim_create_autocmd('DiagnosticChanged', {
            callback = function()
                local ns = vim.api.nvim_create_namespace 'custom_diagnostic_signs'
                vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
                local diagnostics = vim.diagnostic.get(0)

                -- Table to store the highest priority diagnostic for each line
                local line_signs = {}

                for _, diag in ipairs(diagnostics) do
                    local line = diag.lnum
                    local severity = diag.severity

                    -- Assign the highest priority diagnostic (Error > Warn > Hint > Info)
                    if not line_signs[line] or severity < line_signs[line].severity then
                        line_signs[line] = { severity = severity, type = diag.severity }
                    end
                end

                -- Apply signs based on priority
                for line, data in pairs(line_signs) do
                    local max_lines = vim.api.nvim_buf_line_count(0)

                    if line >= 0 and line < max_lines then
                        local sign_type = ({ 'Error', 'Warn', 'Hint', 'Info' })[data.type]
                        local sign_icon = signs[sign_type]

                        vim.api.nvim_buf_set_extmark(0, ns, line, 0, {
                            sign_text = sign_icon,
                            sign_hl_group = 'DiagnosticSign' .. sign_type,
                        })
                    else
                        -- Debugging output (optional)
                        print(string.format('Skipping out-of-range line: %d (max lines: %d)', line, max_lines))
                    end
                end
            end,
        })

    end,
}
