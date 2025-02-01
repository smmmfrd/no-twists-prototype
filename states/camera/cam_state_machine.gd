class_name CameraMachine
extends Node

@export var starting_state : CameraState

@export var MOUSE_HORIZONTAL_SENS = .5
@export var MOUSE_VERTICAL_SENS = .5

@export var CONTROLLER_HORIZONTAL_SENS = 4
@export var CONTROLLER_VERTICAL_SENS = 4

var current_state : CameraState

func init(parent: Player) -> void:
	for child in get_children():
		child.parent = parent
		child.controller = self
	
	change_state(starting_state)

func change_state(new_state: CameraState) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()

func process_input(event:InputEvent) -> void:
	var new_state := current_state.process_input(event)
	
	if new_state:
		change_state(new_state)

func process_physics(delta:float) -> void:
	var new_state := current_state.process_physics(delta)
	
	if new_state:
		change_state(new_state)

func process_frame(delta:float) -> void:
	var new_state := current_state.process_frame(delta)
	
	if new_state:
		change_state(new_state)
