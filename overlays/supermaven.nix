self: super: {
  vimPlugins = super.vimPlugins // {
    supermaven-nvim = super.vimUtils.buildVimPlugin {
      pname = "supermaven-inc";
      version = "main";
      src = super.fetchFromGitHub {
        owner  = "supermaven-inc";
        repo   = "supermaven-nvim";
        rev    = "c7ab94a6bcde96c79ff51afd6a1494606bb6f10b";
        sha256 = "1a4arykaq4678h6j236drlpyyq8f9jbpqq3v4gws64nyw52mdr2d";
      };
    };
  };
}

