{
  den.hosts.x86_64-linux.wsl = {
    users.liexner = { };
    wsl.enable = true;
  };

  den.aspects.wsl = {
    # wsl.docker-desktop.enable = true; # swap with native docker below to use Docker Desktop

    nixos = { pkgs, ... }: {
      programs.nix-ld.enable = true;
      programs.fish.enable = true;
      users.users.liexner.shell = pkgs.fish;
      virtualisation.docker.enable = true;
      users.users.liexner.extraGroups = [ "docker" ];
      fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
      environment.systemPackages = with pkgs; [
        openstackclient
        github-copilot-cli
        wrangler
        nodejs
        chromium
        k3d
        kubernetes-helm
        kubectl # one-off: helm-core-system test cluster
        fluxcd
        k9s
        oxker
      ];
    };

    provides.to-users.homeManager = { pkgs, ... }: {
      home.sessionPath = [ "$HOME/.local/bin" ];
      programs.bash.enable = true;
      programs.starship.enable = true;
      programs.fish.enable = true;
    };

  };
}
