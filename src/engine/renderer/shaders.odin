package renderer

import "core:fmt"
import gl "vendor:OpenGL"
import "core:os"

// TRIANGLE_VERTEX_SOURCE: cstring : `#version 430 core

// layout(location = 0) in vec3 in_position;

// void main() {
//     gl_Position = vec4(in_position, 1.0);
// }
// `

// TRIANGLE_FRAGMENT_SOURCE: cstring : `#version 430 core

// layout(location = 0) out vec4 out_color;

// void main() {
//     out_color = vec4(1.0, 0.45, 0.1, 1.0);
// }
// `

compile_shader :: proc(kind: u32, source: []u8, source_name:string) -> (u32, bool){
    if len(source) == 0 || len(source) > int(max(i32)){
        fmt.eprintf("invalid shader source size: %s\n", source_name)
        return 0, false
    }

    shader := gl.CreateShader(kind)
    if shader == 0 {
        fmt.eprint("could not create shader object")
        return 0, false
    }

    source_pointer := cstring(raw_data(source))
    source_length := i32(len(source))
    gl.ShaderSource(shader, 1, &source_pointer, &source_length)
    gl.CompileShader(shader)

    compiled: i32
    gl.GetShaderiv(shader, gl.COMPILE_STATUS, &compiled)

    if compiled == 0 {
        log_buffer: [4096]u8
        written: i32

        gl.GetShaderInfoLog(shader, i32(len(log_buffer)), &written, &log_buffer[0])
        fmt.eprintf("Shader compilation failed (%s):\n%s\n", source_name, string(log_buffer[:written]))

        gl.DeleteShader(shader)
        return 0, false
    }
    return shader, true
}

compile_shader_file :: proc(kind: u32, path:string) -> (u32, bool){
    allocator := context.allocator

    source, read_error := os.read_entire_file(path, allocator)
    defer delete(source, allocator)

    if read_error != nil {
        fmt.eprintf("Could not read shader '%s': %v\n", path, read_error)
        return 0, false
    }

    return compile_shader(kind, source, path)

}

create_triangle_program :: proc() -> (u32, bool){
    vertex, vertex_ok := compile_shader_file(gl.VERTEX_SHADER, "assets/shaders/triangle.vert")

    if !vertex_ok {
        return 0, false
    }
    defer gl.DeleteShader(vertex)

    fragment, fragment_ok := compile_shader_file(gl.FRAGMENT_SHADER, "assets/shaders/triangle.frag")

    if !fragment_ok {
        return 0, false
    }
    defer gl.DeleteShader(fragment)

    program := gl.CreateProgram()
    if program == 0 {
        fmt.eprintf("Could not create shader program")
        return 0, false
    }

    gl.AttachShader(program, vertex)
    gl.AttachShader(program, fragment)

    gl.LinkProgram(program)

    linked: i32
    gl.GetProgramiv(program, gl.LINK_STATUS, &linked)

    if linked == 0 {
        log_buffer: [4096]u8
        written: i32

        gl.GetProgramInfoLog(
            program,
            i32(len(log_buffer)),
            &written,
            &log_buffer[0],
        )

        fmt.eprintf(
            "Shader program linking failed:\n%s\n",
            string(log_buffer[:written]),
        )

        gl.DeleteProgram(program)
        return 0, false
    }

    gl.DetachShader(program, vertex)
    gl.DetachShader(program, fragment)

    return program, true
    }

