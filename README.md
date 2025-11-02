```sh

nix flake show

#local rebuilds
sudo nixos-rebuild switch --flake .#wsl

# First install
nixos-anywhere --flake .#server nixos@192.168.50.21

# Consecutive updates
nixos-rebuild switch \
  --flake .#elitedesk \
  --target-host liexner@192.168.50.9 \
  --build-host liexner@192.168.50.9 \
  --sudo

```
# secrets-manegement

```sh

nix run github:ryantm/agenix -- -e newt.age

nix run github:ryantm/agenix -- --rekey

```
