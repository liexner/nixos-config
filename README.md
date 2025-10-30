


```sh

nix flake show

sudo nixos-rebuild switch --flake .#wsl

# First install
nixos-anywhere --flake .#server nixos@192.168.50.21

# Consecutive updates
nixos-rebuild switch --flake .#server --target-host liexner@192.168.50.21 --use-remote-sudo


```
