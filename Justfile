update:
    nix flake update --flake ~/nixos-config

wsl:
    sudo nixos-rebuild switch --flake ~/nixos-config#wsl

local machine:
    sudo darwin-rebuild switch --flake ~/nixos-config#{{machine}}

remote host ip:
    nix run nixpkgs#nixos-rebuild -- switch \
      --flake .#{{host}} \
      --target-host liexner@{{ip}} \
      --build-host liexner@{{ip}} \
      --use-remote-sudo
