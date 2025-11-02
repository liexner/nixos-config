{ config, pkgs, ... }:

{

  age.secrets.newt = {
    file = ../../secrets/newt.age;
  };

  services.newt = {
    enable = true;
    settings  = {
      endpoint = "https://pangolin.exner.dev";
    };
    environmentFile = config.age.secrets.newt.path;
  };

}
