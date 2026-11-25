package main

import "core:fmt"
import rl "vendor:raylib"

main :: proc() {
	fmt.println("Hellope!")

	rl.InitWindow(800, 500, "Larpdustry")

	rl.SetTargetFPS(60)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		{
			rl.ClearBackground(rl.BLACK)
		}
		rl.EndDrawing()
	}
}

// TODO:
// render a map
// show a player
// let player fly around
// add sprites for wall, floor, water, ores/
// ...
