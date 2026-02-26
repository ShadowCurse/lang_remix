Scene :: struct {
  rect: Rectangle;
  line_tickness : float;
  color: Color;
}


new_scene :: (center: Vector2, size: Vector2, line_tickness: float, color: Color) -> Scene {
  return .{ new_rect(center, size), line_tickness, color };
}

draw :: (scene: *Scene) {
  DrawRectangleLinesEx(scene.rect, scene.line_tickness, scene.color);
}

collides :: (scene: *Scene, other: *Rectangle) -> Collision, bool {
  scene_rect := scene.rect;
  other_rect := other.*;

  if scene_rect == other_rect return {}, false;

  if left(other_rect) < left(scene_rect) {
    return .{
      pos = .{
        x = left(scene_rect),
        y = pos(other_rect).y,
      },
      normal = .{ 1, 0 },
    }, true;
  } else if right(scene_rect) < right(other_rect) {
    return .{
      pos = .{
        x = right(scene_rect),
        y = pos(other_rect).y,
      },
      normal = .{ -1, 0 },
    }, true;
  } else if top(other_rect) < top(scene_rect) {
    return .{
      pos = .{
        x = pos(other_rect).x,
        y = top(scene_rect),
      },
      normal = .{ 0, 1 },
    }, true;
  } else if bot(scene_rect) < bot(other_rect) {
    return .{
      pos = .{
        x = pos(other_rect).x,
        y = bot(scene_rect),
      },
      normal = .{ 0, -1 },
    }, true;
  } else {
    return {}, false;
  }
}

#import,file "raylib.jai";
#import,file "collision.jai";
