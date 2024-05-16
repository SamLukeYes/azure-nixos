{ modulesPath, pkgs, ... }:

{
  imports = [
    "${modulesPath}/virtualisation/azure-common.nix"
    "${modulesPath}/virtualisation/azure-image.nix"
    ./rustdesk.nix
    ./shadowsocks.nix
  ];

  environment.systemPackages = with pkgs; [
    jq
    neofetch
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

  # virtualisation.azureImage.diskSize = 2500;

  system.stateVersion = "24.05";
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  services.openssh.settings.PasswordAuthentication = false;
  # security.sudo.wheelNeedsPassword = false;
}
