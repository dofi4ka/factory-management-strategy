package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

TerrainType :: enum {
	Wall,
	Floor,
	Water,
	Copper,
	Lead,
	Carbon,
}

TerrainColors := [TerrainType]rl.Color {
	.Wall   = rl.Color{0, 0, 0, 255},
	.Floor  = rl.Color{255, 255, 255, 255},
	.Water  = rl.Color{8, 0, 255, 255},
	.Copper = rl.Color{255, 137, 0, 255},
	.Lead   = rl.Color{107, 111, 175, 255},
	.Carbon = rl.Color{202, 69, 105, 255},
}

TerrainMap :: struct {
	width:  i32,
	height: i32,
	tiles:  []TerrainType,
}

get_terrain_at :: proc(terrain_map: TerrainMap, x, y: i32) -> TerrainType {
	return terrain_map.tiles[y * terrain_map.height + x]
}

load_terrain_map :: proc() -> (TerrainMap, bool) {
	image := rl.LoadImage("map.png")
	if image.data == nil {
		return TerrainMap{}, false
	}
	defer rl.UnloadImage(image)

	pixels := rl.LoadImageColors(image)
	if pixels == nil {
		return TerrainMap{}, false
	}

	tiles := make([]TerrainType, image.width * image.height)

	tile: for i in 0 ..< len(tiles) {
		for color, terrain in TerrainColors {
			if color == pixels[i] {
				tiles[i] = terrain
				continue tile
			}
		}
		tiles[i] = TerrainType.Floor
	}

	return TerrainMap{width = image.width, height = image.height, tiles = tiles}, true
}


UNIT_SIZE :: 16

MIN_ZOOM :: 0.125
MAX_ZOOM :: 16.0

update_zoom :: proc(camera: ^rl.Camera2D, desired_zoom: ^f32) {
	wheel := rl.GetMouseWheelMoveV().y
	if wheel != 0 {
		desired_zoom^ = clamp(desired_zoom^ * math.pow(f32(1.15), wheel), MIN_ZOOM, MAX_ZOOM)
	}

	alpha := 1.0 - math.exp(-18.0 * rl.GetFrameTime())
	camera.zoom *= math.pow(desired_zoom^ / camera.zoom, alpha)
}

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

	camera := rl.Camera2D {
		rl.Vector2{cast(f32)rl.GetRenderWidth() / 2.0, cast(f32)rl.GetRenderHeight() / 2.0},
		player_pos,
		0,
		1.0,
	}
	desired_zoom := camera.zoom

	for !rl.WindowShouldClose() {

		rl.BeginDrawing()
		{
			rl.ClearBackground(rl.BLACK)

			update_zoom(&camera, &desired_zoom)

			rl.BeginMode2D(camera)
			{
				for x in 0 ..< terrain_map.width {
					for y in 0 ..< terrain_map.height {
						rl.DrawRectangle(
							x * UNIT_SIZE,
							y * UNIT_SIZE,
							UNIT_SIZE,
							UNIT_SIZE,
							TerrainColors[get_terrain_at(terrain_map, x, y)],
						)
					}
				}
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
