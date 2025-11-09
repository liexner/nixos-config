{ config, lib, pkgs, ... }:

{

  services.xserver.videoDrivers = ["nvidia"];
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vulkan-tools
      libglvnd
    ];
    extraPackages = with pkgs; [
      vulkan-loader
      vulkan-tools
      vulkan-validation-layers
      libglvnd
    ];
  };


  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

}
