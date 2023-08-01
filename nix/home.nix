{ config, pkgs, lib, ... }:
let
  nonVSCodePlugin = plugin: {
    inherit plugin;
    optional = true;
    config = ''if !exists('g:vscode') | packadd ${plugin.pname} | endif'';
  };
  homeRoot = if pkgs.stdenv.isDarwin then "/Users/" else "/home";
  kittyPager = pkgs.writeScriptBin "pager.sh" (builtins.readFile ./kitty/pager.sh);
  # https://github.com/sharkdp/bat/issues/1145
  manpager = (pkgs.writeShellScriptBin "manpager" (if pkgs.stdenv.isDarwin then ''
    sh -c 'col -bx | bat -l man -p'
    '' else ''
    cat "$1" | col -bx | bat --language man --style plain
  ''));
in
{
  xdg.enable = true;

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

  home.username = "allancalix";
  home.homeDirectory = homeRoot + "allancalix";
  home.stateVersion = "22.05";
  home.sessionVariables = {
    EDITOR = "nvim";
    GIT_EDITOR = "hx";
    PAGER = "less -RFX";
    MANPAGER = "${manpager}/bin/manpager";
  };

  home.packages = [
    kittyPager
    pkgs.input-fonts
    pkgs.nerdfonts
    pkgs._1password
    pkgs.cachix

    pkgs.virtualenv
    pkgs.htop
    pkgs.helix
    pkgs.wezterm
    pkgs.just
    pkgs.openssl
    pkgs.sqlite
    pkgs.bash
    pkgs.zig
    pkgs.racket

    pkgs.topiary
    pkgs.rage
    pkgs.postgresql_15
    pkgs.nodejs_20

    pkgs.vault
    pkgs.google-cloud-sdk
    pkgs.backblaze-b2

    pkgs.gh
    pkgs.git-absorb

    # Extended coreutils
    pkgs.jq
    pkgs.bandwhich
    pkgs.starship
    pkgs.ouch
    pkgs.ripgrep
    pkgs.fd
    pkgs.bat
    pkgs.hexyl
    pkgs.exa
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
          rev = "8bd370c4a5db3b71f52a3079b758f0f2ed082044";
          sha256 = "whF9BYxudKiqOtSdHGOcIitI+ZNRk0xeZbqMcXmivaY=";
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

     if type -q starship
       source (starship init fish --print-full-init | psub)
     end

     if type -q direnv
       direnv hook fish | source
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

      l = "exa --group-directories-first";
      ls = "exa --group-directories-first";
      ll = "exa -l --group-directories-first";
      lal = "exa -al --group-directories-first";
      tree = "exa --tree";

      s = "git status -sb";

      nxd = "nix develop --command fish";
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

  programs.direnv = {
    enable = true;

    nix-direnv = {
      enable = true;
    };
  };

  xdg.configFile."helix/config.toml" = {
    text = builtins.readFile ./helix/config.toml;
  };

  xdg.configFile."kitty/tab_bar.py" = {
    text = builtins.readFile ./kitty/tab_bar.py;
  };

  xdg.configFile."nvim/minimal.vim" = {
    text = builtins.readFile ./nvim/minimal.vim;
  };

  xdg.configFile."wezterm/wezterm.lua" = {
    text = builtins.readFile ./wezterm/wezterm.lua;
  };

  # The starship configuration uses lots of backslashes in it's configuration for templating.
  # This interaction with nix's toml serializer is too annoying to deal with so I'm just doing
  # this manually.
  xdg.configFile."starship.toml" = {
    text = builtins.readFile ./starship/starship.toml;
  };

  programs.kitty = {
    enable = true;

    theme = "Ayu Mirage";
    font = {
      name = "Input Mono";
      size = 12;
    };
    keybindings = {
      "super+equal" = "increase_font_size";
      "super+minus" = "decrease_font_size";
      "super+0" = "restore_font_size";
      "ctrl+a>\\" = "combine : new_window_with_cwd : next_layout";
      "ctrl+a>-" = "new_window_with_cwd";
      "ctrl+a>c" = "new_tab_with_cwd";
      "ctrl+a>p" = "previous_tab";
      "ctrl+a>n" = "next_tab";
      "ctrl+a>," = "set_tab_title";
      "ctrl+a>k" = "neighboring_window top";
      "ctrl+a>j" = "neighboring_window bottom";
      "ctrl+a>l" = "neighboring_window right";
      "ctrl+a>h" = "neighboring_window left";
      "ctrl+a>[" = "show_scrollback";
    };

    darwinLaunchOptions = [
      "--single-instance"
    ];

    settings = {
      allow_remote_control = true;
      tab_bar_style = "custom";
      tab_separator = ''""'';
      tab_title_template = "{index}:{f'{title[:6]}…{title[-6:]}' if title.rindex(title[-1]) + 1 > 25 else title}";
      active_tab_title_template = "{index}:{f'{title[:6]}…{title[-6:]}' if title.rindex(title[-1]) + 1 > 25 else title}";
      tab_fade = "0 0 0 0";
      tab_bar_align = "left";
      tab_bar_min_tabs = 1;
      tab_bar_margin_width = "0.0";
      tab_bar_margin_height = "10.0 0.0";
      active_tab_font_style = "bold-italic";
      inactive_tab_font_style = "normal";
      bell_on_tab = false;
      scrollback_pager = ''nvim -u ~/.config/nvim/minimal.vim -c "silent write! /tmp/kitty_scrollback_buffer | te cat /tmp/kitty_scrollback_buffer - "'';
      macos_option_as_alt = true;
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-nickel
      vim-surround
      tabular
      vim-commentary
      hop-nvim
      impatient-nvim
    ] ++ map nonVSCodePlugin [
      # Neovim Plugins
      nvim-bqf
      neovim-ayu
      trouble-nvim
      nvim-web-devicons
      coq_nvim
      coq-thirdparty
      (nvim-treesitter.withPlugins (
        plugins: with plugins; [
          tree-sitter-elixir
          tree-sitter-lua
          tree-sitter-nickel
          tree-sitter-rust
          tree-sitter-ocaml
          tree-sitter-vim
          tree-sitter-nix
          tree-sitter-python
          tree-sitter-julia
        ]
      ))
      nvim-lspconfig
      lualine-nvim
      telescope-nvim
      plenary-nvim
      popup-nvim
      editorconfig-nvim

      # Vim Plugins
      vim-nix
      copilot-vim
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
      subup = "submodule update --recursive --remote";
      lg = "log --pretty='%Cred%h%Creset | %C(yellow)%d%Creset %s %Cgreen(%cr)%Creset %C(cyan)[%an]%Creset' --graph";
      so = "show --pretty='parent %Cred%p%Creset commit\n  %Cred%h%Creset%C(yellow)%d%Creset%n%n%w(72,2,2)%s%n%n%w(72,0,0)%C(cyan)%an%Creset\n  %Cgreen%ar%Creset'";
      st = "status --short --branch";
      cma = "commit --all -m";
      dp = "diff --word-diff --unified=10";
      append = "!git cherry-pick $(git merge-base HEAD\n  $1)..$1";
    };

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
      gpg = {
        format = "ssh";
      };
      gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      credential = {
        "https://github.com".helper = "!gh auth git-credential";
      };
    };
  };

  programs.zoxide = {
    enable = true;

    enableFishIntegration = true;
  };
}
