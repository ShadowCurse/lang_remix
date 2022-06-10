const rl = @import("raylib.zig");
const collision = @import("collision.zig");
const Box = @import("box.zig").Box;
const Scene = @import("scene.zig").Scene;

const Vector2 = rl.Vector2;
const Color = rl.Color;
const IsKeyDown = rl.IsKeyDown;
const KEY_LEFT = rl.KEY_LEFT;
const KEY_RIGHT = rl.KEY_RIGHT;

const Collider = collision.Collider;
const Collision = collision.Collision;

pub const Platform = struct {
    const Self = @This();

    box: Box,
    speed: f32,

    pub fn new(center: Vector2, size: Vector2, color: Color, speed: f32) Self {
        return Self{
            .box = Box.new(
                center,
                size,
                color,
            ),
            .speed = speed,
        };
    }

    pub fn draw(self: *const Self) void {
        self.box.draw();
    }

    pub fn collides(self: *const Self, collider: *const Collider) ?Collision {
        return self.box.collides(collider);
    }

    pub fn update(self: *Self, scene: *const Scene, dt: f32) void {
        if (IsKeyDown(KEY_LEFT)) {
            self.box.collider.rect.move(Vector2{ .x = -self.speed * dt, .y = 0 });
        }
        if (IsKeyDown(KEY_RIGHT)) {
            self.box.collider.rect.move(Vector2{ .x = self.speed * dt, .y = 0 });
        }

        const col = scene.collides(&self.box.collider);
        if (col) |c| {
            if (0.0 < c.normal.x) {
                self.box.collider.rect.set_pos(Vector2{ .x = c.pos.x + self.box.collider.rect.width() / 2.0, .y = self.box.collider.rect.pos().y });
            } else {
                self.box.collider.rect.set_pos(Vector2{ .x = c.pos.x - self.box.collider.rect.width() / 2.0, .y = self.box.collider.rect.pos().y });
            }
        }
    }
};
