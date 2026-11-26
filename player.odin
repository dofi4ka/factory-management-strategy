package main

import "core:math"
import rl "vendor:raylib"

PLAYER_SPEED :: UNIT_SIZE * 20
PLAYER_SIZE :: UNIT_SIZE * 1.5
TURN_RATE :: 10
ACCELERATION :: 5

Player :: struct {
	pos:              rl.Vector2,
	rotation:         f32,
	desired_rotation: f32,
	speed:            f32,
	desired_speed:    f32,
	scale:            f32,
	texture:          rl.Texture2D,
}

init_player :: proc(game: ^Game) {
	game.player.pos = rl.Vector2 {
		cast(f32)game.terrain.width * UNIT_SIZE / 2,
		cast(f32)game.terrain.height * UNIT_SIZE / 2,
	}

	game.player.texture = rl.LoadTexture("assets/player.png")
	game.player.scale = PLAYER_SIZE / cast(f32)game.player.texture.width
	game.player.rotation = 0
}

_update_player_rotation :: proc(player: ^Player) {
	t := 1.0 - math.exp(-(TURN_RATE * player.speed / PLAYER_SPEED) * rl.GetFrameTime())
	player.rotation += (math.angle_diff(player.rotation, player.desired_rotation)) * t
}

_update_player_pos :: proc(player: ^Player) {
	t := 1.0 - math.exp(-ACCELERATION * rl.GetFrameTime())
	player.speed += (player.desired_speed - player.speed) * t

	player.pos +=
		rl.Vector2Rotate(rl.Vector2{0, -1}, player.rotation) * player.speed * rl.GetFrameTime()
}

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
		player.desired_rotation = math.atan2_f32(direction.x, -direction.y)
		player.desired_speed = PLAYER_SPEED
	} else {
		player.desired_speed = 0
	}

	_update_player_rotation(player)
	_update_player_pos(player)
}

render_player :: proc(player: Player) {
	rl.DrawTextureEx(
		player.texture,
		rl.Vector2{player.pos.x, player.pos.y} -
		rl.Vector2Rotate(rl.Vector2{1, 1} * PLAYER_SIZE / 2, player.rotation),
		math.to_degrees_f32(player.rotation),
		player.scale,
		rl.WHITE,
	)
}
