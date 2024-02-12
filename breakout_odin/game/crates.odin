package game

import rl "vendor:raylib"

Crate :: struct {
    box:      Box,
    disabled: bool,
}

CratePack :: struct {
    crates: [dynamic]Crate,
}

crate_pack_new :: proc(
    pos: rl.Vector2,
    rows: u32,
    cols: u32,
    width: f32,
    height: f32,
    gap_x: f32,
    gap_y: f32,
    color: rl.Color,
) -> CratePack {
    center := pos

    if rows % 2 == 0 {
        center.y +=
            (gap_y / 2.0 + height / 2.0) -
            (gap_y + height) * f32((rows - 1) / 2)
    } else {
        center.y += (gap_y + height) * f32((rows - 1) / 2)
    }
    if cols % 2 == 0 {
        center.x -=
            (gap_x / 2.0 + width / 2.0) + (gap_x + width) * f32((cols - 1) / 2)
    } else {
        center.x -= (gap_x + width) * f32((cols - 1) / 2)
    }

    crates: [dynamic]Crate
    for x: u32 = 0; x < cols; x += 1 {
        for y: u32 = 0; y < rows; y += 1 {
            crate_pos := rl.Vector2 {
                center.x + f32(x) * (f32(width) + gap_x),
                center.y + f32(y) * (f32(height) + gap_y),
            }
            crate := Crate {
                box = Box {
                    rect = rect_new(crate_pos, rl.Vector2{width, height}),
                    color = color,
                },
                disabled = false,
            }
            append(&crates, crate)
        }
    }

    return CratePack{crates = crates}
}

crate_pack_collision :: proc(
    crate_pack: ^CratePack,
    rect: ^rl.Rectangle,
) -> Option(Collision) {
    for _, i in crate_pack.crates {
        crate := &crate_pack.crates[i]
        if crate.disabled {
            continue
        }
        collision := rect_rect_collision(&crate.box.rect, rect)
        if collision != nil {
            crate.disabled = true
            return collision.(Collision)
        }
    }
    return nil
}

crate_pack_draw :: proc(crate_pack: ^CratePack) {
    for _, i in crate_pack.crates {
        crate := &crate_pack.crates[i]
        if crate.disabled {
            continue
        }
        box_draw(&crate.box)
    }
}

import "core:testing"
@(test)
test_crate_pack_new :: proc(_: ^testing.T) {
    crate_pack := crate_pack_new(
        rl.Vector2{0.0, 0.0},
        1,
        1,
        10.0,
        10.0,
        2.0,
        2.0,
        rl.GREEN,
    )
    assert(len(crate_pack.crates) == 1)

    crate_rect := rect_new(rl.Vector2{0.0, 0.0}, rl.Vector2{10.0, 10.0})
    assert(crate_pack.crates[0].box.rect == crate_rect)
}

@(test)
test_crate_pack_new_even_cols :: proc(_: ^testing.T) {
    crate_pack := crate_pack_new(
        rl.Vector2{0.0, 0.0},
        1,
        2,
        10.0,
        10.0,
        2.0,
        2.0,
        rl.GREEN,
    )
    assert(len(crate_pack.crates) == 2)

    crate_rect := rect_new(rl.Vector2{-6.0, 0.0}, rl.Vector2{10.0, 10.0})
    assert(crate_pack.crates[0].box.rect == crate_rect)

    crate_rect_2 := rect_new(rl.Vector2{6.0, 0.0}, rl.Vector2{10.0, 10.0})
    assert(crate_pack.crates[1].box.rect == crate_rect_2)
}

@(test)
test_crate_pack_new_odd_cols :: proc(_: ^testing.T) {
    crate_pack := crate_pack_new(
        rl.Vector2{0.0, 0.0},
        1,
        3,
        10.0,
        10.0,
        2.0,
        2.0,
        rl.GREEN,
    )
    assert(len(crate_pack.crates) == 3)

    crate_rect := rect_new(rl.Vector2{-12.0, 0.0}, rl.Vector2{10.0, 10.0})
    assert(crate_pack.crates[0].box.rect == crate_rect)

    crate_rect_1 := rect_new(rl.Vector2{0.0, 0.0}, rl.Vector2{10.0, 10.0})
    assert(crate_pack.crates[1].box.rect == crate_rect_1)

    crate_rect_2 := rect_new(rl.Vector2{12.0, 0.0}, rl.Vector2{10.0, 10.0})
    assert(crate_pack.crates[2].box.rect == crate_rect_2)
}
