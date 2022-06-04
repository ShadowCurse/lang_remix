use crate::utils::*;
use raylib::prelude::*;

#[derive(Debug, Default, Clone, Copy)]
pub struct Crate {
    rect: Rectangle,
    color: Color,
    disabled: bool,
}

impl Crate {
    pub fn new(pos: Vector2, width: f32, height: f32, color: Color) -> Self {
        let rect = Rectangle::from_center(pos, width, height);
        Self {
            rect,
            color,
            disabled: false,
        }
    }

    #[inline]
    pub fn disabled(&mut self) -> bool {
        self.disabled
    }

    #[inline]
    pub fn disable(&mut self) {
        self.disabled = true;
    }

    #[inline]
    pub fn draw(&self, handle: &mut RaylibMode2D<RaylibDrawHandle>) {
        if !self.disabled {
            handle.draw_rectangle_rec(self.rect, self.color);
        }
    }
}

impl Collider for Crate {
    #[inline]
    fn rect(&self) -> Option<&Rectangle> {
        Some(&self.rect)
    }

    #[inline]
    fn collides(&self, other: &impl Collider) -> Option<Collision> {
        self.rect.collides(other)
    }
}

#[derive(Debug, Default, Clone)]
pub struct CratePack {
    crates: Vec<Crate>,
}

impl CratePack {
    #[allow(clippy::too_many_arguments)]
    pub fn new(
        mut pos: Vector2,
        rows: u32,
        cols: u32,
        width: f32,
        height: f32,
        gap_x: f32,
        gap_y: f32,
        color: Color,
    ) -> Self {
        let mut crates = Vec::new();
        if rows % 2 == 0 {
            pos.y += (gap_y / 2.0 + height / 2.0) - (gap_y + height) * ((rows - 1) / 2) as f32;
        } else {
            pos.y += (gap_y + height) * ((rows - 1) / 2) as f32;
        }
        if cols % 2 == 0 {
            pos.x -= (gap_x / 2.0 + width / 2.0) + (gap_x + width) * ((cols - 1) / 2) as f32;
        } else {
            pos.x -= (gap_x + width) * ((cols - 1) / 2) as f32;
        }

        for x in 0..cols {
            for y in 0..rows {
                let pos = Vector2 {
                    x: pos.x + x as f32 * (width + gap_x),
                    y: pos.y + y as f32 * (height + gap_y),
                };
                let c = Crate::new(pos, width, height, color);
                crates.push(c);
            }
        }
        Self { crates }
    }

    pub fn draw(&self, handle: &mut RaylibMode2D<RaylibDrawHandle>) {
        for c in &self.crates {
            c.draw(handle);
        }
    }
}

impl Collider for CratePack {
    #[inline]
    fn rect(&self) -> Option<&Rectangle> {
        None
    }

    #[inline]
    fn collides_mut(&mut self, other: &impl Collider) -> Option<Collision> {
        for c in self.crates.iter_mut() {
            if !c.disabled() {
                if let Some(collision) = c.collides(other) {
                    c.disable();
                    return Some(collision);
                }
            }
        }
        None
    }
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn cratepack_new() {
        let crate_pack = CratePack::new(
            Vector2 { x: 0.0, y: 0.0 },
            1,
            1,
            10.0,
            10.0,
            2.0,
            2.0,
            Color::GREEN,
        );
        assert_eq!(crate_pack.crates.len(), 1);

        let crate_rect = Rectangle::from_center(Vector2 { x: 0.0, y: 0.0 }, 10.0, 10.0);
        assert_eq!(crate_pack.crates[0].rect, crate_rect);
    }

    #[test]
    fn cratepack_new_even_cols() {
        let crate_pack = CratePack::new(
            Vector2 { x: 0.0, y: 0.0 },
            1,
            2,
            10.0,
            10.0,
            2.0,
            2.0,
            Color::GREEN,
        );
        assert_eq!(crate_pack.crates.len(), 2);

        let crate_rect = Rectangle::from_center(Vector2 { x: -6.0, y: 0.0 }, 10.0, 10.0);
        assert_eq!(crate_pack.crates[0].rect, crate_rect);

        let crate_rect = Rectangle::from_center(Vector2 { x: 6.0, y: 0.0 }, 10.0, 10.0);
        assert_eq!(crate_pack.crates[1].rect, crate_rect);
    }

    #[test]
    fn cratepack_new_odd_cols() {
        let crate_pack = CratePack::new(
            Vector2 { x: 0.0, y: 0.0 },
            1,
            3,
            10.0,
            10.0,
            2.0,
            2.0,
            Color::GREEN,
        );
        assert_eq!(crate_pack.crates.len(), 3);

        let crate_rect = Rectangle::from_center(Vector2 { x: -12.0, y: 0.0 }, 10.0, 10.0);
        assert_eq!(crate_pack.crates[0].rect, crate_rect);

        let crate_rect = Rectangle::from_center(Vector2 { x: 0.0, y: 0.0 }, 10.0, 10.0);
        assert_eq!(crate_pack.crates[1].rect, crate_rect);

        let crate_rect = Rectangle::from_center(Vector2 { x: 12.0, y: 0.0 }, 10.0, 10.0);
        assert_eq!(crate_pack.crates[2].rect, crate_rect);
    }
}
