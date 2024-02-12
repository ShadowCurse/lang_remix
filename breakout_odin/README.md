# Breakout in Zig

Simple breakout implementation using Odin and [raylib](https://www.raylib.com/)

## Build
Dependencies are handled by nix.
Raylib shipped with Odin seems to be outdated, so we link with nix version.

```bash
$ git clone https://github.com/ShadowCurse/lang_remix.git
$ cd lang_remix/breakout_zig
$ nix-shell
$ odin build . -extra-linker-flags="-lraylib"  
$ ./breakout_odin
```
