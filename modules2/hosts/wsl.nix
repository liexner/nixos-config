{
  den.hosts.x86_64-linux.wsl = {
      hostName = "nixos";
      users.liexner = { };
      wsl.enable = true;
  };

  den.aspects.wsl = {
       wsl.docker-desktop.enable = true;

       nixos = { pkgs, ... }: {
          programs.nix-ld.enable = true;
          fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
          environment.systemPackages = with pkgs; [
            openstackclient github-copilot-cli
          ];
        };

        provides.to-users.homeManager = { pkgs, ... }: {
              home.sessionPath = [ "$HOME/.local/bin" ];
              home.packages = [ pkgs.wrangler ];
              programs.bash.enable = true;
              programs.starship.enable = true;
            };

  };
}
