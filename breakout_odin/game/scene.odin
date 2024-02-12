package game

import rl "vendor:raylib"

Scene :: struct {
    box: Box,
}

scene_draw :: proc(scene: ^Scene) {
    box_draw_with_lines(&scene.box)
}
