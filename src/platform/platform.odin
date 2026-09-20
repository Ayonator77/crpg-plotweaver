package platform

import "core:fmt"
import "core:strings"
import sdl "vendor:sdl3"
import gl "vendor:OpenGL"

State :: struct {
    window: ^sdl.Window,
    sdl_init: bool,
    gl_context: sdl.GLContext,
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

    if !sdl.GL_SetAttribute(.CONTEXT_MAJOR_VERSION, 4) {
        fmt.eprintf("Setting OpenGL major version failed: %s\n", sdl.GetError())
        return false
    }

    if !sdl.GL_SetAttribute(.CONTEXT_MINOR_VERSION, 3) {
        fmt.eprintf("Setting OpenGL minor version failed: %s\n", sdl.GetError())
        return false
    }

    if !sdl.GL_SetAttribute(
        .CONTEXT_PROFILE_MASK,
        i32(sdl.GL_CONTEXT_PROFILE_CORE),
    ) {
        fmt.eprintf("Setting OpenGL core profile failed: %s\n", sdl.GetError())
        return false
    }

    if !sdl.GL_SetAttribute(.DOUBLEBUFFER, 1) {
        fmt.eprintf("Enabling double buffering failed: %s\n", sdl.GetError())
        return false
    }
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
        {.RESIZABLE, .OPENGL, .HIGH_PIXEL_DENSITY}
    )

    if(state.window == nil){
        fmt.eprintf("Window creation failed: %s\n", sdl.GetError())
        return false
    }

    state.gl_context = sdl.GL_CreateContext(state.window)

    if state.gl_context == nil {
        fmt.eprintf("OpenGL context creation failed: %s\n", sdl.GetError())
        return false
    }

    gl.load_up_to(4, 3, sdl.gl_set_proc_address)
    fmt.printf("OpenGL version: %s\n", gl.GetString(gl.VERSION))
    fmt.printf("Graphics renderer: %s\n", gl.GetString(gl.RENDERER))

    return true
}

shutdown:: proc(state: ^ State) {
    //Release anything succesfully intialized
    if state.gl_context != nil {
        sdl.GL_DestroyContext(state.gl_context)
        state.gl_context = nil
    }

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

drawable_size :: proc(state: ^State) -> (i32, i32, bool){
    width, height: i32
    ok:= sdl.GetWindowSizeInPixels(state.window, &width, &height)
    if !ok {
        fmt.eprintf("Drawable size query failed: %s\n", sdl.GetError())
    }

    return width, height, ok
}

present :: proc(state: ^State) -> bool {
    if !sdl.GL_SwapWindow(state.window) {
        fmt.eprintf("Frame presentation failed: %s\n", sdl.GetError())
        return false
    }
    return true
}

pause :: proc(milliseconds: u32){
    sdl.Delay(milliseconds)
}