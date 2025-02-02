extends CameraState

@export var lock_state : CameraState

func process_input(event: InputEvent) -> CameraState:
	if wants_lock():
		return lock_state
	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		free_move_camera(event.relative, controller.MOUSE_HORIZONTAL_SENS, controller.MOUSE_VERTICAL_SENS)
	
	return null

func process_frame(_delta : float) -> CameraState:
	free_move_camera(get_camera_input(), controller.CONTROLLER_HORIZONTAL_SENS, controller.CONTROLLER_VERTICAL_SENS)
	
	return null

func free_move_camera(direction : Vector2, HORIZONTAL_SENS : float, VERTICAL_SENS : float) -> void:
	if direction == Vector2.ZERO:
		return
	
	# Rotating player
	parent.rotate_y(deg_to_rad(-direction.x * HORIZONTAL_SENS))
	
	# Rotate player visual to make model stand in place
	parent.visuals.rotate_y(deg_to_rad(direction.x * HORIZONTAL_SENS))
	
	# Rotating camera joint
	parent.camera_joint.rotate_x(deg_to_rad(-direction.y * VERTICAL_SENS))
	parent.camera_joint.rotation.x = clampf(parent.camera_joint.rotation.x, -deg_to_rad(MAX_LOOK_ANGLE), deg_to_rad(MAX_LOOK_ANGLE))
