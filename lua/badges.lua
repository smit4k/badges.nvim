-- main module file
local module = require("badges.module")

---@class Config
---@field style string default badge style
local config = {
  style = "flat", -- options are flat, flat-square, plastic, for-the-badge, and social
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
end

M.hello = function()
  return module.my_first_function(M.config.opt)
end

return M
