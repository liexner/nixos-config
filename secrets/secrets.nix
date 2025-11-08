let
 sshKeys = import ../ssh-keys.nix;
in {
  "newt.age".publicKeys = sshKeys.allKeys ++ sshKeys.allHosts;
}
