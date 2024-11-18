{ modulesPath, pkgs, ... }:

{
  imports = [
    "${modulesPath}/virtualisation/azure-common.nix"
    "${modulesPath}/virtualisation/azure-image.nix"
    ./fail2ban.nix
    ./motd.nix
    ./shadowsocks.nix
  ];

  boot.kernelParams = ["zswap.enabled=1"];

  documentation.enable = false;

  environment.systemPackages = with pkgs; [
    fastfetch
    htop
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

  # https://gist.github.com/ssrlive/32d4f2796746cd5e751985be19adf7a1
  services.openssh.settings = {
    AllowTcpForwarding = "yes";
    GatewayPorts = "yes";
  };

  swapDevices = [{
    device = "/var/swapfile";
    size = 2048;
  }];

  system.stateVersion = "24.05";
  
  # https://github.com/NixOS/nixpkgs/issues/84105
  # start tty0 on serial console
  systemd.services."serial-getty@ttyS0" = {
    enable = true;
    wantedBy = [ "getty.target" ]; # to start at boot
    serviceConfig.Restart = "always"; # restart when session is closed
  };

  services.openssh.settings.PasswordAuthentication = false;
  # security.sudo.wheelNeedsPassword = false;

  time.timeZone = "Asia/Hong_Kong";
}
