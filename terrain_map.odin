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


render_terrain :: proc(terrain_map: TerrainMap) {
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
