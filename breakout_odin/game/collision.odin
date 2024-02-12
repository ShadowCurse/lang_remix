package game

import "core:math"
import rl "vendor:raylib"

Collision :: struct {
    pos:    rl.Vector2,
    normal: rl.Vector2,
}

rect_new :: proc(pos: rl.Vector2, size: rl.Vector2) -> rl.Rectangle {
    return(
        rl.Rectangle {
            x = pos.x - size.x / 2.0,
            y = pos.y - size.y / 2.0,
            width = size.x,
            height = size.y,
        } \
    )

}

rect_set_pos :: proc(rect: ^rl.Rectangle, pos: rl.Vector2) {
    rect.x = pos.x - rect.width / 2.0
    rect.y = pos.y - rect.height / 2.0
}

rect_move :: proc(rect: ^rl.Rectangle, vec: rl.Vector2) {
    rect.x += vec.x
    rect.y += vec.y
}

rect_pos :: proc(rect: ^rl.Rectangle) -> rl.Vector2 {
    return rl.Vector2{rect.x + rect.width / 2.0, rect.y + rect.height / 2.0}
}

rect_width :: proc(rect: ^rl.Rectangle) -> f32 {
    return rect.width
}

rect_height :: proc(rect: ^rl.Rectangle) -> f32 {
    return rect.height
}

rect_top :: proc(rect: ^rl.Rectangle) -> f32 {
    return rect.y
}

rect_bot :: proc(rect: ^rl.Rectangle) -> f32 {
    return rect.y + rect.height
}

rect_left :: proc(rect: ^rl.Rectangle) -> f32 {
    return rect.x
}

rect_right :: proc(rect: ^rl.Rectangle) -> f32 {
    return rect.x + rect.width
}

rect_rect_collision :: proc(
    rect_1: ^rl.Rectangle,
    rect_2: ^rl.Rectangle,
) -> Option(Collision) {
    if rect_1 == rect_2 {
        return nil
    }

    dx := rect_pos(rect_2).x - rect_pos(rect_1).x
    px := (rect_width(rect_2) / 2.0 + rect_width(rect_1) / 2.0) - math.abs(dx)
    if px <= 0 {
        return nil
    }

    dy := rect_pos(rect_2).y - rect_pos(rect_1).y
    py :=
        (rect_height(rect_2) / 2.0 + rect_height(rect_1) / 2.0) - math.abs(dy)
    if py <= 0 {
        return nil
    }

    collision: Collision
    if px < py {
        sx: f32 = dx < 0 ? -1.0 : 1.0
        collision.normal.x = sx
        collision.pos.x = rect_pos(rect_1).x + (rect_width(rect_1) / 2.0 * sx)
        collision.pos.y = rect_pos(rect_2).y
    } else {
        sy: f32 = dy < 0 ? -1 : 1
        collision.normal.y = sy
        collision.pos.x = rect_pos(rect_2).x
        collision.pos.y = rect_pos(rect_1).y + (rect_height(rect_1) / 2.0 * sy)
    }
    return collision
}

rect_border_collision :: proc(
    rect: ^rl.Rectangle,
    border: ^rl.Rectangle,
) -> Option(Collision) {
    if rect == border {
        return nil
    }

    if rect_left(rect) < rect_left(border) {
        return(
            Collision {
                rl.Vector2{rect_left(border), rect_pos(rect).y},
                rl.Vector2{1.0, 0.0},
            } \
        )
    } else if rect_right(border) < rect_right(rect) {
        return(
            Collision {
                rl.Vector2{rect_right(border), rect_pos(rect).y},
                rl.Vector2{-1.0, 0.0},
            } \
        )
    } else if rect_top(rect) < rect_top(border) {
        return(
            Collision {
                rl.Vector2{rect_pos(rect).x, rect_top(border)},
                rl.Vector2{0.0, 1.0},
            } \
        )
    } else if rect_bot(border) < rect_bot(rect) {
        return(
            Collision {
                rl.Vector2{rect_pos(rect).x, rect_bot(border)},
                rl.Vector2{0.0, -1.0},
            } \
        )
    } else {
        return nil
    }
}

import "core:testing"

