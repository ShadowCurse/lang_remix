Ball :: struct {
  box: Box;
  velocity: Vector2;
  speed: float;
}

new_ball :: (center: Vector2, size: Vector2, velocity: Vector2, speed: float, color: Color) -> Ball {
  return .{ new_box(center, size, color), velocity, speed };
}

draw :: (ball: *Ball) {
  draw(*ball.box);
}

update :: (ball: *Ball, scene: *Scene, platform: *Platform, crate_pack: *CratePack, dt: float) {
  move(*ball.box.rect, .{ ball.velocity.x * ball.speed * dt, ball.velocity.y * ball.speed * dt });

  check_collision(ball, scene);
  check_collision(ball, platform);
  check_collision(ball, crate_pack);
}

check_collision :: (ball: *Ball, other: *$T) {
  c, ok := collides(other, *ball.box.rect);
  if ok apply_collision(ball, c);
}

apply_collision :: (ball: *Ball, c: Collision) {
  if c.normal.x != 0.0 ball.velocity.x *= -1.0;
  if c.normal.y != 0.0 ball.velocity.y *= -1.0;
}

#import,file "box.jai";
#import,file "scene.jai";
#import,file "crate.jai";
#import,file "raylib.jai";
#import,file "platform.jai";
#import,file "collision.jai";
