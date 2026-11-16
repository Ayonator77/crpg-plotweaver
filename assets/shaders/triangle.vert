#version 430 core

layout(location = 0) in vec3 in_position;
uniform mat4 u_mvp; //local space -> clip space, built on the cpu each frame

void main() {
    gl_Position = u_mvp * vec4(in_position, 1.0);
}
