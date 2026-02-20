return {
  {
    'allancalix/plan',
    name = 'plan.nvim',
    lazy = false,
    config = function()
      local install_path = vim.fn.stdpath('data') .. '/lazy/plan.nvim'
      vim.opt.rtp:append(install_path .. '/nvim')
      require('plan').setup({})
      dofile(install_path .. '/nvim/plugin/plan.lua')
    end,
  },
}
