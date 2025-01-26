extends State

@export var move_state : State

func process_input(_event : InputEvent) -> State:
	if get_movement_input() != Vector3.ZERO:
		return move_state
	
	return null

func process_frame(_delta : float) -> State:
	parent.velocity.x = move_toward(parent.velocity.x, 0, move_speed)
	parent.velocity.z = move_toward(parent.velocity.z, 0, move_speed)
	
	parent.move_and_slide()
	
	return null
