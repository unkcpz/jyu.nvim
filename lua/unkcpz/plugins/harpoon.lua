return {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local harpoon = require 'harpoon'

        harpoon:setup()

        local keymap = vim.keymap -- for conciseness

        keymap.set('n', '<leader>a', function()
            harpoon:list():add()
        end)

        -- Toggle previous & next buffers stored within Harpoon list
        keymap.set('n', '<leader>gp', function()
            harpoon:list():prev()
        end, { desc = 'previous harpoon buf' })
        keymap.set('n', '<leader>gn', function()
            harpoon:list():next()
        end, { desc = 'next harpoon buf' })
        keymap.set('n', '<C-e>', function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end)
    end,
}
