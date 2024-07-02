{ pkgs, ... }:

{
  programs.rust-motd.settings.fail2_ban.jails = [ "sshd" ];
  services.fail2ban.enable = true;
  systemd.services.rust-motd.path = [ pkgs.fail2ban ];
}