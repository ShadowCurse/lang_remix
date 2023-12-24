package src

import (
	rl "github.com/gen2brain/raylib-go/raylib"
	"gotest.tools/assert"
	"testing"
)

func TestRect(t *testing.T) {
	var pos = rl.Vector2{X: 0.0, Y: 0.0}
	var width float32 = 10.0
	var height float32 = 10.0
	var rect = rect_from_center(pos, width, height)
	assert.Equal(t, rect.pos(), rl.Vector2{X: 0.0, Y: 0.0})
	assert.Equal(t, rect.left(), float32(-5.0))
	assert.Equal(t, rect.right(), float32(5.0))
	assert.Equal(t, rect.top(), float32(-5.0))
	assert.Equal(t, rect.bot(), float32(5.0))
}

func TestRectCollison(t *testing.T) {
	var pos = rl.Vector2{X: 0.0, Y: 0.0}
	var width float32 = 10.0
	var height float32 = 10.0
	var rect1 = rect_from_center(pos, width, height)

	var collision = rect1.collides(&rect1)
	assert.Assert(t, collision.is_none())

	{
		var pos = rl.Vector2{X: 8.0, Y: 8.0}
		var width float32 = 4.0
		var height float32 = 4.0
		var rect2 = rect_from_center(pos, width, height)
		{
			var collision = rect1.collides(&rect2)
			assert.Assert(t, collision.is_none())
		}

		{
			var collision = rect2.collides(&rect1)
			assert.Assert(t, collision.is_none())
		}
	}

	{
		var pos = rl.Vector2{X: 7.0, Y: 4.0}
		var width float32 = 5.0
		var height float32 = 4.0
		var rect2 = rect_from_center(pos, width, height)

		{
			var required_collison = Collision{
				pos:    rl.Vector2{X: 5.0, Y: 4.0},
				normal: rl.Vector2{X: 1.0, Y: 0.0},
			}
			var collision = rect1.collides(&rect2)
			assert.Assert(t, collision.is_some())
			assert.Equal(t, collision.unwrap(), required_collison)
		}

		{
			var required_collison = Collision{
				pos:    rl.Vector2{X: 4.5, Y: 0.0},
				normal: rl.Vector2{X: -1.0, Y: 0.0},
			}
			var collision = rect2.collides(&rect1)
			assert.Assert(t, collision.is_some())
			assert.Equal(t, collision.unwrap(), required_collison)
		}
	}
}
