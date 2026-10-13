package main
// Only the import paths changed with the new folder layout:
// `-collection:pw=src` (see run.bat) turns `src/` into the collection `pw`,
// so any file anywhere in the tree can say `import "pw:engine/platform"`.
import "pw:engine/platform"
import "pw:engine/renderer"
import "pw:game"
import "core:fmt"
import "core:log"

@(require) import "core:mem"


main :: proc() {
    when ODIN_DEBUG {
        track: mem.Tracking_Allocator
        mem.tracking_allocator_init(&track, context.allocator)
        context.allocator = mem.tracking_allocator(&track)
        defer {
            for _, entry in track.allocation_map {
                fmt.eprintf("LEAK %v: %v bytes\n", entry.location, entry.size)
            }
            mem.tracking_allocator_destroy(&track)
        }
    }

    context.logger = log.create_console_logger()
    defer log.destroy_console_logger(context.logger)

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

    game_state: game.State
    defer game.shutdown(&game_state)
    game.init(&game_state)

    fmt.printf(
        "%s: %d x %d\n",
        config.title,
        config.window_width,
        config.window_height
    )
    app := App_State{
        running = true,
        frame_index = 0,
    }

    input: platform.Input
    clock: platform.Frame_Time

    platform.time_init(&clock)

    for app.running {
        defer free_all(context.temp_allocator)
        platform.time_tick(&clock)
        platform.poll_events(&input)

        game.update(&game_state, input, clock.dt)

        if(input.quit_requested || game_state.wants_quit){
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

        renderer.clear(width, height, game_state.background)
        renderer.draw_triangle(&graphics, game_state.triangle_color)

        if !platform.present(&host){
            request_exit(&app)
            break
        }
    }

    fmt.printf("Application Stopped\n")
}
