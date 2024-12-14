class_name Player

extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0

var current_speed: float = speed

@export var acceleration: float = 1500.0;
@export var deceleration: float = 1500.0;

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

# flags
var was_on_ground: bool = false
var can_fall: bool = true

@onready var coyote_timer = %CoyoteTimer
@onready var jump_buffer_timer = %JumpBufferTimer

func _physics_process(delta):
	fixed_update(delta)

func fixed_update(delta):
	_handle_gravity(delta)
	_handle_jump()
	_handle_move(delta)
	
	was_on_ground = is_on_floor()
	move_and_slide()
	if (was_on_ground and not is_on_floor()):
		coyote_timer.start()


func _handle_gravity(delta) -> void:
	if not can_fall:
		velocity.y = 0
	if can_fall and not is_on_floor():
		velocity.y += gravity * delta

func _handle_jump() -> void:
	# jump buffer
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		jump_buffer_timer.start()
	
	if jump_buffer_timer.time_left > 0 and is_on_floor():
		velocity.y = jump_velocity
	
	# normal jump &
	# coyote jump
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_timer.time_left > 0):
		velocity.y = jump_velocity
	
	# variable jump height
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y /= 2

func _handle_move(delta) -> void:
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * current_speed, acceleration*delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration*delta)

func set_speed(_speed) -> void:
	current_speed = _speed

func reset_speed() -> void:
	current_speed = speed

func set_can_fall(_can_fall) -> void:
	can_fall = _can_fall
