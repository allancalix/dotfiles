local map = vim.keymap.set

-- Personal
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Write buffer" })
map("n", "<leader>q", "<cmd>qa!<cr>", { desc = "Quit all" })
map("n", "<leader>fe", "<cmd>Oil<cr>", { desc = "File explorer (Oil)" })
map("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
map("i", "jj", "<esc>")
map("n", "<leader>cw", [[<cmd>%s/[ \t]*$//g<cr>]], { desc = "Strip trailing whitespace" })

-- Movement over wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })

-- Windows
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
map("n", "<leader>-", "<C-w>s", { desc = "Split below" })
map("n", "<leader>|", "<C-w>v", { desc = "Split right" })

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Other buffer" })
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete buffer" })
map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete other buffers" })

-- Tabs
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Prev tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close tab" })

-- Editing
map({ "i", "n" }, "<esc>", "<cmd>nohlsearch<cr><esc>", { desc = "Escape and clear hlsearch" })
map("x", "<", "<gv")
map("x", ">", ">gv")
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move up" })
map("x", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move down" })
map("x", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move up" })
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
map({ "n", "x" }, "<leader>cf", function() require("conform").format() end, { desc = "Format" })

-- Diagnostics and quickfix (]d/[d are Neovim defaults)
local function jump(count, severity)
  return function()
    vim.diagnostic.jump({ count = count, float = true, severity = severity and vim.diagnostic.severity[severity] })
  end
end
map("n", "]e", jump(1, "ERROR"), { desc = "Next error" })
map("n", "[e", jump(-1, "ERROR"), { desc = "Prev error" })
map("n", "]w", jump(1, "WARN"), { desc = "Next warning" })
map("n", "[w", jump(-1, "WARN"), { desc = "Prev warning" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix list" })
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location list" })

-- Pickers
-- stylua: ignore start
map("n", "<leader><space>", function() Snacks.picker.files() end, { desc = "Find files" })
map("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })
map("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })
map("n", "<leader>:", function() Snacks.picker.command_history() end, { desc = "Command history" })
map("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find files" })
map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
map("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find config file" })
map("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Find git files" })
map("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent files" })
map("n", "<leader>fR", function() Snacks.picker.recent({ filter = { cwd = true } }) end, { desc = "Recent files (cwd)" })
map("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep" })
map({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Grep word/selection" })
map("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer lines" })
map("n", "<leader>sB", function() Snacks.picker.grep_buffers() end, { desc = "Grep open buffers" })
map("n", "<leader>sc", function() Snacks.picker.command_history() end, { desc = "Command history" })
map("n", "<leader>sC", function() Snacks.picker.commands() end, { desc = "Commands" })
map("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
map("n", "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer diagnostics" })
map("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help pages" })
map("n", "<leader>sH", function() Snacks.picker.highlights() end, { desc = "Highlights" })
map("n", "<leader>sj", function() Snacks.picker.jumps() end, { desc = "Jumps" })
map("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
map("n", "<leader>sm", function() Snacks.picker.marks() end, { desc = "Marks" })
map("n", "<leader>sM", function() Snacks.picker.man() end, { desc = "Man pages" })
map("n", "<leader>sq", function() Snacks.picker.qflist() end, { desc = "Quickfix list" })
map("n", "<leader>sR", function() Snacks.picker.resume() end, { desc = "Resume picker" })
map("n", "<leader>su", function() Snacks.picker.undo() end, { desc = "Undo history" })
map("n", "<leader>uC", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })

-- Git
map("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git status" })
map("n", "<leader>gd", function() Snacks.picker.git_diff() end, { desc = "Git diff (hunks)" })
map("n", "<leader>gl", function() Snacks.picker.git_log() end, { desc = "Git log" })
map("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git file history" })
map("n", "<leader>gb", function() Snacks.picker.git_log_line() end, { desc = "Git blame line" })
map({ "n", "x" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git browse" })
map("n", "<leader>do", function()
  if vim.fs.root(0, ".jj") then
    vim.cmd("JJ log")
  else
    vim.cmd("DiffviewOpen")
  end
end, { desc = "Open diff view (jj log in jj repos)" })
map("n", "<leader>dq", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" })

-- Zen
map("n", "<leader>uz", function() Snacks.zen() end, { desc = "Zen mode" })
-- stylua: ignore end

-- Toggles
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative number" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.inlay_hints():map("<leader>uh")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle({
  name = "Autoformat (global)",
  get = function() return vim.g.autoformat ~= false end,
  set = function(state) vim.g.autoformat = state end,
}):map("<leader>uf")
Snacks.toggle({
  name = "Autoformat (buffer)",
  get = function() return vim.b.autoformat ~= false end,
  set = function(state) vim.b.autoformat = state end,
}):map("<leader>uF")
