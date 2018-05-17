extends Spatial

onready var camera_node = get_node("Camera_Pivot/Camera")
onready var terrain_node = get_node("Terrain")
onready var terrain_map_node = get_node("Terrain-map")
onready var splatmap_node = get_node("Splatmap")

var enable_ui = true

func _ready():
	# make sure our brush sizes are all in sync by just reassigning the current value
	_update_brush_size(terrain_map_node.brush_size)

func _update_brush_size(size):
	# note, setting our brush size may clamp it so we use the size the terrain map accepted
	terrain_map_node.brush_size = size
	splatmap_node.brush_size = terrain_map_node.brush_size
			
	var radius = terrain_map_node.brush_size.length() * 0.5
	terrain_map_node.brush_strength = radius * 10.0
	terrain_node.set_target_radius(radius)

func _input(event):
	if !enable_ui:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			_update_brush_size(terrain_map_node.brush_size * 1.1)
		elif event.button_index == BUTTON_WHEEL_DOWN:
			_update_brush_size(terrain_map_node.brush_size / 1.1)
			
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

func _process(delta):
	# just to get continious drawing (as our render mode will keep resetting itself) we do this in a process
	
	if !enable_ui:
		return
	
	# check if we're above our UI
	var mouse_pos = get_viewport().get_mouse_position()
	if mouse_pos.x > $UI.rect_position.x:
		return
	
	# update pos
	var pos = $PickMap.get_current_mapcoords()
	if pos:
		$Terrain.set_target(pos + Vector2(0.5, 0.5))
	
		# for now we just react directly on our mouse buttons
		if Input.is_mouse_button_pressed(1):
			# add brush
			if $UI.paint_mode == 0:
				terrain_map_node.do_brush(pos, delta)
			elif $UI.paint_mode == 1:
				terrain_map_node.do_smooth(pos, delta)
			else:
				splatmap_node.do_brush(pos, $UI.paint_mode-5, delta)
		elif Input.is_mouse_button_pressed(2):
			# sub brush
			if $UI.paint_mode == 0:
				terrain_map_node.do_brush(pos, -1.0 * delta)
	else:
		$Terrain.set_target(Vector2(4096.0, 4096.0))

func _on_UI_popup_hidden():
	# re-enable our editor ui
	print("Enabled UI")
	enable_ui = true

func _on_UI_popup_shown():
	# disable our editor ui
	print("Disabled UI")
	enable_ui = false

func _on_UI_brush_texture_changed(texture):
	if terrain_map_node:
		terrain_map_node.set_brush_texture(texture)
		splatmap_node.set_brush_texture(texture)
