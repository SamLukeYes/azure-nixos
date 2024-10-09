let
  bindPort = 7000;
  vhostHTTPPort = 8080;
  ports = [ bindPort vhostHTTPPort ];
in

{
  networking.firewall = {
    allowedTCPPorts = ports;
    allowedUDPPorts = ports;
  };

  programs.rust-motd.settings.service_status.frp = "frp";

  services.frp = {
    enable = true;
    role = "server";
    settings = {
      inherit bindPort vhostHTTPPort;
    };
  };
}