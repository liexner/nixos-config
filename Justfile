update:
    nix flake update --flake ~/nixos-config

# delete all old generations (system + user + home-manager) and garbage-collect the store
clean:
    sudo nix-collect-garbage -d

wsl:
    sudo nixos-rebuild switch --flake ~/nixos-config#wsl

mba:
    sudo darwin-rebuild switch --flake ~/nixos-config#mba

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

