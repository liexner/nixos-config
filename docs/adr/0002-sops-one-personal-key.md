# Secrets: one sops file, one personal key, one host key per server

We moved from agenix (one `.age` file per secret, recipients listed in `secrets/secrets.nix`, three per-machine RSA personal keys) to a single `secrets/secrets.yaml` managed by sops-nix. It is encrypted to exactly two kinds of recipient: one personal ed25519 SSH key, stored in Bitwarden and copied to every PC (also the SSH login key), and each server's own SSH host key, so servers decrypt at activation without any private key being copied to them.

We considered putting the personal key on servers too, so they would need no recipient entry. Rejected: it means copying a private key to every server by hand before its first switch, and a compromised server would hold the key that edits everything. The cost of using host keys is that a reinstalled server gets a new host key and the file has to be re-encrypted (`sops updatekeys`).

In `.sops.yaml` the personal key is the plain `ssh-ed25519` line, because the sops CLI decrypts with `~/.ssh/id_ed25519`. Host keys must be the `age1…` form from `ssh-to-age`: sops-nix converts the host key to an age identity, which cannot decrypt a file encrypted to the raw `ssh-ed25519` recipient (tested with sops 3.13).
