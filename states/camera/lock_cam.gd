extends CameraState

@export var free_state : CameraState

func process_input(event: InputEvent) -> CameraState:
	if wants_lock():
		return free_state
	
	return null

func process_frame(_delta : float) -> CameraState:
	var player_pos := Vector2(parent.global_position.x, parent.global_position.z)
	var target_pos := Vector2(0, 0)
	var dir = -(target_pos - player_pos)
	
	parent.rotation.y = atan2(dir.x, dir.y)
	
	return null
