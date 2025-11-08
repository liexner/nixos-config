{ config, pkgs, ... }:

{

  age.secrets.newt = {
    file = ../../secrets/newt.age;
  };

  services.newt = {
    enable = true;
    environmentFile = config.age.secrets.newt.path;
  };

}
