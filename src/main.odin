package main
import "platform"
import "renderer"
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

    graphics: renderer.State
    defer renderer.shutdown(&graphics)

    if !renderer.init(&graphics){
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
        background = [3]f32{0.1, 0.3, 0.5},
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
        width, height, size_ok := platform.drawable_size(&host)
        if !size_ok{
            request_exit(&app)
            break
        }

        if width <=0 || height <= 0 {
            platform.pause(16)
            continue
        }

        renderer.clear(width, height, app.background)
        renderer.draw_triangle(&graphics)

        if !platform.present(&host){
            request_exit(&app)
            break
        }

        platform.pause(8)
    }

    fmt.printf("Application Stopped")

}