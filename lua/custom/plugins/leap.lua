return {
    'ggandor/leap.nvim',
    config = function()
        local leap = require 'leap'
        leap.create_default_mappings()

        -- Disable auto-jumping to the first match
        leap.opts.safe_labels = {}

        -- Greying out the search area
        vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
    end,
}
