extends Control

export (NodePath) var terrain_map = null
export (NodePath) var splat_map = null
export (NodePath) var particle_map = null
export (NodePath) var terrain = null

signal popup_shown
signal popup_hidden
signal brush_texture_changed(texture)
signal time_of_day_changed(new_hours)

var heightmap_filename = "heightmap.png"
var splatmap_filename = "splatmap.png"
var particlemap_filename = "particlemap.png"

func _ready():
	set_paint_mode(paint_mode)
	
	if terrain:
		$Texture_0.texture_normal = get_node(terrain).get_texture_map_1()
		$Texture_1.texture_normal = get_node(terrain).get_texture_map_2()
		$Texture_2.texture_normal = get_node(terrain).get_texture_map_3()
		$Texture_3.texture_normal = get_node(terrain).get_texture_map_4()
		$Texture_4.texture_normal = get_node(terrain).get_texture_map_5()

func _on_popup_show():
	emit_signal("popup_shown")

func _on_popup_hide():
	emit_signal("popup_hidden")

##############################################################################
# Save
func _on_Save_pressed():
	$Save/SaveFileDialog.popup_centered()

func _on_SaveFileDialog_confirmed():
	# should move save logic somewhere more central
	
	# make sure we have everything we need to save
	if !terrain_map:
		return
	
	if !splat_map:
		return
	
	if !particle_map:
		return
	
	if !terrain:
		return
	
	# determine some filenames
	var save_dir = $Save/SaveFileDialog.current_dir + "/"
	var terrain_heightmap_filename = save_dir + heightmap_filename
	var terrain_splatmap_filename = save_dir + splatmap_filename
	var terrain_particlemap_filename = save_dir + particlemap_filename
	
	# start saving our textures
	print("Saving " + terrain_heightmap_filename)
	var image = get_node(terrain_map).get_texture().get_data()
	image.save_png(terrain_heightmap_filename)
	
	print("Saving " + terrain_splatmap_filename)
	image = get_node(splat_map).get_texture().get_data()
	image.save_png(terrain_splatmap_filename)
	
	print("Saving " + terrain_particlemap_filename)
	image = get_node(particle_map).get_texture().get_data()
	image.save_png(terrain_particlemap_filename)
	
#	Disabled the saving of textures for now, not sure why but it seems to be loosing something
#	Will probably implement this completely different, keeping track of the image names of the images.
#	var material = get_node(terrain).get_material()
#	if !material:
#		return
#	for i in range (0, 5):
#		var image_name = "texture_map_" + str(i+1)
#		image.copy_from(material.get_shader_param(image_name).get_data())
#		image.clear_mipmaps()
#		image.save_png(save_dir + image_name + ".png")
#		
#		Disable this for now, we need to undo normalmap_to_xy
#		image_name = "normal_map_" + str(i+1)
#		image.copy_from(material.get_shader_param(image_name).get_data())
#		image.clear_mipmaps()
#		image.save_png(save_dir + image_name + ".png")
#		
#		image_name = "pbr_map_" + str(i+1)
#		image.copy_from(material.get_shader_param(image_name).get_data())
#		image.clear_mipmaps()
#		image.save_png(save_dir + image_name + ".png")
	
	# we should also save a settings file or create a scene file or something
	

##############################################################################
# Load

func _on_Load_pressed():
	$Load/LoadFileDialog.popup_centered()

func _on_LoadFileDialog_confirmed():
	# should move load logic more central

	# make sure we have everything we need to save
	if !terrain_map:
		return
	
	if !splat_map:
		return
	
	if !particle_map:
		return
	
	if !terrain:
		return
	
	var file = File.new()
	var load_dir = $Load/LoadFileDialog.current_dir + "/"
	var terrain_heightmap_filename = load_dir + "/" + heightmap_filename
	var terrain_splatmap_filename = load_dir + "/" + splatmap_filename
	var terrain_particlemap_filename = load_dir + "/" + particlemap_filename
	
	if file.file_exists(terrain_heightmap_filename):
		print("Loading " + terrain_heightmap_filename)
		get_node(terrain_map).load_image(terrain_heightmap_filename)
	
	if file.file_exists(terrain_splatmap_filename):
		print("Loading " + terrain_splatmap_filename)
		get_node(splat_map).load_image(terrain_splatmap_filename)
	
	if file.file_exists(terrain_particlemap_filename):
		print("Loading " + terrain_particlemap_filename)
		get_node(particle_map).load_image(terrain_particlemap_filename)
	
