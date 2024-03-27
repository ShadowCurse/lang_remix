{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  shellHook = ''export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath [
    pkgs.glew
    pkgs.libclang
    # pkgs.xorg.libX11
    # pkgs.xorg.libXcursor
    # pkgs.xorg.libXrandr
    # pkgs.xorg.libXi
    # pkgs.xorg.libXinerama
  ]}"'';
  buildInputs = with pkgs; [
    cargo
    glew
    cmake
    clang
    libclang
    libxkbcommon
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    xorg.libXinerama
    pkg-config
  ];
}
