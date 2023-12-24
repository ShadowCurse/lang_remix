package src

import (
	rl "github.com/gen2brain/raylib-go/raylib"
)

type SceneBorder struct {
	rectangle      Rect
	line_thickness float32
	line_color     rl.Color
}

func NewSceneBorder(center rl.Vector2, width float32, height float32, line_thickness float32, line_color rl.Color) SceneBorder {
	var rectangle = rect_from_center(center, width, height)
	return SceneBorder{
		rectangle:      rectangle,
		line_thickness: line_thickness,
		line_color:     line_color,
	}
}

func (self *SceneBorder) Draw() {
	rl.DrawRectangleLinesEx(self.rectangle.raylib_rect(), self.line_thickness, self.line_color)
}

// impl Collider
func (self *SceneBorder) rect() Option[*Rect] {
	return option_some(&self.rectangle)
}

func (self *SceneBorder) collides(other Collider) Option[Collision] {
	var this_rect_opt = self.rect()
	var other_rect_opt = other.rect()

	if this_rect_opt.is_none() || other_rect_opt.is_none() {
		return option_none[Collision]()
	}

	var this_rect = this_rect_opt.unwrap()
	var other_rect = other_rect_opt.unwrap()

	if other_rect.left() < this_rect.left() {
		return option_some(
			Collision{
				pos: rl.Vector2{
					X: this_rect.left(),
					Y: other_rect.pos().Y,
				},
				normal: rl.Vector2{X: 1.0, Y: 0.0},
			})
	} else if this_rect.right() < other_rect.right() {
		return option_some(
			Collision{
				pos: rl.Vector2{
					X: this_rect.right(),
					Y: other_rect.pos().Y,
				},
				normal: rl.Vector2{X: -1.0, Y: 0.0},
			})
	} else if other_rect.top() < this_rect.top() {
		return option_some(
			Collision{
				pos: rl.Vector2{
					X: other_rect.pos().X,
					Y: this_rect.top(),
				},
				normal: rl.Vector2{X: 0.0, Y: 1.0},
			})
	} else if this_rect.bot() < other_rect.bot() {
		return option_some(
			Collision{
				pos: rl.Vector2{
					X: other_rect.pos().X,
					Y: this_rect.bot(),
				},
				normal: rl.Vector2{X: 0.0, Y: -1.0},
			})
	} else {
		return option_none[Collision]()
	}
}
