{ config, pkgs, lib, ... }:

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
    pkgs.git-absorb
    pkgs.jq

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

      l = "exa";
      ls = "exa";
      ll = "exa -l";
      lal = "exa -al";

      s = "git status -sb";

      t = "tmux";
      tat = "tmux attach -t";
      tks = "tmux kill-session -t";
      tsw = "tmux switch -t";
    };

    functions = {
      docker_clean = "docker rm (docker ps -aq) && docker rmi (docker images -aq)";
      gc = "git commit -Sv -a $argv";
      git_current_branch = ''
        set path (git rev-parse --git-dir 2>/dev/null)
        cat "$path/HEAD" | sed -e 's/^.*refs\/heads\///'
      '';
      pubip = "curl 'https://api.ipify.org/?format=json' 2> /dev/null | jq -r '.ip'";
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
      tabular
      tcomment_vim
      vim-cue
      vim-go
      vim-nix
      vim-surround
    ];

    extraConfig = (import ./vim.nix) {};
  };

  programs.gh = {
    enable = true;

    settings = {
      git_protocol = "ssh";
    };
  };

  programs.git = {
    enable = true;
    userName = "Allan Calix";

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
