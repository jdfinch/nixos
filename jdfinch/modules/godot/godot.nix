{ config, lib, ... }:
let
  homeDir = config.home.homeDirectory;
  repoHome = "${homeDir}/nixos/jdfinch/home";
in
{
  programs.zsh.shellAliases.godot = "${homeDir}/.local/bin/godot-hm";

  home.activation.godotSetup = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    mkdir -p "${homeDir}/Godot"
    mkdir -p "${homeDir}/.local/bin"
    mkdir -p "${homeDir}/.local/share/applications"
    mkdir -p "${repoHome}/.config/godot"

    ln -sfn "${repoHome}/.local/bin/godot-hm" "${homeDir}/.local/bin/godot-hm"
    ln -sfn \
      "${repoHome}/.local/share/applications/org.godotengine.Godot4.4.desktop" \
      "${homeDir}/.local/share/applications/org.godotengine.Godot4.4.desktop"
  '';
}
