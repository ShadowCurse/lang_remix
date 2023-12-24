package src

import (
	rl "github.com/gen2brain/raylib-go/raylib"
	"math"
)

type Rect rl.Rectangle

func rect_from_center(center rl.Vector2, width float32, height float32) Rect {
	return Rect{
		X:      center.X - width/2.0,
		Y:      center.Y - height/2.0,
		Width:  width,
		Height: height,
	}
}

func (self *Rect) pos() rl.Vector2 {
	return rl.Vector2{
		X: self.X + self.Width/2.0,
		Y: self.Y + self.Height/2.0,
	}
}

func (self *Rect) top() float32 {
	return self.Y
}

func (self *Rect) bot() float32 {
	return self.Y + self.Height
}

func (self *Rect) left() float32 {
	return self.X
}

func (self *Rect) right() float32 {
	return self.X + self.Width
}

func (self *Rect) raylib_rect() rl.Rectangle {
	return rl.Rectangle{
		X:      self.X,
		Y:      self.Y,
		Width:  self.Width,
		Height: self.Height,
	}
}

// impl Collider
func (self *Rect) rect() Option[*Rect] {
	return option_some(self)
}

func (self *Rect) collides(other Collider) Option[Collision] {
	var this_rect_opt = self.rect()
	var other_rect_opt = other.rect()

	if this_rect_opt.is_none() || other_rect_opt.is_none() {
		return option_none[Collision]()
	}

	var this_rect = this_rect_opt.unwrap()
	var other_rect = other_rect_opt.unwrap()

	if this_rect == other_rect {
		return option_none[Collision]()
	}

	var dx = other_rect.pos().X - this_rect.pos().X
	var px = (other_rect.Width+this_rect.Width)/2.0 - float32(math.Abs(float64(dx)))
	if px <= 0.0 {
		return option_none[Collision]()
	}

	var dy = other_rect.pos().Y - this_rect.pos().Y
	var py = (other_rect.Height+this_rect.Height)/2.0 - float32(math.Abs(float64(dy)))
	if py <= 0.0 {
		return option_none[Collision]()
	}

	if px < py {
		var sign float32
		if dx < 0.0 {
			sign = -1.0
		} else {
			sign = 1.0
		}
		return option_some(

			Collision{
				pos: rl.Vector2{
					X: this_rect.pos().X + this_rect.Width/2.0*sign,
					Y: other_rect.pos().Y,
				},
				normal: rl.Vector2{X: sign, Y: 0.0},
			},
		)
	} else {
		var sign float32
		if dy < 0.0 {
			sign = -1.0
		} else {
			sign = 1.0
		}
		return option_some(
			Collision{
				pos: rl.Vector2{
					X: other_rect.pos().X,
					Y: this_rect.pos().Y + this_rect.Height/2.0*sign,
				},
				normal: rl.Vector2{X: 0.0, Y: sign},
			})
	}
}
