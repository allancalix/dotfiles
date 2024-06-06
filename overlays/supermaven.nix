self: super: {
  vimPlugins = super.vimPlugins // {
    supermaven-nvim = super.vimUtils.buildVimPlugin {
      pname = "supermaven-inc";
      version = "main";
      src = super.fetchFromGitHub {
        owner  = "supermaven-inc";
        repo   = "supermaven-nvim";
        rev    = "ef3bd1a6b6f722857f2f88d929dd4ac875655611";
        sha256 = "0bdk7r8nn6j230saxhb73g7pi473c8d2w6kwgp74hrc3jbynhmcs";
      };
    };
  };
}

