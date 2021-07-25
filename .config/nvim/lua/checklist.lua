local M = {}

M.toggle_item = function()
  local line = vim.api.nvim_get_current_line()

  -- [ ] TODO state.
  if line:match('%[%s+%]') then
    local new = line:gsub('%[%s+%]', '[x]', 1)
    return vim.api.nvim_set_current_line(new)
  end

  -- [x] DONE state.
  if line:match('%[x%]') then
    local new = line:gsub('%[x%]', '[ ]', 1)
    return vim.api.nvim_set_current_line(new)
  end
end

return M
