return {
    'mbbill/undotree',
    init = function()
        vim.g.undotree_WindowLayout = 4
        vim.g.undotree_ShortIndicators = 1
        vim.g.undotree_SplitWidth = 30
        vim.g.undotree_SetFocusWhenToggle = 1
    end,
    config = function()
        local keymap = vim.keymap
        keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Toggle Undotree ' })
    end,
}
