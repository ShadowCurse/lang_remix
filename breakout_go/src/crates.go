package src

import (
	rl "github.com/gen2brain/raylib-go/raylib"
)

type Crate struct {
	rectangle Rect
	color     rl.Color
	disabled  bool
}

func NewCrate(center rl.Vector2, width float32, height float32, color rl.Color) Crate {
	var rectangle = rect_from_center(center, width, height)
	return Crate{
		rectangle: rectangle,
		color:     color,
		disabled:  false,
	}
}

func (self *Crate) Draw() {
	if !self.disabled {
		rl.DrawRectangleRec(self.rectangle.raylib_rect(), self.color)
	}
}

// impl Collider
func (self *Crate) rect() Option[*Rect] {
	return option_some(&self.rectangle)
}

func (self *Crate) collides(other Collider) Option[Collision] {
	return self.rectangle.collides(other)
}

type CratePack struct {
	crates []Crate
}

func NewCratePack(
	pos rl.Vector2,
	rows uint32,
	cols uint32,
	width float32,
	height float32,
	gap_x float32,
	gap_y float32,
	color rl.Color,
) CratePack {
	var crates = make([]Crate, 0, cols*rows)
	if rows%2 == 0 {
		pos.Y += (gap_y/2.0 + height/2.0) - (gap_y+height)*float32((rows-1)/2)
	} else {
		pos.Y += (gap_y + height) * float32((rows-1)/2)
	}
	if cols%2 == 0 {
		pos.X -= (gap_x/2.0 + width/2.0) + (gap_x+width)*float32((cols-1)/2)
	} else {
		pos.X -= (gap_x + width) * float32((cols-1)/2)
	}

	for x := uint32(0); x < cols; x++ {
		for y := uint32(0); y < rows; y++ {
			var pos = rl.Vector2{
				X: pos.X + float32(x)*(width+gap_x),
				Y: pos.Y + float32(y)*(height+gap_y),
			}
			var c = NewCrate(pos, width, height, color)
			crates = append(crates, c)
		}
	}
	return CratePack{crates: crates}
}

func (self *CratePack) Draw() {
	for _, c := range self.crates {
		c.Draw()
	}
}

// impl Collider
func (self *CratePack) rect() Option[*Rect] {
	return option_none[*Rect]()
}

func (self *CratePack) collides(other Collider) Option[Collision] {
	for i := 0; i < len(self.crates); i++ {
		var c = &self.crates[i]
		if !c.disabled {
			var collision_opt = c.collides(other)
			if collision_opt.is_some() {
				c.disabled = true
				return collision_opt
			}
		}
	}
	return option_none[Collision]()
}
