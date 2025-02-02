class_name CameraState
extends Node

@export var MAX_LOOK_ANGLE = 50

var parent : Player
var controller : CameraMachine

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> CameraState:
	return null

func process_physics(_delta : float) -> CameraState:
	return null

func process_frame(_delta : float) -> CameraState:
	return null

func get_camera_input() -> Vector2:
	return parent.get_camera_direction()

func wants_lock() -> bool:
	return parent.wants_lock()
