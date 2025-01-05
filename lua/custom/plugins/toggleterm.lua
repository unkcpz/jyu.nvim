return {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = true,
    keys = {
        { '<leader>0', '<Cmd>2ToggleTerm<Cr>', desc = 'Terminal #2' },
        {
            '<leader>Tv',
            function()
                local count = vim.v.count1
                local cwd = vim.fn.getcwd()
                local toggleterm = require 'toggleterm'
                toggleterm.toggle(count, 10, cwd, 'horizontal')
            end,
            desc = 'Open a horizontal terminal on cwd',
        },
        {
            '<leader>Tf',
            function()
                local count = vim.v.count1
                local cwd = vim.fn.getcwd()
                local toggleterm = require 'toggleterm'
                toggleterm.toggle(count, 0, cwd, 'float')
            end,
            desc = 'Open a float terminal on cwd',
        },
    },
    opts = {
        open_mapping = [[<c-\>]],
    },
}
