shader_type particles;
render_mode disable_force, disable_velocity;

uniform float amplitude = 4096.0;
uniform sampler2D heightmap;
uniform sampler2D particlemap;
uniform vec2 heightmap_size = vec2(4096.0, 4096.0);

uniform sampler2D noisemap;

uniform float rows = 300.0;
uniform float spacing = 0.5;
uniform vec3 base_scale = vec3(1.0, 1.0, 1.0);
uniform vec4 channel = vec4(1.0, 0.0, 0.0, 0.0);

float get_height(vec3 pos) {
	vec2 uv = pos.xz + (heightmap_size * 0.5);
	uv.x = floor(uv.x + 0.1);
	uv.y = floor(uv.y + 0.1);
	uv = uv / heightmap_size;
	
	vec4 hm = texture(heightmap, uv);
	return amplitude * (hm.r + (hm.g / 256.0) + (hm.b / 65536.0));
}

float get_densities(vec3 pos) {
	vec2 uv = pos.xz + (heightmap_size * 0.5);
	uv.x = floor(uv.x + 0.1);
	uv.y = floor(uv.y + 0.1);
	uv = uv / heightmap_size;
	
	return dot(texture(particlemap, uv), channel);
}

vec3 get_noise(vec3 pos) {
	vec2 uv = pos.xz * 10.0;
	uv.x = floor(uv.x + 0.1);
	uv.y = floor(uv.y + 0.1);
	uv = uv / 2048.0;
	
	return texture(noisemap, uv).rgb;
}

mat3 rotation_matrix(vec3 axis, float angle) {
	axis = normalize(axis);
	float s = sin(angle);
	float c = cos(angle);
	float oc = 1.0 - c;
	
	mat3 rotmat;
	
	rotmat[0][0] = oc * axis.x * axis.x + c;
	rotmat[0][1] = oc * axis.x * axis.y - axis.z * s;
	rotmat[0][2] = oc * axis.z * axis.x + axis.y * s;
	
	rotmat[1][0] = oc * axis.x * axis.y + axis.z * s;
	rotmat[1][1] = oc * axis.y * axis.y + c;
	rotmat[1][2] = oc * axis.y * axis.z - axis.x * s;
	
	rotmat[2][0] = oc * axis.z * axis.x - axis.y * s;
	rotmat[2][1] = oc * axis.y * axis.z + axis.x * s;
	rotmat[2][2] = oc * axis.z * axis.z + c;
	
	return rotmat;
}

mat4 get_transform(vec3 pos, vec3 scale, float rotate) {
	mat4 t;
	
	float x = floor(pos.x);
	float xd = pos.x - x;
	float z = floor(pos.z); 
	float zd = pos.z - z;
	
	// because we've encoded our height in rgb we need to do our own interpolation
	vec3 posf = vec3(x, 0.0, z);
	float y1 = get_height(posf);
	float y2 = get_height(posf + vec3(1.0, 0.0, 0.0));
	float y3 = get_height(posf + vec3(0.0, 0.0, 1.0));
	float y4 = get_height(posf + vec3(1.0, 0.0, 1.0));
	
	// use our slope value to create our vectors
	vec3 tangent = normalize(vec3(1.0, y2 - y1, 0.0));
	vec3 bitangent = normalize(vec3(0.0, y3 - y1, 1.0));
	vec3 normal = cross(bitangent, tangent);
	
	// rotate
	mat3 rm = rotation_matrix(normal, rotate);
	tangent = rm * tangent;
	bitangent = rm * bitangent;
	
	// now find our center
	y1 = mix(y1, y2, xd);
	y3 = mix(y3, y4, xd);
	
	// scale our vectors
	tangent *= scale.x;
	normal *= scale.y;
	bitangent *= scale.z;
	
	// and build our transform
	t[0][0] = tangent.x;
	t[0][1] = tangent.y;
	t[0][2] = tangent.z;
	t[0][3] = 0.0;
	t[1][0] = normal.x;
	t[1][1] = normal.y;
	t[1][2] = normal.z;
	t[1][3] = 0.0;
	t[2][0] = bitangent.x;
	t[2][1] = bitangent.y;
	t[2][2] = bitangent.z;
	t[2][3] = 0.0;
	t[3][0] = pos.x;
	t[3][1] = mix(y1, y3, zd);
	t[3][2] = pos.z;
	t[3][3] = 1.0;
	
	return t;
}

void vertex() {
	// start by getting our positioning
	highp vec3 pos = vec3(0.0, 0.0, 0.0);
	pos.z = float(INDEX);
	pos.x = mod(pos.z, rows);
	pos.z = (pos.z - pos.x) / rows;
	
	// center, we assume that we have equal rows and columns
	pos.x -= rows * 0.5;
	pos.z -= rows * 0.5;
	
	// adjust our spacing
	pos *= spacing;
	
	// now add our origin
	pos.x += EMISSION_TRANSFORM[3][0];
	pos.z += EMISSION_TRANSFORM[3][2];
	
	// we should add a small random deviation by looking up an offset in a random map
	vec3 rdm = get_noise(pos);
	pos.x += spacing * rdm.r * 2.0;
	pos.z += spacing * rdm.g * 2.0;
	
	// check our density map
	float density = get_densities(pos);
	if (density > (rdm.r * 0.7 + 0.1)) {
		// create our transform for our position (we should make our scale random
		TRANSFORM = get_transform(pos, base_scale * (1.0 - (0.5 * rdm.b)), rdm.g * 3.0);
	} else {
		// ugly hack for now, we're placing our grass somewhere underneath our terrain to hide it
		TRANSFORM[3][0] = pos.x;
		TRANSFORM[3][1] = -10000.0;
		TRANSFORM[3][2] = pos.z;
	}
}