{ config, lib, pkgs, ... }:

{
  imports = [ ];

  # Boot configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network configuration
  networking.hostName = "server";
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "UTC";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    curl
    vim
    htop
  ];

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
    ];
  };

  # Allow unfree packages if needed
  nixpkgs.config.allowUnfree = true;
}
