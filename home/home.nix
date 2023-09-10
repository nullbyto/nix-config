{ config, pkgs, inputs, ... }:

let
  dwm = pkgs.dwm.overrideAttrs (old: {
    src = builtins.fetchGit {
      url = "https://github.com/nullbyto/dwm";
      ref = "config";
    };
    buildInputs = old.buildInputs ++ [ pkgs.imlib2 ];
  });

  dwmblocks = pkgs.dwmblocks.overrideAttrs (old: {
    src = builtins.fetchGit {
      url = "https://github.com/nullbyto/dwmblocks-async";
      ref = "main";
    };
  });

  dmenu = pkgs.dmenu.overrideAttrs (old: {
    src = builtins.fetchGit {
      url = "https://github.com/nullbyto/dmenu-flexipatch";
      ref = "master";
    };
  });
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "amin";
  home.homeDirectory = "/home/amin";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    dwm
    dwmblocks
    dmenu
    pkgs.alacritty
    pkgs.neovim
    pkgs.emacs
    pkgs.dunst
    pkgs.feh
    pkgs.rofi
    pkgs.flameshot
    pkgs.xfce.thunar
    pkgs.xfce.thunar-volman
    pkgs.ranger
    pkgs.xarchiver
    pkgs.cinnamon.xreader
    pkgs.gpick
    pkgs.sxhkd
    pkgs.ueberzug
    pkgs.xdotool
    pkgs.nitrogen
    pkgs.thunderbird
    pkgs.qalculate-gtk
    pkgs.gpick
    pkgs.pywal
    pkgs.lightdm-gtk-greeter
    pkgs.j4-dmenu-desktop
    pkgs.lxappearance
    pkgs.font-manager
    pkgs.vivaldi
    pkgs.khal
    pkgs.neofetch
    pkgs.picom
    pkgs.insync
    pkgs.papirus-icon-theme
    pkgs.catppuccin-gtk
    pkgs.betterlockscreen
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/amin/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
