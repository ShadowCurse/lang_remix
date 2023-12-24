const rl = @import("raylib.zig");
const std = @import("std");
const collision = @import("collision.zig");

const Collider = collision.Collider;
const Collision = collision.Collision;

pub const Box = struct {
    const Self = @This();

    collider: Collider,
    color: rl.Color,

    pub fn new(center: rl.Vector2, size: rl.Vector2, color: rl.Color) Self {
        return Self{
            .collider = Collider.new(center, size, box_collision),
            .color = color,
        };
    }

    pub fn draw(self: *const Self) void {
        rl.DrawRectangleRec(self.collider.rect.inner(), self.color);
    }

    pub fn collides(self: *const Self, collider: *const Collider) ?Collision {
        return self.collider.collides(collider);
    }

    fn box_collision(this: *const Collider, other: *const Collider) ?Collision {
        if (this == other) return null;

        const this_rect = this.rect;
        const other_rect = other.rect;

        if (this_rect.equals(&other_rect)) return null;

        const dx = other_rect.pos().x - this_rect.pos().x;
        const px =
            (other_rect.width() / 2.0 + this_rect.width() / 2.0) - @fabs(dx);
        if (px <= 0) return null;

        const dy = other_rect.pos().y - this_rect.pos().y;
        const py =
            (other_rect.height() / 2.0 + this_rect.height() / 2.0) - @fabs(dy);
        if (py <= 0) return null;

        if (px < py) {
            var sx: f32 = 0;
            if (dx < 0) {
                sx = -1.0;
            } else {
                sx = 1.0;
            }
            return Collision{
                .normal = rl.Vector2{ .x = sx, .y = 0 },
                .pos = rl.Vector2{ .x = this_rect.pos().x + (this_rect.width() / 2.0 * sx), .y = other_rect.pos().y },
            };
        } else {
            var sy: f32 = 0;
            if (dy < 0) {
                sy = -1.0;
            } else {
                sy = 1.0;
            }
            return Collision{
                .normal = rl.Vector2{ .x = 0, .y = sy },
                .pos = rl.Vector2{ .x = other_rect.pos().x, .y = this_rect.pos().y + (this_rect.height() / 2.0 * sy) },
            };
        }
    }
};

test "box collision self" {
    const box = Box.new(rl.Vector2{ .x = 10, .y = 10 }, rl.Vector2{ .x = 10, .y = 10 }, rl.GREEN);
    try std.testing.expectEqual(box.collides(&box.collider), null);
}

test "box collision same" {
    const box = Box.new(rl.Vector2{ .x = 10, .y = 10 }, rl.Vector2{ .x = 10, .y = 10 }, rl.GREEN);
    const box2 = Box.new(rl.Vector2{ .x = 10, .y = 10 }, rl.Vector2{ .x = 10, .y = 10 }, rl.GREEN);
    try std.testing.expectEqual(box.collider.collides(&box2.collider), null);
}

test "box collision right" {
    const box = Box.new(rl.Vector2{ .x = 10, .y = 10 }, rl.Vector2{ .x = 10, .y = 10 }, rl.GREEN);
    const box2 = Box.new(rl.Vector2{ .x = 18, .y = 10 }, rl.Vector2{ .x = 10, .y = 10 }, rl.GREEN);
    const this_collision = box.collider.collides(&box2.collider);
    const req_collision = Collision{ .pos = rl.Vector2{ .x = 15, .y = 10 }, .normal = rl.Vector2{ .x = 1, .y = 0 } };
    try std.testing.expectEqual(this_collision, req_collision);
}

test "box collision left" {
    const box = Box.new(rl.Vector2{ .x = 10, .y = 10 }, rl.Vector2{ .x = 10, .y = 10 }, rl.GREEN);
    const box2 = Box.new(rl.Vector2{ .x = 8, .y = 10 }, rl.Vector2{ .x = 10, .y = 10 }, rl.GREEN);
    const this_collision = box.collider.collides(&box2.collider);
    const req_collision = Collision{ .pos = rl.Vector2{ .x = 5, .y = 10 }, .normal = rl.Vector2{ .x = -1, .y = 0 } };
    try std.testing.expectEqual(this_collision, req_collision);
}

test "box collision top" {
    const box = Box.new(rl.Vector2{ .x = 10, .y = 10 }, rl.Vector2{ .x = 10, .y = 10 }, rl.GREEN);
    const box2 = Box.new(rl.Vector2{ .x = 10, .y = 8 }, rl.Vector2{ .x = 10, .y = 10 }, rl.GREEN);
    const this_collision = box.collider.collides(&box2.collider);
    const req_collision = Collision{ .pos = rl.Vector2{ .x = 10, .y = 5 }, .normal = rl.Vector2{ .x = 0, .y = -1 } };
    try std.testing.expectEqual(this_collision, req_collision);
}

test "box collision bot" {
    const box = Box.new(rl.Vector2{ .x = 10, .y = 10 }, rl.Vector2{ .x = 10, .y = 10 }, rl.GREEN);
    const box2 = Box.new(rl.Vector2{ .x = 10, .y = 18 }, rl.Vector2{ .x = 10, .y = 10 }, rl.GREEN);
    const this_collision = box.collider.collides(&box2.collider);
    const req_collision = Collision{ .pos = rl.Vector2{ .x = 10, .y = 15 }, .normal = rl.Vector2{ .x = 0, .y = 1 } };
    try std.testing.expectEqual(this_collision, req_collision);
}
