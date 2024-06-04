{
  programs.rust-motd.settings.service_status.sws = "static-web-server";

  services.static-web-server = {
    enable = true;
    root = "/home/azureuser/Public/";
  };
}