@(test)
test_rect :: proc(_: ^testing.T) {
    rect := rect_new(rl.Vector2{0.0, 0.0}, rl.Vector2{10.0, 10.0})
    assert(rect_pos(&rect) == rl.Vector2{0.0, 0.0})
    assert(rect_left(&rect) == -5.0)
    assert(rect_right(&rect) == 5.0)
    assert(rect_top(&rect) == -5.0)
    assert(rect_bot(&rect) == 5.0)
}

@(test)
test_rect_rect_collision :: proc(_: ^testing.T) {
    rect1 := rect_new(rl.Vector2{0.0, 0.0}, rl.Vector2{10.0, 10.0})

    {
        collision := rect_rect_collision(&rect1, &rect1)
        assert(collision == nil)
    }

    rect2 := rect_new(rl.Vector2{8.0, 8.0}, rl.Vector2{4.0, 4.0})
    {
        collision := rect_rect_collision(&rect1, &rect2)
        assert(collision == nil)
    }
    {
        collision := rect_rect_collision(&rect2, &rect1)
        assert(collision == nil)
    }

    rect2 = rect_new(rl.Vector2{7.0, 4.0}, rl.Vector2{5.0, 4.0})

    {
        required_collison := Collision {
            pos = rl.Vector2{5.0, 4.0},
            normal = rl.Vector2{1.0, 0.0},
        }
        collision := rect_rect_collision(&rect1, &rect2)
        assert(collision != nil)
        assert(collision.(Collision) == required_collison)
    }

    {
        required_collison := Collision {
            pos = rl.Vector2{4.5, 0.0},
            normal = rl.Vector2{-1.0, 0.0},
        }
        collision := rect_rect_collision(&rect2, &rect1)
        assert(collision != nil)
        assert(collision.(Collision) == required_collison)
    }
}

@(test)
test_border_collision :: proc(_: ^testing.T) {
    border := rect_new(rl.Vector2{0.0, 0.0}, rl.Vector2{30.0, 30.0})

    // no collison left
    {
        rect := rect_new(rl.Vector2{-10.0, 0.0}, rl.Vector2{10.0, 5.0})
        collision := rect_border_collision(&rect, &border)
        assert(collision == nil)
    }

    // collison left
    {
        rect := rect_new(rl.Vector2{-10.0, 0.0}, rl.Vector2{11.0, 5.0})
        required_collison := Collision {
            pos = rl.Vector2{-15.0, 0.0},
            normal = rl.Vector2{1.0, 0.0},
        }
        collision := rect_border_collision(&rect, &border)
        assert(collision != nil)
        assert(collision.(Collision) == required_collison)
    }

    // no collison right
    {
        rect := rect_new(rl.Vector2{10.0, 0.0}, rl.Vector2{10.0, 5.0})
        collision := rect_border_collision(&rect, &border)
        assert(collision == nil)
    }

    // collison right
    {
        rect := rect_new(rl.Vector2{10.0, 0.0}, rl.Vector2{11.0, 5.0})
        required_collison := Collision {
            pos = rl.Vector2{15.0, 0.0},
            normal = rl.Vector2{-1.0, 0.0},
        }
        collision := rect_border_collision(&rect, &border)
        assert(collision != nil)
        assert(collision.(Collision) == required_collison)
    }

    // no collison top
    {
        rect := rect_new(rl.Vector2{0.0, -10.0}, rl.Vector2{5.0, 10.0})
        collision := rect_border_collision(&rect, &border)
        assert(collision == nil)
    }

    // collison top
    {
        rect := rect_new(rl.Vector2{0.0, -10.0}, rl.Vector2{5.0, 11.0})
        required_collison := Collision {
            pos = rl.Vector2{0.0, -15.0},
            normal = rl.Vector2{0.0, 1.0},
        }
        collision := rect_border_collision(&rect, &border)
        assert(collision != nil)
        assert(collision.(Collision) == required_collison)
    }

    // no collison bot
    {
        rect := rect_new(rl.Vector2{0.0, 10.0}, rl.Vector2{5.0, 10.0})
        collision := rect_border_collision(&rect, &border)
        assert(collision == nil)
    }

    // collison bot
    {
        rect := rect_new(rl.Vector2{0.0, 10.0}, rl.Vector2{5.0, 11.0})
        required_collison := Collision {
            pos = rl.Vector2{0.0, 15.0},
            normal = rl.Vector2{0.0, -1.0},
        }
        collision := rect_border_collision(&rect, &border)
        assert(collision != nil)
        assert(collision.(Collision) == required_collison)
    }
}
