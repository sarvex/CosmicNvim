local M = {}

function M.get_install_path()
  local path = os.getenv('COSMICNVIM_INSTALL_DIR')
  if not path then
    return vim.fn.stdpath('config')
  end
  return path
end

function M.get_cache_path()
  local path = os.getenv('COSMICNVIM_CACHE_DIR')
  if not path then
    return vim.fn.stdpath('cache')
  end
  return path
end

function M.get_runtimepath()
  local path = os.getenv('COSMICNVIM_RUNTIMEPATH')
  if not path then
    return vim.fn.stdpath('data')
  end
  return path
end

-- update instance of CosmicNvim
function M.update()
  local Logger = require('cosmic.utils.logger')
  local Job = require('plenary.job')
  local path = M.get_install_path()
  local errors = {}

  Job
    :new({
      command = 'git',
      args = { 'pull', '--ff-only' },
      cwd = path,
      on_start = function()
        Logger:log('Updating...')
      end,
      on_exit = function()
        if vim.tbl_isempty(errors) then
          Logger:log('Updated! Running CosmicReloadSync...')
          M.reload_user_config_sync()
        else
          table.insert(errors, 1, 'Something went wrong! Please pull changes manually.')
          table.insert(errors, 2, '')
          Logger:error('Update failed!', { timeout = 30000 })
        end
      end,
      on_stderr = function(_, err)
        table.insert(errors, err)
      end,
    })
    :sync()
end

return M
