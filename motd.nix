{ lib, pkgs, ... }:

{
  programs.rust-motd = {
    enable = true;
    settings = {
      banner = {
        color = "white";
        command = "${lib.getExe pkgs.fastfetch} --logo-type none --detect-version false";
      };
      last_login.azureuser = 10;
      service_status.waagent = "waagent";
    };
  };
}