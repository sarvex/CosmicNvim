-- Override Cosmic editor options

local g = vim.g
local map = require('cosmic.utils').map
local opt = vim.opt

-- Add additional keymaps or disable existing ones
-- To view maps set, use `:Telescope keymaps`
-- or `:map`, `:map <leader>`

-- Example: Additional insert mapping:
map('i', 'jj', '<esc>')

-- Mapping options:
-- map('n', ...)
-- map('v', ...)
-- map('i', ...)
-- map('t', ...)

-- Example: Disable find files keymap
-- vim.keymap.del('n', '<leader>f')

-- See :h vim.keymap for more info
