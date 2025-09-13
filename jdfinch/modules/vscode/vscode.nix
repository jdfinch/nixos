{ config, pkgs, lib, ... }:

let
  userDirStore = ./User;  # enumerate from flake source (pure)

  repoRoot   = "${config.home.homeDirectory}/nixos";
  userRoot   = "${repoRoot}/${config.home.username}";
  userDirAbs = "${userRoot}/modules/vscode/User";

  oos  = config.lib.file.mkOutOfStoreSymlink;
  exts = import ./extensions.nix { inherit pkgs; };

  recFiles = relDir: srcDir:
    let
      entries = builtins.readDir srcDir;
      names   = builtins.attrNames entries;
      step = acc: name:
        let
          typ     = entries.${name};
          relPath = if relDir == "" then name else "${relDir}/${name}";
          srcNext = "${srcDir}/${name}";
        in
          if typ == "directory" then
            acc // (recFiles relPath srcNext)   # recurse; DO NOT link dirs
          else if typ == "regular" || typ == "symlink" then
            acc // {
              "${"Code/User/${relPath}"}" = {
                source = oos "${userDirAbs}/${relPath}";
                force  = true;
              };
            }
          else acc;
    in lib.foldl' step {} names;

  xdgLinks = recFiles "" userDirStore;
in
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default.extensions = exts;
  };

  # Only file links under ~/.config/Code/User/*
  xdg.configFile = xdgLinks;
}
