{ config, lib, pkgs, ... }:

{
  imports = [
    ../../modules/services/home-assistant.nix
    ../../modules/services/newt.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Boot configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network configuration
  networking.hostName = "elitedesk";
  networking.networkmanager.enable = true;

  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    vim
    htop
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # Enable SSH
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";

  # Define a user account
  users.users.liexner = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "nixos";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqbPTff2s5oVZDSZiVpd9S8UdUF5gtwwlYNpm5kTYTxNlVvzdR/jicVuXA4AfugNP6YzK4FVHtCL+z/wFLSYPQsZh7W5mlHGvWexTC0p9I3FJTm+ihZYk60S030/ErznuOLc0QomhUZLridXuurFAbFn9DZo2mq+tho1duuhavXQvhSCBCmIy7ZbXau81MMJg9/5q+SIsTEPAPvYXo2rLEMbcYTDYOXKzlnZEG+Gvjvvr6AkSOLOzsjG1nwbn/E2Za+B1x2zkx2CntYXQH389yi6fn+PZKjVDLk1Fmha/WnuYv5BrmWfaQdpN+cMqCNC0DL+88RtsaAEf1I+Zim5A04Zod8PazqN2cv9m9K9Td8HUKKSxIcSFITH5EhtsZxfNMpiZkbltl3KtbKoluoqQJJwq5JFM7zyVhFbdqDAGXcAtN4JaSbPDlIK18qELvKRkUIZ4LEl9SsQw8JjnuHdJFdraxvYiYOsslVq8IKJu/J5YDcT+0/gf9/PWpFCmbBv8= nixos@nixos"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDVKG/eEFh3f9vjissH/POclGm1/3W4RdlCOz6yHPfb/PlWKO2Sppda/3Lseq8qx+9P9IED3x1ExcewbvF9L9uPKKaGSgbBmesyjevD6NaU9Z/UpEdXYNTImTGqB/W4bMMWIUVmglyNcgtbzjhzsk8YvQNWuZFtHauRy6pUmmhv0ortvdlE1oRAZ5Z61xogBPoYygaxoYPKJhqQkSMJfJnKtfXs5JvjNeK/o5Pw/2r1fJICSaW7I8mXb1Zju9U86Ar28SoVMNsKC85dT0dRUSHH4Mg9jDLK8ICi4sG/RA9BsmIbJOB26F0b85ycUzm4mPCqPm5kWtuyScUOne+WwxJ73B+46Lv3N76Zhg185FZOOZLfR5BJ275gSedsjvq9EZH5BBoHhMoRHf0e3JyQaKcuqPwPc69tgwmTXIJhk5Bxh8kpasjDEEsVuD4VxEL6o8Tl9QJcnqJIgJBUAnsn2TDWKZ+3FXuqrc5zEnx9ymmhu9Txxvu0C8APlsF9kpGn4XE= linusexner@Linuss-MacBook-Air.local"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCl8W3NY+dlThgNx441yj9NY+lEmVWs3SOgtQn5Tw2pORsuSSoLh25S0fXB9cy6GCVMbG3Esopu9+qFGyDBuELMNIToOQOAQmEaGRavxb1Arb8ggZi84G87bly8qrsD4NfpayVZVR65VAMi8rXlSfSPAY6UlH32Mo49ywCjiAqdzGPU5Xo9JmdnfEt0ONm4puwGaTw3V+0m6hAhZXCNLKwxp3+7ImAsqo04EDKnWEcqqQ82zajYa/i4h0zzYQINzhl+qhXQLR9oWV/p6IjHnXPe5Z5sSadQJKJdD6wpJ5xNKd9TYWnlUFhWpPKqxMaUpvW/CGNmZJBkHAR1aOYR+FXlk9SVIfqrRqaY94BCkyQqclHUhKmXScFD4HDiRhDX75B8sYqNJfkHOL8KZIqPG4xjcbEgSv9CaA55q5cr8yMZk48YhJiFP7v5rtA4gKWJwY/EwKsTTW8cDWXa+8cW8ylglPZTDwkN3y6aw2ZQIXJNZ6R0/jdyet0Tulugu83ftE8= liexner@nixos"
    ];
  };

}
