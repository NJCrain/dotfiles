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
    autojump
    ripgrep
    bat
    kakoune
    kakoune-lsp
    (pkgs.callPackage (import ./custom-packages/kak-tree-sitter/kak-tree-sitter.nix) {})
    gcc
    vscode-langservers-extracted
    nerd-fonts.fira-code
    (writeShellScriptBin "fzf-preview" (builtins.readFile ./scripts/fzf-preview))
    wireguard-tools
    auto-ssh
  ];

  programs.fd = {
		enable = true;
		hidden = true;
		ignores = [ ".git/" ];
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
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    terminal = "tmux-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    escapeTime = 10;
  };
  
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.librewolf = {
    enable = true;
  };

  programs.lazygit= {
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
