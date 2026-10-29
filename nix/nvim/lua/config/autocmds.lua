local function augroup(name) return vim.api.nvim_create_augroup("user_" .. name, { clear = true }) end
local autocmd = vim.api.nvim_create_autocmd

-- Only autocomplete in real file buffers. Pickers, vim.ui.input prompts, and other
-- special buffers (buftype=prompt/nofile/...) otherwise pop up buffer-word suggestions.
autocmd({ "BufEnter", "InsertEnter" }, {
  group = augroup("autocomplete"),
  callback = function(ev)
    if vim.bo[ev.buf].buftype ~= "" then
      vim.bo[ev.buf].autocomplete = false
    end
  end,
})

-- Reload files changed outside Neovim.
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function() vim.hl.on_yank() end,
})

autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. tab)
  end,
})

-- Reopen files at the last cursor position.
autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(ev)
    local exclude = { "gitcommit", "jjdescription" }
    if vim.tbl_contains(exclude, vim.bo[ev.buf].filetype) or vim.b[ev.buf].last_loc then
      return
    end
    vim.b[ev.buf].last_loc = true
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close utility windows with q.
autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = { "checkhealth", "gitsigns-blame", "help", "man", "nvim-pack", "qf", "startuptime" },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true, desc = "Quit buffer" })
  end,
})

autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "jjdescription" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

autocmd("FileType", {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function() vim.opt_local.conceallevel = 0 end,
})

-- Create missing parent directories on save.
autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(ev)
    if ev.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(ev.match) or ev.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
