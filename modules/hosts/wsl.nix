{
  den.hosts.x86_64-linux.wsl = {
      users.liexner = { };
      wsl.enable = true;
  };

  den.aspects.wsl = {
       wsl.docker-desktop.enable = true;

       nixos = { pkgs, ... }: {
          programs.nix-ld.enable = true;
          programs.fish.enable = true;
          users.users.liexner.shell = pkgs.fish;
          fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
          environment.systemPackages = with pkgs; [
            openstackclient github-copilot-cli wrangler
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
