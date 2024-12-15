extends Node2D

var rot_speed: float = 1440.0
var move_speed: float = 200.0
var rot_dxn: int = 1
var move_dxn: int = 1

@onready var left_ray = $Raycasts/LeftRay
@onready var right_ray = $Raycasts/RightRay

@onready var visuals = $Visuals

func _process(delta):
	update_rot(delta)
	update_pos(delta)

func update_rot(delta):
	visuals.rotation_degrees += rot_dxn * rot_speed * delta
	#if visuals.rotation_degrees == 360 or visuals.rotation_degrees == -360: 
		#visuals.rotation_degrees *= -1

func update_pos(delta):
	global_position.x += move_dxn * move_speed * delta
	if left_ray.is_colliding():
		move_dxn = 1
		rot_dxn = 1
		left_ray.enabled = false
		right_ray.enabled = true
	elif right_ray.is_colliding():
		move_dxn = -1
		rot_dxn = -1
		left_ray.enabled = true
		right_ray.enabled = false




