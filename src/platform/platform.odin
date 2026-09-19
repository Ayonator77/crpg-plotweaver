package platform

import "core:fmt"
import "core:strings"
import sdl "vendor:sdl3"

State :: struct {
    window: ^sdl.Window,
    sdl_init: bool,
}

Events :: struct {
    quit_requested: bool,
    escape_pressed: bool,
}

init:: proc(state: ^State, title: string, width, height: i32) -> bool {
    // Initialize SDL and create a window
    if(!sdl.Init({.VIDEO})){
        fmt.eprintf("SDL initialization failed: %s\n", sdl.GetError())
        return false
    }
    state.sdl_init = true

    c_title, allocation_error := strings.clone_to_cstring(title)
    if(allocation_error != nil) {
        fmt.eprintf("Window title allocation failed: %v\n", allocation_error)
        return false
    }
    defer delete(c_title)

    state.window = sdl.CreateWindow(
        c_title,
        width,
        height,
        {.RESIZABLE}
    )

    if(state.window == nil){
        fmt.eprintf("Window creation failed: %s\n", sdl.GetError())
        return false
    }

    return true
}

shutdown:: proc(state: ^ State) {
    //Release anything succesfully intialized
    if(state.window != nil){
        sdl.DestroyWindow(state.window)
        state.window = nil
    }

    if(state.sdl_init){
        sdl.Quit()
        state.sdl_init = false
    }
}

poll_events:: proc() -> Events{
    // Translate sdl events into our own event summary
    results : Events
    event: sdl.Event
    for sdl.PollEvent(&event) {
        #partial switch event.type {
            case .QUIT:
                results.quit_requested = true
            
            case .KEY_DOWN:
                if event.key.key == sdl.K_ESCAPE {
                    results.escape_pressed = true
                }
        }
    }

    return results
}

pause :: proc(milliseconds: u32){
    sdl.Delay(milliseconds)
}