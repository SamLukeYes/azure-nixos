{ pkgs, ... }:

let
  username = "shadowsocks";
  home = "/var/lib/${username}";
  configFile = "${home}/config.json";
  port = 1024;
in

{
  networking.firewall = {
    allowedTCPPorts = [ port ];
    allowedUDPPorts = [ port ];
  };

  systemd = {
    services.ssserver = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [
        jq
        shadowsocks-rust
      ];
      script = ''
        jq '.server_port = ${builtins.toString port}' ${configFile} > /tmp/config.json
        exec ssserver -c /tmp/config.json
      '';
      serviceConfig = {
        # https://github.com/shadowsocks/shadowsocks-rust/blob/master/debian/shadowsocks-rust-server%40.service
        AmbientCapabilities = ["CAP_NET_BIND_SERVICE"];
        CapabilityBoundingSet = ["CAP_NET_BIND_SERVICE"];
        PrivateTmp = true;
        User = username;
        Group = username;
      };
      unitConfig.ConditionFileNotEmpty = configFile;
    };

    tmpfiles.rules = [
      "d ${home} 1700 ${username} ${username}"
    ];
  };

  users = {
    groups.${username} = {};
    users.${username} = {
      inherit home;
      group = username;
      isSystemUser = true;
    };
  };
}