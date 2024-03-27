use crate::crates::CratePack;
use crate::platform::Platform;
use crate::scene::SceneBorder;
use crate::utils::{Collider, Collision, RectUtils};
use raylib_ffi::*;

pub struct Ball {
    rect: Rectangle,
    color: Color,
    velocity: Vector2,
    speed: f32,
}

impl Ball {
    pub fn new(
        pos: Vector2,
        width: f32,
        height: f32,
        color: Color,
        velocity: Vector2,
        speed: f32,
    ) -> Self {
        let rect = Rectangle::from_center(pos, width, height);
        Self {
            rect,
            color,
            velocity,
            speed,
        }
    }

    #[inline]
    pub fn draw(&self) {
        unsafe {
            DrawRectangleRec(self.rect, self.color);
        }
    }

    pub fn update(
        &mut self,
        scene: &SceneBorder,
        platform: &Platform,
        crate_pack: &mut CratePack,
        dt: f32,
    ) {
        self.rect.x += self.velocity.x * self.speed * dt;
        self.rect.y += self.velocity.y * self.speed * dt;

        self.check_collision(scene);
        self.check_collision(platform);
        self.check_collision_mut(crate_pack);
    }

    fn check_collision(&mut self, collider: &impl Collider) {
        if let Some(collision) = collider.collides(self) {
            self.handle_collision(collision);
        }
    }
    fn check_collision_mut(&mut self, collider: &mut impl Collider) {
        if let Some(collision) = collider.collides_mut(self) {
            self.handle_collision(collision);
        }
    }
    fn handle_collision(&mut self, collision: Collision) {
        if collision.normal.x != 0.0 {
            self.velocity.x *= -1.0;
        }
        if collision.normal.y != 0.0 {
            self.velocity.y *= -1.0;
        }
    }
}

impl Collider for Ball {
    #[inline]
    fn rect(&self) -> Option<&Rectangle> {
        Some(&self.rect)
    }
}
