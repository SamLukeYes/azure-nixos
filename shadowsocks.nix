{ pkgs, ... }:

let
  username = "shadowsocks";
  home = "/var/lib/${username}";
  port = 1024;
  cipher = "2022-blake3-aes-256-gcm";
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
      path = [ pkgs.shadowsocks-rust ];
      script = ''
        PASSWORD=`cat ${home}/password`
        exec ssserver -s [::]:${builtins.toString port} \
          -m ${cipher} -k $PASSWORD
      '';   # TODO: Don't pass password to command line
      serviceConfig = {
        # https://github.com/shadowsocks/shadowsocks-rust/blob/master/debian/shadowsocks-rust-server%40.service
        AmbientCapabilities = ["CAP_NET_BIND_SERVICE"];
        CapabilityBoundingSet = ["CAP_NET_BIND_SERVICE"];
        User = username;
        Group = username;
      };
      unitConfig.ConditionFileNotEmpty = "${home}/password";
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