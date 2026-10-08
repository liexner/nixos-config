update:
    nix flake update --flake ~/nixos-config

clean:
    sudo nix-collect-garbage -d

switch:
    sudo {{ if os() == "macos" { "darwin" } else { "nixos" } }}-rebuild switch --flake ~/nixos-config

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
