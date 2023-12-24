package src

import (
	rl "github.com/gen2brain/raylib-go/raylib"
	"gotest.tools/assert"
	"testing"
)

func TestCratePack(t *testing.T) {
	var crate_pack = NewCratePack(
		rl.Vector2{X: 0.0, Y: 0.0},
		1,
		1,
		10.0,
		10.0,
		2.0,
		2.0,
		rl.Green,
	)
	assert.Equal(t, len(crate_pack.crates), 1)

	var crate_rect = rect_from_center(rl.Vector2{X: 0.0, Y: 0.0}, 10.0, 10.0)
	assert.Equal(t, crate_pack.crates[0].rectangle, crate_rect)
}

func TestCratePackNewEvenCols(t *testing.T) {
	var crate_pack = NewCratePack(
		rl.Vector2{X: 0.0, Y: 0.0},
		1,
		2,
		10.0,
		10.0,
		2.0,
		2.0,
		rl.Green,
	)
	assert.Equal(t, len(crate_pack.crates), 2)

	{
		var crate_rect = rect_from_center(rl.Vector2{X: -6.0, Y: 0.0}, 10.0, 10.0)
		assert.Equal(t, crate_pack.crates[0].rectangle, crate_rect)
	}

	{
		var crate_rect = rect_from_center(rl.Vector2{X: 6.0, Y: 0.0}, 10.0, 10.0)
		assert.Equal(t, crate_pack.crates[1].rectangle, crate_rect)
	}
}

func TestCratePackNewOddCols(t *testing.T) {
	var crate_pack = NewCratePack(
		rl.Vector2{X: 0.0, Y: 0.0},
		1,
		3,
		10.0,
		10.0,
		2.0,
		2.0,
		rl.Green,
	)
	assert.Equal(t, len(crate_pack.crates), 3)

	{
		var crate_rect = rect_from_center(rl.Vector2{X: -12.0, Y: 0.0}, 10.0, 10.0)
		assert.Equal(t, crate_pack.crates[0].rectangle, crate_rect)
	}

	{
		var crate_rect = rect_from_center(rl.Vector2{X: 0.0, Y: 0.0}, 10.0, 10.0)
		assert.Equal(t, crate_pack.crates[1].rectangle, crate_rect)
	}

	{
		var crate_rect = rect_from_center(rl.Vector2{X: 12.0, Y: 0.0}, 10.0, 10.0)
		assert.Equal(t, crate_pack.crates[2].rectangle, crate_rect)
	}
}
