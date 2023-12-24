package src

import (
	rl "github.com/gen2brain/raylib-go/raylib"
)

type Ball struct {
	rectangle Rect
	color     rl.Color
	velocity  rl.Vector2
	speed     float32
}

func NewBall(center rl.Vector2, width float32, height float32, color rl.Color, velocity rl.Vector2, speed float32) Ball {
	var rectangle = rect_from_center(center, width, height)
	return Ball{
		rectangle: rectangle,
		color:     color,
		velocity:  velocity,
		speed:     speed,
	}
}

func (self *Ball) Draw() {
	rl.DrawRectangleRec(self.rectangle.raylib_rect(), self.color)
}

func (self *Ball) Update(scene *SceneBorder, platform *Platform, crate_pack *CratePack, dt float32) {
	self.rectangle.X += self.velocity.X * self.speed * dt
	self.rectangle.Y += self.velocity.Y * self.speed * dt

	{
		var collision_opt = scene.collides(self)
		if collision_opt.is_some() {
			var collision = collision_opt.unwrap()
			self.handle_collision(collision)
		}
	}

	{
		var collision_opt = platform.collides(self)
		if collision_opt.is_some() {
			var collision = collision_opt.unwrap()
			self.handle_collision(collision)
		}
	}

	{
		var collision_opt = crate_pack.collides(self)
		if collision_opt.is_some() {
			var collision = collision_opt.unwrap()
			self.handle_collision(collision)
		}
	}
}

func (self *Ball) handle_collision(collision Collision) {
	if collision.normal.X != 0.0 {
		self.velocity.X *= -1.0
	}
	if collision.normal.Y != 0.0 {
		self.velocity.Y *= -1.0
	}
}

// impl Collider
func (self *Ball) rect() Option[*Rect] {
	return option_some(&self.rectangle)
}

func (self *Ball) collides(other Collider) Option[Collision] {
	return option_none[Collision]()
}
