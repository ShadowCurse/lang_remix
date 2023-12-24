package src

import (
	rl "github.com/gen2brain/raylib-go/raylib"
	"gotest.tools/assert"
	"testing"
)

func TestSceneNew(t *testing.T) {
	var pos = rl.Vector2{X: 10.0, Y: 10.0}
	var width float32 = 20.0
	var height float32 = 15.0
	var line_thickness float32 = 2.0
	var line_color = rl.Gold
	var scene = NewSceneBorder(pos, width, height, line_thickness, line_color)

	var required_rect = rect_from_center(pos, width, height)
	assert.Equal(t, scene.rectangle, required_rect)
	assert.Equal(t, scene.line_thickness, line_thickness)
	assert.Equal(t, scene.line_color, line_color)
}
func TestSceneRect(t *testing.T) {
	var pos = rl.Vector2{X: 10.0, Y: 10.0}
	var width float32 = 20.0
	var height float32 = 15.0
	var line_thickness float32 = 2
	var line_color = rl.Gold
	var scene = NewSceneBorder(pos, width, height, line_thickness, line_color)

	var required_rect = rect_from_center(pos, width, height)

	assert.Equal(t, *scene.rect().unwrap(), required_rect)
}

func TestSceneCollision(t *testing.T) {
	var pos = rl.Vector2{X: 0.0, Y: 0.0}
	var width float32 = 30.0
	var height float32 = 30.0
	var line_thickness float32 = 2.0
	var line_color = rl.Gold
	var scene = NewSceneBorder(pos, width, height, line_thickness, line_color)

	// no collison left
	{
		var pos = rl.Vector2{X: -10.0, Y: 0.0}
		var width float32 = 10.0
		var height float32 = 5.0
		var not_colliding_rect = rect_from_center(pos, width, height)

		var collision = scene.collides(&not_colliding_rect)
		assert.Assert(t, collision.is_none())
	}

	// collison left
	{
		var pos = rl.Vector2{X: -10.0, Y: 0.0}
		var width float32 = 11.0
		var height float32 = 5.0
		var colliding_rect = rect_from_center(pos, width, height)

		var required_collison = Collision{
			pos:    rl.Vector2{X: -15.0, Y: 0.0},
			normal: rl.Vector2{X: 1.0, Y: 0.0},
		}

		var collision = scene.collides(&colliding_rect)
		assert.Assert(t, collision.is_some())
		assert.Equal(t, collision.unwrap(), required_collison)
	}

	// no collison right
	{
		var pos = rl.Vector2{X: 10.0, Y: 0.0}
		var width float32 = 10.0
		var height float32 = 5.0
		var not_colliding_rect = rect_from_center(pos, width, height)

		var collision = scene.collides(&not_colliding_rect)
		assert.Assert(t, collision.is_none())
	}

	// collison right
	{
		var pos = rl.Vector2{X: 10.0, Y: 0.0}
		var width float32 = 11.0
		var height float32 = 5.0
		var colliding_rect = rect_from_center(pos, width, height)

		var required_collison = Collision{
			pos:    rl.Vector2{X: 15.0, Y: 0.0},
			normal: rl.Vector2{X: -1.0, Y: 0.0},
		}

		var collision = scene.collides(&colliding_rect)
		assert.Assert(t, collision.is_some())
		assert.Equal(t, collision.unwrap(), required_collison)
	}

	// no collison top
	{
		var pos = rl.Vector2{X: 0.0, Y: -10.0}
		var width float32 = 5.0
		var height float32 = 10.0
		var not_colliding_rect = rect_from_center(pos, width, height)

		var collision = scene.collides(&not_colliding_rect)
		assert.Assert(t, collision.is_none())
	}

	// collison top
	{
		var pos = rl.Vector2{X: 0.0, Y: -10.0}
		var width float32 = 5.0
		var height float32 = 11.0
		var colliding_rect = rect_from_center(pos, width, height)

		var required_collison = Collision{
			pos:    rl.Vector2{X: 0.0, Y: -15.0},
			normal: rl.Vector2{X: 0.0, Y: 1.0},
		}

		var collision = scene.collides(&colliding_rect)
		assert.Assert(t, collision.is_some())
		assert.Equal(t, collision.unwrap(), required_collison)
	}

	// no collison bot
	{
		var pos = rl.Vector2{X: 0.0, Y: 10.0}
		var width float32 = 5.0
		var height float32 = 10.0
		var not_colliding_rect = rect_from_center(pos, width, height)

		var collision = scene.collides(&not_colliding_rect)
		assert.Assert(t, collision.is_none())
	}

	// collison bot
	{
		var pos = rl.Vector2{X: 0.0, Y: 10.0}
		var width float32 = 5.0
		var height float32 = 11.0
		var colliding_rect = rect_from_center(pos, width, height)

		var required_collison = Collision{
			pos:    rl.Vector2{X: 0.0, Y: 15.0},
			normal: rl.Vector2{X: 0.0, Y: -1.0},
		}

		var collision = scene.collides(&colliding_rect)
		assert.Assert(t, collision.is_some())
		assert.Equal(t, collision.unwrap(), required_collison)
	}
}
