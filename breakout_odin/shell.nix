{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    odin
    ols
    raylib
    pkg-config
  ];
}
