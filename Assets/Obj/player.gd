extends CharacterBody3D

@onready var anim: AnimationPlayer = $Visual/AnimationPlayer

var SPEED = 5.0
var JUMP_VELOCITY = 6.0 * GLOBAL.PIXEL_Y
var ACCEL = 0.75
var DECCEL = 0.2

var JUMP_FORCE_BASE = 6.0 * GLOBAL.PIXEL_Y
var jump_force = JUMP_FORCE_BASE

var GRAVITY_BASE = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = GRAVITY_BASE

var is_moving: bool = false
var is_falling: bool = false
var is_jumping: bool = false
var in_air: bool = false

var can_jump: bool = true
var jump_trigger: bool = false

var jump_time_threshold = 10
var jump_time = 0

var jump_buffer_max = 6
var jump_buffer: float = 0.0

var coyote_time_max: float = 5.0
var coyote_time: float = coyote_time_max

var jump_accel = 0.4
var jump_accel_threshold = 10
var jump_accel_time = jump_accel_threshold
var jump_accel_time_max = -10

var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
var direction = (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
var direction_string = "down"

enum STATE {
	idle,
	walk,
	run
}

var state = STATE.idle

func _process(delta: float) -> void:
	
	if !is_moving:
		anim.play("idle_" + str(direction_string))
		anim.speed_scale = 0.0
	else:
		anim.play("walk_" + str(direction_string))
		anim.speed_scale = velocity.length() * 0.25;

func _physics_process(delta: float) -> void:

	if !is_on_floor():
		velocity.y -= gravity * delta
	else:
		jump_trigger = false
		is_jumping = false
		is_falling = false
		
	if velocity.y < 0.0:
		is_falling = true
	else:
		is_falling = false
		
	if is_falling:
		if abs(velocity.y) < 0.75:
			gravity = lerp(gravity, GRAVITY_BASE * .5, .1)
		else:
			gravity = GRAVITY_BASE
	else:
		gravity = GRAVITY_BASE * 1.1
		
	if velocity.y != 0.0:
		in_air = true
	else:
		in_air = false
		
	if Input.is_action_just_pressed("jump") && can_jump:
		#velocity.y = JUMP_VELOCITY
		jump_buffer = jump_buffer_max

	if jump_buffer > 0:
		if jump_buffer <= 0.0:
			jump_buffer = 0.0
		else:
			jump_buffer -= 1.0 
		
		if !jump_trigger || coyote_time > 0.0:
			jump()
			
	
	if is_falling && !is_jumping:
		if coyote_time > 0.0:
			coyote_time -= 1.0
	
	print(coyote_time)
	
	input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, ACCEL)
		velocity.z = lerp(velocity.z, direction.z * SPEED, ACCEL * GLOBAL.PIXEL_Z)
	else:
		velocity.x = lerp(velocity.x, 0.0, DECCEL)
		velocity.z = lerp(velocity.z, 0.0, DECCEL * GLOBAL.PIXEL_Z)

	if velocity.x != 0.0 || velocity.z != 0.0:
		is_moving = true;
	else:
		is_moving = false;
		
		
	var stop_treshold = 0.1;
	if velocity.x > -stop_treshold && velocity.x < stop_treshold:
		velocity.x = 0.0
	if velocity.z > -stop_treshold && velocity.z < stop_treshold:
		velocity.z = 0.0
	
	match input_dir:
		Vector2(0, 0):
			pass
		Vector2(-1, 0),\
		Vector2(-1, -1):
			direction_string = "left"
		Vector2(1, 0),\
		Vector2(1, 1):
			direction_string = "right"
		Vector2(0, -1),\
		Vector2(1, -1):
			direction_string = "up"
		Vector2(0, 1),\
		Vector2(-1, 1):
			direction_string = "down"
			

	move_and_slide()

func jump():
	velocity.y = JUMP_FORCE_BASE
	is_jumping = true
	is_falling = false
	jump_trigger = true
