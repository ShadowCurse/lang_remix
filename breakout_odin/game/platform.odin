package game

import rl "vendor:raylib"

Platform :: struct {
    box:   Box,
    speed: f32,
}

platform_update :: proc(platform: ^Platform, scene: ^Scene, dt: f32) {
    if rl.IsKeyDown(rl.KeyboardKey.LEFT) {
        rect_move(&platform.box.rect, rl.Vector2{-platform.speed * dt, 0.0})
    }
    if rl.IsKeyDown(rl.KeyboardKey.RIGHT) {
        rect_move(&platform.box.rect, rl.Vector2{platform.speed * dt, 0.0})
    }

    scene_collision := rect_border_collision(
        &platform.box.rect,
        &scene.box.rect,
    )
    if scene_collision != nil {
        collision := scene_collision.(Collision)
        if 0.0 < collision.normal.x {
            rect_set_pos(
                &platform.box.rect,
                rl.Vector2 {
                    collision.pos.x + rect_width(&platform.box.rect) / 2.0,
                    rect_pos(&platform.box.rect).y,
                },
            )
        } else {
            rect_set_pos(
                &platform.box.rect,
                rl.Vector2 {
                    collision.pos.x - rect_width(&platform.box.rect) / 2.0,
                    rect_pos(&platform.box.rect).y,
                },
            )
        }
    }
}

platform_draw :: proc(platform: ^Platform) {
    box_draw(&platform.box)
}
