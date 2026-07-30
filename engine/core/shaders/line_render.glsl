@ctype mat4 hmm_mat4

@vs vs
layout(binding = 0, std140) uniform vs_params {
    mat4 mvp;
};

// Positions are in world space and .w is a packed u32 rgb color!
layout(location=0) in vec4 position;

out vec4 out_color;
const float norm = 0.00390625;

void main() {
	gl_Position = mvp * vec4(position.xyz, 1.0);
	float color = position.w * 256.0;
	float colf = fract(color);
	out_color.r = floor(color) * norm;
	color = colf * 256.0;
	colf = fract(color);
	out_color.g = floor(color) * norm;;
	color = colf * 256.0;
	colf = fract(color);
	out_color.b = floor(color) * norm;;
	out_color.a = 1.0;
}
@end

@fs fs
layout(location=0) in vec4 out_color;
out vec4 frag_color;

void main() {
    frag_color = out_color;
}
@end

@program line_draw vs fs