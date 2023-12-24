package main

import (
	. "breakout/src"
	rl "github.com/gen2brain/raylib-go/raylib"
)

const WIDTH float32 = 800.0
const HEIGHT float32 = 450.0
const TARGET_FPS int32 = 80

var BACKGROUND_COLOR rl.Color = rl.Black
var SCENE_OUTLINE_COLOR rl.Color = rl.LightGray
var PLATFORM_COLOR rl.Color = rl.Red
var BALL_COLOR rl.Color = rl.Green
var CRATE_COLOR rl.Color = rl.Gray

func main() {
	rl.InitWindow(int32(WIDTH), int32(HEIGHT), "Breakout")
	defer rl.CloseWindow()

	rl.SetTargetFPS(TARGET_FPS)

	var scene = NewSceneBorder(rl.Vector2{X: WIDTH * 0.5, Y: HEIGHT * 0.5}, WIDTH, HEIGHT, 2, SCENE_OUTLINE_COLOR)

	var platform = NewPlatform(rl.Vector2{X: WIDTH * 0.5, Y: HEIGHT * 0.8}, 100.0, 20.0, PLATFORM_COLOR, 500.0)

	var camera = rl.Camera2D{
		Offset:   rl.Vector2Zero(),
		Target:   rl.Vector2Zero(),
		Rotation: 0.0,
		Zoom:     1.0,
	}

	var crate_pack = NewCratePack(rl.Vector2{X: WIDTH * 0.5, Y: HEIGHT * 0.2}, 3, 4, 70.0, 30.0, 10.0, 10.0, CRATE_COLOR)

	var ball = NewBall(rl.Vector2{X: WIDTH * 0.5, Y: HEIGHT * 0.5}, 20.0, 20.0, BALL_COLOR, rl.Vector2{X: 1.4, Y: 1.0}, 100.0)

	for !rl.WindowShouldClose() {
		var dt = rl.GetFrameTime()

		platform.Update(&scene, dt)
		ball.Update(&scene, &platform, &crate_pack, dt)

		rl.BeginDrawing()
		rl.ClearBackground(BACKGROUND_COLOR)
		rl.BeginMode2D(camera)

		scene.Draw()
		crate_pack.Draw()
		ball.Draw()
		platform.Draw()

		rl.EndMode2D()
		rl.EndDrawing()
	}
}
