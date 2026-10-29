-- Actions for the acx monorepo. The "acx" session at the repository root acts
-- as the control node, and each jj workspace gets its own "acx/<name>" session
-- that starts with an agent and a shell.

local HOME = os.getenv("HOME")
local ROOT = HOME .. "/acx/src/github.com/acx-dev/acx"
local WORKSPACES = HOME .. "/acx/src/github.com/acx-dev/acx_workspaces"
local ROOT_SESSION = "acx"
local PREFIX = "acx/"
local SHELL = "com.superlogical.terminal.shell"
local AGENT = "buck2 run //tools/agents/claude -- --dangerously-skip-permissions"

local function check(result, err)
  if result == nil then error(err, 0) end
  return result
end

-- The Rex server only has the minimal PATH macOS gives apps, so commands run
-- through the login shell (fish) to see the same environment as a terminal.
local function jj(args)
  local argv = { os.getenv("SHELL"), "-l", "-c", "exec $argv", "jj", "--no-pager" }
  for _, a in ipairs(args) do argv[#argv + 1] = a end
  local r = check(rex.exec(argv, { cwd = ROOT, timeout = 25 }))
  if not r.ok then error(r.stderr, 0) end
  return r.stdout
end

-- Returns a table mapping each workspace name to its root directory.
local function workspaces()
  local out = jj({ "workspace", "list", "-T", 'name ++ "\\t" ++ self.root() ++ "\\n"' })
  local ws = {}
  for name, dir in out:gmatch("([^\t\n]+)\t([^\n]+)") do ws[name] = dir end
  return ws
end

-- Returns a table mapping each session label to its ID.
local function sessions()
  local r = check(rex.call("session.list", {}))
  local ids = {}
  for _, s in ipairs(r.sessions or {}) do ids[s.label] = s.session_id end
  return ids
end

-- Asks the app that ran the action to show the session. Returns false when
-- there is no app to ask, such as from a CLI without Remote Control.
local function show(session_id)
  return (pcall(rex.client.queue, "session.select", { session_id = session_id }))
end

local function terminal(label, options)
  return { block = { flavor = SHELL, label = label, options = options } }
end

-- The agent is typed into an interactive shell rather than run as the pane's
-- command, so direnv loads the monorepo environment first and the pane falls
-- back to a shell when the agent exits.
local function agent_window(dir)
  return {
    window_label = "agent",
    layout = { split = {
      direction = "horizontal",
      ratio = 0.6,
      before = terminal("agent", { cwd = dir, initial_input = AGENT .. "\n" }),
      after = terminal("shell", { cwd = dir }),
    } },
  }
end

local function open_workspace(name, dir, focus)
  local label = PREFIX .. name
  local id, created = sessions()[label], false
  if id == nil then
    id = check(rex.call("session.create", { label = label, initial_windows = { agent_window(dir) } })).session_id
    created = true
  end
  return { session_id = id, label = label, created = created, shown = focus and show(id) }
end

local function block_dir(block_id)
  local r = check(rex.block.call("com.superlogical.terminal", "pwd", { block_id = block_id }))
  local path = (r.pwd or ""):gsub("^file://[^/]*", "")
  return (path:gsub("%%(%x%x)", function(h) return string.char(tonumber(h, 16)) end))
end

rex.action{
  name = "acx_ws",
  title = "acx: Open Workspace",
  description = "Switch to a jj workspace's session, creating the session if needed. Create workspaces with ws in a terminal.",
  category = "acx",
  args = { name = "string" },
  run = function(ctx, args)
    local dir = workspaces()[args.name]
    if dir == nil or args.name == "default" then
      error("no workspace named " .. args.name .. "; create it with: ws " .. args.name, 0)
    end
    return open_workspace(args.name, dir, true)
  end,
}

rex.action{
  name = "acx_ws_restore",
  title = "acx: Reopen Workspace Sessions",
  description = "Create a session for every jj workspace that doesn't have one.",
  category = "acx",
  run = function(ctx, args)
    local opened = {}
    for name, dir in pairs(workspaces()) do
      if name ~= "default" and open_workspace(name, dir, false).created then
        opened[#opened + 1] = PREFIX .. name
      end
    end
    table.sort(opened)
    return { opened = opened }
  end,
}

rex.action{
  name = "acx_ws_shell",
  title = "acx: New Workspace Shell",
  description = "Open a shell tab in the focused pane's directory.",
  category = "acx",
  run = function(ctx, args)
    local r = check(rex.session.new_window{
      window_label = "shell",
      layout = terminal("shell", { cwd = block_dir(ctx.block_id) }),
    })
    return { window_id = r.window_id }
  end,
}

rex.action{
  name = "acx_ws_close",
  title = "acx: Close This Workspace",
  description = "Forget the focused pane's jj workspace and destroy its session. Its directory is kept.",
  category = "acx",
  run = function(ctx, args)
    local dir = block_dir(ctx.block_id)
    local name = dir:match("^" .. WORKSPACES:gsub("%p", "%%%0") .. "/([^/]+)")
    if name == nil then error("not in an acx workspace: " .. dir, 0) end
    -- An action can only destroy the session it runs in, so check before
    -- forgetting the workspace rather than leave its session behind.
    local id = sessions()[PREFIX .. name]
    if id ~= nil and id ~= ctx.session_id then
      error("run this from the " .. PREFIX .. name .. " session", 0)
    end
    jj({ "workspace", "forget", name })
    if id then check(rex.call("session.destroy", { session_id = id })) end
    return { forgot = name, kept = WORKSPACES .. "/" .. name }
  end,
}

rex.action{
  name = "acx_root",
  title = "acx: Go to Root",
  category = "acx",
  run = function(ctx, args)
    local id = sessions()[ROOT_SESSION]
    if id == nil then
      id = check(rex.call("session.create", {
        label = ROOT_SESSION,
        initial_windows = { { window_label = "root", layout = terminal("root", { cwd = ROOT }) } },
      })).session_id
    end
    return { session_id = id, shown = show(id) }
  end,
}
