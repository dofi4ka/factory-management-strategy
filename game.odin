package main

import "core:fmt"
import rl "vendor:raylib"

Game :: struct {
	camera:      Camera,
	terrain_map: TerrainMap,
	player:      Player,
}

init_game :: proc(game: ^Game) {
	terrain_map, ok := load_terrain_map()
	if !ok {
		fmt.panicf("Failed to load map")
	}

	rl.InitWindow(800, 500, "Larpdustry")
	rl.ToggleBorderlessWindowed()
	rl.SetTargetFPS(60)

	load_terrain_textures()
	init_player(&game.player, terrain_map)
	init_camera(&game.camera, game.player.pos)
}

update_game :: proc(game: ^Game) {
	update_player(&game.player)
	update_camera(&game.camera, game.player.pos)
}

_render_game2dmode :: proc(game: Game) {
	rl.BeginMode2D(game.camera.rl_camera)
	defer rl.EndMode2D()

	render_terrain(game.terrain_map)
	render_player(game.player)
}

render_game :: proc(game: Game) {
	rl.BeginDrawing()
	defer rl.EndDrawing()

	rl.ClearBackground(rl.BLACK)

	_render_game2dmode(game)
}
