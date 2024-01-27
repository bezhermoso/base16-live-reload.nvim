-- main module file

local function check_prerequisites()
  local ok = pcall(require, "base16-colorscheme")
  if not ok then
    vim.notify("Required plugin RRethy/nvim-base16 is missing.", vim.log.levels.ERROR)
    return false
  end
  ok = pcall(require, "fwatch")
  if not ok then
    vim.notify("Required plugin rktjmp/fwatch.nvim is missing.", vim.log.levels.ERROR)
    return false
  end
  return true
end

local function get_files_to_watch()
    -- tinted-theming/base16-shell uses XDG_CONFIG_PATH if present.
    local config_dir = vim.env.XDG_CONFIG_HOME
    if config_dir == nil or config_dir == '' then
        config_dir = '~/.config'
    end
    return {
        -- tinted-theming/base16-shell writes this file
        config_dir .. "/tinted-theming/set_theme.lua",
        -- chriskempson/base16-shell writes this file
        "~/.vimrc_background",
    }
end

---@param config Config
local function start_watcher(config)
  local fwatch = require("fwatch")
  local base16 = require("base16-colorscheme")
  local files = get_files_to_watch()
  for _, f in ipairs(files) do
    local full_path = vim.fn.expand(f)
    if not vim.fn.filereadable(full_path) then
      goto continue
    end
    fwatch.watch(full_path, {
      on_event = function()
        vim.schedule(base16.load_from_shell)
        vim.schedule(config.callback or function() end)
      end
    })
    ::continue::
  end
end

---@class Config
---@field callback function Optional callback you'd like called on file-change.
local config = {
  callback = function() end
}

---@class MyModule
local M = {}

---@type Config
M.config = config

---@param args Config?
-- you can define your setup function here. Usually configurations can be merged, accepting outside params and
-- you can also put some validation here for those.
M.setup = function(args)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})
  local ok = check_prerequisites()
  if not ok then
    -- Required plugins aren't present. Stop.
    return
  end

  start_watcher(M.config)
end

return M
