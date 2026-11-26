package main

import "core:fmt"
import rl "vendor:raylib"

UNIT_SIZE :: 64

main :: proc() {
	fmt.println("Hellope!")

	terrain_map, ok := load_terrain_map()
	if !ok {
		fmt.panicf("Failed to load map")
	}


	rl.InitWindow(800, 500, "Larpdustry")
	rl.ToggleBorderlessWindowed()
	rl.SetTargetFPS(60)

	load_terrain_textures()
	player := Player{}
	init_player(&player, terrain_map)

	camera := Camera{}
	init_camera(&camera, player.pos)

	for !rl.WindowShouldClose() {
		update_player(&player)
		update_camera(&camera, player.pos)

		rl.BeginDrawing()
		{
			rl.ClearBackground(rl.BLACK)

			rl.BeginMode2D(camera.rl_camera)
			{
				render_terrain(terrain_map)
				render_player(player)
			}
			rl.EndMode2D()
		}
		rl.EndDrawing()
	}
}


// TODO: add simple interface with buildings
// TODO: let place buildings
// TODO: add mechanic of mining ores manually
// TODO: add cost and build time to buildings
