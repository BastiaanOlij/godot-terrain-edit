extends Viewport

#########################################################################################
# Brush strenght

export var brush_strength = 10.0 setget set_brush_strength, get_brush_strength

func get_brush_strength():
	return brush_strength

func set_brush_strength(strength):
	brush_strength = strength

#########################################################################################
# Brush size

export var brush_size = Vector2(10.0, 10.0) setget set_brush_size, get_brush_size

func get_brush_size():
	return brush_size

func set_brush_size(size):
	var was_pos = brush_pos
	
	size.x = clamp(size.x, 1.0, 256.0);
	size.y = clamp(size.y, 1.0, 256.0);
	brush_size = size
	# this can get called before we are ready :)
	if $Brush:
		$Brush.rect_size = brush_size
	
	# recenter it!
	set_brush_pos(brush_pos)

#########################################################################################
# Brush position

export var brush_pos = Vector2(1024.0,1024.0) setget set_brush_pos, get_brush_pos

func get_brush_pos():
	return brush_pos

func set_brush_pos(pos):
	brush_pos = pos;
	
	var centered_pos = brush_pos - (brush_size * 0.5)
	# this can get called before we are ready :)
	if $Brush:
		$Brush.rect_position = centered_pos

#########################################################################################
# Brush texture

export var brush_texture = "radial" setget set_brush_texture, get_brush_texture

func set_brush_texture(p_texture):
	brush_texture = p_texture
	if $Brush:
		var image = Image.new()
		var err = image.load("res://Textures/brushes/" + brush_texture + ".png")
		if err == 0:
			var texture = ImageTexture.new()
			texture.create_from_image(image, 0)
			$Brush.texture = texture

func get_brush_texture():
	return brush_texture

#########################################################################################
# Apply brush

func do_brush(pos, channel, multi):
	# just place all brushes, the visible one will render
	set_brush_pos(pos)
	
	# make sure our channel and strength are set
	$Brush.material.set_shader_param("channel", channel)
	$Brush.material.set_shader_param("strength", brush_strength * multi)
	
	# show only what we're about to use
	$Prefill.visible = false
	$Brush.visible = true

	# and trigger a render
	render_target_update_mode = Viewport.UPDATE_ONCE

func _ready():
	# make sure our prefill is the right size
	$Prefill.rect_size = size

	# reissue this now that we are ready, note that this will also call set_brush_pos
	set_brush_size(brush_size)

func load_image(p_filename):
	var image = Image.new()
	var err = image.load(p_filename)
#	var image = load(p_filename)
	if err == 0:
		var texture = ImageTexture.new()
		texture.create_from_image(image, 0)
		
		# Temporarily show our texture rectangle with our texture overwriting the contents of our viewport
		$Prefill.texture = texture
		$Prefill.visible = true
		$Brush.visible = false
		render_target_update_mode = Viewport.UPDATE_ONCE
