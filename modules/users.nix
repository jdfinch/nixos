# modules/users.nix
{ pkgs, ... }:
{
  users.users.jdfinch = {
    isNormalUser = true;
    description = "James Finch";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = [ ]; # keep empty or move per-user packages to Home Manager later
  };
}
