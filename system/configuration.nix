# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, pkgs-unstable, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      #<nixos-hardware/lenovo/thinkpad/t450s> # does not work with flakes
      ./hardware-configuration.nix
      inputs.xremap-flake.nixosModules.default
    ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Hardware
  hardware.trackpoint.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Flakes
  services.xremap = {
    withX11 = true;
    userName = "amin";
    watch = true;
    yamlConfig = builtins.readFile (builtins.fetchurl { 
      url = https://raw.githubusercontent.com/nullbyto/dotfiles/master/dot_config/xremap.yml;
      sha256 = "13m8wcyfcpr5x86g56akwdnsjsmhwjwnjjym86pv9da01ll301nh";
    });
  };

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "amin" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.startx.enable = true;
  #services.xserver.displayManager.defaultSession = "none+dwm";
  # installs dwm alongside its .desktop entry
  services.xserver.windowManager.dwm.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "eu";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable blueman/bluetooth
  services.blueman.enable = true;
  # Enable security key service for YubiKey
  services.pcscd.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.naturalScrolling = true;
  #services.xserver.synaptics.enable = true;

  security.polkit.enable = true;

  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.amin = {
    isNormalUser = true;
    description = "Amin";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      firefox
      # thunderbird
    ];
  };

  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    htop
    vim
    bat
    tmux
    fzf
    xclip
    direnv
    rnix-lsp
    chezmoi
    python3
    python3Packages.pip
    nodejs
    nodePackages.npm
    networkmanager
    networkmanagerapplet
    blueman
    bluez
    dnsutils
    arandr
    pulseaudio
    pavucontrol
    alsa-utils
    pamixer
    brightnessctl
    redshift
    xorg.xrandr
    xorg.xrdb
    xorg.xev
    xorg.xinput
    # for flatpak software
    gnome.gnome-software
  ];

  # Fonts
  fonts.fonts = with pkgs; [
    terminus_font
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  services.flatpak.enable = true;
  # xdg portal needed for flatpaks
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Tailscale VPN
  services.tailscale.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
