package renderer

import gl "vendor:OpenGL"
import "core:fmt"


State :: struct {
    triangle_vao: u32,
    triangle_vbo: u32,
    triangle_program: u32,
}

init :: proc(state: ^State) -> bool{
    vertices := [9]f32 {
        -0.5, -0.5, 0.0,
        0.5, -0.5, 0.0,
        0.0, 0.5, 0.0,
    }

    gl.GenVertexArrays(1, &state.triangle_vao)
    gl.GenBuffers(1, &state.triangle_vbo)

    if state.triangle_vao == 0 || state.triangle_vbo == 0 {
        fmt.eprintf("Failed to obtain triangle object names")
        return false
    }

    gl.BindVertexArray(state.triangle_vao)
    gl.BindBuffer(gl.ARRAY_BUFFER, state.triangle_vbo)

    gl.BufferData(gl.ARRAY_BUFFER, size_of(vertices), &vertices[0], gl.STATIC_DRAW)

    gl.VertexAttribPointer(0, 3, gl.FLOAT, false, i32(3 * size_of(f32)), 0)

    gl.EnableVertexAttribArray(0)
    uploaded_bytes: i32
    gl.GetBufferParameteriv(gl.ARRAY_BUFFER, gl.BUFFER_SIZE, &uploaded_bytes)

    if uploaded_bytes != i32(size_of(vertices)) {
        fmt.eprintf("Unexpected vertex buffer size: expected %d. got %d\n", size_of(vertices), uploaded_bytes)
        return false
    }

    gl.BindVertexArray(0)
    gl.BindBuffer(gl.ARRAY_BUFFER, 0)

    fmt.printf("Triangle vertex buffer: %d bytes\n", uploaded_bytes)

    program, program_ok := create_triangle_program()
    if !program_ok {
        return false
    }

    state.triangle_program = program
    return true
}

shutdown :: proc(state: ^State){
    if state.triangle_program != 0 {
        gl.UseProgram(0)
        gl.DeleteProgram(state.triangle_program)
        state.triangle_program = 0
    }

    if state.triangle_vao != 0 {
        gl.DeleteVertexArrays(1, &state.triangle_vao)
        state.triangle_vao = 0
    }

    if state.triangle_vbo != 0 {
        gl.DeleteBuffers(1, &state.triangle_vbo)
        state.triangle_vbo = 0
    }
}

draw_triangle :: proc(state: ^State){
    gl.UseProgram(state.triangle_program)
    gl.BindVertexArray(state.triangle_vao)
    
    gl.DrawArrays(gl.TRIANGLES, 0, 3)

    gl.BindVertexArray(0)
    gl.UseProgram(0)
}

clear :: proc(width, height: i32, color: [3]f32){
    gl.Viewport(0, 0, width, height)
    gl.ClearColor(color[0], color[1], color[2], 1.0)
    gl.Clear(gl.COLOR_BUFFER_BIT)
}
