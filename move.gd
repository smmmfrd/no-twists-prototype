extends State

@export var idle_state : State

func process_frame(_delta : float) -> State:	
	var direction = get_movement_input()
	
	if direction == Vector3.ZERO:
		return idle_state
	
	parent.velocity.x = direction.x * move_speed
	parent.velocity.z = direction.z * move_speed
	
	rotate_visuals(direction)
	
	parent.move_and_slide()
	
	return null
