extends StaticBody2D

@onready var animation_player = $AnimationPlayer
@onready var delay = $Delay

var die_time: float = 0.2
var return_time: float = 2.0

var is_active: bool = true

func _on_check_player_body_entered(body):
	delay.wait_time = die_time
	delay.start()

func _on_delay_timeout():
	is_active = !is_active
	
	if is_active:
		animation_player.play("return")
	else:
		animation_player.play("burn away")
		delay.wait_time = return_time
		delay.start()
