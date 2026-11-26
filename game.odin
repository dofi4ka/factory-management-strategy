package main

import "core:fmt"
import rl "vendor:raylib"

Game :: struct {
	camera:  Camera,
	terrain: TerrainMap,
	player:  Player,
}

init_game :: proc(game: ^Game) {
	rl.InitWindow(800, 500, "Larpdustry")
	rl.ToggleBorderlessWindowed()
	rl.SetTargetFPS(60)


	ok := load_terrain(game)
	if !ok {
		fmt.panicf("Failed to load map")
	}
	init_player(game)
	init_camera(game)
}

update_game :: proc(game: ^Game) {
	update_player(&game.player)
	update_camera(&game.camera, game.player.pos)
}

_render_game2dmode :: proc(game: Game) {
	rl.BeginMode2D(game.camera)
	defer rl.EndMode2D()

	render_terrain(game.terrain)
	render_player(game.player)
}

render_game :: proc(game: Game) {
	rl.BeginDrawing()
	defer rl.EndDrawing()

	rl.ClearBackground(rl.BLACK)

	_render_game2dmode(game)
}
