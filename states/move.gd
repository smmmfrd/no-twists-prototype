extends State

@export var idle_state : State
@export var falling_state : State
@export var jumping_state : State
@export var attacking_state : State
@export var running_state : State

func process_input(_event: InputEvent) -> State:
	if get_attack():
		return attacking_state
	
	if get_jump():
		return jumping_state
	
	if get_run():
		return running_state
	
	return null

func process_frame(_delta : float) -> State:
	
	var direction = get_movement_input()
	
	rotate_visuals(direction)
	
	if not parent.is_on_floor():
		return falling_state
	
	if direction == Vector3.ZERO:
		return idle_state
	
	parent.velocity.x = direction.x * move_speed
	parent.velocity.z = direction.z * move_speed
	
	parent.move_and_slide()
	
	return null
