return {
  "kdheepak/juliaFormatter.vim",
  lazy = false,
  ft = { 'julia' },
  config = function()
    vim.g.juliaFormatter_options = { style = "blue" }

    local keymap = vim.keymap
    keymap.set('n', '<leader>jf', '<cmd>JuliaFormatterFormat<cr>', { noremap = true, silent = true })
  end,
}
