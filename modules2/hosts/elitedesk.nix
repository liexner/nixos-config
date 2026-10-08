{ den, inputs, ... }:
{

  den.hosts.x86_64-linux.elitedesk = {
    users.liexner = { };
  };

  den.aspects.elitedesk = {
      #includes = with den.aspects; [ tailscale microbin home-assistant ];

      nixos = { pkgs, ... }: {
        imports = [ inputs.disko.nixosModules.disko ];
        nix.settings.trusted-users = [ "@wheel" ];

        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        systemd.network.enable = true;
        networking.useNetworkd = true;

        services.openssh.enable = true;
        security.sudo.wheelNeedsPassword = false;

        environment.systemPackages = with pkgs; [ vim htop ];

        system.autoUpgrade = {
          enable = true;
          flake = "github:liexner/nixos-config";
          dates = "weekly";
          allowReboot = true;
        };
        nix.gc = { automatic = true; dates = "weekly"; options = "--delete-older-than 30d"; };
        nix.settings.auto-optimise-store = true;

      #DISKO
      disko.devices.disk.main = {
              type = "disk";
              device = "/dev/sda";
              content = {
                type = "gpt";
                partitions = {
                  boot = {
                    size = "1G";
                    type = "EF00";
                    content = { type = "filesystem"; format = "vfat"; mountpoint = "/boot"; mountOptions = [ "defaults" ]; };
                  };
                  root = {
                    size = "100%";
                    content = { type = "filesystem"; format = "ext4"; mountpoint = "/"; };
                  };
                };
              };
            };

    };

      };
}
