Crate :: struct {
  box: Box;
  disabled: bool;
}

new_crate :: (center: Vector2, size: Vector2, color: Color) -> Crate {
  return .{ new_box(center, size, color), false};
}

draw :: (crate: *Crate) {
  if !crate.disabled draw(*crate.box);
}

collides :: (crate: *Crate, rect: *Rectangle) -> Collision, bool {
  if crate.disabled return {}, false;
  c, ok := collides(*crate.box.rect, rect);
  return c, ok;
}

CratePack :: struct {
  crates: [..]Crate;
}

new_crate_pack :: (pos: Vector2, rows: u32, cols: u32, width: float, height: float,
                   gap_x: float, gap_y: float, color: Color) -> CratePack {
  s_pos := pos;
  if rows % 2 == 0 {
    s_pos.y += (gap_y / 2.0 + height / 2.0) - (gap_y + height) * cast(float)((rows - 1) / 2);
  } else {
    s_pos.y += (gap_y + height) * cast(float)((rows - 1) / 2);
  }
  if (cols % 2 == 0) {
    s_pos.x -= (gap_x / 2.0 + width / 2.0) + (gap_x + width) * cast(float)((cols - 1) / 2);
  } else {
    s_pos.x -= (gap_x + width) * cast(float)((cols - 1) / 2);
  }

  crates : [..]Crate;
  x: u32 = 0;
  for x: 0..cols - 1 {
    y: u32 = 0;
    for y: 0..rows - 1 {
      crate_pos : Vector2 = .{
        s_pos.x + x * (width + gap_x),
        s_pos.y + y * (height + gap_y),
      };
      crate := new_crate(crate_pos, .{ width, height }, color);
      array_add(*crates, crate);
    }
  }
  return .{crates};
}

draw :: (crate_pack: *CratePack) {
  for *crate: crate_pack.crates draw(crate);
}

collides :: (crate_pack: *CratePack, rect: *Rectangle) -> Collision, bool {
  for *crate: crate_pack.crates {
    c, ok := collides(crate, rect);
    if ok {
      crate.disabled = true;
      return c, true;
    }
  }
  return {}, false;
}

#import "Basic";
#import,file "box.jai";
#import,file "raylib.jai";
#import,file "collision.jai";
