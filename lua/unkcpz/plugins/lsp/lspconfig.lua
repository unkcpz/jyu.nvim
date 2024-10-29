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

        -- import mason_lspconfig plugin
        local mason_lspconfig = require 'mason-lspconfig'

        -- import cmp-nvim-lsp plugin
        local cmp_nvim_lsp = require 'cmp_nvim_lsp'

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

        -- used to enable autocompletion (assign to every lsp server config)
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- Change the Diagnostic symbols in the sign column (gutter)
        -- (not in youtube nvim video)
        local signs = { Error = ' ', Warn = ' ', Hint = '󰠠 ', Info = ' ' }
        for type, icon in pairs(signs) do
            local hl = 'DiagnosticSign' .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
        end

        mason_lspconfig.setup_handlers {
            -- default handler for installed servers
            function(server_name)
                lspconfig[server_name].setup {
                    capabilities = capabilities,
                }
            end,
            ['lua_ls'] = function()
                -- configure lua server (with special settings)
                lspconfig['lua_ls'].setup {
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            -- make the language server recognize "vim" global
                            diagnostics = {
                                globals = { 'vim' },
                            },
                            completion = {
                                callSnippet = 'Replace',
                            },
                        },
                    },
                }
            end,
        }
    end,
}
