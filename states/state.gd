class_name State
extends Node

@export var move_speed : int = 3

@export var animation_name : String

var parent : CharacterBody3D

var gravity : float =  -ProjectSettings.get_setting("physics/3d/default_gravity")

func enter() -> void:
	parent.animation_player.play(animation_name)

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(_delta : float) -> State:
	return null

func process_frame(_delta : float) -> State:
	return null

func get_movement_input() -> Vector3:
	return parent.get_movement_direction()

func get_jump() -> bool:
	return parent.wants_jump()

func get_attack() -> bool:
	return parent.wants_attack()

func get_run() -> bool:
	return parent.wants_run()

func rotate_visuals(direction: Vector3) -> void:
	if direction != Vector3.ZERO:
		parent.visuals.look_at(parent.position + direction)
