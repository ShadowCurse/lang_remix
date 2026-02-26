new_rect :: (center: Vector2, size: Vector2) -> Rectangle {
  return .{
    x = center.x - size.x / 2.0,
    y = center.y - size.y / 2.0,
    width = size.x,
    height = size.y,
  };
}

operator == :: (r1: Rectangle, r2: Rectangle) -> bool {
  return (r1.x == r2.x) && (r1.y == r2.y) && (r1.width == r2.width) && (r1.height == r2.height);
}

set_pos :: (cr: *Rectangle, new_pos: Vector2) {
  cr.x = new_pos.x - cr.width / 2.0;
  cr.y = new_pos.y - cr.height / 2.0;
}

move :: (cr: *Rectangle, direction: Vector2) {
  cr.x += direction.x;
  cr.y += direction.y;
}

pos :: (cr: Rectangle) -> Vector2 {
  return .{ cr.x + cr.width / 2.0, cr.y + cr.height / 2.0 };
}

top :: (cr: Rectangle) -> float {
  return cr.y;
}

bot :: (cr: Rectangle) -> float {
  return cr.y + cr.height;
}

left :: (cr: Rectangle) -> float {
  return cr.x;
}

right :: (cr: Rectangle) -> float {
  return cr.x + cr.width;
}

Collision :: struct {
  pos:    Vector2;
  normal: Vector2;
}

operator == :: (r1: Collision, r2: Collision) -> bool {
  return r1.pos == r2.pos && r1.normal == r2.normal;
}

collides :: (r1: *Rectangle, r2: *Rectangle) -> Collision, bool {
  if r1 == r2 return {}, false;
  if r1.* == r2.* return {}, false;

  dx := pos(r2).x - pos(r1).x;
  px := (r2.width / 2.0 + r1.width / 2.0) - Math.abs(dx);
  if px <= 0 return {}, false;

  dy := pos(r2).y - pos(r1).y;
  py := (r2.height / 2.0 + r1.height / 2.0) - Math.abs(dy);
  if py <= 0 return {}, false;

  if px < py {
    sx := ifx dx < 0 then -1 else 1;
    return .{
      normal = .{ xx sx, 0 },
      pos = .{ pos(r1).x + (r1.width / 2.0 * sx), pos(r2).y },
    }, true;
  } else {
    sy := ifx dy < 0 then -1 else 1;
    return .{
      normal = .{ 0, xx sy },
      pos = .{ pos(r2).x, pos(r1).y + (r1.height / 2.0 * sy) },
    }, true;
  }
}

#import,file "raylib.jai";
