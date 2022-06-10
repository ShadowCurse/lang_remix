const rl = @import("raylib.zig");
const std = @import("std");
const Ball = @import("ball.zig").Ball;
const Scene = @import("scene.zig").Scene;
const Platform = @import("platform.zig").Platform;
const CratePack = @import("crate.zig").CratePack;

const WIDTH = 800;
const HEIGHT = 450;
const TARGET_FPS = 80;
const BACKGROUND_COLOR = rl.BLACK;
const SCENE_OUTLINE_COLOR = rl.LIGHTGRAY;
const PLATFORM_COLOR = rl.RED;
const BALL_COLOR = rl.GREEN;
const CRATE_COLOR = rl.GRAY;

pub fn main() anyerror!void {
    rl.InitWindow(WIDTH, HEIGHT, "Breakout");
    defer rl.CloseWindow();

    rl.SetTargetFPS(TARGET_FPS);

    const scene =
        Scene.new(rl.Vector2{ .x = WIDTH * 0.5, .y = HEIGHT * 0.5 }, rl.Vector2{ .x = WIDTH, .y = HEIGHT }, 2, SCENE_OUTLINE_COLOR);

    var platform =
        Platform.new(rl.Vector2{ .x = WIDTH * 0.5, .y = HEIGHT * 0.8 }, rl.Vector2{ .x = 100, .y = 20 }, PLATFORM_COLOR, 500);

    const camera = rl.Camera2D{
        .offset = rl.Vector2{ .x = 0, .y = 0 },
        .target = rl.Vector2{ .x = 0, .y = 0 },
        .rotation = 0.0,
        .zoom = 1.0,
    };

    var crate_pack = try CratePack.new(rl.Vector2{ .x = WIDTH * 0.5, .y = HEIGHT * 0.2 }, 3, 4, 70, 30, 10, 10, CRATE_COLOR);
    defer crate_pack.deinit();

    var ball =
        Ball.new(rl.Vector2{ .x = WIDTH * 0.5, .y = HEIGHT * 0.5 }, rl.Vector2{ .x = 30, .y = 30 }, rl.Vector2{ .x = 1, .y = 1 }, 100, BALL_COLOR);

    while (!rl.WindowShouldClose()) {
        const dt = rl.GetFrameTime();

        platform.update(&scene, dt);
        ball.update(&scene, &platform, &crate_pack, dt);

        rl.BeginDrawing();
        rl.ClearBackground(BACKGROUND_COLOR);
        rl.BeginMode2D(camera);

        scene.draw();
        crate_pack.draw();
        ball.draw();
        platform.draw();

        rl.EndMode2D();
        rl.EndDrawing();
    }
}
