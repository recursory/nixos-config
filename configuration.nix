{ config, pkgs, ... }:
{
  imports =
    [
    ./hardware-configuration.nix
    ];
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "ntfs" ];
  };
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Los_Angeles";
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
  services.printing.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  users.users.recursory = {
    isNormalUser = true;
# Debatable.
    description = "Olivia Naomi Lund";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    packages = with pkgs; [
      thunderbird
    ];
  }; 
  programs = {
    firefox.enable = true;
    udevil.enable = true;
    nix-ld.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
      wget
      git
      gparted
      keepassxc
      steam
      obsidian
      milkytracker
      discord-canary
      vesktop
      anki
      gimp
      ffmpeg
      vlc
      gramps
      handbrake
      nodejs
      obs-studio
      audacity
      quodlibet
      pkgs.godot_4
      imagemagick
      icu
      ];
  services = {
    flatpak.enable = true;
    openssh.enable = true;
    xserver = {
      xkb = {
        layout = "us";
        variant = "";
      };
      enable = true;
      displayManager.lightdm.enable = true;
      desktopManager.cinnamon.enable = true;
    };
    libinput.enable = true;
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };
  system.stateVersion = "24.11";
  virtualisation.docker.enable = true;
  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
  ];
}
