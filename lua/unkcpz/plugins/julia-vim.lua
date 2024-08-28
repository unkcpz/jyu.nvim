return {
  "JuliaEditorSupport/julia-vim",
  lazy = true,
  -- load when detecting Julia-specific project files
  cond = function()
    return vim.fn.glob("Project.toml") ~= ""
  end,
  config = function()
    -- Disable LaTex to Unicode conversion on Tab for julia-vim
    vim.g.latex_to_unicode_tab = 0
    vim.g.latex_to_unicode_keymap = 1
  end,
}
