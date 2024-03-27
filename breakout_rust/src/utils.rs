use raylib_ffi::*;

// Trait for easier Vector2 use
pub trait Vector2Utils {
    fn eq(&self, other: &Self) -> bool;
}

impl Vector2Utils for Vector2 {
    fn eq(&self, other: &Self) -> bool {
        self.x == other.x && self.y == other.y
    }
}

// Trait for easier rectangle use
pub trait RectUtils {
    fn from_center(center: Vector2, width: f32, height: f32) -> Self;
    fn pos(&self) -> Vector2;
    fn top(&self) -> f32;
    fn bot(&self) -> f32;
    fn left(&self) -> f32;
    fn right(&self) -> f32;
    fn eq(&self, other: &Self) -> bool;
}

impl RectUtils for Rectangle {
    #[inline]
    fn from_center(center: Vector2, width: f32, height: f32) -> Self {
        Self {
            x: center.x - width / 2.0,
            y: center.y - height / 2.0,
            width,
            height,
        }
    }

    #[inline]
    fn pos(&self) -> Vector2 {
        Vector2 {
            x: self.x + self.width / 2.0,
            y: self.y + self.height / 2.0,
        }
    }

    #[inline]
    fn top(&self) -> f32 {
        self.y
    }

    #[inline]
    fn bot(&self) -> f32 {
        self.y + self.height
    }

    #[inline]
    fn left(&self) -> f32 {
        self.x
    }

    #[inline]
    fn right(&self) -> f32 {
        self.x + self.width
    }

    #[inline]
    fn eq(&self, other: &Self) -> bool {
        self.x == other.x
            && self.y == other.y
            && self.width == other.width
            && self.height == other.height
    }
}

// Represents collision between colliders
#[derive(Debug, Clone, Copy)]
pub struct Collision {
    pub pos: Vector2,
    pub normal: Vector2,
}

impl PartialEq for Collision {
    fn eq(&self, other: &Self) -> bool {
        self.pos.x == other.pos.x
            && self.pos.y == other.pos.y
            && self.normal.x == other.normal.x
            && self.normal.y == other.normal.y
    }
}

// Trait for determining collison
pub trait Collider {
    fn rect(&self) -> Option<&Rectangle>;
    fn collides(&self, _other: &impl Collider) -> Option<Collision> {
        None
    }
    fn collides_mut(&mut self, _other: &impl Collider) -> Option<Collision> {
        None
    }
}

impl Collider for Rectangle {
    #[inline]
    fn rect(&self) -> Option<&Rectangle> {
        Some(self)
    }

    fn collides(&self, other: &impl Collider) -> Option<Collision> {
        let this_rect = self.rect();
        let other_rect = other.rect();

        if this_rect.is_none() || other_rect.is_none() {
            return None;
        }

        let this_rect = this_rect.unwrap();
        let other_rect = other_rect.unwrap();

        if this_rect.eq(other_rect) {
            return None;
        }

        let dx = other_rect.pos().x - this_rect.pos().x;
        let px = (other_rect.width + this_rect.width) / 2.0 - dx.abs();
        if px <= 0.0 {
            return None;
        }

        let dy = other_rect.pos().y - this_rect.pos().y;
        let py = (other_rect.height + this_rect.height) / 2.0 - dy.abs();
        if py <= 0.0 {
            return None;
        }

        if px < py {
            let sign = dx.signum();
            Some(Collision {
                pos: Vector2 {
                    x: this_rect.pos().x + this_rect.width / 2.0 * sign,
                    y: other_rect.pos().y,
                },
                normal: Vector2 { x: sign, y: 0.0 },
            })
        } else {
            let sign = dy.signum();
            Some(Collision {
                pos: Vector2 {
                    x: other_rect.pos().x,
                    y: this_rect.pos().y + this_rect.height / 2.0 * sign,
                },
                normal: Vector2 { x: 0.0, y: sign },
            })
        }
    }
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn rect_utils() {
        let pos = Vector2 { x: 0.0, y: 0.0 };
        let width = 10.0;
        let height = 10.0;
        let rect = Rectangle::from_center(pos, width, height);
        assert!(rect.pos().eq(&Vector2 { x: 0.0, y: 0.0 }));
        assert_eq!(rect.left(), -5.0);
        assert_eq!(rect.right(), 5.0);
        assert_eq!(rect.top(), -5.0);
        assert_eq!(rect.bot(), 5.0);
    }

    #[test]
    fn rect_collison() {
        let pos = Vector2 { x: 0.0, y: 0.0 };
        let width = 10.0;
        let height = 10.0;
        let rect1 = Rectangle::from_center(pos, width, height);

        assert!(rect1.collides(&rect1).is_none());

        let pos = Vector2 { x: 8.0, y: 8.0 };
        let width = 4.0;
        let height = 4.0;
        let rect2 = Rectangle::from_center(pos, width, height);

        assert!(rect1.collides(&rect2).is_none());
        assert!(rect2.collides(&rect1).is_none());

        let pos = Vector2 { x: 7.0, y: 4.0 };
        let width = 5.0;
        let height = 4.0;
        let rect2 = Rectangle::from_center(pos, width, height);

        let required_collison = Collision {
            pos: Vector2 { x: 5.0, y: 4.0 },
            normal: Vector2 { x: 1.0, y: 0.0 },
        };
        let collision = rect1.collides(&rect2);
        assert!(collision.is_some());
        assert_eq!(collision.unwrap(), required_collison);

        let required_collison = Collision {
            pos: Vector2 { x: 4.5, y: 0.0 },
            normal: Vector2 { x: -1.0, y: 0.0 },
        };
        let collision = rect2.collides(&rect1);
        assert!(collision.is_some());
        assert_eq!(collision.unwrap(), required_collison);
    }
}
