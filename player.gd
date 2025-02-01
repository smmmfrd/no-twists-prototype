extends CharacterBody3D

@export var MOUSE_HORIZONTAL_SENS = .5
@export var MOUSE_VERTICAL_SENS = .5


@export var CONTROLLER_HORIZONTAL_SENS = 4
@export var CONTROLLER_VERTICAL_SENS = 4

@export var MAX_LOOK_ANGLE = 60

@onready var camera_joint : Node3D = %"Camera Joint"
@onready var animation_player: AnimationPlayer = $"Visuals/mixamo_base/AnimationPlayer"
@onready var visuals: Node3D = $Visuals
@onready var state_machine: Node = $"State Machine"

const WALKING_SPEED = 3
const RUNNING_SPEED = 5

const JUMP_VELOCITY = 4.5

var locked = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	state_machine.init(self)

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		move_camera(event.relative, MOUSE_HORIZONTAL_SENS, MOUSE_VERTICAL_SENS)
	
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event.is_action_pressed("click"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _process(delta: float) -> void:
	var look_direction = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	
	if look_direction != Vector2.ZERO:
		move_camera(look_direction, CONTROLLER_HORIZONTAL_SENS, CONTROLLER_VERTICAL_SENS)
	
	state_machine.process_frame(delta)

func move_camera(direction : Vector2, HORIZONTAL_SENS : float, VERTICAL_SENS : float) -> void:
	# Rotating player
		rotate_y(deg_to_rad(-direction.x * HORIZONTAL_SENS))
		
		# Rotate player visual to make model stand in place
		visuals.rotate_y(deg_to_rad(direction.x * HORIZONTAL_SENS))
		
		# Rotating camera joint
		camera_joint.rotate_x(deg_to_rad(-direction.y * VERTICAL_SENS))
		camera_joint.rotation.x = clampf(camera_joint.rotation.x, -deg_to_rad(MAX_LOOK_ANGLE), deg_to_rad(MAX_LOOK_ANGLE))

func wants_jump() -> bool:
	return Input.is_action_just_pressed("jump")

func wants_attack() -> bool:
	return Input.is_action_just_pressed("attack")

func wants_run() -> bool:
	return Input.is_action_pressed("sprint")

func get_movement_direction() -> Vector3:
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var movement := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	return movement
