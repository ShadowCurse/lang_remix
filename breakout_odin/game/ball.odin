package game

import rl "vendor:raylib"

Ball :: struct {
    box:      Box,
    velocity: rl.Vector2,
    speed:    f32,
}

ball_update :: proc(
    ball: ^Ball,
    scene: ^Scene,
    platform: ^Platform,
    crate_pack: ^CratePack,
    dt: f32,
) {
    rect_move(&ball.box.rect, ball.velocity * ball.speed * dt)

    scene_collision := rect_border_collision(&ball.box.rect, &scene.box.rect)
    if scene_collision != nil {
        ball_apply_collision(ball, scene_collision.(Collision))
    }

    platform_collision := rect_rect_collision(
        &ball.box.rect,
        &platform.box.rect,
    )
    if platform_collision != nil {
        ball_apply_collision(ball, platform_collision.(Collision))
    }

    crates_collision := crate_pack_collision(crate_pack, &ball.box.rect)
    if crates_collision != nil {
        ball_apply_collision(ball, crates_collision.(Collision))
    }
}

ball_apply_collision :: proc(ball: ^Ball, collision: Collision) {
    if (collision.normal.x != 0.0) {
        ball.velocity.x *= -1.0
    }
    if (collision.normal.y != 0.0) {
        ball.velocity.y *= -1.0
    }
}

ball_draw :: proc(ball: ^Ball) {
    box_draw(&ball.box)
}
