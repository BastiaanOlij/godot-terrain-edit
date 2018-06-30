extends Particles

export (Texture) var heightmap = null setget set_heightmap, get_heightmap
export (Texture) var particlemap = null setget set_particlemap, get_particlemap
export (Texture) var noisemap = null setget set_noisemap, get_noisemap
export var channel = 1 setget set_channel, get_channel

export var rows_and_columns = 10 setget set_rows_and_columns, get_rows_and_columns
export var spacing = 1.0 setget set_spacing, get_spacing

export var particle_scale = Vector3(1.0, 1.0, 1.0) setget set_particle_scale, get_particle_scale

func set_heightmap(new_texture):
	heightmap = new_texture;
	if process_material and heightmap:
		process_material.set_shader_param("heightmap", heightmap)

func get_heightmap():
	return heightmap

func set_particlemap(new_texture):
	particlemap = new_texture;
	if process_material and particlemap:
		process_material.set_shader_param("particlemap", particlemap)

func get_particlemap():
	return particlemap

func set_noisemap(new_texture):
	noisemap = new_texture;
	if process_material and noisemap:
		process_material.set_shader_param("noisemap", noisemap)

func get_noisemap():
	return noisemap

func set_channel(new_channel):
	channel = new_channel
	if process_material:
		if (channel == 1):
			process_material.set_shader_param("channel", Color(1.0, 0.0, 0.0, 0.0))
		elif (channel == 2):
			process_material.set_shader_param("channel", Color(0.0, 1.0, 0.0, 0.0))
		elif (channel == 3):
			process_material.set_shader_param("channel", Color(0.0, 0.0, 1.0, 0.0))
		elif (channel == 4):
			process_material.set_shader_param("channel", Color(0.0, 0.0, 0.0, 1.0))

func get_channel():
	return channel

func set_rows_and_columns(new_value):
	rows_and_columns = new_value
	amount = rows_and_columns * rows_and_columns
	if process_material:
		process_material.set_shader_param("rows", rows_and_columns)
	
	_update_size();

func get_rows_and_columns():
	return rows_and_columns

func set_spacing(new_spacing):
	spacing = new_spacing
	if process_material:
		process_material.set_shader_param("spacing", spacing)
	
	_update_size();

func get_spacing():
	return spacing

func set_particle_scale(new_scale):
	particle_scale = new_scale
	if process_material:
		process_material.set_shader_param("base_scale", particle_scale)

func get_particle_scale():
	return particle_scale

func _update_size():
	var size = rows_and_columns * spacing
	visibility_aabb = AABB(Vector3(-size * 0.5, 0.0, -size * 0.5), Vector3(size, 1000.0, size))

func _ready():
	# update these now we're ready to set our material
	set_heightmap(heightmap)
	set_particlemap(particlemap)
	set_noisemap(noisemap)
	set_channel(channel)
	set_rows_and_columns(rows_and_columns)
	set_spacing(spacing)
	set_particle_scale(particle_scale)

func _process(delta):
	var vp = get_parent().get_viewport()
	var camera_node = vp.get_camera()

	# need to recenter our terrain on our camera in large steps
	# improvements needed here is when the camera gets heigher up, we want to move our terrain more forward
	# more experimentation is needed here.
	if camera_node:
		# has to be a factor of spacing or we'll issues with our placement
		var step_size = spacing * 10.0
		
		# keep centered on our camera (we're going to enhance this to be forward of our camera)
		var new_location = camera_node.global_transform.origin
		
		# now make sure we reposition in fixed steps
		new_location.x -= fposmod(new_location.x, step_size) 
		new_location.z -= fposmod(new_location.z, step_size) 
		
		if global_transform.origin != new_location:
			# print("New location: " + str(new_location))
			global_transform.origin = new_location
