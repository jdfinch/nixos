# Reusable helper for Home Manager: recursively link *files only*
# from a flake source dir into XDG config, with editable out-of-store targets.
# Usage: import this file with { lib, config } and call recFilesOnlyXdg { … }.
{ lib, config }:

let
  oos = config.lib.file.mkOutOfStoreSymlink;

  # Build an attrset suitable for xdg.configFile by enumerating *files only*
  # from a store-safe source directory (srcRel), and linking each to a path
  # in your working tree (worktreeAbs). No directory links are created.
  #
  # Args:
  #   srcRel      : path    # e.g. ./User (relative to the caller .nix file)
  #   destPrefix  : string  # e.g. "Code/User" → ~/.config/Code/User/*
  #   worktreeAbs : string  # absolute path base in your repo for editable links
  recFilesOnlyXdg = { srcRel, destPrefix, worktreeAbs }:
    let
      go = relDir: srcDir:
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
                acc // (go relPath srcNext)  # recurse; DO NOT link dirs
              else if typ == "regular" || typ == "symlink" then
                acc // {
                  "${destPrefix}/${relPath}" = {
                    source = oos "${worktreeAbs}/${relPath}";
                    force  = true;
                  };
                }
              else acc;
        in lib.foldl' step {} names;
    in
      go "" srcRel;
in
{
  inherit recFilesOnlyXdg;
}
