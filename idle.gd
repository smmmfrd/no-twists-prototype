extends State

@export var move_state : State

func process_input(event : InputEvent) -> State:
	if get_movement_input() != Vector3.ZERO:
		print("changing to move state")
		return move_state
	
	return null

func process_physics(delta : float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	return null
