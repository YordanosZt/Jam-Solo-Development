extends Player

@export var dash_speed: float = 1200.0

@onready var dash_timer = $Timers/DashTimer
@onready var dash_delay = $Timers/DashDelay

var is_dashing: bool = false

func _physics_process(delta):
	super.fixed_update(delta)
	
	handle_dash()

func handle_dash():
	if Input.is_action_just_pressed("dash") and dash_delay.time_left == 0:
		dash_timer.start()
		dash_delay.start()
		
	if dash_timer.time_left > 0:
		super.set_speed(dash_speed)
		super.set_can_fall(false)
		is_dashing = true
	else:
		super.reset_speed()
		super.set_can_fall(true)
		is_dashing = false
