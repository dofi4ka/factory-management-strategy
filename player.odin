package main

import "core:math"
import rl "vendor:raylib"

Player :: struct {
	pos: rl.Vector2,
}

init_player :: proc(player: ^Player, terrain_map: TerrainMap) {
	player.pos = rl.Vector2 {
		cast(f32)terrain_map.width * UNIT_SIZE / 2,
		cast(f32)terrain_map.height * UNIT_SIZE / 2,
	}
}

PLAYER_SPEED :: UNIT_SIZE * 5

update_player :: proc(player: ^Player) {
	player_direction := rl.Vector2{}

	if rl.IsKeyDown(rl.KeyboardKey.A) || rl.IsKeyDown(rl.KeyboardKey.LEFT) {
		player_direction += rl.Vector2{-1, 0}
	}
	if rl.IsKeyDown(rl.KeyboardKey.D) || rl.IsKeyDown(rl.KeyboardKey.RIGHT) {
		player_direction += rl.Vector2{1, 0}
	}
	if rl.IsKeyDown(rl.KeyboardKey.W) || rl.IsKeyDown(rl.KeyboardKey.UP) {
		player_direction += rl.Vector2{0, -1}
	}
	if rl.IsKeyDown(rl.KeyboardKey.S) || rl.IsKeyDown(rl.KeyboardKey.DOWN) {
		player_direction += rl.Vector2{0, 1}
	}

	if player_direction.y != 0 && player_direction.x != 0 {
		player_direction /= cast(f32)math.sqrt(2.0)
	}

	player_direction *= PLAYER_SPEED * rl.GetFrameTime()

	player.pos += player_direction
}
