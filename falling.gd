extends State

@export var idle_state : State
@export var moving_state : State

func process_frame(delta : float) -> State:
	var direction = get_movement_input()
	
	rotate_visuals(direction)
	
	if not parent.is_on_floor():
		parent.velocity.y += gravity * delta
	else:
		if direction == Vector3.ZERO:
			return idle_state
		
		return moving_state
	
	parent.velocity.x = direction.x * move_speed
	parent.velocity.z = direction.z * move_speed
	
	parent.move_and_slide()
	
	return null
