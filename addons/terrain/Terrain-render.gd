extends Spatial

############################################################################
# target

export var target = Vector2(4096.0, 4096.0) setget set_target, get_target
export var target_radius = 1.0 setget set_target_radius, get_target_radius
export var target_inner_radius = 1.0 setget set_target_inner_radius, get_target_inner_radius
export var target_color = Color(1.0, 0.0, 0.0, 1.0) setget set_target_color, get_target_color

func set_target(new_target):
	target = new_target
	if material:
		material.set_shader_param("target", target)

func get_target():
	return target;

func set_target_radius(radius):
	target_radius = radius
	if material:
		material.set_shader_param("target_radius", target_radius)

func get_target_radius():
	return target_radius

func set_target_inner_radius(radius):
	target_inner_radius = radius
	if material:
		material.set_shader_param("target_inner_radius", target_inner_radius)

func get_target_inner_radius():
	return target_inner_radius

func set_target_color(color):
	target_color = color
	if material:
		material.set_shader_param("target_color", target_color)

func get_target_color():
	return target_color

############################################################################
# textures
export (Texture) var heightmap = null setget set_heightmap, get_heightmap

func set_heightmap(texture):
	heightmap = texture
	if material and heightmap:
		material.set_shader_param("heightmap", heightmap)
		material.set_shader_param("heightmap_size", heightmap.get_size())

func get_heightmap():
	return heightmap

export (Texture) var splatmap = null setget set_splatmap, get_splatmap

func set_splatmap(texture):
	splatmap = texture
	if material and splatmap:
		material.set_shader_param("splatmap", splatmap)
		material.set_shader_param("splatmap_size", splatmap.get_size())

func get_splatmap():
	return splatmap

export var texture_scale_1 = 0.1 setget set_texture_scale_1, get_texture_scale_1
export (Texture) var texture_map_1 = null setget set_texture_map_1, get_texture_map_1
export (Texture) var normal_map_1 = null setget set_normal_map_1, get_normal_map_1
export (Texture) var pbr_map_1 = null setget set_pbr_map_1, get_pbr_map_1

func set_texture_scale_1(texture_scale):
	texture_scale_1 = texture_scale
	if material:
		material.set_shader_param("texture_scale_1", texture_scale_1)

func get_texture_scale_1():
	return texture_scale_1

func set_texture_map_1(texture_map):
	texture_map_1 = texture_map
	if material and texture_map_1:
		material.set_shader_param("texture_map_1", texture_map_1)

func get_texture_map_1():
	return texture_map_1

func set_normal_map_1(normal_map):
	normal_map_1 = normal_map
	if material and normal_map_1:
		material.set_shader_param("normal_map_1", normal_map_1)

func get_normal_map_1():
	return normal_map_1

func set_pbr_map_1(pbr_map):
	pbr_map_1 = pbr_map
	if material and pbr_map_1:
		material.set_shader_param("pbr_map_1", pbr_map_1)

func get_pbr_map_1():
	return pbr_map_1

export var texture_scale_2 = 0.1 setget set_texture_scale_2, get_texture_scale_2
export (Texture) var texture_map_2 = null setget set_texture_map_2, get_texture_map_2
export (Texture) var normal_map_2 = null setget set_normal_map_2, get_normal_map_2
export (Texture) var pbr_map_2 = null setget set_pbr_map_2, get_pbr_map_2

func set_texture_scale_2(texture_scale):
	texture_scale_2 = texture_scale
	if material:
		material.set_shader_param("texture_scale_2", texture_scale_2)

func get_texture_scale_2():
	return texture_scale_2

func set_texture_map_2(texture_map):
	texture_map_2 = texture_map
	if material and texture_map_2:
		material.set_shader_param("texture_map_2", texture_map_2)

func get_texture_map_2():
	return texture_map_2

func set_normal_map_2(normal_map):
	normal_map_2 = normal_map
	if material and normal_map_2:
		material.set_shader_param("normal_map_2", normal_map_2)

func get_normal_map_2():
	return normal_map_2

func set_pbr_map_2(pbr_map):
	pbr_map_2 = pbr_map
	if material and pbr_map_2:
		material.set_shader_param("pbr_map_2", pbr_map_2)

func get_pbr_map_2():
	return pbr_map_2

export var texture_scale_3 = 0.1 setget set_texture_scale_3, get_texture_scale_3
export (Texture) var texture_map_3 = null setget set_texture_map_3, get_texture_map_3
export (Texture) var normal_map_3 = null setget set_normal_map_3, get_normal_map_3
export (Texture) var pbr_map_3 = null setget set_pbr_map_3, get_pbr_map_3

func set_texture_scale_3(texture_scale):
	texture_scale_3 = texture_scale
	if material:
		material.set_shader_param("texture_scale_3", texture_scale_3)

func get_texture_scale_3():
	return texture_scale_3

func set_texture_map_3(texture_map):
	texture_map_3 = texture_map
	if material and texture_map_3:
		material.set_shader_param("texture_map_3", texture_map_3)

func get_texture_map_3():
	return texture_map_3

func set_normal_map_3(normal_map):
	normal_map_3 = normal_map
	if material and normal_map_3:
		material.set_shader_param("normal_map_3", normal_map_3)

func get_normal_map_3():
	return normal_map_3

func set_pbr_map_3(pbr_map):
	pbr_map_3 = pbr_map
	if material and pbr_map_3:
		material.set_shader_param("pbr_map_3", pbr_map_3)

func get_pbr_map_3():
	return pbr_map_3

