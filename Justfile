update:
    nix flake update --flake ~/nixos-config

clean:
    sudo nix-collect-garbage -d

wsl:
    sudo nixos-rebuild switch --flake ~/nixos-config#wsl

m1:
    sudo darwin-rebuild switch --flake ~/nixos-config#m1

m4:
    sudo darwin-rebuild switch --flake ~/nixos-config#m4

secret name:
    cd secrets && nix run github:ryantm/agenix -- -e {{name}}.age

remote host ip:
    nix run nixpkgs#nixos-rebuild -- switch \
      --flake .#{{host}} \
      --target-host liexner@{{ip}} \
      --build-host liexner@{{ip}} \
      --use-remote-sudo

ed:
    just remote elitedesk elitedesk
