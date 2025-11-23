{
  config,
  pkgs,
  lib,
  ...
}: let
  nonVSCodePlugin = plugin: {
    inherit plugin;
    optional = true;
    config = ''if !exists('g:vscode') | packadd ${plugin.pname} | endif'';
  };
  homeRoot =
    if pkgs.stdenv.isDarwin
    then "/Users/"
    else "/home/";
  gc = pkgs.writeScriptBin ",gc" (builtins.readFile ./scripts/gc);
  ssh-init-term = pkgs.writeShellScriptBin ",ssh-init-term" (builtins.readFile ./scripts/ssh-init-term);
  # This just forwards commands to the Tailscale binary, not using the `,` prefix.
  tailscale = pkgs.writeScriptBin "tailscale" (builtins.readFile ./scripts/tailscale);
  username = "allancalix";
  onePassPath =
    if pkgs.stdenv.isDarwin
    then "~/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else "~/.1password/agent.sock";
  onePassSigningBackend =
    if pkgs.stdenv.isDarwin
    then "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
    else "/opt/1Password/op-ssh-sign";
in {
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

  home.packages = [
    # Scripts
    gc
    ssh-init-term
    tailscale

    pkgs._1password-cli
    pkgs.btop
    pkgs.openssl
    pkgs.ouch

    # Extended utils
    pkgs.age
    pkgs.age-plugin-yubikey
    pkgs.age-plugin-se
    pkgs.age-plugin-1p
    pkgs.yubikey-manager

    # Applications
    pkgs.aria2
    pkgs.postgresql_18
    pkgs.redpanda-client
    pkgs.yt-dlp-light
    pkgs.claude-code
    pkgs.ffmpeg
    pkgs.typst

    # Extended coreutils
    pkgs.jq
    pkgs.jo
    pkgs.bandwhich
    pkgs.ripgrep
    pkgs.sd
    pkgs.bat-extras.batman
    pkgs.hexyl
    pkgs.eza
    pkgs.curl
    pkgs.nickel
    pkgs.mosh

    # Development
    pkgs.bun
    pkgs.difftastic
    pkgs.duckdb
    pkgs.fastfetch
    pkgs.gh
    pkgs.sqlite
    pkgs.tldr
    pkgs.tokei
    pkgs.watchexec
    pkgs.helix
    pkgs.uv
  ];

  programs.fish = {
    enable = true;

    plugins = [
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
         source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
       end

       if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.sh
         source /nix/var/nix/profiles/default/etc/profile.d/nix.fish
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
      jj_status = ''
        jj log --revisions @ --no-graph --ignore-working-copy --color always --limit 1 --template '
          separate(" ",
            change_id.shortest(4),
            bookmarks,
            "|",
            concat(
              if(conflict, "💥"),
              if(divergent, "🚧"),
              if(hidden, "👻"),
              if(immutable, "🔒"),
            ),
            raw_escape_sequence("\x1b[1;32m") ++ if(empty, "(empty)"),
            raw_escape_sequence("\x1b[1;32m") ++ if(description.first_line().len() == 0,
              "(no description set)",
              if(description.first_line().substr(0, 29) == description.first_line(),
                description.first_line(),
                description.first_line().substr(0, 29) ++ "…",
              )
            ) ++ raw_escape_sequence("\x1b[0m"),
          )
        '
      '';
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

  xdg.configFile."nvim".source = ./nvim;

  xdg.configFile."ghostty/config" = {
    text = builtins.readFile ./ghostty/config;
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;

    options = {
      plus-style = "syntax #012800";
      minus-style = "syntax #340001";
      syntax-theme = "Monokai Extended";
      navigate = true;
      line-numbers = true;
    };
  };

  programs.git = {
    enable = true;

    ignores = [
      ".DS_Store"
      ".idea"
    ];

    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJGbUaWlb/y+fgePO+ZFd7ToGpGqzMJUuKdGMuLMhuaI";
      signByDefault = true;
    };

    settings = {
      user = {
        name = "Allan Calix";
        email = "contact@acx.dev";
      };
      alias = {
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
      gpg.ssh.program = onePassSigningBackend;
      credential = {
        "https://github.com".helper = "!gh auth git-credential";
        "git@github.com".helper = onePassSigningBackend;
      };
      url = {
        "git@github.com:".insteadOf = "gh:";
        "https://github.com/".insteadOf = "http:";
      };
    };
  };

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
  };

  programs.fd = {
    enable = true;

    ignores = ["prelude"];
  };

  programs.jujutsu = {
    enable = true;

    settings = {
      user = {
        name = "Allan Calix";
        email = "contact@acx.dev";
      };
      ui = {
        default-command = "log";
        diff-formatter = ["difft" "--color=always" "$left" "$right"];
        graph.style = "square";
      };
      revsets = {
        log = "stack(mine() | @) | trunk() | @";
        log-graph-prioritize = "coalesce(megamerge(), trunk())";
      };
      revset-aliases = {
        "user(x)" = "author(x) | committer(x)";
        "megamerge()" = "coalesce(present(megamerge), reachable(stack(), merges()))";

        "stack()" = "ancestors(reachable(@, mutable()), 2)";
        "stack(x)" = "ancestors(reachable(x, mutable()), 2)";
        "stack(x, n)" = "ancestors(reachable(x, mutable()), n)";

        # Revsets that should refuse to push.
        "wip()" = "description(glob:'wip:*')";
        "private()" = "description(glob:'private:*')";
        "blacklist()" = "wip() | private()";

        "open()" = "stack(trunk().. & mine(), 1)";
        "ready()" = "open() ~ blacklist()::";
      };
      aliases = {
        d = ["diff"];
        s = ["show"];
        n = ["new"];
        nt = ["new" "trunk()"];

        fold = ["squash" "--into" "@" "--from"];
        retrunk = ["rebase" "-d" "trunk()"];
        open = ["log" "-r" "open()"];

        sandwich = [ "rebase" "-B" "megamerge()" "-A" "trunk()" "-r"];
      };
      templates = {
        git_push_bookmark = "\"allancalix/push-\" ++ change_id.short()";
      };
      snapshot = {
        auto-update-stale = true;
      };
      git = {
        private-commits = "blacklist()";
        colocate = true;
        subprocess = true;
      };
      signing = {
        backend = "ssh";
        behavior = "own";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJGbUaWlb/y+fgePO+ZFd7ToGpGqzMJUuKdGMuLMhuaI";
        backends.ssh.program = onePassSigningBackend;
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
    enableDefaultConfig = false;

    matchBlocks."*" = {
      identitiesOnly = true;
      identityAgent = onePassPath;
    };

    extraConfig = lib.optionalString pkgs.stdenv.isDarwin ''
      Include ~/.orbstack/ssh/config
    '';
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      scan_timeout = 10;
      add_newline = false;
      line_break.disabled = true;
      cmd_duration.disabled = true;

      nix_shell.disabled = true;
      git_branch.disabled = true;
      custom.git_branch = {
        when = true;
        command = "jj root >/dev/null 2>&1 || starship module git_branch";
        description = "Only show git_branch if we're not in a jj repo.";
      };

      custom.jj = {
        command = "jj_status";
        when = "jj root";
        symbol = "";
      };

      git_status = {
        format = "[[(•$untracked$modified$staged)](218)]($style)";
        style = "cyan";
        untracked = " ";
        modified = " ";
        staged = " ";
        stashed = "≡";
      };

      format = lib.concatStringsSep "" [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$custom"
        "$nix_shell"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](green)";
      };

      directory.style = "blue";
    };
  };

  programs.emacs = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;

    enableFishIntegration = true;
  };

    services.syncthing = {
    enable = false;

    settings = {
      gui = {
        address = "127.0.0.1:8384";
        insecureAdminAccess = true;
      };

      options = {
        urAccepted = -1;
        natEnabled = false;
        globalAnnounceEnabled = false;
        localAnnounceEnabled = false;
        relaysEnabled = false;
      };
    };
  };
}
