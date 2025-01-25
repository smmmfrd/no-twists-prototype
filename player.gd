extends CharacterBody3D

@export var MOUSE_HORIZONTAL_SENS = .5
@export var MOUSE_VERTICAL_SENS = .5
@export var MAX_LOOK_ANGLE = 60

@onready var camera_joint : Node3D = %"Camera Joint"
@onready var animation_player: AnimationPlayer = $Visuals/mixamo_base/AnimationPlayer
@onready var visuals: Node3D = $Visuals

const WALKING_SPEED = 3
const RUNNING_SPEED = 5

const JUMP_VELOCITY = 4.5

var locked = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Rotating player
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_HORIZONTAL_SENS))
		
		# Rotate player visual to make model stand in place
		visuals.rotate_y(deg_to_rad(event.relative.x * MOUSE_HORIZONTAL_SENS))
		
		# Rotating camera joint
		camera_joint.rotate_x(deg_to_rad(-event.relative.y * MOUSE_VERTICAL_SENS))
		camera_joint.rotation.x = clampf(camera_joint.rotation.x, -deg_to_rad(MAX_LOOK_ANGLE), deg_to_rad(MAX_LOOK_ANGLE))
	
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event.is_action_pressed("click"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("attack") and !locked:
		if animation_player.current_animation != "kick":
			animation_player.play("kick")
			animation_player.animation_finished.connect(attack_finished)
			print("kickin it")
			locked = true
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var current_speed = WALKING_SPEED if not Input.is_action_pressed("sprint") else RUNNING_SPEED
	
	if direction:
		if !locked:
			if Input.is_action_pressed("sprint"):
				if animation_player.current_animation != "running":
					animation_player.play("running")
			else:
				if animation_player.current_animation != "walking":
					animation_player.play("walking")
			
				visuals.look_at(position + direction)
		
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		if !locked:
			if animation_player.current_animation != "idle":
				animation_player.play("idle")
			velocity.x = move_toward(velocity.x, 0, current_speed)
			velocity.z = move_toward(velocity.z, 0, current_speed)
	
	if !locked:
		move_and_slide()

func attack_finished(_anim_name : String):
	locked = false
