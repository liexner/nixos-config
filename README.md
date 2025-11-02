```sh

nix flake show

#local rebuilds
sudo nixos-rebuild switch --flake .#wsl

# First install
nixos-anywhere --flake .#server nixos@192.168.50.21

# Consecutive updates
# nixos-rebuild switch --flake .#server --target-host liexner@192.168.50.21 --use-remote-sudo
nixos-rebuild switch \
  --flake .#elitedesk \
  --target-host liexner@192.168.50.9 \
  --build-host liexner@192.168.50.9 \
  --sudo

```
# secrets-manegement

```sh
#new host key
# mkdir -p ~/.config/sops/age
# nix-shell -p age --run "age-keygen -o ~/.config/sops/age/keys.txt"
# chmod 600 ~/.config/sops/age/keys.txt
# grep "public key" ~/.config/sops/age/keys.txt # add to .sops.yaml

# #edit the encrypted file
# sops secrets/global.yaml

# #if added a new host to .sops.yaml -> need to be run from a already added host
# sops updatekeys secrets/global.yaml
#
nix run github:ryantm/agenix -- -e newt.age

```
