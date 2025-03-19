return {
    -- tmux & split window navigation
    'christoomey/vim-tmux-navigator',
    config = function()
        vim.api.nvim_set_keymap('t', '<C-h>', '<C-h>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('t', '<C-j>', '<C-j>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('t', '<C-k>', '<C-k>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('t', '<C-l>', '<C-l>', { noremap = true, silent = true })
    end,
}
