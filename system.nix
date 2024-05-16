{ lib, modulesPath, pkgs, ... }:

{
  imports = [
    "${modulesPath}/virtualisation/azure-common.nix"
    "${modulesPath}/virtualisation/azure-image.nix"
    ./rustdesk.nix
    ./shadowsocks.nix
  ];

  documentation.enable = false;

  environment.systemPackages = with pkgs; [
    fastfetch
    jq
    nix-tree
  ];

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    settings = {
      auto-optimise-store = true;
      trusted-users = [ "azureuser" ];
    };
  };

  programs.rust-motd = {
    enable = true;
    settings = {
      banner = {
        color = "white";
        command = "${lib.getExe pkgs.fastfetch}  --logo-type small --ts-version false";
      };
      # filesystems.root = "/";
    };
  };

  # virtualisation.azureImage.diskSize = 2500;

  system.stateVersion = "24.05";
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  services.openssh.settings.PasswordAuthentication = false;
  # security.sudo.wheelNeedsPassword = false;

  zramSwap.enable = true;
}
