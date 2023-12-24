package src

import (
	rl "github.com/gen2brain/raylib-go/raylib"
)

type Platform struct {
	rectangle Rect
	color     rl.Color
	speed     float32
}

func NewPlatform(center rl.Vector2, width float32, height float32, color rl.Color, speed float32) Platform {
	var rectangle = rect_from_center(center, width, height)
	return Platform{
		rectangle: rectangle,
		color:     color,
		speed:     speed,
	}
}

func (self *Platform) Draw() {
	rl.DrawRectangleRec(self.rectangle.raylib_rect(), self.color)
}

func (self *Platform) Update(scene *SceneBorder, dt float32) {
	if rl.IsKeyDown(rl.KeyA) {
		self.rectangle.X -= self.speed * dt
	}
	if rl.IsKeyDown(rl.KeyD) {
		self.rectangle.X += self.speed * dt
	}
	var collision_opt = scene.collides(self)
	if collision_opt.is_some() {
		var collision = collision_opt.unwrap()
		if 0.0 <= collision.normal.X {
			self.rectangle.X = collision.pos.X
		} else {
			self.rectangle.X = collision.pos.X - self.rectangle.Width
		}
	}
}

// impl Collider
func (self *Platform) rect() Option[*Rect] {
	return option_some(&self.rectangle)
}

func (self *Platform) collides(other Collider) Option[Collision] {
	return self.rectangle.collides(other)
}
