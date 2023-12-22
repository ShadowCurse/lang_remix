{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    clang
    cmake
    glew
    gtest
    raylib
    pkg-config
  ];
}
