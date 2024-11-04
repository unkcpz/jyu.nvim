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
        end, {desc = "previous harpoon buf"})
        keymap.set('n', '<leader>gn', function()
            harpoon:list():next()
        end, {desc = "next harpoon buf"})

        -- basic telescope configuration
        local conf = require('telescope.config').values
        local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end

            require('telescope.pickers')
                .new({}, {
                    prompt_title = 'Harpoon',
                    finder = require('telescope.finders').new_table {
                        results = file_paths,
                    },
                    previewer = conf.file_previewer {},
                    sorter = conf.generic_sorter {},
                })
                :find()
        end

        keymap.set('n', '<C-e>', function()
            toggle_telescope(harpoon:list())
        end, { desc = 'Open harpoon window' })
    end,
}
