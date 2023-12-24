{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    go
    glew
    wayland
    libxkbcommon
    pkg-config
  ];
}
