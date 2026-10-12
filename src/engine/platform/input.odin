package platform

// Engine owned key names. Game uses this and never sees SDL
// Grouped by hand; odinfmt would otherwise put one key per line.
// Order matters: each key's ordinal is its bit in bit_set[Key; u128].

//odinfmt: disable
Key :: enum u8 {
	Unknown,

	// Letters
	A, B, C, D, E, F, G, H, I, J, K, L, M,
	N, O, P, Q, R, S, T, U, V, W, X, Y, Z,

	// Number row
	Num_0, Num_1, Num_2, Num_3, Num_4,
	Num_5, Num_6, Num_7, Num_8, Num_9,

	// Control
	Escape, Enter, Space, Tab, Backspace, Delete,

	// Modifiers
	Left_Shift, Right_Shift,
	Left_Ctrl,  Right_Ctrl,
	Left_Alt,   Right_Alt,

	// Arrows
	Up, Down, Left, Right,

	// Function keys
	F1, F2, F3, F4,  F5,  F6,
	F7, F8, F9, F10, F11, F12,
}
//odinfmt: enable

Mouse_Button :: enum u8 {
	Left,
	Middle,
	Right,
	X1,
	X2,
}

// Lives across frames. '*_down' persits and edges plus mouse_delta and wheel reset each frame
Input :: struct {
	keys_down:      bit_set[Key;u128],
	keys_pressed:   bit_set[Key;u128],
	keys_released:  bit_set[Key;u128],
	mouse_down:     bit_set[Mouse_Button],
	mouse_pressed:  bit_set[Mouse_Button],
	mouse_released: bit_set[Mouse_Button],
	mouse_position: [2]f32, //window pixels, origin top-left
	mouse_delta:    [2]f32, //total movement this frame
	wheel:          f32, //scroll this frame (+ = away from you)
	quit_requested: bool,
}

