return {
    'kylechui/nvim-surround',
    event = { 'BufReadPre', 'BufNewFile' },
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    config = function()
        local surround = require 'nvim-surround'
        surround.setup {
            keymaps = {
                insert = '<C-g>z',
                insert_line = 'gC-ggZ',
                normal = 'gz',
                normal_cur = 'gZ',
                normal_line = 'gzgz',
                normal_cur_line = 'gZgZ',
                visual = 'gz',
                visual_line = 'gZ',
                delete = 'gzd',
                change = 'gzr',
            },
        }
    end,
}
