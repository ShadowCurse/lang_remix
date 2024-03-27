use crate::scene::SceneBorder;
use crate::utils::*;
use raylib_ffi::*;

#[derive(Debug, Clone, Copy)]
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
    pub fn draw(&self) {
        unsafe {
            DrawRectangleRec(self.rect, self.color);
        }
    }

    pub fn update(&mut self, scene: &SceneBorder, dt: f32) {
        unsafe {
            if IsKeyDown(enums::KeyboardKey::A as i32) {
                self.rect.x -= self.speed * dt;
            }
            if IsKeyDown(enums::KeyboardKey::D as i32) {
                self.rect.x += self.speed * dt;
            }
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
