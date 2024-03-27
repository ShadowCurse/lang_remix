use raylib_ffi::*;

mod ball;
mod crates;
mod platform;
mod scene;
mod utils;

const WIDTH: i32 = 800;
const HEIGHT: i32 = 450;
const TARGET_FPS: i32 = 80;
const BACKGROUND_COLOR: Color = colors::BLACK;
const SCENE_OUTLINE_COLOR: Color = colors::LIGHTGRAY;
const PLATFORM_COLOR: Color = colors::RED;
const BALL_COLOR: Color = colors::GREEN;
const CRATE_COLOR: Color = colors::GRAY;

fn main() {
    unsafe {
        InitWindow(WIDTH, HEIGHT, rl_str!("Breakout in Rust"));
        SetTargetFPS(TARGET_FPS);

        let camera = Camera2D {
            offset: Vector2 { x: 0.0, y: 0.0 },
            target: Vector2 { x: 0.0, y: 0.0 },
            rotation: 0.0,
            zoom: 1.0,
        };

        let scene = scene::SceneBorder::new(
            Vector2 {
                x: WIDTH as f32 * 0.5,
                y: HEIGHT as f32 * 0.5,
            },
            WIDTH as f32,
            HEIGHT as f32,
            1,
            SCENE_OUTLINE_COLOR,
        );

        let mut platform = platform::Platform::new(
            Vector2 {
                x: WIDTH as f32 * 0.5,
                y: HEIGHT as f32 * 0.8,
            },
            100.0,
            20.0,
            PLATFORM_COLOR,
            500.0,
        );

        let mut ball = ball::Ball::new(
            Vector2 {
                x: WIDTH as f32 * 0.5,
                y: HEIGHT as f32 * 0.75,
            },
            20.0,
            20.0,
            BALL_COLOR,
            Vector2 { x: 1.4, y: 1.0 },
            100.0,
        );

        let mut crate_pack = crates::CratePack::new(
            Vector2 {
                x: WIDTH as f32 * 0.5,
                y: HEIGHT as f32 * 0.2,
            },
            3,
            4,
            70.0,
            30.0,
            10.0,
            10.0,
            CRATE_COLOR,
        );

        while !WindowShouldClose() {
            let dt = GetFrameTime();
            platform.update(&scene, dt);
            ball.update(&scene, &platform, &mut crate_pack, dt);

            BeginDrawing();
            ClearBackground(BACKGROUND_COLOR);
            BeginMode2D(camera);

            scene.draw();
            crate_pack.draw();
            platform.draw();
            ball.draw();

            EndMode2D();
            EndDrawing();
        }
        CloseWindow();
    }
}
