update:
    nix flake update --flake ~/nixos-config

wsl:
    sudo nixos-rebuild switch --flake ~/nixos-config#wsl

mba:
    sudo darwin-rebuild switch --flake ~/nixos-config#mba

remote host ip:
    nix run nixpkgs#nixos-rebuild -- switch \
      --flake .#{{host}} \
      --target-host liexner@{{ip}} \
      --build-host liexner@{{ip}} \
      --use-remote-sudo

ed:
    just remote elitedesk elitedesk

