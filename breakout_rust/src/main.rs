use raylib::prelude::*;

mod ball;
mod crates;
mod platform;
mod scene;
mod utils;

const WIDTH: i32 = 800;
const HEIGHT: i32 = 450;
const TARGET_FPS: u32 = 80;
const BACKGROUND_COLOR: Color = Color::BLACK;
const SCENE_OUTLINE_COLOR: Color = Color::LIGHTGRAY;
const PLATFORM_COLOR: Color = Color::RED;
const BALL_COLOR: Color = Color::GREEN;
const CRATE_COLOR: Color = Color::GRAY;

fn main() {
    let (mut rl, thread) = raylib::init()
        .size(WIDTH, HEIGHT)
        .title("Breakout in Rust")
        .build();

    rl.set_target_fps(TARGET_FPS);

    let camera = Camera2D {
        offset: Vector2::zero(),
        target: Vector2::zero(),
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

    while !rl.window_should_close() {
        let dt = rl.get_frame_time();
        platform.update(&scene, &rl, dt);
        ball.update(&scene, &platform, &mut crate_pack, dt);

        let mut d = rl.begin_drawing(&thread);
        d.clear_background(BACKGROUND_COLOR);
        let mut d2 = d.begin_mode2D(camera);

        scene.draw(&mut d2);
        crate_pack.draw(&mut d2);
        platform.draw(&mut d2);
        ball.draw(&mut d2);
    }
}
