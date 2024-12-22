extends StaticBody2D

var can_spin: bool = false
var rot_speed: float = 300.0
var dxn: int = 1
@onready var return_timer = $ReturnTimer
@onready var start_spin_timer = $StartSpinTimer

func _physics_process(delta):
	if can_spin:
		spin(delta)

func spin(delta) -> void:
	rotation_degrees += dxn * rot_speed * delta
	
	if rotation_degrees >= 180.0:
		rotation_degrees = 180.0
		can_spin = false
		return_timer.start()
		dxn = -1
	if rotation_degrees <= 0:
		rotation_degrees = 0
		can_spin = false
		dxn = 1

func _on_check_player_body_entered(_8body):
	start_spin_timer.start()


func _on_return_timer_timeout():
	can_spin = true


func _on_start_spin_timer_timeout():
	can_spin = true
