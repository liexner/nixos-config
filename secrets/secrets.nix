let
  keys = import ../keys.nix;
  admins = builtins.attrValues keys.personal;
in
{
  "tailscale.age".publicKeys = admins ++ [ keys.hosts.elitedesk ];
}
