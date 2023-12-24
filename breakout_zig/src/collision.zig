const rl = @import("raylib.zig");

const Vector2 = rl.Vector2;
const Rectangle = rl.Rectangle;

pub const CollisionRect = struct {
    const Self = @This();

    rect: Rectangle,

    pub fn new(center: Vector2, size: Vector2) Self {
        return Self{ .rect = Rectangle{
            .x = center.x - size.x / 2.0,
            .y = center.y - size.y / 2.0,
            .width = size.x,
            .height = size.y,
        } };
    }

    pub fn equals(self: *const Self, other: *const Self) bool {
        return (self.rect.x == other.rect.x) and
            (self.rect.y == other.rect.y) and
            (self.rect.width == other.rect.width) and
            (self.rect.height == other.rect.height);
    }

    pub fn inner(self: *const Self) Rectangle {
        return self.rect;
    }

    pub fn set_pos(self: *Self, new_pos: Vector2) void {
        self.rect.x = new_pos.x - self.rect.width / 2.0;
        self.rect.y = new_pos.y - self.rect.height / 2.0;
    }

    pub fn move(self: *Self, direction: Vector2) void {
        self.rect.x += direction.x;
        self.rect.y += direction.y;
    }

    pub fn pos(self: *const Self) Vector2 {
        return Vector2{ .x = self.rect.x + self.rect.width / 2.0, .y = self.rect.y + self.rect.height / 2.0 };
    }

    pub fn width(self: *const Self) f32 {
        return self.rect.width;
    }

    pub fn height(self: *const Self) f32 {
        return self.rect.height;
    }

    pub fn top(self: *const Self) f32 {
        return self.rect.y;
    }

    pub fn bot(self: *const Self) f32 {
        return self.rect.y + self.rect.height;
    }

    pub fn left(self: *const Self) f32 {
        return self.rect.x;
    }

    pub fn right(self: *const Self) f32 {
        return self.rect.x + self.rect.width;
    }
};

pub const Collision = struct {
    pos: Vector2,
    normal: Vector2,
};

pub const Collider = struct {
    const Self = @This();
    const collision_fn = *const fn (self: *const Self, other: *const Self) ?Collision;

    collision_check: collision_fn,
    rect: CollisionRect,

    pub fn new(center: Vector2, size: Vector2, collision: collision_fn) Self {
        return Self{
            .rect = CollisionRect.new(center, size),
            .collision_check = collision,
        };
    }

    pub fn collides(self: *const Self, other: *const Self) ?Collision {
        return self.collision_check(self, other);
    }
};
