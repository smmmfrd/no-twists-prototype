class_name CameraMachine
extends Node

@export var starting_state : CameraState

@export var change_delay : float

@export var MOUSE_HORIZONTAL_SENS = .5
@export var MOUSE_VERTICAL_SENS = .5

@export var CONTROLLER_HORIZONTAL_SENS = 4
@export var CONTROLLER_VERTICAL_SENS = 4

var current_state : CameraState
var can_change := true

func init(parent: Player) -> void:
	for child in get_children():
		child.parent = parent
		child.controller = self
	
	change_state(starting_state)

func change_state(new_state: CameraState) -> void:
	if not can_change:
		return
	
	if current_state:
		current_state.exit()
	
	can_change = false
	get_tree().create_timer(change_delay).timeout.connect(delay_ended)
	
	current_state = new_state
	current_state.enter()

func delay_ended():
	can_change = true

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
