{ inputs, ... }:
{
  flake.modules.darwin.mba =
    { pkgs, ... }:
    {
      imports = [
        inputs.self.modules.darwin.cli-tools
      ];

      nix.settings.experimental-features = [ "nix-command" "flakes" ];
      system.stateVersion = 6;

      environment.systemPackages = with pkgs; [
        git
        just
      ];
    };
}
