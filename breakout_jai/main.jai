WIDTH :: 800;
HEIGHT :: 450;
TARGET_FPS :: 120;
BACKGROUND_COLOR :: BLACK;
SCENE_OUTLINE_COLOR :: LIGHTGRAY;
PLATFORM_COLOR :: RED;
BALL_COLOR :: GREEN;
CRATE_COLOR :: GRAY;

main :: () {
  InitWindow(WIDTH, HEIGHT, "Breakout");
  defer CloseWindow();

  SetTargetFPS(TARGET_FPS);

  scene := new_scene(.{ WIDTH * 0.5, HEIGHT * 0.5 }, .{ WIDTH, HEIGHT }, 2, SCENE_OUTLINE_COLOR);
  platform := new_platform(.{ WIDTH * 0.5, HEIGHT * 0.8 }, .{ 100, 20 }, PLATFORM_COLOR, 500);
  camera : Camera2D = .{
    offset = .{ 0, 0 },
    target = .{ 0, 0 },
    rotation = 0.0,
    zoom = 1.0,
  };
  crate_pack := new_crate_pack(.{ WIDTH * 0.5, HEIGHT * 0.2 }, 3, 4, 70, 30, 10, 10, CRATE_COLOR);
  ball := new_ball(.{ WIDTH * 0.5, HEIGHT * 0.5 }, .{ 30, 30 }, .{ 1, 1 }, 100, BALL_COLOR);

  while !WindowShouldClose() {
    dt := GetFrameTime();

    update(*platform, *scene, dt);
    update(*ball, *scene, *platform, *crate_pack, dt);

    BeginDrawing();
    ClearBackground(BACKGROUND_COLOR);
    BeginMode2D(camera);

    draw(*scene);
    draw(*crate_pack);
    draw(*ball);
    draw(*platform);

    EndMode2D();
    EndDrawing();
  }
}

#import "game";
