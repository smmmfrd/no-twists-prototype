extends CharacterBody3D

@export var MOUSE_HORIZONTAL_SENS = .5
@export var MOUSE_VERTICAL_SENS = .5
@export var MAX_LOOK_ANGLE = 60

@onready var camera_joint : Node3D = %"Camera Joint"
@onready var animation_player: AnimationPlayer = $Visuals/mixamo_base/AnimationPlayer
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

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

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
