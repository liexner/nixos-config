{
  den.hosts.x86_64-linux.wsl-den = {
      hostName = "nixos";
      users.liexner = { };
      wsl.enable = true;
  };

  den.aspects.wsl-den.nixos = {
       wsl.docker-desktop.enable = true;

       nixos = { pkgs, ... }: {
          programs.nix-ld.enable = true;
          fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
          environment.systemPackages = with pkgs; [
            openstackclient github-copilot-cli
          ];
        };

  };
}
