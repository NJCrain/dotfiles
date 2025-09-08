{ config, pkgs, lib, ... }:

{
  home.username = "nick";
  home.homeDirectory = "/home/nick";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    stow
    tmux
    autojump
    fd
    ripgrep
    bat
    kakoune
    kakoune-lsp
    kak-tree-sitter
    vscode-langservers-extracted
    nerd-fonts.fira-code
    (writeShellScriptBin "fzf-preview" (builtins.readFile ./scripts/fzf-preview))
  ];

  programs.fzf = {
		enable = true;
		defaultCommand = "fd . --type file -H --no-ignore-vcs | eza --icons=always --color=always --sort=name";
		defaultOptions = ["--ansi" "--preview 'fzf-preview {}'"];
		enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
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
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  home.activation = {
    stowKakoune = lib.hm.dag.entryAfter ["writeBoundary" "installPackages"] ''
       run stow -t $HOME $HOME/dotfiles/kakoune
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
