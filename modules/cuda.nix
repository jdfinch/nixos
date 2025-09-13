{ pkgs, config, ... }:

let
  tk = pkgs.cudaPackages.cudatoolkit;  # whatever your nixpkgs pin provides
in
{
  # Fail fast if the pin isn't CUDA 12.8 exactly.
  assertions = [{
    assertion = (tk.version == "12.8");
    message   = "This config expects CUDA 12.8, but nixpkgs provides ${tk.version}. Bump nixpkgs or change the pin.";
  }];

  # Proprietary NVIDIA driver
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;              # set true only if you want the open kernel module
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Avoid nouveau conflicts
  boot.blacklistedKernelModules = [ "nouveau" ];

  # Put nvcc (from toolkit) and nvidia-smi (from driver) on PATH
  environment.systemPackages = [
    tk
    config.boot.kernelPackages.nvidiaPackages.stable
  ];

  # Helpful env
  environment.variables.CUDA_PATH = toString tk;

  # OpenGL
  hardware.graphics.enable = true;

  # Wayland/Hyprland NVIDIA QoL tweaks
  environment.sessionVariables = {
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
  };
}
