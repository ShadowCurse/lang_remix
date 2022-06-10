const rl = @import("raylib.zig");
const std = @import("std");
const collision = @import("collision.zig");
const Box = @import("box.zig").Box;

const Vector2 = rl.Vector2;
const Color = rl.Color;

const Collider = collision.Collider;
const Collision = collision.Collision;

pub const Crate = struct {
    const Self = @This();

    box: Box,
    disabled: bool,

    pub fn new(center: Vector2, size: Vector2, color: Color) Self {
        return Self{
            .box = Box.new(
                center,
                size,
                color,
            ),
            .disabled = false,
        };
    }

    pub fn draw(self: *const Self) void {
        if (!self.disabled)
            self.box.draw();
    }

    pub fn collides(self: *const Self, collider: *const Collider) ?Collision {
        if (self.disabled)
            return null;
        return self.box.collides(collider);
    }
};

pub const CratePack = struct {
    const Self = @This();

    crates: std.ArrayList(Crate),

    pub fn new(pos: Vector2, rows: u32, cols: u32, width: f32, height: f32, gap_x: f32, gap_y: f32, color: Color) !Self {
        var s_pos = pos;
        if (rows % 2 == 0) {
            s_pos.y += (gap_y / 2.0 + height / 2.0) -
                (gap_y + height) * (@intToFloat(f32, rows - 1) / 2);
        } else {
            s_pos.y += (gap_y + height) * (@intToFloat(f32, rows - 1) / 2);
        }
        if (cols % 2 == 0) {
            s_pos.x -=
                (gap_x / 2.0 + width / 2.0) + (gap_x + width) * (@intToFloat(f32, cols - 1) / 2);
        } else {
            s_pos.x -= (gap_x + width) * (@intToFloat(f32, cols - 1) / 2);
        }

        var crates: std.ArrayList(Crate) = std.ArrayList(Crate).init(std.heap.page_allocator);
        var x: u32 = 0;
        while (x < cols) : (x += 1) {
            var y: u32 = 0;
            while (y < rows) : (y += 1) {
                const crate_pos = Vector2{
                    .x = s_pos.x + @intToFloat(f32, x) * (width + gap_x),
                    .y = s_pos.y + @intToFloat(f32, y) * (height + gap_y),
                };
                const crate = Crate.new(crate_pos, Vector2{ .x = width, .y = height }, color);
                try crates.append(crate);
            }
        }
        return Self{
            .crates = crates,
        };
    }

    pub fn deinit(self: *Self) void {
        self.crates.deinit();
    }

    pub fn draw(self: *const Self) void {
        for (self.crates.items) |crate| {
            crate.draw();
        }
    }

    pub fn collides(self: *Self, collider: *const Collider) ?Collision {
        for (self.crates.items) |*crate| {
            const c = crate.collides(collider);
            if (c) |value| {
                crate.disabled = true;
                return value;
            }
        }
        return null;
    }
};
