let
  keys = import ../keys.nix;
  admin = keys.personal.nixos;
in
{
  "hass-basic-auth.age".publicKeys = [ admin keys.hosts.elitedesk ];
}
