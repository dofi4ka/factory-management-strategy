package main

import "core:fmt"
import rl "vendor:raylib"

UNIT_SIZE :: 64


main :: proc() {
	fmt.println("Hellope!")

	game := Game{}
	init_game(&game)

	for !rl.WindowShouldClose() {
		update_game(&game)

		render_game(game)
	}
}


// TODO: add simple interface with buildings
// TODO: let place buildings
// TODO: add mechanic of mining ores manually
// TODO: add cost and build time to buildings
