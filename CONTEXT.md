# nixos-config

Personal NixOS / nix-darwin fleet for one person.

## Language

**Personal key**:
The single ed25519 SSH key, kept in Bitwarden and copied to every PC, used both to log in to servers and to edit the Secrets file.
_Avoid_: admin key, master key

**Server key**:
A server's own SSH host key, generated on that server and never copied off it; lets the server read the Secrets file.
_Avoid_: machine key

**Secrets file**:
The one encrypted file holding every secret for every service.
_Avoid_: secret store, vault
