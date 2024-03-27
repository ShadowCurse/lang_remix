use crate::utils::*;
use raylib_ffi::*;

/// Scene border
#[derive(Debug, Clone, Copy)]
pub struct SceneBorder {
    rect: Rectangle,
    line_thickness: i32,
    line_color: Color,
}

impl SceneBorder {
    pub fn new(
        center: Vector2,
        width: f32,
        height: f32,
        line_thickness: i32,
        line_color: Color,
    ) -> Self {
        let rect = Rectangle::from_center(center, width, height);
        Self {
            rect,
            line_thickness,
            line_color,
        }
    }

    #[inline]
    pub fn draw(&self) {
        unsafe {
            DrawRectangleLinesEx(self.rect, self.line_thickness as f32, self.line_color);
        }
    }
}

impl Collider for SceneBorder {
    #[inline]
    fn rect(&self) -> Option<&Rectangle> {
        Some(&self.rect)
    }

    fn collides(&self, other: &impl Collider) -> Option<Collision> {
        let this_rect = self.rect();
        let other_rect = other.rect();

        if this_rect.is_none() || other_rect.is_none() {
            return None;
        }

        let this_rect = this_rect.unwrap();
        let other_rect = other_rect.unwrap();

        if other_rect.left() < this_rect.left() {
            Some(Collision {
                pos: Vector2 {
                    x: this_rect.left(),
                    y: other_rect.pos().y,
                },
                normal: Vector2 { x: 1.0, y: 0.0 },
            })
        } else if this_rect.right() < other_rect.right() {
            Some(Collision {
                pos: Vector2 {
                    x: this_rect.right(),
                    y: other_rect.pos().y,
                },
                normal: Vector2 { x: -1.0, y: 0.0 },
            })
        } else if other_rect.top() < this_rect.top() {
            Some(Collision {
                pos: Vector2 {
                    x: other_rect.pos().x,
                    y: this_rect.top(),
                },
                normal: Vector2 { x: 0.0, y: 1.0 },
            })
        } else if this_rect.bot() < other_rect.bot() {
            Some(Collision {
                pos: Vector2 {
                    x: other_rect.pos().x,
                    y: this_rect.bot(),
                },
                normal: Vector2 { x: 0.0, y: -1.0 },
            })
        } else {
            None
        }
    }
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn scene_new() {
        let pos = Vector2 { x: 10.0, y: 10.0 };
        let width = 20.0;
        let height = 15.0;
        let line_thickness = 2;
        let line_color = colors::GOLD;
        let scene = SceneBorder::new(pos, width, height, line_thickness, line_color);

        let required_rect = Rectangle::from_center(pos, width, height);
        assert!(scene.rect.eq(&required_rect));
        assert_eq!(scene.line_thickness, line_thickness);
    }

    #[test]
    fn scene_rect() {
        let pos = Vector2 { x: 10.0, y: 10.0 };
        let width = 20.0;
        let height = 15.0;
        let line_thickness = 2;
        let line_color = colors::GOLD;
        let scene = SceneBorder::new(pos, width, height, line_thickness, line_color);

        let required_rect = Rectangle::from_center(pos, width, height);
        assert!(scene.rect().unwrap().eq(&required_rect));
    }

    #[test]
    fn scene_collision() {
        let pos = Vector2 { x: 0.0, y: 0.0 };
        let width = 30.0;
        let height = 30.0;
        let line_thickness = 2;
        let line_color = colors::GOLD;
        let scene = SceneBorder::new(pos, width, height, line_thickness, line_color);

        // no collison left
        let pos = Vector2 { x: -10.0, y: 0.0 };
        let width = 10.0;
        let height = 5.0;
        let not_colliding_rect = Rectangle::from_center(pos, width, height);

        let collision = scene.collides(&not_colliding_rect);
        dbg!(&collision);
        assert!(collision.is_none());

        // collison left
        let pos = Vector2 { x: -10.0, y: 0.0 };
        let width = 11.0;
        let height = 5.0;
        let colliding_rect = Rectangle::from_center(pos, width, height);

        let required_collison = Collision {
            pos: Vector2 { x: -15.0, y: 0.0 },
            normal: Vector2 { x: 1.0, y: 0.0 },
        };

        let collision = scene.collides(&colliding_rect);
        assert!(collision.is_some());
        assert_eq!(collision.unwrap(), required_collison);

        // no collison right
        let pos = Vector2 { x: 10.0, y: 0.0 };
        let width = 10.0;
        let height = 5.0;
        let not_colliding_rect = Rectangle::from_center(pos, width, height);

        let collision = scene.collides(&not_colliding_rect);
        assert!(collision.is_none());

        // collison right
        let pos = Vector2 { x: 10.0, y: 0.0 };
        let width = 11.0;
        let height = 5.0;
        let colliding_rect = Rectangle::from_center(pos, width, height);

        let required_collison = Collision {
            pos: Vector2 { x: 15.0, y: 0.0 },
            normal: Vector2 { x: -1.0, y: 0.0 },
        };

        let collision = scene.collides(&colliding_rect);
        assert!(collision.is_some());
        assert_eq!(collision.unwrap(), required_collison);

        // no collison top
        let pos = Vector2 { x: 0.0, y: -10.0 };
        let width = 5.0;
        let height = 10.0;
        let not_colliding_rect = Rectangle::from_center(pos, width, height);

        let collision = scene.collides(&not_colliding_rect);
        assert!(collision.is_none());

        // collison top
        let pos = Vector2 { x: 0.0, y: -10.0 };
        let width = 5.0;
        let height = 11.0;
        let colliding_rect = Rectangle::from_center(pos, width, height);

        let required_collison = Collision {
            pos: Vector2 { x: 0.0, y: -15.0 },
            normal: Vector2 { x: 0.0, y: 1.0 },
        };

        let collision = scene.collides(&colliding_rect);
        assert!(collision.is_some());
        assert_eq!(collision.unwrap(), required_collison);

        // no collison bot
        let pos = Vector2 { x: 0.0, y: 10.0 };
        let width = 5.0;
        let height = 10.0;
        let not_colliding_rect = Rectangle::from_center(pos, width, height);

        let collision = scene.collides(&not_colliding_rect);
        assert!(collision.is_none());

        // collison bot
        let pos = Vector2 { x: 0.0, y: 10.0 };
        let width = 5.0;
        let height = 11.0;
        let colliding_rect = Rectangle::from_center(pos, width, height);

        let required_collison = Collision {
            pos: Vector2 { x: 0.0, y: 15.0 },
            normal: Vector2 { x: 0.0, y: -1.0 },
        };

        let collision = scene.collides(&colliding_rect);
        assert!(collision.is_some());
        assert_eq!(collision.unwrap(), required_collison);
    }
}
