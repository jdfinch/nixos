# jdfinch/modules/vscode/vscode.nix
{ config, pkgs, lib, ... }:

let
  # 1) Pure, store-safe source to enumerate:
  userDirStore = ./User;

  # 2) Build the absolute path to your working tree (no hardcoded user/home):
  repoRoot   = "${config.home.homeDirectory}/nixos";
  userRoot   = "${repoRoot}/${config.home.username}";
  userDirAbs = "${userRoot}/modules/vscode/User";

  oos  = config.lib.file.mkOutOfStoreSymlink;
  exts = import ./extensions.nix { inherit pkgs; };

  # Recursively gather *files only* from flake source; link to working tree.
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
            acc // (recFiles relPath srcNext)                     # recurse; no dir links
          else if typ == "regular" || typ == "symlink" then
            acc // {
              "${"Code/User/${relPath}"}" = {
                source = oos "${userDirAbs}/${relPath}";          # editable
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

  xdg.configFile = xdgLinks;  # creates ~/.config/Code/User/<each file>
}
