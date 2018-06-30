shader_type canvas_item;

uniform float strength = 10.0;

void fragment() {
	// Use our texture as a lookup to determine our draw strength
	// Note that our texture should be a grayscale texture and r=g=b
	float add_height = strength * texture(TEXTURE, UV).r;
	
	// get our current colour at this spot
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	// convert to a height
	float height = (color.r * 65536.0) + (color.g * 256.0) + color.b;
	
	// add our change and clamp it
	height = clamp(height + add_height, 0.0, 65536.0);
	
	// update our color
	color.b = mod(height, 1.0);
	height = (height - color.b) / 256.0;
	color.g = mod(height, 1.0);
	height = (height - color.g) / 256.0;
	color.r = height;
	color.a = 1.0; // JIC
	
	COLOR = color;
}
