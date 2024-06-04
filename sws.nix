let rootDir = "/home/azureuser/Public/"; in

{
  programs.rust-motd.settings.service_status.sws = "static-web-server";

  services.static-web-server = {
    enable = true;
    root = rootDir;
  };

  systemd.services.static-web-server.unitConfig.ConditionPathIsDirectory = rootDir;
}