
precision mediump float;

uniform sampler2D u_main;

varying vec2 v_uvCoordinates;

vec4 Color;

void main() {
	gl_FragColor = texture2D(u_main, v_uvCoordinates);
    Color = gl_FragColor;
}