extends State

@export var idle_state : State
@export var moving_state : State
@export var falling_state : State

@export var jump_velocity = 4.5

func enter() -> void:
	super()
	parent.velocity.y = jump_velocity

func process_frame(delta : float) -> State:
	var direction = get_movement_input()
	
	rotate_visuals(direction)
	
	parent.velocity.x = direction.x * move_speed
	parent.velocity.z = direction.z * move_speed
	parent.velocity.y += gravity * delta
	
	if parent.velocity.y < 0:
		return falling_state
	
	parent.move_and_slide()
	
	return null
