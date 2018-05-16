shader_type spatial;
render_mode unshaded,skip_vertex_transform;

uniform sampler2D heightmap;
uniform vec2 heightmap_size = vec2(4096.0, 4096.0);
uniform vec2 pickmap_offset = vec2(0.0, 0.0);
uniform vec2 pickmap_size = vec2(512.0, 512.0);
uniform float amplitude = 4096.0;

varying vec3 world_pos;

float get_height(vec3 pos) {
	vec2 uv = pos.xz + (heightmap_size * 0.5);
	uv.x = floor(uv.x);
	uv.y = floor(uv.y);
	uv = uv / heightmap_size;
	
	vec4 hm = texture(heightmap, uv);
	return amplitude * (hm.r + (hm.g / 256.0) + (hm.b / 65536.0));
}

void vertex() {
	// WORLD_MATRIX should only have a translation, no rotation, else we'll need to inverse the rotation to get the Y for our vertex.y
	VERTEX = (WORLD_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	// sample height in 3 locations so we can calculate our gradient
	float y1 = get_height(VERTEX);
	
	VERTEX.y = y1;
	world_pos = VERTEX;
	VERTEX = (INV_CAMERA_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	vec3 color = vec3(0.0, 0.0, 0.0);

	// HDR gives us enough precision to do this
	color.r = (floor(world_pos.x) + (pickmap_size.x * 0.5) - pickmap_offset.x) / pickmap_size.x;
	color.g = (floor(world_pos.z) + (pickmap_size.y * 0.5) - pickmap_offset.y) / pickmap_size.y;
	color.b = 0.0; // may use b for indexing other objects
	
	ALBEDO = color;
}

