# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.lxqt.enable = true;

  services.xserver = {
    layout = "us";
    xkbVariant = "mac";
    xkbOptions = "terminate:ctrl_alt_bksp, caps:ctrl_modifier";
    libinput.enable = false;
  };

  environment.shellInit = ''
    ${pkgs.xcape}/bin/xcape -e "Caps_Lock=Escape"
  '';

  services.xserver.synaptics.additionalOptions = ''
    Option "VertScrollDelta" "-100"
    Option "HorizScrollDelta" "-100"
  '';

  services.xserver.synaptics.enable = true;
  services.xserver.synaptics.tapButtons = true;
  services.xserver.synaptics.fingersMap = [ 0 0 0 ];
  services.xserver.synaptics.buttonsMap = [ 1 3 2 ];
  services.xserver.synaptics.twoFingerScroll = true;

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

  users.users.juliosueiras = {
    isNormalUser = true;
    description = "Julio";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "22.11"; # Did you read the comment?

}
