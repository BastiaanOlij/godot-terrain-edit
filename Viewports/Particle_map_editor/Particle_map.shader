shader_type canvas_item;
render_mode blend_disabled;

uniform float strength = 0.3;
uniform int channel = 0;

void fragment() {
	// Use our texture as a lookup to determine our draw strength
	// Note that our texture should be a grayscale texture and r=g=b
	float add = strength * texture(TEXTURE, UV).r;
	
	// get our current colour at this spot
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV).rgba;
	
	if (channel == 0) {
		color.r = clamp(color.r + add, 0.0, 1.0);
	} else if (channel == 1) {
		color.g = clamp(color.g + add, 0.0, 1.0);
	} else if (channel == 2) {
		color.b = clamp(color.b + add, 0.0, 1.0);
	} else if (channel == 3) {
		color.a = clamp(color.a + add, 0.0, 1.0);
	}
	
	COLOR = color;
}
