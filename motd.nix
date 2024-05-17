{ config, lib, pkgs, ... }:

{
  programs.rust-motd = {
    enable = true;
    settings = {
      banner = {
        color = "white";
        command = "${lib.getExe pkgs.fastfetch} --colors-block-range-end 0 --logo-type small --ts-version false";
      };
      # filesystems.root = "/";
      last_login.azureuser = 10;
    };
  };

  systemd = {
    services.rust-motd.serviceConfig = {
      User = "azureuser";
      # Group = "azureuser";
    };
    tmpfiles.rules = [
      "d ${config.systemd.services.rust-motd.serviceConfig.WorkingDirectory} 644 azureuser azureuser - -"
    ];
  };
}