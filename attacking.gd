extends State

@export var idle_state : State
@export var moving_state : State

var attacking = false

func enter() -> void:
	super()
	
	attacking = true
	parent.animation_player.animation_finished.connect(attack_finished)

func process_frame(_delta : float) -> State:
	if attacking:
		return null
	
	var direction = get_movement_input()
	
	if direction == Vector3.ZERO:
		return idle_state
	
	return moving_state

func attack_finished(_anim_name : String) -> void:
	attacking = false
