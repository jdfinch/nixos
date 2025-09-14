{ pkgs, ... }:

with pkgs.vscode-extensions; [
  mkhl.direnv
  jnoortheen.nix-ide
  ms-python.python
  ms-python.debugpy
  ms-python.vscode-pylance
  ms-toolsai.jupyter
]
