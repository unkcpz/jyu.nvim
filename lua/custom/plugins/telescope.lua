return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        'nvim-tree/nvim-web-devicons',
        'folke/todo-comments.nvim',
    },
    config = function()
        local telescope = require 'telescope'
        local actions = require 'telescope.actions'

        telescope.setup {
            defaults = {
                path_display = { 'smart' },
                mappings = {
                    i = {
                        ['<C-k>'] = actions.move_selection_previous, -- move to prev result
                        ['<C-j>'] = actions.move_selection_next, -- move to next result
                        ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
                    },
                },
                layout_strategy = 'horizontal', -- Options: horizontal, vertical, center, dropdown
                layout_config = {
                    horizontal = {
                        prompt_position = 'top', -- Moves prompt to the top
                        preview_width = 0.45,
                        results_width = 0.6,
                    },
                    vertical = {
                        mirror = false,
                    },
                    center = {
                        width = 0.5, -- Centers the layout with 50% width
                    },
                    dropdown = {
                        width = 0.5, -- Dropdown menu width
                        previewer = false, -- No preview window
                    },
                },
                sorting_strategy = 'ascending', -- Show results from top to bottom
                winblend = 10, -- Transparency (adjust as needed)
                border = true, -- Enable borders
                color_devicons = true, -- Color icons
            },
            pickers = {
                find_files = {
                    theme = 'dropdown',
                },
            },
        }

        telescope.load_extension 'fzf'

        -- set keymaps
        local keymap = vim.keymap -- for conciseness

        keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Fuzzy find files in cwd' })
        keymap.set('n', '<leader>fb', '<cmd>Telescope current_buffer_fuzzy_find<cr>', { desc = 'Fuzzy find in the current buffer' })
        keymap.set('n', '<leader>fr', '<cmd>Telescope oldfiles<cr>', { desc = 'Fuzzy find recent files' })
        keymap.set('n', '<leader>fs', '<cmd>Telescope live_grep<cr>', { desc = 'Find string in cwd' })
        keymap.set('n', '<leader>fc', '<cmd>Telescope grep_string<cr>', { desc = 'Find string under cursor in cwd' })
        keymap.set('n', '<leader>ft', '<cmd>TodoTelescope<cr>', { desc = 'Find todos' })
    end,
}
