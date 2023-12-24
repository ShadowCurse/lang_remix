const rl = @import("raylib.zig");
const collision = @import("collision.zig");

const Vector2 = rl.Vector2;
const Color = rl.Color;
const DrawRectangleLinesEx = rl.DrawRectangleLinesEx;

const Collider = collision.Collider;
const Collision = collision.Collision;

pub const Scene = struct {
    const Self = @This();

    collider: Collider,
    line_tickness: f32,
    color: Color,

    pub fn new(comptime center: Vector2, comptime size: Vector2, comptime line_tickness: f32, comptime color: Color) Self {
        return Self{
            .collider = Collider.new(center, size, scene_collision),
            .line_tickness = line_tickness,
            .color = color,
        };
    }

    pub fn draw(self: *const Self) void {
        DrawRectangleLinesEx(self.collider.rect.inner(), self.line_tickness, self.color);
    }

    pub fn collides(self: *const Self, collider: *const Collider) ?Collision {
        return self.collider.collides(collider);
    }

    fn scene_collision(this: *const Collider, other: *const Collider) ?Collision {
        if (this == other) return null;

        const this_rect = this.rect;
        const other_rect = other.rect;

        if (this_rect.equals(&other_rect)) return null;

        if (other_rect.left() < this_rect.left()) {
            return Collision{
                .pos = Vector2{
                    .x = this_rect.left(),
                    .y = other_rect.pos().y,
                },
                .normal = Vector2{ .x = 1, .y = 0 },
            };
        } else if (this_rect.right() < other_rect.right()) {
            return Collision{
                .pos = Vector2{
                    .x = this_rect.right(),
                    .y = other_rect.pos().y,
                },
                .normal = Vector2{ .x = -1, .y = 0 },
            };
        } else if (other_rect.top() < this_rect.top()) {
            return Collision{
                .pos = Vector2{
                    .x = other_rect.pos().x,
                    .y = this_rect.top(),
                },
                .normal = Vector2{ .x = 0, .y = 1 },
            };
        } else if (this_rect.bot() < other_rect.bot()) {
            return Collision{
                .pos = Vector2{
                    .x = other_rect.pos().x,
                    .y = this_rect.bot(),
                },
                .normal = Vector2{ .x = 0, .y = -1 },
            };
        } else {
            return null;
        }
    }
};

const std = @import("std");
const Box = @import("box.zig").Box;

test "Box inside scene" {
    const scene = Scene.new(Vector2{ .x = 100, .y = 100 }, Vector2{ .x = 200, .y = 200 }, 2, rl.RED);
    const box = Box.new(Vector2{ .x = 10, .y = 10 }, Vector2{ .x = 10, .y = 10 }, rl.RED);
    const col = scene.collides(&box.collider);
    try std.testing.expect(col == null);
}

test "Box collision right" {
    const scene = Scene.new(Vector2{ .x = 100, .y = 100 }, Vector2{ .x = 200, .y = 200 }, 2, rl.RED);
    const box = Box.new(Vector2{ .x = 200, .y = 100 }, Vector2{ .x = 10, .y = 10 }, rl.RED);
    const col = scene.collides(&box.collider);
    try std.testing.expect(col != null);
    const req_col = Collision{ .pos = Vector2{ .x = 200, .y = 100 }, .normal = Vector2{ .x = -1, .y = 0 } };
    try std.testing.expectEqual(col, req_col);
}

test "Box collision left" {
    const scene = Scene.new(Vector2{ .x = 100, .y = 100 }, Vector2{ .x = 200, .y = 200 }, 2, rl.RED);
    const box = Box.new(Vector2{ .x = 0, .y = 100 }, Vector2{ .x = 10, .y = 10 }, rl.RED);
    const col = scene.collides(&box.collider);
    try std.testing.expect(col != null);
    const req_col = Collision{ .pos = Vector2{ .x = 0, .y = 100 }, .normal = Vector2{ .x = 1, .y = 0 } };
    try std.testing.expectEqual(col, req_col);
}

test "Box collision top" {
    const scene = Scene.new(Vector2{ .x = 100, .y = 100 }, Vector2{ .x = 200, .y = 200 }, 2, rl.RED);
    const box = Box.new(Vector2{ .x = 100, .y = 0 }, Vector2{ .x = 10, .y = 10 }, rl.RED);
    const col = scene.collides(&box.collider);
    try std.testing.expect(col != null);
    const req_col = Collision{ .pos = Vector2{ .x = 100, .y = 0 }, .normal = Vector2{ .x = 0, .y = 1 } };
    try std.testing.expectEqual(col, req_col);
}

test "Box collision bot" {
    const scene = Scene.new(Vector2{ .x = 100, .y = 100 }, Vector2{ .x = 200, .y = 200 }, 2, rl.RED);
    const box = Box.new(Vector2{ .x = 100, .y = 200 }, Vector2{ .x = 10, .y = 10 }, rl.RED);
    const col = scene.collides(&box.collider);
    try std.testing.expect(col != null);
    const req_col = Collision{ .pos = Vector2{ .x = 100, .y = 200 }, .normal = Vector2{ .x = 0, .y = -1 } };
    try std.testing.expectEqual(col, req_col);
}
