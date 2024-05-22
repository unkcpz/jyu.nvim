return {
  'mrcjkb/rustaceanvim',
  version = '^4', -- Recommended
  lazy = false, -- This plugin is already lazy
  ft = { "rust" },
  config = function()
    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>crr", "<cmd>RustLsp runnables<CR>", { desc = "RustLsp runnables" }) -- run rust
    keymap.set("n", "<leader>crf", "<cmd>RustFmt<CR>", { desc = "Rust formatting" }) -- run rust formatting
  end
}
