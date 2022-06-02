{ config, pkgs, lib, ... }:
let
  nonVSCodePlugin = plugin: {
    inherit plugin;
    optional = true;
    config = ''if !exists('g:vscode') | packadd ${plugin.pname} | endif'';
  };
in
{
  xdg.enable = true;

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

  home.username = "allancalix";
  home.homeDirectory = "/Users/allancalix";
  home.stateVersion = "21.11";
  home.sessionVariables = {
    EDITOR = "nvim";
    GIT_EDITOR = "nvim";
    PAGER = "less -RFX";
    MANPAGER = "less -RFX";
  };

  home.packages = [
    pkgs.input-fonts

    pkgs.virtualenv
    pkgs.shadowenv
    pkgs.git-absorb
    pkgs.jq
    pkgs.gh
    pkgs.fnm

    pkgs.consul
    pkgs.nomad
    pkgs.vault
    pkgs.google-cloud-sdk
    pkgs.backblaze-b2

    pkgs.ripgrep
    pkgs.fd
    pkgs.exa
    pkgs.bat
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
    ];

    loginShellInit = ''
      	          if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      	            fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      	          end

      	          if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      	            fenv source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      	          end

                  fish_vi_key_bindings

                  if which shadowenv
                    shadowenv init fish | source
                  end

                  if which fnm
                    fnm env --use-on-cd --shell fish | source
                  end

                  bind -M insert \cj _fzf_jump_session
                  bind -M normal \cj _fzf_jump_session
      	          '';

    interactiveShellInit = ''
      set -g fish_prompt_pwd_dir_length 3

      function fish_prompt
          set_color brblack
          echo -n "["(date "+%H:%M")"] "
          set_color blue
          echo -n (hostname)
          if [ $PWD != $HOME ]
              set_color brblack
              echo -n ':'
              set_color yellow
              echo -n (basename $PWD)
          end
          set_color green
          printf '%s ' (__fish_git_prompt)
          set_color normal
          if set -q IN_NIX_SHELL
            echo -n '👾'
          end
          if set -q SPIN && [ $SPIN = 1 ]
            echo -n '☁️'
          end
          set_color red
          echo -n '| '
          set_color normal
      end

      # Disable greeting prompt
      function fish_greeting
      end
    '';

    shellAliases = {
      cd = "z";

      gd = "git diff -M";
      gdc = "git diff --cached -M";
      ga = "git add -A";
      gap = "git add -p";
      gau = "git add -u";
      gbr = "git branch -v";
      gl = "git lg";
      gst = "git stash";
      gstp = "git stash pop";
      gup = "git pull";
      gf = "git fetch --prune";
      gc = "git commit -v -S";
      gp = "git push";
      gpthis = "git push origin (git_current_branch):(git_current_branch)";

      b = "bazelisk";
      br = "bazelisk run";
      bb = "bazelisk build";
      bt = "bazelisk test";
      bazel = "bazelisk";

      l = "exa";
      ls = "exa";
      ll = "exa -l";
      lal = "exa -al";

      s = "git status -sb";

      t = "tmux";
      tat = "tmux attach -t";
      tks = "tmux kill-session -t";
      tsw = "tmux switch -t";

      nixsh = "nix-shell --run fish";
    };

    functions = {
      docker_clean = "docker rm (docker ps -aq) && docker rmi (docker images -aq)";
      gc = "git commit -Sv -a $argv";
      git_current_branch = ''
        set path (git rev-parse --git-dir 2>/dev/null)
        cat "$path/HEAD" | sed -e 's/^.*refs\/heads\///'
      '';
      pubip = "curl 'https://api.ipify.org/?format=json' 2> /dev/null | jq -r '.ip'";
      set_session = ''
        set session_name $argv

        if set -q TMUX
          tmux switch-client -t "$session_name"
        else
          tmux attach -t "$session_name"
        end
      '';
      _fzf_search_tmux_sessions = ''
        tmux list-sessions -F "#{?session_attached,,#{session_name}}" | \
          sed '/^$/d' | \
          fzf --reverse --header jump-to-session --preview "tmux capture-pane -pt {} | \
          xargs echo"
      '';
      _fzf_jump_session = ''
        set session_name (_fzf_search_tmux_sessions)

        set_session $session_name
      '';
    };
  };

  programs.fzf = {
    enable = true;

    defaultCommand = "fd --type f";
    defaultOptions = [
      "--color fg:#cbccc6,bg:#1f2430,hl:#707a8c"
      "--color fg+:#707a8c,bg+:#191e2a,hl+:#ffcc66"
      "--color info:#73d0ff,prompt:#707a8c,pointer:#cbccc6"
      "--color marker:#73d0ff,spinner:#73d0ff,header:#d4bfff"
      "--reverse"
      "--border"
      "--height 25%"
    ];
    enableFishIntegration = true;
  };

  programs.gpg.enable = true;

  programs.kitty = {
    enable = true;

    # This feature was recently added but doesn't seem to be supported
    # in the installed home-manager version. Uncomment this when the
    # merge is included in the system's home-manager build.
    # https://github.com/nix-community/home-manager/pull/2710
    # theme = "Ayu Mirage";
    font = {
      name = "Input Mono";
      size = 12;
    };
    keybindings = {
      "super+equal" = "increase_font_size";
      "super+minus" = "decrease_font_size";
      "super+0" = "restore_font_size";
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-surround
      tabular
      tcomment_vim
    ] ++ map nonVSCodePlugin [
      # Neovim Plugins
      coq_nvim
      nvim-treesitter
      nvim-lspconfig
      lualine-nvim
      telescope-nvim
      plenary-nvim
      popup-nvim
      editorconfig-nvim

      # Vim Plugins
      ayu-vim
      vim-cue
      vim-go
      vim-nix
    ];

    extraConfig = (import ./vim.nix) {};
  };

  programs.git = {
    enable = true;
    userName = "Allan Calix";
    userEmail = "contact@acx.dev";

    aliases = {
      co = "checkout";
      subup = "submodule update --recursive --remote";
      lg = "log --pretty='%Cred%h%Creset | %C(yellow)%d%Creset %s %Cgreen(%cr)%Creset %C(cyan)[%an]%Creset' --graph";
      so = "show --pretty='parent %Cred%p%Creset commit\n  %Cred%h%Creset%C(yellow)%d%Creset%n%n%w(72,2,2)%s%n%n%w(72,0,0)%C(cyan)%an%Creset\n  %Cgreen%ar%Creset'";
      st = "status --short --branch";
      cma = "commit --all -m";
      dp = "diff --word-diff --unified=10";
      append = "!git cherry-pick $(git merge-base HEAD\n  $1)..$1";
    };

    signing = {
      key = "B2F67574B94C1E89";
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
      credential = {
        "https://github.com".helper = "!gh auth git-credential";
      };
    };
  };

  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    shell = "${pkgs.fish}/bin/fish";

    extraConfig = builtins.readFile ./tmux.conf;
  };

  programs.zoxide = {
    enable = true;

    enableFishIntegration = true;
  };
}
