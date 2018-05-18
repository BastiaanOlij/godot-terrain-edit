extends "res://Viewports/editor.gd"

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
