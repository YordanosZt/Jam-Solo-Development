extends Camera2D

@export var players : Array

var active_player : CharacterBody2D
var active_idx: int = 0

var y_offset: float = -100.0

func _ready():
	active_player = get_node(players[active_idx])
	active_player.set_is_active(true)
	
	offset = Vector2(0, y_offset)

func _process(_delta):
	handle_switch()
	
	update_position()

func update_position():
	global_position = active_player.global_position

func handle_switch():
	if Input.is_action_just_pressed("switch_left"):
		switch_player(-1)
		
	if Input.is_action_just_pressed("switch_right"):
		switch_player(1)

func switch_player(dxn: int):
	active_player.set_is_active(false)
	active_idx += dxn
	
	if active_idx < 0:
		active_idx = players.size() - 1
	elif active_idx >= players.size():
		active_idx = 0
	
	active_player = get_node(players[active_idx])
	active_player.set_is_active(true)
