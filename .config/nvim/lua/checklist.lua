local M = {}

local default_states = {
  ' ', -- TODO
  'x', -- DONE
}

M.toggle_item = function()
  local line = vim.api.nvim_get_current_line()

  for i, state in ipairs(default_states) do
    if line:match('%['.. state ..'%]') then
      next = default_states[i + 1] or default_states[1]
      local new = line:gsub('%['.. state ..'%]', '['.. next ..']', 1)
      return vim.api.nvim_set_current_line(new)
    end
  end
end

return M
