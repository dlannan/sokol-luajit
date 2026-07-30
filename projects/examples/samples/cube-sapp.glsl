@ctype mat4 hmm_mat4

@vs vs_cube
layout(binding = 0, std140) uniform vs_params {
    mat4 mvp;
};

in vec4 position;
in vec4 color0;

out vec4 color;

void main() {
    gl_Position = mvp * position;
    color = color0;
}
@end

@fs fs_cube
in vec4 color;
out vec4 frag_color;

void main() {
    frag_color = color;
}
@end

@program cube vs_cube fs_cube
