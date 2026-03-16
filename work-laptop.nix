{ config, pkgs, lib, ... }:

{
  home.username = "nick";
  home.homeDirectory = "/Users/nick";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    stow
    autojump
    ripgrep
    bat
    kakoune
    kakoune-lsp
    (pkgs.callPackage (import ./custom-packages/kak-tree-sitter/kak-tree-sitter.nix) {})
    gcc
    (pkgs.callPackage (import ./custom-packages/vscode-lang-servers-extracted/vscode-lang-servers-extracted.nix) {})
    typescript-language-server
    tailwindcss-language-server
    nerd-fonts.fira-code
    (writeShellScriptBin "fzf-preview" (builtins.readFile ./scripts/fzf-preview))
    (writeShellScriptBin "lazygit-edit" (builtins.readFile ./scripts/lazygit-edit))
    wezterm
    _1password-gui
    alt-tab-macos
    dbeaver-bin
    karabiner-elements
    slack
    postman
    raycast
    wireguard-tools
    zoom-us
    autossh
    tree
    fswatch
    codex
    graphite-cli
    firefox
    eslint_d
    mosh
    codex
    claude-code
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    silent = true;
  };

  programs.fd = {
		enable = true;
		hidden = true;
		ignores = [ ".git/" ];
  };

  programs.bash = {
    enable = true;
  };

  programs.fzf = {
		enable = true;
		defaultCommand = "fd . --type file -H --no-ignore-vcs | eza --icons=always --color=always --sort=name";
		defaultOptions = ["--ansi"];
		enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
  };

  programs.nnn = {
    enable = true;
    package = (pkgs.nnn.override { withNerdIcons = true; });
    plugins.mappings = {
      o = "fzopen";
      j = "autojump";
      p = "preview-tui";
    };
  };
    

  home.sessionVariables = {
    EDITOR = "kak";
    NNN_FIFO = "/tmp/nnn.fifo";
  };

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };

    shellAliases = {
      dev-connect = "autossh -M 0 -f server -L 3000:localhost:3000 -L 8080:localhost:8080 -L 4000:localhost:4000 -L 8233:localhost:8233 -L 8000:localhost:8000 -N";
      nix-shell = "nix-shell --run $SHELL";
    };

    # Only run Homebrew shellenv in interactive shells,
    # and only if brew actually exists.
    profileExtra = ''
    if [[ $- == *i* ]] && [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    '';

		envExtra = ''
    if [[ ! -o interactive ]] && [[ ! -o login ]]; then
      eval "$(${pkgs.direnv}/bin/direnv export zsh)"
    fi
    export XDG_CONFIG_HOME=$HOME/.config
    '';

    siteFunctions = {
			deploy-canary = ''
        local branch_to_upload="''${1:-$(git branch --show-current)}"
        git checkout "$branch_to_upload" && \
        git branch -f canary && \
        git checkout canary && \
        git push -f origin canary && \
        git checkout -
			'';
    };
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    terminal = "tmux-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    escapeTime = 10;
    extraConfig = ''
			set -g default-command "${pkgs.zsh}/bin/zsh"
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.librewolf = {
    enable = true;
  };

  programs.awscli = {
    enable = true;
  };

  programs.vscode = {
    enable = true;
  };

  programs.git = {
		enable = true;
		settings = {
			user = {
				name = "Nick Crain";
				email = "nicholascrain@gmail.com";
			};
			rebase = {
				updateRefs = true;
			};
			alias = {
				default-branch = "!git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'";
      	merge-base-origin ="!f() { git merge-base \${1-HEAD} origin/$(git default-branch); };f ";
      	stack = "!f() { BRANCH=\${1-HEAD}; MERGE_BASE=$(git merge-base-origin $BRANCH); git --no-pager log --decorate-refs=refs/heads --simplify-by-decoration --pretty=format:\"%(decorate:prefix=,suffix=,tag=,separator=%n)\" $MERGE_BASE..$BRANCH; };f ";
      	push-stack = "!f() { BRANCH=\${1-HEAD};  git stack $BRANCH | xargs -I {} git push --force-with-lease origin {}; };f ";

			};
		};
  };

  programs.lazygit = {
    enable = true;
    enableZshIntegration = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
