return {
  "kdheepak/juliaFormatter.vim",
  lazy = false,
  -- load when detecting Julia-specific project files
  cond = function()
    return vim.fn.glob("Project.toml") ~= ""
  end,
  config = function()
    vim.g.juliaFormatter_options = { style = "blue" }

    local keymap = vim.keymap
    keymap.set('n', '<leader>jf', '<cmd>JuliaFormatterFormat<cr>', { noremap = true, silent = true })
  end,
}
