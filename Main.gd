extends Spatial

signal terrain_has_changed;

var enable_ui = true
var terrain_changed = false

var base_night_sky_rotation = Basis(Vector3(1.0, 1.0, -1.0).normalized(), 1.2)
var horizontal_angle = 25.0
var time_of_day = 10.5

var max_sun_energy = 2.0

func _ready():
	# make sure our brush sizes are all in sync by just reassigning the current value
	_update_brush_size($Viewports/Terrain_map.brush_size)
	
	# init our time of day
	$Sky_texture.set_time_of_day(time_of_day, get_node("DirectionalLight"), deg2rad(horizontal_angle), max_sun_energy)
	
	# rotate our night sky so our milkyway isn't on our horizon
	_set_sky_rotation()

func _update_brush_size(size):
	# note, setting our brush size may clamp it so we use the size the terrain map accepted
	$Viewports/Terrain_map.brush_size = size
	$Viewports/Splat_map.brush_size = $Viewports/Terrain_map.brush_size
	$Viewports/Particle_map.brush_size = $Viewports/Terrain_map.brush_size
	
	# should check if we also want to update the strength for our splat map and particle map
	var radius = $Viewports/Terrain_map.brush_size.length() * 0.5
	$Viewports/Terrain_map.brush_strength = radius * 10.0
	$Terrain_render.set_target_radius(radius)

func _input(event):
	if !enable_ui:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			_update_brush_size($Viewports/Terrain_map.brush_size * 1.1)
		elif event.button_index == BUTTON_WHEEL_DOWN:
			_update_brush_size($Viewports/Terrain_map.brush_size / 1.1)
	
	# should move this into UI
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_0:
				$UI.paint_mode = 0
			elif event.scancode == KEY_1:
				$UI.paint_mode = 5
			elif event.scancode == KEY_2:
				$UI.paint_mode = 6
			elif event.scancode == KEY_3:
				$UI.paint_mode = 7
			elif event.scancode == KEY_4:
				$UI.paint_mode = 8
			elif event.scancode == KEY_5:
				$UI.paint_mode = 9
			elif event.scancode == KEY_6:
				$UI.paint_mode = 10

func _process(delta):
	# just to get continious drawing (as our render mode will keep resetting itself) we do this in a process
	
	var fps = Performance.get_monitor(Performance.TIME_FPS)
	$FPS.text = str(fps)
	
	if !enable_ui:
		return
	
	# check if we're above our UI
	var mouse_pos = get_viewport().get_mouse_position()
	if mouse_pos.x > $UI.rect_position.x:
		return
	
	# update pos
	var pos = $Viewports/Pick_map.get_current_mapcoords()
	if pos:
		$Terrain_render.set_target(pos + Vector2(0.5, 0.5))
		pos += Vector2(1.0, 1.0)
	
		# for now we just react directly on our mouse buttons
		if Input.is_mouse_button_pressed(1):
			# add brush
			if $UI.paint_mode == 0:
				$Viewports/Terrain_map.do_brush(pos, delta)
				terrain_changed = true
			elif $UI.paint_mode == 1:
				$Viewports/Terrain_map.do_smooth(pos, delta)
				terrain_changed = true
			elif $UI.paint_mode >= 5 and $UI.paint_mode <= 9:
				$Viewports/Splat_map.do_brush(pos, $UI.paint_mode-5, delta)
			elif $UI.paint_mode >= 10 and $UI.paint_mode <= 13:
				$Viewports/Particle_map.do_brush(pos, $UI.paint_mode-10, delta)
		elif Input.is_mouse_button_pressed(2):
			# sub brush
			if $UI.paint_mode == 0:
				$Viewports/Terrain_map.do_brush(pos, -1.0 * delta)
			elif $UI.paint_mode >= 10 and $UI.paint_mode <= 13:
				$Viewports/Particle_map.do_brush(pos, $UI.paint_mode-10, -delta)
	else:
		$Terrain_render.set_target(Vector2(4096.0, 4096.0))
	
	# did the terrain change and we released our mouse button?
	if terrain_changed and !Input.is_mouse_button_pressed(1):
		terrain_changed = false
		
		# emit a signal so we can do things, like create an undo point
		emit_signal("terrain_has_changed")

func _on_UI_popup_hidden():
	# re-enable our editor ui
	print("Enabled UI")
	enable_ui = true

func _on_UI_popup_shown():
	# disable our editor ui
	print("Disabled UI")
	enable_ui = false

func _on_UI_brush_texture_changed(texture):
	if $Viewports/Terrain_map:
		$Viewports/Terrain_map.set_brush_texture(texture)
		$Viewports/Splat_map.set_brush_texture(texture)
		$Viewports/Particle_map.set_brush_texture(texture)

func _on_Main_terrain_has_changed():
	# we need to create a copy of the image from our terrain
	# this is veeeeeery slow, so need to find a way to delay this until the user stops editing for a bit
#	var new_image = Image.new()
#	new_image.copy_from($Viewports/Terrain_map.get_texture().get_data())
#	var new_texture = ImageTexture.new()
#	new_texture.create_from_image(new_image, 0)
		
	# should remember this image so we can implement an undo function, maybe keep the last 5...
	pass

############################################################
# sky related

func _set_sky_rotation():
	var rot = Basis(Vector3(0.0, 1.0, 0.0), deg2rad(horizontal_angle)) * Basis(Vector3(1.0, 0.0, 0.0), time_of_day * PI / 12.0)
	rot = rot * base_night_sky_rotation;
	$Sky_texture.set_rotate_night_sky(rot)

func _on_Sky_texture_sky_updated():
	$Sky_texture.copy_to_environment(get_viewport().get_camera().environment)

func _on_UI_time_of_day_changed(new_value):
	time_of_day = new_value

	$Sky_texture.set_time_of_day(time_of_day, get_node("DirectionalLight"), deg2rad(horizontal_angle), max_sun_energy)
	_set_sky_rotation()
