local M = {}

local STYLES = { "flat", "flat-square", "plastic", "for-the-badge", "social" }
local html_ft = {
  html = true,
  vue = true,
  jsx = true,
  tsx = true,
  svelte = true,
  htmldjango = true,
  jinja = true,
  heex = true,
  astro = true,
  php = true,
}

M.config = { style = "flat" }

local function load_badges()
  local plugin_dir = debug.getinfo(1, "S").source:sub(2):match("(.*/lua/)")
  local path = plugin_dir .. "../data/badges.json"
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    vim.notify("badges.nvim: failed to read badges.json", vim.log.levels.ERROR)
    return {}
  end
  local decoded_ok, data = pcall(vim.json.decode, table.concat(lines, "\n"))
  if not decoded_ok then
    vim.notify("badges.nvim: failed to parse badges.json", vim.log.levels.ERROR)
    return {}
  end
  return data
end

local function insert_at_cursor(text)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local new_line = line:sub(1, col) .. text .. line:sub(col + 1)
  vim.api.nvim_set_current_line(new_line)
  vim.api.nvim_win_set_cursor(0, { row, col + #text })
end

local function format_badge(url, label)
  if html_ft[vim.bo.filetype] ~= nil then
    return string.format("<img src='%s' alt='%s'>", url, label)
  end
  return string.format("![%s](%s)", label, url)
end

local function fill_fields(fields, values, badge_label, callback)
  fields = fields or {}
  if #fields == 0 then
    callback(values)
    return
  end
  local field = fields[1]
  local remaining = vim.list_slice(fields, 2)
  vim.ui.input({ prompt = badge_label .. " > " .. field.prompt }, function(input)
    if not input then
      return
    end
    values[field.key] = input
    fill_fields(remaining, values, badge_label, callback)
  end)
end

function M.select_badge()
  local badges = load_badges()
  local names = vim.tbl_keys(badges)
  table.sort(names)
  vim.ui.select(names, { prompt = "Select badge: " }, function(choice)
    if not choice then
      return
    end
    local badge = badges[choice]
    local style_options = vim.list_extend({ "default (" .. M.config.style .. ")" }, STYLES)
    vim.ui.select(style_options, { prompt = "Select style: " }, function(style_choice)
      if not style_choice then
        return
      end
      local style = M.config.style
      if style_choice ~= style_options[1] then
        style = style_choice
      end
      fill_fields(badge.fields, {}, badge.label, function(values)
        values.style = style
        local url = badge.url:gsub("{(%w+)}", values)
        insert_at_cursor(format_badge(url, badge.label))
      end)
    end)
  end)
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  vim.api.nvim_create_user_command("BadgeInsert", function()
    M.select_badge()
  end, {})
end

return M
