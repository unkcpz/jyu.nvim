return {
    'ggandor/leap.nvim',
    config = function()
        local leap = require 'leap'
        vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap-forward)')
        vim.keymap.set({ 'n', 'x', 'o' }, 'S', '<Plug>(leap-backward)')
        vim.keymap.set({ 'n', 'x', 'o' }, 'gs', '<Plug>(leap-from-window)')

        -- Disable auto-jumping to the first match
        leap.opts.safe_labels = {}

        -- Greying out the search area
        vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
    end,
}
