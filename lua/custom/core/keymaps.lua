vim.g.mapleader = ' '

local keymap = vim.keymap -- for conciseness

keymap.set('i', 'jk', '<ESC>', { desc = 'Exit insert mode with jk' })

keymap.set('n', '<leader>nh', ':nohl<CR>', { desc = 'Clear search highlights' })

-- delete single character without copying into register
keymap.set('n', 'x', '"_x')

-- increment/decrement numbers
keymap.set('n', '<leader>+', '<C-a>', { desc = 'Increment number' }) -- increment
keymap.set('n', '<leader>-', '<C-x>', { desc = 'Decrement number' }) -- decrement

-- window management
keymap.set('n', '<leader>sv', '<C-w>v', { desc = 'Split window vertically' }) -- split window vertically
keymap.set('n', '<leader>sh', '<C-w>s', { desc = 'Split window horizontally' }) -- split window horizontally
keymap.set('n', '<leader>se', '<C-w>=', { desc = 'Make splits equal size' }) -- make split windows equal width & height
keymap.set('n', '<leader>sx', '<cmd>close<CR>', { desc = 'Close current split' }) -- close current split window

keymap.set('n', '<leader>s+', ':resize +5<CR>', { desc = "Increase window height" })
keymap.set('n', '<leader>s-', ':resize -5<CR>', { desc = "Decrease window height" })
keymap.set('n', '<leader>s>', ':vertical resize +5<CR>', { desc = "Increase window width" })
keymap.set('n', '<leader>s<', ':vertical resize -5<CR>', { desc = "Decrease window width" })

keymap.set('n', '<leader>to', '<cmd>tabnew<CR>', { desc = 'Open new tab' }) -- open new tab
keymap.set('n', '<leader>tx', '<cmd>tabclose<CR>', { desc = 'Close current tab' }) -- close current tab
keymap.set('n', '<leader>tn', '<cmd>tabn<CR>', { desc = 'Go to next tab' }) --  go to next tab
keymap.set('n', '<leader>tp', '<cmd>tabp<CR>', { desc = 'Go to previous tab' }) --  go to previous tab
keymap.set('n', '<leader>tf', '<cmd>tabnew %<CR>', { desc = 'Open current buffer in new tab' }) --  move current buffer to new tab

-- Jump out from terminal mode
keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { desc = 'Jump out from the terminal mode ' })

-- quickfix
keymap.set('n', '<leader>cn', '<cmd>cnext<CR>', { desc = 'next in quickfix list' })
keymap.set('n', '<leader>cp', '<cmd>cprevious<CR>', { desc = 'previous in quickfix list' })

-- remap tab as esc
-- (already the default of nvim)
-- vim.api.nvim_set_keymap('i', '<C-c>', '<Esc>', { noremap = true, silent = true })

-- Function to toggle the Quickfix list
local function toggle_quickfix()
    local qf_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            qf_exists = true
            break
        end
    end
    if qf_exists then
        vim.cmd 'cclose'
    else
        vim.cmd 'botright copen'
    end
end

-- Map the toggle function to <leader>ct
keymap.set('n', '<leader>ct', toggle_quickfix, { desc = 'toggle quickfix list' })

-- Functino to toggle wrap/unwrap lines
local function toggle_wrap()
    vim.wo.wrap = not vim.wo.wrap
    print('Line Wrap: ' .. (vim.wo.wrap and 'Enabled' or 'Disabled'))
end

-- Map the toggle function to <leader>w
keymap.set('n', '<leader>ww', toggle_wrap, { desc = 'toggle wrap lines' })

-- Select and execute lua
vim.keymap.set("v", "<leader>rl", ":'<,'>lua<CR>", { noremap = true, silent = true })
