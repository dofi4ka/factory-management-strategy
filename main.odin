package main

import "core:fmt"
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


main :: proc() {
	fmt.println("Hellope!")

	terrain_map, ok := load_terrain_map()
	if !ok {
		fmt.panicf("Failed to load map")
	}

	rl.InitWindow(800, 500, "Larpdustry")
	rl.SetTargetFPS(60)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		{
			rl.ClearBackground(rl.BLACK)

			for x in 0 ..< terrain_map.width {
				for y in 0 ..< terrain_map.height {
					rl.DrawRectangle(
						x * 10,
						y * 10,
						10,
						10,
						TerrainColors[get_terrain_at(terrain_map, x, y)],
					)
				}
			}
		}
		rl.EndDrawing()
	}
}

// TODO:
// show a player
// let player fly around
// add sprites for wall, floor, water, ores/
// ...
