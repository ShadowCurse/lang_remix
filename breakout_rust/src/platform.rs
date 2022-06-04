use crate::scene::SceneBorder;
use crate::utils::*;
use raylib::prelude::*;

#[derive(Debug, Default, Clone, Copy)]
pub struct Platform {
    rect: Rectangle,
    color: Color,
    speed: f32,
}

impl Platform {
    pub fn new(pos: Vector2, width: f32, height: f32, color: Color, speed: f32) -> Self {
        let rect = Rectangle::from_center(pos, width, height);
        Self { rect, color, speed }
    }

    #[inline]
    pub fn draw(&self, handle: &mut RaylibMode2D<RaylibDrawHandle>) {
        handle.draw_rectangle_rec(self.rect, self.color);
    }

    pub fn update(&mut self, scene: &SceneBorder, handle: &RaylibHandle, dt: f32) {
        if handle.is_key_down(KeyboardKey::KEY_A) {
            self.rect.x -= self.speed * dt;
        }
        if handle.is_key_down(KeyboardKey::KEY_D) {
            self.rect.x += self.speed * dt;
        }
        if let Some(collision) = scene.collides(self) {
            if 0.0 <= collision.normal.x {
                self.rect.x = collision.pos.x;
            } else {
                self.rect.x = collision.pos.x - self.rect.width;
            }
        }
    }
}

impl Collider for Platform {
    #[inline]
    fn rect(&self) -> Option<&Rectangle> {
        Some(&self.rect)
    }

    #[inline]
    fn collides(&self, other: &impl Collider) -> Option<crate::utils::Collision> {
        self.rect.collides(other)
    }
}
