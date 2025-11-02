{ config, pkgs, ... }:

{

  services.newt = {
    enable = true;
    settings  = {
      endpoint = "https://pangolin.exner.dev";
    };

  };

}
