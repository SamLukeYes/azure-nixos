{ lib, pkgs, ... }:

{
  programs.rust-motd = {
    enable = true;
    settings = {
      banner = {
        color = "white";
        command = "${lib.getExe pkgs.fastfetch} --colors-block-range-end 0 --logo-type none --detect-version false";
      };
      # filesystems.root = "/";
      last_login.azureuser = 10;
    };
  };
}