#	Disabled for now, it's loosing something in these loads.. 
#	var material = get_node(terrain).get_material()
#	if !material:
#		return
#	for i in range (0, 5):
#		var image_name = "texture_map_" + str(i+1)
#		if file.file_exists(load_dir + image_name + ".png"):
#			get_node(terrain).load_texture_map(i + 1, load_dir + image_name + ".png")
#		
#		image_name = "normal_map_" + str(i+1)
#		if file.file_exists(load_dir + image_name + ".png"):
#			get_node(terrain).load_normal_map(i + 1, load_dir + image_name + ".png")
#		
#		image_name = "pbr_map_" + str(i+1)
#		if file.file_exists(load_dir + image_name + ".png"):
#			get_node(terrain).load_pbr_map(i + 1, load_dir + image_name + ".png")
	
	$Texture_0.texture_normal = get_node(terrain).get_texture_map_1()
	$Texture_1.texture_normal = get_node(terrain).get_texture_map_2()
	$Texture_2.texture_normal = get_node(terrain).get_texture_map_3()
	$Texture_3.texture_normal = get_node(terrain).get_texture_map_4()
	$Texture_4.texture_normal = get_node(terrain).get_texture_map_5()

##############################################################################
# Paint modes

export (int) var paint_mode = 0 setget set_paint_mode, get_paint_mode

func set_paint_mode(p_mode):
	paint_mode = p_mode
	
	# first time this is called it will be before everything is loaded so... :)
	if $UpDownButton:
		var selected_color = Color(1.0, 1.0, 1.0, 1.0)
		var not_selected_color = Color(1.0, 1.0, 1.0, 0.5)
		if paint_mode == 0:
			$UpDownButton.modulate = selected_color
		else:
			$UpDownButton.modulate = not_selected_color
		
		if paint_mode == 1:
			$SmoothButton.modulate = selected_color
		else:
			$SmoothButton.modulate = not_selected_color
		
		if paint_mode == 5:
			$Texture_0.modulate = selected_color
		else:
			$Texture_0.modulate = not_selected_color
		
		if paint_mode == 6:
			$Texture_1.modulate = selected_color
		else:
			$Texture_1.modulate = not_selected_color
		
		if paint_mode == 7:
			$Texture_2.modulate = selected_color
		else:
			$Texture_2.modulate = not_selected_color
		
		if paint_mode == 8:
			$Texture_3.modulate = selected_color
		else:
			$Texture_3.modulate = not_selected_color
		
		if paint_mode == 9:
			$Texture_4.modulate = selected_color
		else:
			$Texture_4.modulate = not_selected_color
		
		if paint_mode == 10:
			$Particle_0.modulate = selected_color
		else:
			$Particle_0.modulate = not_selected_color

		if paint_mode == 11:
			$Particle_1.modulate = selected_color
		else:
			$Particle_1.modulate = not_selected_color

		if paint_mode == 12:
			$Particle_2.modulate = selected_color
		else:
			$Particle_2.modulate = not_selected_color

		if paint_mode == 13:
			$Particle_3.modulate = selected_color
		else:
			$Particle_3.modulate = not_selected_color

func get_paint_mode():
	return paint_mode

func _on_UpDownButton_pressed():
	set_paint_mode(0)

func _on_SmoothButton_pressed():
	set_paint_mode(1)

func _on_Texture_0_pressed():
	set_paint_mode(5)

func _on_Texture_1_pressed():
	set_paint_mode(6)

func _on_Texture_2_pressed():
	set_paint_mode(7)

func _on_Texture_3_pressed():
	set_paint_mode(8)

func _on_Texture_4_pressed():
	set_paint_mode(9)

##############################################################################
# Particles

func _on_Particle_0_pressed():
	set_paint_mode(10)

func _on_Particle_1_pressed():
	set_paint_mode(11)

func _on_Particle_2_pressed():
	set_paint_mode(12)

func _on_Particle_3_pressed():
	set_paint_mode(13)

##############################################################################
# Brush textures

export var brush_texture = "radial" setget set_brush_texture, get_brush_texture

func set_brush_texture(texture):
	if brush_texture != texture:
		brush_texture = texture
		emit_signal("brush_texture_changed", brush_texture)
	
	if $Brush_0:
		var selected_color = Color(1.0, 1.0, 1.0, 1.0)
		var not_selected_color = Color(1.0, 1.0, 1.0, 0.5)
		if brush_texture == "radial":
			$Brush_0.modulate = selected_color
		else:
			$Brush_0.modulate = not_selected_color
		
		if brush_texture == "splatter":
			$Brush_1.modulate = selected_color
		else:
			$Brush_1.modulate = not_selected_color

func get_brush_texture():
	return brush_texture

func _on_Brush_0_pressed():
	set_brush_texture("radial")

func _on_Brush_1_pressed():
	set_brush_texture("splatter")

##############################################################################
# Time of day

func _on_Time_of_day_value_changed(new_value):
	emit_signal("time_of_day_changed", new_value)



