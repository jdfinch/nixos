# modules/cuda.nix
{ lib, pkgs, config, ... }:

let
  # map simple versions to nixpkgs attribute names
  toolkitFor = v:
    { "12.8" = pkgs.cudaPackages.cudatoolkit_12_8;
      "12.7" = pkgs.cudaPackages.cudatoolkit_12_7;
      "12.6" = pkgs.cudaPackages.cudatoolkit_12_6;
    }.${v} or (throw "Unsupported CUDA toolkit version: ${v}");
in
{
  options.my.cuda = {
    enable = lib.mkEnableOption "NVIDIA driver + CUDA toolkit";
    toolkitVersion = lib.mkOption {
      type = lib.types.enum [ "12.8" "12.7" "12.6" ];
      default = "12.8";
      description = "CUDA Toolkit version to install.";
    };
    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Additional CUDA packages (e.g., cudnn).";
    };
    waylandTweaks = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Apply NVIDIA-friendly Wayland/Hyprland env tweaks.";
    };
    useOpenKernelDriver = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use NVIDIA open kernel module (newer GPUs only).";
    };
  };

  config = lib.mkIf config.my.cuda.enable {
    # Proprietary NVIDIA driver
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = config.my.cuda.useOpenKernelDriver;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # Nouveau often conflicts—blacklist it
    boot.blacklistedKernelModules = [ "nouveau" ];

    # CUDA toolkit + optional extras
    environment.systemPackages =
      let tk = toolkitFor config.my.cuda.toolkitVersion;
      in [ tk ] ++ config.my.cuda.extraPackages;

    # Helpful env for dev shells/compiles
    environment.variables = {
      CUDA_PATH = toString (toolkitFor config.my.cuda.toolkitVersion);
    };

    # Optional Wayland/Hyprland tweaks for smoother NVIDIA experience
    environment.sessionVariables =
      lib.mkIf config.my.cuda.waylandTweaks {
        # Mutter/Wayland/Hyprland friendly flags
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        WLR_NO_HARDWARE_CURSORS = "1";
        # Some setups like this; harmless elsewhere:
        GBM_BACKEND = "nvidia-drm";
        LIBVA_DRIVER_NAME = "nvidia";
      };
  };
}
