extends Viewport

#####################################################################################
# Pickmap works by rendering our heightmap with a shader that encodes the map
# coordinates into the result set. 
# We then position our camera along the ray of our real viewports camera from wherever
# the mouse is currently located.
# We use an orthographic camera and we're only interested in the pixel right in the
# center so we render a really tiny viewport. 
# Godot crashed on me with a 1x1 viewport so I set it to 5x5 and we've getting the
# center pixel.

export (Texture) var heightmap = null setget set_heightmap, get_heightmap
export (NodePath) var display_viewport = null

var material = null
var hm_size = Vector2(4096.0, 4096.0)

# For some reason we don't have enough precision for a 4k x 4k map
# but as we're only showing part of our map this will be good enough
var pickmap_offset = Vector2(0.0, 0.0)
var pickmap_size = Vector2(512.0, 512.0)

func get_current_mapcoords():
	var image = get_texture().get_data()
	image.lock()
	var map = image.get_pixel(size.x / 2.0 - 1.0, size.y / 2.0 - 1.0)
	image.unlock()
	
	var pos = Vector2(map.r * pickmap_size.x, map.g * pickmap_size.y);
	
	if pos.x == 0.0 and pos.y == 0.0:
		return null
	
	pos -= pickmap_size / 2.0;
	pos += pickmap_offset;
	pos += hm_size / 2.0;
	
	return pos

func set_heightmap(new_heightmap):
	heightmap = new_heightmap;
	if material and heightmap:
		hm_size = heightmap.get_size()
		material.set_shader_param("heightmap", heightmap)
		material.set_shader_param("heightmap_size", hm_size)

func get_heightmap():
	return heightmap

func _ready():
	# get our material, note that all parts of our terrain share this material
	material = get_node("Terrain/64_by_64/Plane_0_0").get_surface_material(0)
	material.set_shader_param("pickmap_size", pickmap_size)
	
	# reapply no that we have access to our material
	set_heightmap(heightmap)

func _process(delta):
	# get our parents viewport and its camera
	var vp = null
	
	# try to get our display viewport first
	if display_viewport:
		vp = get_node(display_viewport)
	
	# didn't have a display viewport? then get our main viewport
	if !vp:
		vp = get_parent().get_viewport()
		
	# get our camera
	var cam = vp.get_camera()
	if cam:
		var mp = vp.get_mouse_position() 
		var new_transform = Transform()
		
		# position our camera along the ray
		new_transform.origin = cam.project_ray_origin(mp)
		$Camera.global_transform = new_transform.looking_at(new_transform.origin + cam.project_ray_normal(mp), Vector3(0.0, 1.0, 0.0))
	
		# need to update the offset
		var cam_pos = cam.get_global_transform().origin
		pickmap_offset = Vector2(floor(cam_pos.x), floor(cam_pos.z))
		material.set_shader_param("pickmap_offset", pickmap_offset)
