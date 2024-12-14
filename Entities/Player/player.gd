extends CharacterBody2D


const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0

var acceleration: float = 900.0;
var deceleration: float = 900.0;

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

# flags
var was_on_ground: bool = false

@onready var coyote_timer = %CoyoteTimer
@onready var jump_buffer_timer = %JumpBufferTimer

func _physics_process(delta):
	handle_gravity(delta)
	
	handle_jump()
	
	handle_move(delta)
	
	was_on_ground = is_on_floor()
	
	move_and_slide()
	
	if (was_on_ground and not is_on_floor()):
		coyote_timer.start()


func handle_gravity(delta) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_jump() -> void:
	# jump buffer
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		jump_buffer_timer.start()
	
	if jump_buffer_timer.time_left > 0 and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# normal jump &
	# coyote jump
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_timer.time_left > 0):
		velocity.y = JUMP_VELOCITY
	
	# variable jump height
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y /= 2

func handle_move(delta) -> void:
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, acceleration*delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration*delta)

