shader_type canvas_item;

uniform float strength = 10.0;

float get_height(sampler2D tex, vec2 uv) {
	// get our current colour at this spot
	vec4 color = texture(tex, uv);
	
	// convert to a height
	float height = (color.r * 65536.0) + (color.g * 256.0) + color.b;
	
	return height;
}

float get_smoothed_height(sampler2D tex, vec2 uv) {
	float off_x = 1.0 / 4096.0;
	float off_y = 1.0 / 4096.0;
	
	float height = get_height(tex, uv);
	height += get_height(tex, uv + vec2(off_x, 0.0));
	height += get_height(tex, uv + vec2(off_x, off_y));
	height += get_height(tex, uv + vec2(0.0, off_y));
	height += get_height(tex, uv + vec2(-off_x, off_y));
	height += get_height(tex, uv + vec2(-off_x, 0.0));
	height += get_height(tex, uv + vec2(-off_x, -off_y));
	height += get_height(tex, uv + vec2(0.0, -off_y));
	height += get_height(tex, uv + vec2(off_x, -off_y));
	
	return height / 9.0;
}

void fragment() {
	// For now just use the distance to our point, the further away, we are, the less we add.
	// The size of this depends directly on the size of the rectangle we draw
	// Note that our texture should be a grayscale texture and r=g=b
	float s = clamp(strength * texture(TEXTURE, UV).r, 0.0, 1.0);
	
	// get our current height
	float height = get_height(SCREEN_TEXTURE, SCREEN_UV);
	
	// now get our smoothed height
	float smoothed = get_smoothed_height(SCREEN_TEXTURE, SCREEN_UV);
	
	// and get our interpolated height
	height = height + ((smoothed - height) * s);
	
	// update our color
	vec4 color;
	color.b = mod(height, 1.0);
	height = (height - color.b) / 256.0;
	color.g = mod(height, 1.0);
	height = (height - color.g) / 256.0;
	color.r = height;
	color.a = 1.0; // JIC
	COLOR = color;
}
