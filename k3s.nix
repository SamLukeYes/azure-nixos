{ pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      nerdctl
    ];

    sessionVariables.CONTAINERD_ADDRESS = "unix:///run/k3s/containerd/containerd.sock";
  };

  programs.rust-motd.settings.service_status.k3s = "k3s";
  services.k3s.enable = true;
}