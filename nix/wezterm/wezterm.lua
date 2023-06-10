local wezterm = require "wezterm"

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = "Ayu Mirage (Gogh)"
config.front_end = "WebGpu"
config.hide_tab_bar_if_only_one_tab = true

config.font = wezterm.font("Input Mono")

-- Keybinds
config.leader = {
  key = "a",
  mods = "CTRL",
}
config.keys = {
  { key = "-",  mods = "LEADER", action = wezterm.action{SplitVertical={domain="CurrentPaneDomain"}} },
  { key = "\\", mods = "LEADER", action = wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}} },
  { key = "h",  mods = "LEADER", action = wezterm.action{ActivatePaneDirection="Left"} },
  { key = "j",  mods = "LEADER", action = wezterm.action{ActivatePaneDirection="Down"} },
  { key = "k",  mods = "LEADER", action = wezterm.action{ActivatePaneDirection="Up"} },
  { key = "l",  mods = "LEADER", action = wezterm.action{ActivatePaneDirection="Right"} },
  { key = "H",  mods = "LEADER|SHIFT", action = wezterm.action{AdjustPaneSize={"Left", 5}} },
  { key = "J",  mods = "LEADER|SHIFT", action = wezterm.action{AdjustPaneSize={"Down", 5}} },
  { key = "K",  mods = "LEADER|SHIFT", action = wezterm.action{AdjustPaneSize={"Up", 5}} },
  { key = "L",  mods = "LEADER|SHIFT", action = wezterm.action{AdjustPaneSize={"Right", 5}} },
  { key = "c",  mods = "LEADER",       action = wezterm.action{SpawnTab="CurrentPaneDomain"} },
}

-- Domains
config.unix_domains = {
  {
    name = "local.dev",
  },
}
config.default_gui_startup_args = { 'connect', 'local.dev', }

return config