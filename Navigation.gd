extends Position3D

export (NodePath) var terrain = null

var angle_x = -10;
var angle_y = 0;

var _angle_x = -10;
var _angle_y = 0;

var move_to;

const MIN_CAM_GROUND_DISTANCE = 1.0

func _ready():
	move_to = transform.origin

func _input(event):
	if event is InputEventMouseMotion:
		if Input.is_key_pressed(KEY_ALT):
			# rotate by motion
			angle_x -= event.relative.y;
			angle_y -= event.relative.x;
			
			if angle_x > -5:
				angle_x = -5
			elif angle_x < -90:
				angle_x = -90
		elif Input.is_key_pressed(KEY_SHIFT):
			var left_right = transform.basis.x
			left_right.y = 0.0
			left_right = left_right.normalized()
			
			move_to += left_right * event.relative.x * -0.1
			
			var front_back = transform.basis.z
			front_back.y = 0.0
			front_back = front_back.normalized()
			
			move_to += front_back * event.relative.y * -0.1
		elif Input.is_key_pressed(KEY_CONTROL):
			var cam_origin = $Camera.transform.origin
			cam_origin.z = clamp(cam_origin.z + (event.relative.y * 0.1), 10.0, 1000.0)
			$Camera.transform.origin = cam_origin

func _process(delta):
	if angle_x != _angle_x or angle_y != _angle_y:
		_angle_x += (angle_x - _angle_x) * delta * 10.0;
		_angle_y += (angle_y - _angle_y) * delta * 10.0;
		
		var basis = Basis(Vector3(0.0, 1.0, 0.0), deg2rad(_angle_y))
		basis *= Basis(Vector3(1.0, 0.0, 0.0), deg2rad(_angle_x))
		transform.basis = basis
	
	if move_to != transform.origin:
		transform.origin += (move_to - transform.origin) * delta * 10.0;
	
#	if terrain:
#		# position our pivot so it is above ground
#		var info = get_node(terrain).get_terrain_info(translation)
#		if !info.empty():
#			translation.y = info['height'] + 1.0
#
#		# now check if this positions our camera below ground, if so we move it heigher
#		info = get_node(terrain).get_terrain_info(camera_node.global_transform.origin)
#		if !info.empty():
#			var cam_y = $Camera.global_transform.origin.y
#			if cam_y < info['height'] + MIN_CAM_GROUND_DISTANCE:
#				translation.y += info['height'] + MIN_CAM_GROUND_DISTANCE - cam_y