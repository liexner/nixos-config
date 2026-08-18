# nixos-config

Multi-host NixOS / nix-darwin configuration, organized with
[flake-parts](https://flake.parts) and
[import-tree](https://github.com/vic/import-tree) (the "dendritic" pattern):
every `.nix` file under `modules/` is auto-imported into the flake, and each
module registers itself under `flake.modules.nixos.<name>` /
`flake.modules.darwin.<name>`. Hosts then assemble themselves from those
named modules (see e.g. `modules/hosts/elitedesk/default.nix`).

Hosts:

- `elitedesk` — NixOS, home server (Home Assistant, Caddy, Tailscale)
- `wsl` — NixOS-WSL, daily driver dev environment
- `mba` — nix-darwin, MacBook Air

## Usage

```sh
# see all flake outputs
nix flake show

# update inputs
just update
```

### Local rebuilds

```sh
just wsl   # sudo nixos-rebuild switch --flake .#wsl
just mba   # sudo darwin-rebuild switch --flake .#mba
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

Secrets are managed with [agenix](https://github.com/ryantm/agenix); keys
live in `keys.nix` and recipients are declared in `secrets/secrets.nix`.

```sh
just "secret name"   # cd secrets && nix run github:ryantm/agenix -- -e <name>.age
```
