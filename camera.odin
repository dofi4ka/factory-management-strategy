package main

import "core:math"
import rl "vendor:raylib"

MIN_ZOOM :: 0.125
MAX_ZOOM :: 16.0

Camera :: struct {
	rl_camera:    rl.Camera2D,
	desired_zoom: f32,
}

update_zoom :: proc(camera: ^Camera) {
	wheel := rl.GetMouseWheelMoveV().y
	if wheel != 0 {
		camera.desired_zoom = clamp(
			camera.desired_zoom * math.pow(f32(1.15), wheel),
			MIN_ZOOM,
			MAX_ZOOM,
		)
	}

	alpha := 1.0 - math.exp(-18.0 * rl.GetFrameTime())
	camera.rl_camera.zoom *= math.pow(camera.desired_zoom / camera.rl_camera.zoom, alpha)
}

update_camera :: proc(camera: ^Camera, target: rl.Vector2) {
	update_zoom(camera)
	camera.rl_camera.offset = rl.Vector2 {
		cast(f32)rl.GetRenderWidth() / 2.0,
		cast(f32)rl.GetRenderHeight() / 2.0,
	}
	camera.rl_camera.target = target
}

init_camera :: proc(camera: ^Camera, target: rl.Vector2) {
	camera.desired_zoom = 1.0
	camera.rl_camera.zoom = 1.0
	update_camera(camera, target)
}
