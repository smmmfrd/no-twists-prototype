class_name State
extends Node

@export var move_speed : int = 3

@export var animation_name : String

var parent : CharacterBody3D

var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")

func enter() -> void:
	parent.animation_player.play(animation_name)

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta : float) -> State:
	return null

func process_frame(delta : float) -> State:
	return null

func get_movement_input() -> Vector3:
	return parent.get_movement_direction()

func rotate_visuals(direction: Vector3) -> void:
	parent.visuals.look_at(parent.position + direction)
