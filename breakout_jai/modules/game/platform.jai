Platform :: struct {
  box: Box;
  speed: float;
}

new_platform :: (center: Vector2, size: Vector2, color: Color, speed: float) -> Platform {
  return .{ new_box(center, size, color), speed};
}

draw :: (platform: *Platform) {
  draw(*platform.box);
}

collides :: (platform: *Platform, rect: *Rectangle) -> Collision, bool {
  c, ok := collides(*platform.box.rect, rect);
  return c, ok;
}

update :: (platform: *Platform, scene: *Scene, dt: float) {
  if IsKeyDown(xx KEY_LEFT) move(*platform.box.rect, .{ -platform.speed * dt, 0 });
  if IsKeyDown(xx KEY_RIGHT) move(*platform.box.rect, .{ platform.speed * dt, 0 });

  c, ok := collides(scene, *platform.box.rect);
  if ok {
    if 0.0 < c.normal.x {
      set_pos(
        *platform.box.rect,
        .{ c.pos.x + platform.box.rect.width / 2.0, pos(platform.box.rect).y }
      );
    } else {
      set_pos(
        *platform.box.rect,
        .{ c.pos.x - platform.box.rect.width / 2.0, pos(platform.box.rect).y }
      );
    }
  }
}

#import,file "box.jai";
#import,file "scene.jai";
#import,file "raylib.jai";
#import,file "collision.jai";
