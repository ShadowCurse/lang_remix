package breakout

import game "game"
import rl "vendor:raylib"

WIDTH: i32 : 800
HEIGHT: i32 : 450
TARGET_FPS: i32 : 120
BACKGROUND_COLOR: rl.Color : rl.BLACK
SCENE_OUTLINE_COLOR: rl.Color : rl.LIGHTGRAY
PLATFORM_COLOR: rl.Color : rl.RED
BALL_COLOR: rl.Color : rl.GREEN
CRATE_COLOR: rl.Color : rl.GRAY

main :: proc() {
    rl.InitWindow(WIDTH, HEIGHT, "Breakout")
    rl.SetTargetFPS(TARGET_FPS)

    camera := rl.Camera2D {
        offset = rl.Vector2{},
        target = rl.Vector2{},
        rotation = 0.0,
        zoom = 1.0,
    }

    scene := game.Scene {
        box = game.Box {
            rect = game.rect_new(
                rl.Vector2{f32(WIDTH) * 0.5, f32(HEIGHT) * 0.5},
                rl.Vector2{f32(WIDTH), f32(HEIGHT)},
            ),
            line_thickness = 2.0,
            color = SCENE_OUTLINE_COLOR,
        },
    }

    platform := game.Platform {
        box = game.Box {
            rect = game.rect_new(
                rl.Vector2{f32(WIDTH) * 0.5, f32(HEIGHT) * 0.8},
                rl.Vector2{100.0, 20.0},
            ),
            line_thickness = 0.0,
            color = PLATFORM_COLOR,
        },
        speed = 500.0,
    }

    crate_pack := game.crate_pack_new(
        rl.Vector2{f32(WIDTH) * 0.5, f32(HEIGHT) * 0.2},
        3,
        4,
        70.0,
        30.0,
        10.0,
        10.0,
        CRATE_COLOR,
    )

    ball := game.Ball {
        box = game.Box {
            rect = game.rect_new(
                rl.Vector2{f32(WIDTH) * 0.5, f32(HEIGHT) * 0.5},
                rl.Vector2{30.0, 30.0},
            ),
            line_thickness = 0.0,
            color = BALL_COLOR,
        },
        velocity = rl.Vector2{1.4, 1.0},
        speed = 100.0,
    }

    for !rl.WindowShouldClose() {
        dt := rl.GetFrameTime()

        game.platform_update(&platform, &scene, dt)
        game.ball_update(&ball, &scene, &platform, &crate_pack, dt)

        rl.BeginDrawing()
        rl.ClearBackground(BACKGROUND_COLOR)

        game.scene_draw(&scene)
        game.crate_pack_draw(&crate_pack)
        game.ball_draw(&ball)
        game.platform_draw(&platform)

        rl.BeginMode2D(camera)
        rl.EndMode2D()

        rl.EndDrawing()
    }

    rl.CloseWindow()
}

//
// auto main() -> int {
//   InitWindow(WIDTH, HEIGHT, "Breakout");
//   SetTargetFPS(TARGET_FPS);
//
//   auto scene =
//       Scene({WIDTH * 0.5, HEIGHT * 0.5}, {WIDTH, HEIGHT}, 2, SCENE_OUTLINE_COLOR);
//
//   auto platform =
//       Platform({WIDTH * 0.5, HEIGHT * 0.8}, {100.0, 20.0}, PLATFORM_COLOR, 500.0);
//
//   auto camera = Camera2D{
//       .offset = Vector2{},
//       .target = Vector2{},
//       .rotation = 0.0,
//       .zoom = 1.0,
//   };
//
//   auto crate_pack = CratePack({WIDTH * 0.5, HEIGHT * 0.2}, 3, 4, 70.0, 30.0, 10.0, 10.0, CRATE_COLOR);
//
//   auto ball =
//       Ball({WIDTH * 0.5, HEIGHT * 0.5}, {30.0, 30.0}, BALL_COLOR, {1.4, 1.0}, 100.0);
//
//   while (!WindowShouldClose()) {
//     auto dt = GetFrameTime();
//
//     platform.update(scene, dt);
//     ball.update(scene, platform, crate_pack, dt);
//
//     BeginDrawing();
//     ClearBackground(BACKGROUND_COLOR);
//     BeginMode2D(camera);
//
//     scene.draw_lines();
//     crate_pack.draw();
//     ball.draw();
//     platform.draw();
//
//     EndMode2D();
//     EndDrawing();
//   }
//
//   CloseWindow();
//
//   return 0;
// }
