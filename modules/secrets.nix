{ inputs, self, ... }:
{
  # Include from any aspect that declares `sops.secrets.<name>`.
  den.aspects.secrets.nixos = {
    imports = [ inputs.sops-nix.nixosModules.sops ];
    sops.defaultSopsFile = self + "/secrets/secrets.yaml";
    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
