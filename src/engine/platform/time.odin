package platform

import sdl "vendor:sdl3"


MAX_DT :: 0.1

Frame_Time :: struct{
  dt:             f32,
  total:          f64,
  frame:          u64,
  last_counter:   u64,
  frequency:      f64,
}

time_init :: proc(t: ^Frame_Time){
  t.frequency = f64(sdl.GetPerformanceFrequency())
  t.last_counter = sdl.GetPerformanceCounter()
}

time_tick :: proc(t: ^Frame_Time){
  now := sdl.GetPerformanceCounter()
  elapsed := f64(now - t.last_counter)/t.frequency
  t.last_counter = now
  t.dt = f32(min(elapsed, MAX_DT))
  t.total += elapsed
  t.frame += 1 
}


