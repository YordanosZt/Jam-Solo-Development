extends Player

@export var dash_speed: float = 1200.0

@onready var dash_timer = $Timers/DashTimer
@onready var dash_delay = $Timers/DashDelay

@onready var visual = $Visual

var is_dashing: bool = false
var is_in_danger_zone: bool = false

func _physics_process(delta):
	fixed_update(delta)
	
	if not is_dashing and is_in_danger_zone:
		die()
	
	if is_dashing:
		visual.modulate = Color(1, 1, 1, 0.3)
	else:
		visual.modulate = Color(1, 1, 1, 1)
	
	if not is_active: return
	_handle_dash()

func _handle_dash():
	if velocity.x != 0 and Input.is_action_just_pressed("ability") and dash_delay.time_left == 0:
		dash_timer.start()
		dash_delay.start()
		
	if dash_timer.time_left > 0:
		set_speed(dash_speed)
		set_can_fall(false)
		is_dashing = true
	else:
		reset_speed()
		set_can_fall(true)
		is_dashing = false

func _on_hit_box_area_entered(_area):
	is_in_danger_zone = true

func _on_hit_box_area_exited(_area):
	is_in_danger_zone = false
