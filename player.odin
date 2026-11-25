package main

import "core:math"
import rl "vendor:raylib"

Player :: struct {
	pos:      rl.Vector2,
	rotation: f32,
	texture:  rl.Texture2D,
}

init_player :: proc(player: ^Player, terrain_map: TerrainMap) {
	player.pos = rl.Vector2 {
		cast(f32)terrain_map.width * UNIT_SIZE / 2,
		cast(f32)terrain_map.height * UNIT_SIZE / 2,
	}

	image: rl.Image = rl.LoadImage("player.png")

	rl.ImageResizeNN(&image, PLAYER_SIZE, PLAYER_SIZE)
	texture: rl.Texture2D = rl.LoadTextureFromImage(image)
	rl.UnloadImage(image)

	player.texture = texture
	player.rotation = 0
}

PLAYER_SPEED :: UNIT_SIZE * 10
PLAYER_SIZE :: UNIT_SIZE * 3

update_player :: proc(player: ^Player) {
	direction := rl.Vector2{0, 0}

	if rl.IsKeyDown(rl.KeyboardKey.A) || rl.IsKeyDown(rl.KeyboardKey.LEFT) {
		direction += rl.Vector2{-1, 0}
	}
	if rl.IsKeyDown(rl.KeyboardKey.D) || rl.IsKeyDown(rl.KeyboardKey.RIGHT) {
		direction += rl.Vector2{1, 0}
	}
	if rl.IsKeyDown(rl.KeyboardKey.W) || rl.IsKeyDown(rl.KeyboardKey.UP) {
		direction += rl.Vector2{0, -1}
	}
	if rl.IsKeyDown(rl.KeyboardKey.S) || rl.IsKeyDown(rl.KeyboardKey.DOWN) {
		direction += rl.Vector2{0, 1}
	}

	if (direction != rl.Vector2{0, 0}) {
		player.rotation = math.atan2_f32(direction.x, -direction.y)
	}

	direction *= PLAYER_SPEED * rl.GetFrameTime()

	if direction.y != 0 && direction.x != 0 {
		direction /= cast(f32)math.sqrt(2.0)
	}

	player.pos += direction
}

render_player :: proc(player: Player) {
	rl.DrawTextureEx(
		player.texture,
		rl.Vector2{player.pos.x, player.pos.y} -
		rl.Vector2Rotate(rl.Vector2{1, 1} * PLAYER_SIZE / 2, player.rotation),
		math.to_degrees_f32(player.rotation),
		1.0,
		rl.WHITE,
	)
}
