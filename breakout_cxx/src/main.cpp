#include "raylib.h"
#include "raymath.h"
#include "ball.hpp"
#include "box.hpp"
#include "crates.hpp"
#include "platform.hpp"
#include "scene.hpp"

constexpr int WIDTH = 800;
constexpr int HEIGHT = 450;
constexpr int TARGET_FPS = 80;
constexpr Color BACKGROUND_COLOR = BLACK;
constexpr Color SCENE_OUTLINE_COLOR = LIGHTGRAY;
constexpr Color PLATFORM_COLOR = RED;
constexpr Color BALL_COLOR = GREEN;
constexpr Color CRATE_COLOR = GRAY;

auto main() -> int {
  InitWindow(WIDTH, HEIGHT, "Breakout");
  SetTargetFPS(TARGET_FPS);

  auto scene =
      Scene({WIDTH * 0.5, HEIGHT * 0.5}, {WIDTH, HEIGHT}, 2, SCENE_OUTLINE_COLOR);

  auto platform =
      Platform({WIDTH * 0.5, HEIGHT * 0.8}, {100.0, 20.0}, PLATFORM_COLOR, 500.0);

  auto camera = Camera2D{
      .offset = Vector2{},
      .target = Vector2{},
      .rotation = 0.0,
      .zoom = 1.0,
  };

  auto crate_pack = CratePack({WIDTH * 0.5, HEIGHT * 0.2}, 3, 4, 70.0, 30.0, 10.0, 10.0, CRATE_COLOR);

  auto ball =
      Ball({WIDTH * 0.5, HEIGHT * 0.5}, {30.0, 30.0}, BALL_COLOR, {1.4, 1.0}, 100.0);

  while (!WindowShouldClose()) {
    auto dt = GetFrameTime();

    platform.update(scene, dt);
    ball.update(scene, platform, crate_pack, dt);

    BeginDrawing();
    ClearBackground(BACKGROUND_COLOR);
    BeginMode2D(camera);

    scene.draw_lines();
    crate_pack.draw();
    ball.draw();
    platform.draw();

    EndMode2D();
    EndDrawing();
  }

  CloseWindow();

  return 0;
}
