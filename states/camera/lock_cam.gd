extends CameraState

@export var cam_join_offset : Vector3

@export var free_state : CameraState

var joint_start_pos : Vector3

func enter() -> void:
	joint_start_pos = parent.camera_joint.position
	parent.camera_joint.position = parent.camera_joint.position + cam_join_offset

func exit() -> void:
	parent.camera_joint.position = joint_start_pos

func process_input(_event: InputEvent) -> CameraState:
	if wants_lock():
		return free_state
	
	return null

func process_frame(_delta : float) -> CameraState:
	var player_pos := Vector2(parent.global_position.x, parent.global_position.z)
	var target_pos := Vector2(0, 0)
	var dir = -(target_pos - player_pos)
	
	parent.rotation.y = atan2(dir.x, dir.y)
	
	return null
