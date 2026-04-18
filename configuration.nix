# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  #export NIXPKGS_ALLOW_UNFREE=1
    imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ];

# Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixosTower"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Enable networking
    networking.networkmanager.enable = true;

# Set your time zone.
  time.timeZone = "America/Los_Angeles";

# Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

# Enable the X11 windowing system.
  services.xserver.enable = true;

# Enable the Budgie Desktop environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.budgie.enable = true;

# Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

# Enable CUPS to print documents.
  services.printing.enable = true;

# Enable sound with pipewire.
  services.pulseaudio.enable = false;
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

# Enable touchpad support (enabled default in most desktopManager).
# services.xserver.libinput.enable = true;

# Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.recursory = {
    isNormalUser = true;
# Debatable.
    description = "Olivia Naomi Lund";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      thunderbird
    ];
  };

# Install firefox.
  programs.firefox.enable = true;

# Allow unfree packages
  nixpkgs.config.allowUnfree = true;

# List packages installed in system profile. To search, run:
# $ nix search wget

  environment.sessionVariables = {
#DOTNET_ROOT = "${pkgs.dotnet-sdk}/share/dotnet";
  };

  environment.systemPackages = with pkgs;
  [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      git
      gcc
      keepassxc
      steam
      obsidian
      anki
      gimp
      ffmpeg
      vlc
      handbrake
      audacity
      obs-studio
      feh
      p7zip
      btop
      samba
      discord-canary
      netcat
      doomrunner
      retroarch
#qbittorrent
#linuxKernel.packages.linux_zen.xone
      pulseaudio
#minecraft
      qdirstat
      dotnetCorePackages.sdk_8_0_1xx-bin
      xivlauncher
      deluge
      immersed
      yt-dlp
      quodlibet
      kdePackages.kdenlive
      lmms
      zip
      pulseeffects-legacy
      pcsx2
      snes9x
#namebench
      dmidecode
      traceroute
      mtr
      dnsutils
      nix-tree
      ];

# There have been amdgpu issues in 6.10 so you maybe need to revert on the default lts kernel.
# boot.kernelPackages = pkgs.linuxPackages;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  programs.mtr.enable = true;
#services.mtr-exporter.enable = true;

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

# List services that you want to enable:
  services.netdata.enable = false;

# Enable the OpenSSH daemon.
  services.openssh.enable = true;

#services.mullvad-vpn.enable = true;
#services.mullvad-vpn.package = pkgs.mullvad-vpn;
  services.mozillavpn.enable = true;


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
  system.stateVersion = "24.11"; # Did you read the comment?

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [nvidia-vaapi-driver];
    };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true; # Set to false to use the proprietary kernel module
    fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    ];
  hardware.steam-hardware.enable = true;
  hardware.xone.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  services.flatpak.enable = true;

# For mount.cifs, required unless domain name resolution is not needed.
  fileSystems."/mnt/share" = {
    device = "//192.168.1.68/Public";
    fsType = "cifs";
    options = let
# this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
  };


  programs.nix-ld.enable = true;
  programs.dconf.enable = true;
  networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];
}
