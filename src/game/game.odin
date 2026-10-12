package game
import "pw:engine/platform"

//Everything the game owns. main only reads it to know what to draw

State :: struct {
  background: [3]f32,
  triangle_color: [3]f32,
  wants_quit: bool,
}

init :: proc(game: ^State){
  game.background = {0.1, 0.3, 0.5}
  game.triangle_color = {1.0, 0.45, 0.1}
}

update :: proc(game: ^State, input: platform.Input){
  if .Escape in input.keys_pressed do game.wants_quit = true

  if .R in input.keys_pressed {
      game.triangle_color = [3]f32{1.0, 0.0, 0.0}
  } else if .G in input.keys_pressed {
      game.triangle_color = [3]f32{0.0, 1.0, 0.0}
  } else if .B in input.keys_pressed {
      game.triangle_color = [3]f32{0.0, 0.0, 1.0}
  }
}

shutdown :: proc(game: ^State) {}


