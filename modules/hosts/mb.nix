{ den, ... }:
{
  den.hosts.aarch64-darwin = {
    m1.users.liexner = { };
    m4.users.liexner = { };
  };

  # shared by all macs
  den.aspects.macbook.darwin = {
    system.defaults.dock.autohide = true;
  };

  den.aspects.m1.includes = [ den.aspects.macbook ];
  den.aspects.m4.includes = [ den.aspects.macbook ];
}
