package game

import rl "vendor:raylib"

Box :: struct {
    rect:           rl.Rectangle,
    line_thickness: f32,
    color:          rl.Color,
}

box_draw :: proc(box: ^Box) {
    rl.DrawRectangleRec(box.rect, box.color)
}

box_draw_with_lines :: proc(box: ^Box) {
    rl.DrawRectangleLinesEx(box.rect, box.line_thickness, box.color)
}
