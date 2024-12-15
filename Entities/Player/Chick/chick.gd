extends Player

var ice_jump_vel: float = -800.0

@export var ice: PackedScene

@onready var ice_jump_timer = $Timers/IceJumpTimer

func _physics_process(delta):
	if not is_active: return
	
	fixed_update(delta)
	_handle_ice_jump()

func _handle_ice_jump():
	if ice_jump_timer.time_left == 0 and Input.is_action_just_pressed("ability") and should_jump():
		jump(ice_jump_vel)
		_spawn_ice()
		ice_jump_timer.start()

func _spawn_ice():
	var _ice = ice.instantiate()
	_ice.global_position = global_position
	_ice.global_rotation = global_rotation
	_ice.play_anim()
	add_child(_ice)
