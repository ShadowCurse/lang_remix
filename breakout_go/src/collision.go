package src

import (
	rl "github.com/gen2brain/raylib-go/raylib"
)

type Collision struct {
	pos    rl.Vector2
	normal rl.Vector2
}

type Collider interface {
	rect() Option[*Rect]
	collides(other Collider) Option[Collision]
}
