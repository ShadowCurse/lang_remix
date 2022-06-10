const rl = @import("raylib.zig");
const std = @import("std");
const collision = @import("collision.zig");
const Box = @import("box.zig").Box;
const Scene = @import("scene.zig").Scene;
const Platform = @import("platform.zig").Platform;
const CratePack = @import("crate.zig").CratePack;

const Vector2 = rl.Vector2;
const Color = rl.Color;

const Collider = collision.Collider;
const Collision = collision.Collision;

pub const Ball = struct {
    const Self = @This();

    box: Box,
    velocity: Vector2,
    speed: f32,

    pub fn new(center: Vector2, size: Vector2, velocity: Vector2, speed: f32, color: Color) Self {
        return Self{
            .box = Box.new(
                center,
                size,
                color,
            ),
            .velocity = velocity,
            .speed = speed,
        };
    }

    pub fn draw(self: *const Self) void {
        self.box.draw();
    }

    pub fn collides(self: *const Self, collider: *const Collider) ?Collision {
        return self.box.collides(collider);
    }

    pub fn update(self: *Self, scene: *const Scene, platform: *const Platform, crate_pack: *CratePack, dt: f32) void {
        self.box.collider.rect.move(Vector2{ .x = self.velocity.x * self.speed * dt, .y = self.velocity.y * self.speed * dt });

        self.check_collision_const(Scene, scene);
        self.check_collision_const(Platform, platform);
        self.check_collision(CratePack, crate_pack);
    }

    fn check_collision_const(self: *Self, comptime T: type, other: *const T) void {
        const col = other.collides(&self.box.collider);
        if (col) |c| {
            self.apply_collision(c);
        }
    }

    fn check_collision(self: *Self, comptime T: type, other: *T) void {
        const col = other.collides(&self.box.collider);
        if (col) |c| {
            self.apply_collision(c);
        }
    }

    fn apply_collision(self: *Self, c: Collision) void {
        if (c.normal.x != 0.0) {
            self.velocity.x *= -1.0;
        }
        if (c.normal.y != 0.0) {
            self.velocity.y *= -1.0;
        }
    }
};
