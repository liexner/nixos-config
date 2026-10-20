# nixos-config

Multi-host NixOS / nix-darwin configuration, organized with
[den](https://github.com/denful/den) and
[import-tree](https://github.com/vic/import-tree): every `.nix` file under
`modules/` is auto-imported. Hosts are declared under
`den.hosts.<system>.<name>` (the name is also the hostname) and built from
`den.aspects.<name>` (see e.g. `modules/hosts/elitedesk.nix`).

Hosts:

- `elitedesk` — NixOS, home server (Home Assistant, Caddy, Tailscale)
- `wsl` — NixOS-WSL, daily driver dev environment
- `loki` — nix-darwin, MacBook Air (M1, user `liexner`)
- `odin` — nix-darwin, MacBook Air (M4, user `liexner`)

## Usage

```sh
# see all flake outputs
nix flake show

# update inputs
just update
```

### Local rebuilds

```sh
just switch   # {nixos,darwin}-rebuild switch for the current hostname

# first switch on a fresh machine (hostname not set yet):
sudo darwin-rebuild switch --flake .#loki
```

### Remote rebuilds

```sh
just ed    # rebuild elitedesk over the network (via just remote elitedesk <ip-or-host>)

# or directly:
just remote {{host}} {{ip}}
```

### First install (bare metal / VM)

```sh
nixos-anywhere --flake .#elitedesk nixos@<ip>
```

### Secrets

All secrets live in one sops file, `secrets/secrets.yaml`, encrypted to the
personal ed25519 key (in Bitwarden) and each server's SSH host key (see `.sops.yaml`).
Aspects that need a secret include `den.aspects.secrets` and declare `sops.secrets.<name>`.

```sh
just secrets   # sops secrets/secrets.yaml
```

New or reinstalled server: add `ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub`
to `.sops.yaml`, then `just rekey`.
