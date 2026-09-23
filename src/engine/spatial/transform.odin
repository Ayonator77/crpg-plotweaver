package spatial

Transform :: struct {
    position: [3]f32,
    scale: [3]f32,
}

identity :: proc() -> Transform {
    return Transform {
        position = {0, 0, 0},
        scale = {1, 1, 1},
    }
}

to_matrix :: proc(t: Transform) -> (m: matrix[4, 4]f32) {
    m[0, 0] = t.scale[0]
    m[1, 1] = t.scale[1]
    m[2, 2] = t.scale[2]
    m[3, 3] = 1

    m[0, 3] = t.position[0]
    m[1, 3] = t.position[1]
    m[2, 3] = t.position[2]

    return
}