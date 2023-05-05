local p = require("insis.utils.path")
local cfg = require("insis").config

local install_path = p.join(p.getData(), "site", "pack", "packer", "start", "packer.nvim")

local M = {}

M.avaliable = function()
  return vim.fn.empty(vim.fn.glob(install_path)) == 0
end

M.install = function()
  if not M.avaliable() then
    vim.notify("pakcer.nvim installing ...")
    vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      -- "https://gitcode.net/mirrors/wbthomason/packer.nvim",
      install_path,
    })
    -- https://github.com/wbthomason/packer.nvim/issues/750
    local rtp_addition = p.getDataPath() .. "/site/pack/*/start/*"
    if not string.find(vim.o.runtimepath, rtp_addition) then
      vim.o.runtimepath = rtp_addition .. "," .. vim.o.runtimepath
    end
    vim.notify("pakcer.nvim install complete")
  end
end

local function readSnapshotJSON()
  local snapshotPath = p.join(p.getConfig(), "snapshots-" .. require("insis").version .. ".json")
  return vim.fn.json_decode(vim.fn.readfile(snapshotPath))
end

local function getPluginList()
  local status_ok, snapshot = pcall(readSnapshotJSON)
  if not status_ok then
    log("ERROR: read " .. "snapshots-" .. require("insis").version .. ".json failed!")
  end
  package.loaded["insis.plugins"] = nil
  local pluginList = require("insis.plugins")
  if cfg.lock_plugin_commit then
    for _, plugin in ipairs(pluginList) do
      local short_name, _ = require("packer.util").get_plugin_short_name(plugin)
      if snapshot and snapshot[short_name] and snapshot[short_name].commit then
        plugin.commit = snapshot[short_name].commit
      end
    end
  end
  return pluginList
end

M.setup = function()
  local status_ok, packer = pcall(require, "packer")
  if not status_ok then
    vim.notify("require packer.nvim failed")
    return
  end
  local pluginList = getPluginList()
  packer.reset()
  packer.startup({
    function(use)
      for _, plugin in ipairs(pluginList) do
        use(plugin)
      end
    end,
    config = {
      -- snapshots folder
      snapshot_path = p.getConfig(),
      max_jobs = nil,
      clone_timeout = 100,
      -- custom source
      git = {
        -- default_url_format = "https://hub.fastgit.xyz/%s",
        -- default_url_format = "https://mirror.ghproxy.com/https://github.com/%s",
        -- default_url_format = "https://gitcode.net/mirrors/%s",
        -- default_url_format = "https://github.com/%s",
        default_url_format = cfg.mirror.packer .. "%s",
      },
      display = {
        open_fn = function()
          return require("packer.util").float({ border = "rounded" })
        end,
      },
    },
  })
end

M.sync = function()
  local status_ok, packer = pcall(require, "packer")
  if not status_ok then
    vim.notify("require packer.nvim failed")
    return
  end
  -- package.loaded["insis.plugins"] = nil
  -- local pluginList = require("insis.plugins")
  getPluginList()
  packer.reset()
  packer.sync()
end

local function createSnapshots()
  vim.api.nvim_command("PackerSnapshot snapshots-" .. require("insis").version .. ".json")
end

vim.api.nvim_create_user_command("InsisCreateSnapshots", createSnapshots, {})

return M
