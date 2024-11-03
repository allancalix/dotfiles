{ config, pkgs, lib, ... }:
let
  nonVSCodePlugin = plugin: {
    inherit plugin;
    optional = true;
    config = ''if !exists('g:vscode') | packadd ${plugin.pname} | endif'';
  };
  homeRoot = if pkgs.stdenv.isDarwin then "/Users/" else "/home";
  gc = pkgs.writeScriptBin ",gc" (builtins.readFile ./scripts/gc);
  ssh-init-term = (pkgs.writeShellScriptBin ",ssh-init-term" (builtins.readFile ./scripts/ssh-init-term));
  # This just forwards commands to the Tailscale binary, not using the `,` prefix.
  tailscale = pkgs.writeScriptBin "tailscale" (builtins.readFile ./scripts/tailscale);
  username = "allancalix";
  onePassPath = "~/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock";

  zedThemeDracula = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "zed";
    rev = "c2163e9f812eea4df6091cfc1919c72fbcbc098b";
    sha256 = "0m6r70mfm35wd4f31q2v0dcaszgdq8q8sfx3wi6a8rdkxvgm0ycs";
  };
in
{
  xdg.enable = true;

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

  home.username = username;
  home.homeDirectory = homeRoot + username;
  home.stateVersion = "24.05";
  home.sessionVariables = {
    EDITOR = "nvim";
    GIT_EDITOR = "nvim -u ${config.xdg.configHome}/nvim/minimal.vim";
    PAGER = "less -RFX";
    DOCUMENT_ROOT = homeRoot + username + "/Dropbox";
    # This environment variable is used for `jujutsu` that doesn't support configuration found in `~/.ssh/config`.
    # Annoyingly, because MacOS has a stupid space in the file name I can't just use the the fully qualified path
    # in both places because the escaping is important for being parseable inside the ssh config file.
    SSH_AUTH_SOCK = homeRoot + username + "/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
  };

  home.file.".config/zed/themes" = {
    source = pkgs.runCommandNoCC "dracula.json" {} ''
      mkdir -p $out
      cp ${zedThemeDracula}/themes/dracula.json $out/
    '';
  };

  home.packages = [
    # Scripts
    gc
    ssh-init-term
    tailscale

    pkgs._1password
    pkgs.htop
    pkgs.openssl
    pkgs.ouch

    # Applications
    pkgs.rage
    pkgs.caddy
    pkgs.aria
    pkgs.postgresql_17
    pkgs.redpanda-client
    pkgs.yt-dlp-light

    # Extended coreutils
    pkgs.jq
    pkgs.jo
    pkgs.bandwhich
    pkgs.ripgrep
    pkgs.sd
    pkgs.fd
    pkgs.bat-extras.batman
    pkgs.hexyl
    pkgs.eza
    pkgs.curl
    pkgs.nickel

    # Development
    pkgs.starship
    pkgs.difftastic
    pkgs.duckdb
    pkgs.fastfetch
    pkgs.gh
    pkgs.sqlite
    pkgs.tldr
    pkgs.tokei
    pkgs.watchexec
    pkgs.helix
  ];

  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "foreign-env";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
          sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
        };
      }
      {
        name = "fifc";
        src = pkgs.fetchFromGitHub {
          owner = "gazorby";
          repo = "fifc";
          rev = "2ee5beec7dfd28101026357633616a211fe240ae";
          sha256 = "Nrart7WAh2VQhsDDe0EFI59TqvBO56US2MraqencxgE=";
        };
      }
    ];

    loginShellInit = ''
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      end

      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      end

     if test -e /opt/homebrew/bin/brew
        /opt/homebrew/bin/brew shellenv | source
      end

      fish_vi_key_bindings
    '';

    interactiveShellInit = ''
      # Disable greeting prompt
      function fish_greeting
      end

      set -gx PATH ~/.local/bin $PATH

      if type -q starship
        source (starship init fish --print-full-init | psub)
      end

      if type -q direnv
        direnv hook fish | source
      end

      if type -q jj
        jj util completion fish | source
      end
    '';

    shellAliases = {
      c = "bat";
      ga = "git add -A";
      gap = "git add -p";
      gau = "git add -u";
      gbr = "git branch -v";
      gc = "git commit -v -S";
      gd = "git diff -M";
      gdc = "git diff --cached -M";
      gf = "git fetch --prune";
      gl = "git lg";
      gp = "git push";
      gpthis = "git push origin (git_current_branch):(git_current_branch)";
      gst = "git stash";
      gstp = "git stash pop";
      gup = "git pull";
      jc = "jj commit";
      jd = "jj diff";
      jl = "jj log";
      jp = "jj git push";
      l = "eza --group-directories-first";
      lal = "eza -al --group-directories-first";
      ll = "eza -l --group-directories-first";
      ls = "eza --group-directories-first";
      man = "batman";
      s = "jj status";
      tree = "eza --tree";
    };

    functions = {
      gc = "git commit -Sv -a $argv";
      git_current_branch = ''
        set path (git rev-parse --git-dir 2>/dev/null)
        cat "$path/HEAD" | sed -e 's/^.*refs\/heads\///'
      '';
      # Set repo-specific config rules to advance main branches on commit. Set this for repos where
      # pushing to main is the commit policy (like single contributor repos). Both values have to be
      # set otherwise these options may behave unpredictably when interacting with the global options.
      ",jj_track_main" = ''
        jj config set --repo experimental-advance-branches.enabled-branches '["main"]'
        jj config set --repo experimental-advance-branches.disabled-branches '["wip/*"]'
      '';
      pubip = "curl 'https://api.ipify.org/?format=json' 2> /dev/null | jq -r '.ip'";
    };
  };

  programs.fzf = {
    enable = true;

    defaultCommand = "fd --type f";
    defaultOptions = [
      # https://github.com/dracula/fzf/blob/master/INSTALL.md
      "--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9"
      "--color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9"
      "--color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6"
      "--color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"
      "--reverse"
      "--border"
      "--height 40%"
    ];
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;

    nix-direnv = {
      enable = true;
    };
  };

  xdg.configFile."helix/config.toml" = {
    text = builtins.readFile ./helix/config.toml;
  };

  xdg.configFile."nvim/minimal.vim" = {
    text = builtins.readFile ./nvim/minimal.vim;
  };

  xdg.configFile."ghostty/config" = {
    text = builtins.readFile ./ghostty/config;
  };

  # The starship configuration uses lots of backslashes in it's configuration for templating.
  # This interaction with nix's toml serializer is too annoying to deal with so I'm just doing
  # this manually.
  xdg.configFile."starship.toml" = {
    text = builtins.readFile ./starship/starship.toml;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-surround
      tabular
      vim-commentary
      hop-nvim
    ] ++ map nonVSCodePlugin [
      dracula-nvim

      # Neovim Plugins
      nvim-bqf
      trouble-nvim
      oil-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      nvim-treesitter
      conform-nvim
      nvim-lspconfig
      supermaven-nvim
      lualine-nvim
      telescope-nvim
      telescope-zf-native-nvim
      plenary-nvim
    ];

    extraConfig = ''
      ${builtins.readFile ./nvim/vimrc.vim}

      lua <<EOF
      ${builtins.readFile ./nvim/init.lua}
      EOF
    '';
  };

  programs.git = {
    enable = true;
    userName = "Allan Calix";
    userEmail = "contact@acx.dev";

    aliases = {
      co = "checkout";
      cm = "commit --all -m --no-gpg-sign";
      subup = "submodule update --recursive --remote";
      lg = "log --pretty='%Cred%h%Creset | %C(yellow)%d%Creset %s %Cgreen(%cr)%Creset %C(cyan)[%an]%Creset' --graph";
      so = "show --pretty='parent %Cred%p%Creset commit\n  %Cred%h%Creset%C(yellow)%d%Creset%n%n%w(72,2,2)%s%n%n%w(72,0,0)%C(cyan)%an%Creset\n  %Cgreen%ar%Creset'";
      st = "status --short --branch";
      cma = "commit --all -m";
      dp = "diff --word-diff --unified=10";
      append = "!git cherry-pick $(git merge-base HEAD\n  $1)..$1";
    };

    ignores = [
      ".DS_Store"
      ".idea"
    ];

    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJGbUaWlb/y+fgePO+ZFd7ToGpGqzMJUuKdGMuLMhuaI";
      signByDefault = true;
    };

    delta = {
      enable = true;

      options = {
        plus-style = "syntax #012800";
        minus-style = "syntax #340001";
        syntax-theme = "Monokai Extended";
        navigate = true;
        line-numbers = true;
      };
    };

    extraConfig = {
      diff.algorithm = "histogram";
      commit.verbose = true;
      init.defaultBranch = "main";
      merge.conflictstyle = "zdiff3";
      push = {
        default = "current";
        autoSetupRemote = true;
      };
      gpg = {
        format = "ssh";
      };
      gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      credential = {
        "https://github.com".helper = "!gh auth git-credential";
      };
      url = {
        "git@github.com:".insteadOf = "gh:";
        "https://github.com/".insteadOf = "http:";
      };
    };
  };

  programs.jujutsu = {
    enable = true;

    settings = {
      user = {
        name = "Allan Calix";
        email = "contact@acx.dev";
      };
      ui = {
        default-command = "status";
        diff.tool = ["difft" "--color=always" "$left" "$right"];
      };
      git = {
        push-bookmark-prefix = "allancalix/push-";
      };
      signing = {
        backend = "ssh";
        sign-all = true;
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJGbUaWlb/y+fgePO+ZFd7ToGpGqzMJUuKdGMuLMhuaI";
        backends.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
      experimental-advance-branches = {
        enabled-branches = ["glob:allancalix/pr-*"];
        disabled-branches = ["main"];
      };
    };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
    };
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        IdentitiesOnly=yes
        IdentityAgent ${onePassPath}

      Include ~/.orbstack/ssh/config
    '';
  };

  programs.zoxide = {
    enable = true;

    enableFishIntegration = true;
  };

  services.syncthing = {
    enable = true;
  };
}
