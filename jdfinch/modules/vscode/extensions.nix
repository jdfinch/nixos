{ pkgs, ... }:

with pkgs.vscode-extensions; [
  mkhl.direnv
  jnoortheen.nix-ide
  ms-python.python
]
