{ config, lib, pkgs, ... }:

{
  programs.rust-motd.settings.service_status = {
    hbbr = "rustdesk-relay";
    hbbs = "rustdesk-signal";
  };

  services.rustdesk-server = {
    enable = true;
    openFirewall = true;
    relayIP = "0.0.0.0";  # dummy value to prevent assertion failure
  };

  systemd.services.rustdesk-signal = {
    serviceConfig = {
      ExecStart = lib.mkForce "${pkgs.writeShellScript "hbbs-start" ''
        PATH=${lib.makeBinPath [
          config.services.rustdesk-server.package
          pkgs.curl
          pkgs.jq
        ]}:$PATH
        public_ip=`curl -s -H Metadata:true --noproxy * http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0?api-version=2024-03-15 | jq -r .publicIpAddress`
        exec hbbs -r $public_ip
      ''}";
      Restart = "on-failure";
    };
  };
}