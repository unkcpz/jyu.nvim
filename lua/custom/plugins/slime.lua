return {
    -- slime (REPL integration)
    -- https://github.com/LazyVim/LazyVim/discussions/234
    {
        'jpalardy/vim-slime',
        keys = {
            { '<leader>rc', '<cmd>SlimeConfig<cr>', desc = 'Slime Config' },
            { '<leader>rr', '<Plug>SlimeSendCell<BAR>/^# %%<CR>', desc = 'Slime Send Cell' },
        },
        config = function()
            vim.g.slime_target = 'tmux'
            vim.g.slime_cell_delimiter = '# %%'
            vim.g.slime_bracketed_paste = 1
        end,
    },
}
