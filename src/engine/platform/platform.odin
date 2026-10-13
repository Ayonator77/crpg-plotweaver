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

@(private)
translate_scancode :: proc(code: sdl.Scancode) -> Key{
    #partial switch code {
        case .A ..= .Z:
            return Key(int(Key.A) + int(code) - int(sdl.Scancode.A))

        // SDL orders digits _1.._9, _0, so 0 gets its own case
        case ._1 ..= ._9:
            return Key(int(Key.Num_1) + int(code) - int(sdl.Scancode._1))
        case ._0: return .Num_0

        case .F1 ..= .F12:
            return Key(int(Key.F1) + int(code) - int(sdl.Scancode.F1))

        case .ESCAPE:    return .Escape
        case .RETURN:    return .Enter
        case .SPACE:     return .Space
        case .TAB:       return .Tab
        case .BACKSPACE: return .Backspace
        case .DELETE:    return .Delete

        case .LSHIFT:    return .Left_Shift
        case .RSHIFT:    return .Right_Shift
        case .LCTRL:     return .Left_Ctrl
        case .RCTRL:     return .Right_Ctrl
        case .LALT:      return .Left_Alt
        case .RALT:      return .Right_Alt

        // SDL orders arrows RIGHT, LEFT, DOWN, UP: a range would map them wrong
        case .UP:        return .Up
        case .DOWN:      return .Down
        case .LEFT:      return .Left
        case .RIGHT:     return .Right
    }

    return .Unknown
}

poll_events :: proc(input: ^Input){
    input.keys_pressed = {}
    input.keys_released = {}
    input.mouse_pressed = {}
    input.mouse_released = {}
    input.mouse_delta = {}
    input.wheel = 0

    event: sdl.Event
    for sdl.PollEvent(&event) {
        #partial switch event.type {
            case .QUIT:
                input.quit_requested = true
            
            case .KEY_DOWN:
                key := translate_scancode(event.key.scancode)
                if key == .Unknown || event.key.repeat do continue
                input.keys_down += {key}
                input.keys_pressed += {key}
            
            case .KEY_UP:
              key := translate_scancode(event.key.scancode)
              if key == .Unknown do continue
              input.keys_down -= {key}
              input.keys_released += {key}
            
            case .MOUSE_WHEEL:
              scroll := event.wheel.y
              if event.wheel.direction == .FLIPPED do scroll = -scroll
              input.wheel += scroll

            case .MOUSE_MOTION:
              input.mouse_position = {event.motion.x, event.motion.y}
              input.mouse_delta += {event.motion.xrel, event.motion.yrel}

            case .MOUSE_BUTTON_DOWN, .MOUSE_BUTTON_UP:
              sdl_button := event.button.button
              if sdl_button < 1 || sdl_button > 5 do continue
              button := Mouse_Button(sdl_button - 1)
              if event.button.down {
                input.mouse_down += {button}
                input.mouse_pressed += {button}
              }else {
                input.mouse_down -= {button}
                input.mouse_released += {button}
    
              }

            case .WINDOW_FOCUS_LOST:
              input.keys_released += input.keys_down
              input.keys_down = {}
              input.mouse_released += input.mouse_down
              input.mouse_down = {}            
        }
    }
}


set_vsync :: proc(on: bool) -> bool{
  if !sdl.GL_SetSwapInterval(on ? 1: 0) {
    fmt.eprintf("Setting swap interval failed: %s\n", sdl.GetError())
    return false
  }
  return true
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
