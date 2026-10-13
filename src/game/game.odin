package game
import "pw:engine/platform"
import "core:math"

//Everything the game owns. main only reads it to know what to draw

BASE_BACKGROUND :: [3]f32 {0.1, 0.3, 0.5}
PULSE_HZ :: 0.5

State :: struct {
  background:     [3]f32,
  triangle_color: [3]f32,
  wants_quit:     bool,
  time:           f32,
}

init :: proc(game: ^State){ 
  game.background = BASE_BACKGROUND
  game.triangle_color = {1.0, 0.45, 0.1}
}

update :: proc(game: ^State, input: platform.Input, dt: f32){
  if .Escape in input.keys_pressed do game.wants_quit = true

  if .R in input.keys_pressed {
      game.triangle_color = [3]f32{1.0, 0.0, 0.0}
  } else if .G in input.keys_pressed {
      game.triangle_color = [3]f32{0.0, 1.0, 0.0}
  } else if .B in input.keys_pressed {
      game.triangle_color = [3]f32{0.0, 0.0, 1.0}
  }

  game.time += dt
  brightness := 0.75 + 0.25 * math.sin(game.time * math.TAU * PULSE_HZ)
  game.background = BASE_BACKGROUND * brightness
}

shutdown :: proc(game: ^State) {}


