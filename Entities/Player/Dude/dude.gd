extends Player

@export var dash_speed: float = 1200.0

@onready var dash_timer = $Timers/DashTimer
@onready var dash_delay = $Timers/DashDelay

var is_dashing: bool = false

func _physics_process(delta):
	fixed_update(delta)
	
	if not is_active: return
	_handle_dash()

func _handle_dash():
	if Input.is_action_just_pressed("ability") and dash_delay.time_left == 0:
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
