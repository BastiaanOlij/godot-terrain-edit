shader_type spatial;
render_mode skip_vertex_transform;

uniform sampler2D heightmap;
uniform vec2 heightmap_size = vec2(4096.0, 4096.0);

uniform sampler2D splatmap;
uniform vec2 splatmap_size = vec2(4096.0, 4096.0);

uniform sampler2D noisemap;

// probably should change these into texture atlasses?
uniform sampler2D texture_map_1 : hint_black_albedo;
uniform sampler2D normal_map_1 : hint_normal;
uniform sampler2D pbr_map_1 : hint_black_albedo;
uniform float texture_scale_1 = 0.1;

uniform sampler2D texture_map_2 : hint_black_albedo;
uniform sampler2D normal_map_2 : hint_normal;
uniform sampler2D pbr_map_2 : hint_black_albedo;
uniform float texture_scale_2 = 0.1;

uniform sampler2D texture_map_3 :  hint_black_albedo;
uniform sampler2D normal_map_3 : hint_normal;
uniform sampler2D pbr_map_3 : hint_black_albedo;
uniform float texture_scale_3 = 0.1;

uniform sampler2D texture_map_4 : hint_black_albedo;
uniform sampler2D normal_map_4 : hint_normal;
uniform sampler2D pbr_map_4 : hint_black_albedo;
uniform float texture_scale_4 = 0.1;

uniform sampler2D texture_map_5;
uniform sampler2D normal_map_5 : hint_normal;
uniform sampler2D pbr_map_5 : hint_black_albedo;
uniform float texture_scale_5 = 0.1;

uniform float amplitude = 4096.0;
uniform vec2 target = vec2(4096.0, 4096.0);
uniform float target_inner_radius = 1.0;
uniform float target_radius = 2.0;
uniform vec4 target_color : hint_color = vec4(1.0, 0.0, 0.0, 1.0);

varying vec3 world_pos;

float get_height(vec3 pos) {
	vec2 uv = pos.xz + (heightmap_size * 0.5);
	uv.x = floor(uv.x + 0.5);
	uv.y = floor(uv.y + 0.5);
	uv = uv / heightmap_size;
	
	vec4 hm = texture(heightmap, uv);
	return amplitude * (hm.r + (hm.g / 256.0) + (hm.b / 65536.0));
}

vec4 get_splatmap(vec3 pos) {
	// we add a little bit of noise here so we don't have sharp borders
	vec2 noise = texture(noisemap, pos.xz).xy * 2.0 - 1.0;
	
	vec2 uv = pos.xz + noise + (splatmap_size * 0.5);
	uv = uv / splatmap_size;
	
	return texture(splatmap, uv);
}

void vertex() {
	// WORLD_MATRIX should only have a translation, no rotation, else we'll need to inverse the rotation to get the Y for our vertex.y
	VERTEX = (WORLD_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	// sample height in 3 locations so we can calculate our gradient
	float y1 = get_height(VERTEX);
	float y2 = get_height(VERTEX + vec3(-1.0, 0.0, 0.0));
	float y3 = get_height(VERTEX + vec3(1.0, 0.0, 0.0));
	float y4 = get_height(VERTEX + vec3(0.0, 0.0, -1.0));
	float y5 = get_height(VERTEX + vec3(0.0, 0.0, 1.0));
	
	VERTEX.y = y1;
	world_pos = VERTEX;
	VERTEX = (INV_CAMERA_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	// now calculate BINORMAL, TANGENT and NORMAL
	TANGENT = normalize(vec3(2.0, y3-y2, 0.0));
	BINORMAL = normalize(vec3(0.0, y4-y5, -2.0));
	NORMAL = cross(TANGENT, BINORMAL);
	
	// and rotate these by the camera
	NORMAL = (INV_CAMERA_MATRIX * vec4(NORMAL, 0.0)).xyz;
	BINORMAL = (INV_CAMERA_MATRIX * vec4(BINORMAL, 0.0)).xyz;
	TANGENT = (INV_CAMERA_MATRIX * vec4(TANGENT, 0.0)).xyz;
}

void fragment() {
	// Get our splatmap values
	vec4 spm = get_splatmap(world_pos);
	
	float tf1 = clamp(1.0 - spm.r - spm.g - spm.b - spm.a, 0.0, 1.0);
	float tf2 = spm.r;
	float tf3 = spm.g;
	float tf4 = spm.b;
	float tf5 = spm.a;
	
	// get our uvs
	vec2 uv_1 = world_pos.xz * texture_scale_1;
	vec2 uv_2 = world_pos.xz * texture_scale_2;
	vec2 uv_3 = world_pos.xz * texture_scale_3;
	vec2 uv_4 = world_pos.xz * texture_scale_4;
	vec2 uv_5 = world_pos.xz * texture_scale_5;
	
	// create our albedo color
	vec3 color = vec3(0.0, 0.0, 0.0);
	vec3 normal = vec3(0.0, 0.0, 0.0);
	vec3 pbr = vec3(0.0, 0.0, 0.0);
	
	color += texture(texture_map_1, uv_1).rgb * tf1;
	normal += (texture(normal_map_1, uv_1).rgb * 2.0 - 1.0) * tf1;
	pbr += texture(pbr_map_1, uv_1).rgb * tf1;
	
	color += texture(texture_map_2, uv_2).rgb * tf2;
	normal += (texture(normal_map_2, uv_2).rgb * 2.0 - 1.0) * tf2;
	pbr += texture(pbr_map_2, uv_2).rgb * tf2;
	
	color += texture(texture_map_3, uv_3).rgb * tf3;
	normal += (texture(normal_map_3, uv_3).rgb * 2.0 - 1.0) * tf3;
	pbr += texture(pbr_map_3, uv_3).rgb * tf3;
	
	color += texture(texture_map_4, uv_4).rgb * tf4;
	normal += (texture(normal_map_4, uv_4).rgb * 2.0 - 1.0) * tf4;
	pbr += texture(pbr_map_4, uv_4).rgb * tf4;
	
	color += texture(texture_map_5, uv_5).rgb * tf5;
	normal += (texture(normal_map_5, uv_5).rgb * 2.0 - 1.0) * tf5;
	pbr += texture(pbr_map_5, uv_5).rgb * tf5;
	
	// finalise our normal
	if (length(normal) < 0.1) {
		normal = vec3(0.0, 1.0, 0.0);
	}
	NORMALMAP = normalize(normal) * 0.5 + 0.5;
	
	// use our PBR settings
	METALLIC = pbr.r;
	ROUGHNESS = pbr.g;
	// anything we want to use the blue channel for?
	
	// paint our target, this should be removed in game
	if (target.x != 4096.0 || target.y != 4096.0) {
		// overlay our target so we know where we are painting
		float distance = length(world_pos.xz + (heightmap_size * 0.5) - target);
		if (distance < target_inner_radius) {
			color = target_color.rgb;
		} else if (distance > (target_radius - 0.2) && distance < target_radius) {
			color = target_color.rgb;
		}
	}
	
	ALBEDO = color;
}

