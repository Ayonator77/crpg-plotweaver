package main

App_config :: struct {
    title: string,
    window_width : i32,
    window_height : i32,
}

App_State :: struct {
    running: bool,
    frame_index: u64,
    background: [3]f32,
    triangle_color: [3]f32
}

request_exit :: proc(app: ^App_State){
    app.running = false
}

advance_frame :: proc(app: ^App_State) {
    app.frame_index += 1
}
