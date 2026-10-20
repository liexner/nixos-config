update:
    nix flake update --flake ~/nixos-config

clean:
    sudo nix-collect-garbage -d

switch:
    sudo {{ if os() == "macos" { "darwin" } else { "nixos" } }}-rebuild switch --flake ~/nixos-config

secrets:
    sops secrets/secrets.yaml

# re-encrypt to the recipients in .sops.yaml (after adding/removing a server)
rekey:
    sops updatekeys -y secrets/secrets.yaml

remote host ip:
    nix run nixpkgs#nixos-rebuild -- switch \
      --flake .#{{host}} \
      --target-host liexner@{{ip}} \
      --build-host liexner@{{ip}} \
      --elevate=sudo

ed:
    just remote elitedesk elitedesk
