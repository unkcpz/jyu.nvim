return {
    'wesleimp/stylua.nvim',
    config = function()
        local keymap = vim.keymap
        keymap.set('n', '<leader>lf', ':lua require("stylua").format()<cr>', { noremap = true, silent = true })
    end,
}