export var texture_scale_4 = 0.1 setget set_texture_scale_4, get_texture_scale_4
export (Texture) var texture_map_4 = null setget set_texture_map_4, get_texture_map_4
export (Texture) var normal_map_4 = null setget set_normal_map_4, get_normal_map_4
export (Texture) var pbr_map_4 = null setget set_pbr_map_4, get_pbr_map_4

func set_texture_scale_4(texture_scale):
	texture_scale_4 = texture_scale
	if material:
		material.set_shader_param("texture_scale_4", texture_scale_4)

func get_texture_scale_4():
	return texture_scale_4

func set_texture_map_4(texture_map):
	texture_map_4 = texture_map
	if material and texture_map_4:
		material.set_shader_param("texture_map_4", texture_map_4)

func get_texture_map_4():
	return texture_map_4

func set_normal_map_4(normal_map):
	normal_map_4 = normal_map
	if material and normal_map_4:
		material.set_shader_param("normal_map_4", normal_map_4)

func get_normal_map_4():
	return normal_map_4

func set_pbr_map_4(pbr_map):
	pbr_map_4 = pbr_map
	if material and pbr_map_4:
		material.set_shader_param("pbr_map_4", pbr_map_4)

func get_pbr_map_4():
	return pbr_map_4

export var texture_scale_5 = 0.1 setget set_texture_scale_5, get_texture_scale_5
export (Texture) var texture_map_5 = null setget set_texture_map_5, get_texture_map_5
export (Texture) var normal_map_5 = null setget set_normal_map_5, get_normal_map_5
export (Texture) var pbr_map_5 = null setget set_pbr_map_5, get_pbr_map_5

func set_texture_scale_5(texture_scale):
	texture_scale_5 = texture_scale
	if material:
		material.set_shader_param("texture_scale_5", texture_scale_5)

func get_texture_scale_5():
	return texture_scale_5

func set_texture_map_5(texture_map):
	texture_map_5 = texture_map
	if material and texture_map_5:
		material.set_shader_param("texture_map_5", texture_map_5)

func get_texture_map_5():
	return texture_map_5

func set_normal_map_5(normal_map):
	normal_map_5 = normal_map
	if material and normal_map_5:
		material.set_shader_param("normal_map_5", normal_map_5)

func get_normal_map_5():
	return normal_map_5

func set_pbr_map_5(pbr_map):
	pbr_map_5 = pbr_map
	if material and pbr_map_5:
		material.set_shader_param("pbr_map_5", pbr_map_5)

func get_pbr_map_5():
	return pbr_map_5

############################################################################
# internal

onready var center_plane = get_node("64_by_64/Plane_0_0")
var material = null

func _ready():
	# we'll reuse this material for all 
	material = center_plane.get_surface_material(0)
	
	# and only now can we update our material
	set_target(target)
	set_target_radius(target_radius)
	set_target_inner_radius(target_inner_radius)
	set_target_color(target_color)
	
	set_heightmap(heightmap)
	set_splatmap(splatmap)
	
	set_texture_scale_1(texture_scale_1)
	set_texture_map_1(texture_map_1)
	set_normal_map_1(normal_map_1)
	set_pbr_map_1(pbr_map_1)
	
	set_texture_scale_2(texture_scale_2)
	set_texture_map_2(texture_map_2)
	set_normal_map_2(normal_map_2)
	set_pbr_map_2(pbr_map_2)
	
	set_texture_scale_3(texture_scale_3)
	set_texture_map_3(texture_map_3)
	set_normal_map_3(normal_map_3)
	set_pbr_map_3(pbr_map_3)
	
	set_texture_scale_4(texture_scale_4)
	set_texture_map_4(texture_map_4)
	set_normal_map_4(normal_map_4)
	set_pbr_map_4(pbr_map_4)
	
	set_texture_scale_5(texture_scale_5)
	set_texture_map_5(texture_map_5)
	set_normal_map_5(normal_map_5)
	set_pbr_map_5(pbr_map_5)

func _process(delta):
	var vp = get_parent().get_viewport()
	var camera_node = vp.get_camera()

	# need to recenter our terrain on our camera in large steps
	# improvements needed here is when the camera gets heigher up, we want to move our terrain more forward
	# more experimentation is needed here.
	if camera_node:
		var cam_location = camera_node.global_transform.origin
		var new_location = global_transform.origin
		var offset = cam_location - new_location
		
		if offset.x < -32.0 or offset.x > 32.0:
			cam_location.x -= fmod(cam_location.x, 32.0)
			new_location.x = cam_location.x
		
		if offset.z < -32.0 or offset.z > 32.0:
			cam_location.z -= fmod(cam_location.z, 32.0)
			new_location.z = cam_location.z
		
		global_transform.origin = new_location

############################################################################
# Deprecated, I'll solve this differently

func get_material():
	return material

func load_texture_map(which, p_filename):
	var image_name = "texture_map_" + str(which)
	var image = Image.new()
	var err = image.load(p_filename)
	if err == 0:
		print("Loading " + p_filename + " for " + image_name)
		var texture = ImageTexture.new()
		texture.create_from_image(image, 1 + 2 + 4)
		material.set_shader_param(image_name, texture)

func load_normal_map(which, p_filename):
	var image_name = "normal_map_" + str(which)
	var image = Image.new()
	var err = image.load(p_filename)
	if err == 0:
		var texture = ImageTexture.new()
#		image.normalmap_to_xy()
		texture.create_from_image(image, 1 + 2 + 4)
		material.set_shader_param(image_name, texture)

func load_pbr_map(which, p_filename):
	var image_name = "pbr_map_" + str(which)
	var image = Image.new()
	var err = image.load(p_filename)
	if err == 0:
		var texture = ImageTexture.new()
		texture.create_from_image(image, 1 + 2 + 4)
		material.set_shader_param(image_name, texture)



