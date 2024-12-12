precision mediump float;

uniform sampler2D u_foreground;
uniform sampler2D u_background;
uniform bool u_foregroundExists;
uniform bool u_backgroundExists;
uniform vec2 u_resolution;
uniform int u_mode;
uniform float u_opacity;

varying vec2 v_uvCoordinates;

// 0 "Normal", 1 "Dissolve",
// 2 "Darken", 3 "Multiply", 4 "Color Burn", 5 "Linear Burn", 6 "Darker Color",
// "7 Lighten", 8 "Screen", 9 "Color Dodge", 10 "Linear Dodge (Add)", 11 "Lighter Color",
// 12 "Overlay", 13 "Soft Light", 14 "Hard Light", 15 "Vivid Light", 16 "Linear Light", 17 "Pin Light", 18 "Hard Mix",
// 19 "Difference", 20 "Exclusion", 21 "Subtract", 22 "Divide",
// 23 "Hue", 24"Saturation", 25 "Color", 26 "Luminosity",

vec4 Color;

void main() {
	if (!u_foregroundExists && !u_backgroundExists) {
		Color = vec4(0, 0, 0, 1);
		return;
	}
	else if (!u_foregroundExists) {
		Color = vec4(texture2D(u_background, v_uvCoordinates).rgb, 1);
		return;
	}
	else if (!u_backgroundExists) {
		Color = vec4(texture2D(u_background, v_uvCoordinates).rgb, 1);
		return;
	}

	vec3 fg = texture2D(u_foreground, v_uvCoordinates).rgb;
	vec3 bg = texture2D(u_background, v_uvCoordinates).rgb;
	vec3 result;

	if(u_mode == 0) { // Normal
			result = fg * u_opacity + bg * (1.0 - u_opacity);
    }
	else if(u_mode == 1) {  // Dissolve
			float random = fract(sin(dot(v_uvCoordinates, vec2(12.9898, 78.233))) * 43758.5453);
			if (u_opacity > random) result = fg;
			else result = bg;
	}
	else if(u_mode == 2) {  // Multiply
			result = fg * bg;
    }
	else if(u_mode == 3) {  // Screen
			result = 1.0 - (1.0 - fg) * (1.0 - bg);
    }
	else if(u_mode == 4) {  // Add (Linear Dodge)
			result = min(fg + bg, 1.0);
    }
	else if(u_mode == 5) {  // Overlay
			if (u_opacity < 0.5) result = 2.0 * fg * bg;
			else result = 1.0 - 2.0 * (1.0 - fg) * (1.0 - bg);
    }
	else if(u_mode == 6) {  // Subtract
			result = max(bg - fg, 0.0);
    }
	else { // Not implemented
			result = vec3(1, 0, 1);
	}

	gl_FragColor = vec4(result.rgb, 1);
    Color = gl_FragColor;
}