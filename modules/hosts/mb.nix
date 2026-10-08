{ den, ... }:
{
  den.hosts.aarch64-darwin = {
    loki.users.liexner = { };
    odin.users.liexner = { };
  };

  # shared by all macs
  den.aspects.macbook.darwin = {
    system.defaults.dock.autohide = true;

    homebrew = {
      enable = true;
      casks = [ "vorssaint" ];
    };
  };

  den.aspects.loki.includes = [ den.aspects.macbook ];
  den.aspects.odin.includes = [ den.aspects.macbook ];
}
