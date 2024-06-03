self: super: {
  vimPlugins = super.vimPlugins // {
    supermaven-nvim = super.vimPluginFrom2Nix (
      super.fetchFromGitHub {
        owner  = "supermaven-inc";
        repo   = "supermaven-nvim";
        rev    = "ef3bd1a6b6f722857f2f88d929dd4ac875655611";
      }
    );
  };
}

