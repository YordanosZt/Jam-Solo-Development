class_name Player

extends CharacterBody2D

@export var is_active: bool = false

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0

@export var acceleration: float = 1500.0;
@export var deceleration: float = 1500.0;

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_speed: float = speed
var checkpoint_pos: Vector2 = Vector2.ZERO

# flags
var was_on_ground: bool = false
var can_fall: bool = true

@onready var coyote_timer = %CoyoteTimer
@onready var jump_buffer_timer = %JumpBufferTimer

func _ready():
	checkpoint_pos = global_position

func _physics_process(delta):
	fixed_update(delta)

func fixed_update(delta):
	_handle_gravity(delta)
	
	if not is_active: return
	
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
		start_buffer_timer()
	
	# jump
	if Input.is_action_just_pressed("jump") and should_jump():
		velocity.y = jump_velocity
	
	# variable jump height
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y /= 2

func start_buffer_timer() -> void:
	jump_buffer_timer.start()

func should_jump() -> bool:
	# normal jump &
	# coyote jump
	if is_on_floor() or coyote_timer.time_left > 0:
		return true
	
	# jump buffer	
	if jump_buffer_timer.time_left > 0 and is_on_floor():
		return true
	
	return false

func jump(vel: float = jump_velocity) -> void:
	velocity.y = vel

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

func set_is_active(active: bool) -> void:
	is_active = active

func die():
	global_position = checkpoint_pos
