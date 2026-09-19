package main
import "platform"

import "core:fmt"


main :: proc() {
    config := App_config{
        title = "Plotweaver RPG",
        window_width = 1920,
        window_height = 1080,
    }

    host: platform.State
    defer platform.shutdown(&host)
    if !platform.init(&host, config.title, config.window_width, config.window_height) {
        return
    }

    fmt.printf(
        "%s: %d x %d\n",
        config.title,
        config.window_width,
        config.window_height
    )
    app := App_State{
        running = true,
        frame_index = 0,
        background = [3]f32{0.0, 0.1, 0.5},
    }

    for app.running {
        events := platform.poll_events()
        if(events.quit_requested || events.escape_pressed){
            request_exit(&app)
        }

        if(!app.running){
            break
        }
        advance_frame(&app)
        platform.pause(8)
    }

    fmt.printf("Application Stopped")

}