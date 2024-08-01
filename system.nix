{ modulesPath, pkgs, ... }:

{
  imports = [
    "${modulesPath}/virtualisation/azure-common.nix"
    "${modulesPath}/virtualisation/azure-image.nix"
    ./fail2ban.nix
    ./k3s.nix
    ./motd.nix
    ./rustdesk.nix
    ./shadowsocks.nix
    ./sws.nix
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

  # virtualisation.azureImage.diskSize = 2500;

  programs = {
    git.enable = true;
    xonsh.enable = true;
  };

  system.stateVersion = "24.05";
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  services.openssh.settings.PasswordAuthentication = false;
  # security.sudo.wheelNeedsPassword = false;

  time.timeZone = "Asia/Hong_Kong";

  zramSwap.enable = true;
}
