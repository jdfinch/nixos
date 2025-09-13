# jdfinch/modules/vscode/vscode.nix
{ config, pkgs, lib, ... }:

let
  # Absolute path to your repo, without hardcoding username/home:
  repoRoot   = "${config.home.homeDirectory}/nixos";
  userRoot   = "${repoRoot}/${config.home.username}";
  userDirAbs = "${userRoot}/modules/vscode/User";

  oos  = config.lib.file.mkOutOfStoreSymlink;
  exts = import ./extensions.nix { inherit pkgs; };

  # Recursively collect *files only* under User/, mapping each to ~/.config/Code/User/*
  recFiles = relDir: absDir:
    let
      entries = builtins.readDir absDir;
      names   = builtins.attrNames entries;
      step = acc: name:
        let
          typ     = entries.${name};
          relPath = if relDir == "" then name else "${relDir}/${name}";
          absPath = "${absDir}/${name}";
        in
          if typ == "directory" then
            acc // (recFiles relPath absPath)  # recurse, but do NOT link directories
          else if typ == "regular" || typ == "symlink" then
            acc // {
              "${"Code/User/${relPath}"}" = {
                source = oos absPath;   # out-of-store, editable
                force  = true;          # replace existing files
              };
            }
          else acc;
    in lib.foldl' step {} names;

  xdgLinks = recFiles "" userDirAbs;
in
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default.extensions = exts;
  };

  # Create individual file links under ~/.config/Code/User/*
  xdg.configFile = xdgLinks;
}
