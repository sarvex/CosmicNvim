local user_config = require 'cosmic.core.user'
local icons = require 'cosmic.utils.icons'
local u = require 'cosmic.utils'

-- set up args
local args = {
  respect_buf_cwd = true,
  diagnostics = {
    enable = true,
    icons = {
      hint = icons.hint,
      info = icons.info,
      warning = icons.warn,
      error = icons.error,
    },
  },
  update_focused_file = {
    enable = true,
  },
  view = {
    width = 35,
    number = true,
    relativenumber = true,
  },
  git = {
    ignore = true,
  },
  renderer = {
    highlight_git = true,
    special_files = {},
    icons = {
      glyphs = {
        default = '',
        symlink = icons.symlink,
        git = icons.git,
        folder = icons.folder,
      },
    },
  },
  on_attach = function(bufnr)
    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    local ok, api = pcall(require, 'nvim-tree.api')
    assert(ok, 'api module is not found')
    vim.keymap.set('n', '<CR>', api.node.open.tab_drop, opts('Tab drop'))
  end,
}

-- auto show hydra on nvimtree focus
local function change_root_to_global_cwd()
  local global_cwd = vim.fn.getcwd()
  -- local global_cwd = vim.fn.getcwd(-1, -1)
  api.tree.change_root(global_cwd)
end

local hint = [[
 _w_: cd CWD   _c_: Path yank           _/_: Filter
 _y_: Copy     _x_: Cut                 _p_: Paste
 _r_: Rename   _d_: Remove              _n_: New
 _h_: Hidden   _?_: Help
 ^
]]
-- ^ ^           _q_: exit

-- local nvim_tree_hydra = nil
-- local nt_au_group = vim.api.nvim_create_augroup('NvimTreeHydraAu', { clear = true })

-- local Hydra = require 'hydra'
-- local function spawn_nvim_tree_hydra()
--   nvim_tree_hydra = Hydra {
--     name = 'NvimTree',
--     hint = hint,
--     config = {
--       color = 'pink',
--       invoke_on_body = true,
--       buffer = 0,         -- only for active buffer
--       hint = {
--         position = 'bottom',
--         border = 'rounded',
--       },
--     },
--     mode = 'n',
--     body = 'H',
--     heads = {
--       { 'w', change_root_to_global_cwd,     { silent = true } },
--       { 'c', api.fs.copy.absolute_path,     { silent = true } },
--       { '/', api.live_filter.start,         { silent = true } },
--       { 'y', api.fs.copy.node,              { silent = true } },
--       { 'x', api.fs.cut,                    { exit = true, silent = true } },
--       { 'p', api.fs.paste,                  { exit = true, silent = true } },
--       { 'r', api.fs.rename,                 { silent = true } },
--       { 'd', api.fs.remove,                 { silent = true } },
--       { 'n', api.fs.create,                 { silent = true } },
--       { 'h', api.tree.toggle_hidden_filter, { silent = true } },
--       { '?', api.tree.toggle_help,          { silent = true } },
--       -- { 'q', nil, { exit = true, nowait = true } },
--     },
--   }
--   nvim_tree_hydra:activate()
-- end

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  pattern = '*',
  callback = function(opts)
    if vim.bo[opts.buf].filetype == 'NvimTree' then
      spawn_nvim_tree_hydra()
    else
      if nvim_tree_hydra then
        nvim_tree_hydra:exit()
      end
    end
  end,
  group = nt_au_group,
})

return {
  'kyazdani42/nvim-tree.lua',
  config = function()
    require('nvim-tree').setup(u.merge(args, user_config.plugins.nvim_tree or {}))
  end,
  init = function()
    local map = require('cosmic.utils').map

    map('n', '<C-n>', ':NvimTreeToggle<CR>', { desc = 'Toggle Tree' })
    map('n', '<leader>nt', ':NvimTreeToggle<CR>', { desc = 'Toggle Tree' })
    map('n', '<leader>nr', ':NvimTreeRefresh<CR>', { desc = 'Refresh Tree' })
  end,
  cmd = {
    'NvimTreeClipboard',
    'NvimTreeFindFile',
    'NvimTreeOpen',
    'NvimTreeRefresh',
    'NvimTreeToggle',
  },
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'nvim-tree'),
}
