{ ... }:

{
  programs.rust-motd.settings.service_status.k3s = "k3s";
  services.k3s.enable = true;
}