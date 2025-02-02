class_name Player
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
@onready var camera_state: Node = $"Camera State"

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	state_machine.init(self)
	camera_state.init(self)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event.is_action_pressed("click"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	camera_state.process_input(event)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	camera_state.process_frame(delta)

func wants_jump() -> bool:
	return Input.is_action_just_pressed("jump")

func wants_attack() -> bool:
	return Input.is_action_just_pressed("attack")

func wants_run() -> bool:
	return Input.is_action_pressed("sprint")

func wants_lock() -> bool:
	return Input.is_action_just_pressed("target")

func get_movement_direction() -> Vector3:
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var movement := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	return movement

func get_camera_direction() -> Vector2:
	var look_direction = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	
	return look_direction
