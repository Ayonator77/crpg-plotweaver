package renderer

import gl "vendor:OpenGL"

clear :: proc(width, height: i32, color: [3]f32){
    gl.Viewport(0, 0, width, height)
    gl.ClearColor(color[0], color[1], color[2], 1.0)
    gl.Clear(gl.COLOR_BUFFER_BIT)
}