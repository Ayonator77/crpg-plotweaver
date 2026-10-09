package platform

// Engine owned key names. Game uses this and never sees SDL

Key :: enum u8 {
    Unknown,
    A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z,
    Num_0, Num_1, Num_2, Num_3, Num_4, Num_5, Num_6, Num_7, Num_8, Num_9,
    Escape, Enter, Space, Tab, Backspace, Delete,
    Left_Shift, Right_Shift, Left_Ctrl, Right_Ctrl, Left_Alt, Right_Alt,
    Up, Down, Left, Right,
    F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12,
}

Mouse_Button :: enum u8 {Left, Middle, Right, X1, X2}

// Lives across frames. '*_down' persits and edges plus mouse_delta and wheel reset each frame
Input :: struct {
    keys_down:      bit_set[Key; u128],
    keys_pressed:   bit_set[Key; u128],
    keys_released:  bit_set[Key; u128],

    mouse_down:     bit_set[Mouse_Button],
    mouse_pressed:  bit_set[Mouse_Button],
    mouse_released: bit_set[Mouse_Button],
    mouse_position: [2]f32, //window pixels, origin top-left
    mouse_delta:    [2] f32, //total movement this frame
    wheel:          f32, //scroll this frame (+ = away from you)

    quit_requested: bool,
}