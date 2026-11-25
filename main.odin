package main

import "core:fmt"
import rl "vendor:raylib"

UNIT_SIZE :: 16

main :: proc() {
	fmt.println("Hellope!")

	terrain_map, ok := load_terrain_map()
	if !ok {
		fmt.panicf("Failed to load map")
	}

	rl.InitWindow(800, 500, "Larpdustry")
	rl.SetTargetFPS(60)

	player_pos := rl.Vector2 {
		cast(f32)terrain_map.width * UNIT_SIZE / 2,
		cast(f32)terrain_map.height * UNIT_SIZE / 2,
	}

	camera := Camera{}
	init_camera(&camera, player_pos)

	for !rl.WindowShouldClose() {
		update_camera(&camera, player_pos)

		rl.BeginDrawing()
		{
			rl.ClearBackground(rl.BLACK)

			rl.BeginMode2D(camera.rl_camera)
			{
				render_terrain(terrain_map)
			}
			rl.EndMode2D()
		}
		rl.EndDrawing()
	}
}

// TODO:
// show a player
// let player fly around
// add sprites for wall, floor, water, ores/
// ...
