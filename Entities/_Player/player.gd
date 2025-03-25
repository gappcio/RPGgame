extends CharacterBody3D

class_name Player

@onready var anim: AnimationPlayer = $Visual/AnimationPlayer
@export var inventory: Inventory;

@onready var camera_yaw: Node3D = $CameraRoot/CameraYaw

@onready var mesh: MeshInstance3D = $Visual/MeshInstance3D2
@onready var direction_sprite: Node3D = $Visual/direction_sprite

var SPEED = 5.0
var ACCEL = 0.75
var DECCEL = 0.2
var JUMP_FORCE_BASE = 4.5;
var jump_force = JUMP_FORCE_BASE

var GRAVITY_BASE = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = GRAVITY_BASE

var dir: Vector3;

var is_moving: bool = false
var is_falling: bool = false
var is_jumping: bool = false
var in_air: bool = false

var can_jump: bool = true
var jump_trigger: bool = false

var jump_time_threshold = 10.0
var jump_time = 0

var jump_buffer_max = 6.0
var jump_buffer: float = 0.0

var coyote_time_max: float = 6.0
var coyote_time: float = coyote_time_max

var just_jumped: bool = false

var jump_accel = 0.7
var jump_accel_threshold = 6.0
var jump_accel_time = jump_accel_threshold

var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
var direction = (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
var direction_string = "down"

var final_speed: float = SPEED;

enum STATE {
	idle,
	walk,
	run
}

var state = STATE.idle

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	
	if is_zero_approx(velocity.y):
		if !is_moving:
			anim.play("idle_" + str(direction_string))
			anim.speed_scale = 0.0
		else:
			
			var anim_pos = anim.current_animation_position;
			anim.play("walk_" + str(direction_string))
			anim.seek(anim_pos);
			
			if direction_string == "down" || direction_string == "up":
				anim.speed_scale = velocity.length() * 0.25;
			else:
				anim.speed_scale = velocity.length() * 0.25;
	elif velocity.y < 0.0:
		anim.play("fall_" + str(direction_string))
		anim.speed_scale = 0.0
	elif velocity.y > 0.0:
		anim.play("jump_" + str(direction_string))
		anim.speed_scale = 0.0
		
	if Input.is_action_just_pressed("camera_left"):
		inventory.add_item(ITEM.ITEM_ID.stick, 3);
		
	if Input.is_action_just_pressed("camera_right"):
		inventory.item_drop(ITEM.ITEM_ID.quartz, 1, global_position);

func _physics_process(delta: float) -> void:
	
	var key_right = Input.is_action_pressed("move_right")
	var key_left = Input.is_action_pressed("move_left")
	var key_down = Input.is_action_pressed("move_down")
	var key_up = Input.is_action_pressed("move_up")
	var key_jump = Input.is_action_just_pressed("jump")
	var key_jump_down = Input.is_action_pressed("jump")
	var key_run = Input.is_action_pressed("run")
	
	if key_right: direction_string = "right"
	if key_left: direction_string = "left"
	if key_down: direction_string = "down"
	if key_up: direction_string = "up"
	
	if !is_on_floor():
		velocity.y -= gravity * delta
	else:
		jump_trigger = false
		is_jumping = false
		is_falling = false
		coyote_time = coyote_time_max
		jump_time = 0
		
	if velocity.y < 0.0:
		is_falling = true
	else:
		is_falling = false
		
	if is_falling:
		if abs(velocity.y) < 0.75:
			gravity = lerp(gravity, GRAVITY_BASE * 1.25, .2)
		else:
			gravity = GRAVITY_BASE * 1.75
	else:
		gravity = GRAVITY_BASE * 2.25
		
		
	if velocity.y != 0.0:
		in_air = true
	else:
		in_air = false
		
	if key_jump && can_jump:
		#velocity.y = JUMP_VELOCITY
		jump_buffer = jump_buffer_max

	if jump_buffer > 0.0:
		if jump_buffer <= 0.0:
			jump_buffer = 0.0
		else:
			jump_buffer -= 1.0 
		
		if !jump_trigger && !in_air:
			jump()
			
	
	if is_jumping:
		jump_time += 1.0
	
	if just_jumped:
		jump_accel_time -= 1.0;
		
		if jump_accel_time <= 0.0:
			just_jumped = false
			jump_accel_time = jump_accel_threshold
			
		velocity.y = lerp(velocity.y, JUMP_FORCE_BASE * 1.25, jump_accel)
			
	
	if !key_jump_down && is_jumping:
		if !is_falling && !is_on_floor():
			jump_time = jump_time_threshold
			jump_accel_time = jump_accel_threshold
			just_jumped = false
			velocity.y *= 0.9
	
	if is_falling && !is_jumping:
		if coyote_time > 0.0:
			coyote_time -= 1.0
			
			if !jump_trigger && jump_buffer > 0.0:
				jump()
	
	input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left");
	direction.z = Input.get_action_strength("move_down") - Input.get_action_strength("move_up");
	#direction = Vector2(direction.x, direction.z).rotated(-camera_root.rotation.y);
	direction = direction.rotated(Vector3.UP, camera_yaw.rotation.y);
	var target_rotation = atan2(direction.x, direction.z);
	mesh.rotation.y = lerp_angle(mesh.rotation.y, target_rotation, 10 * delta);
	
	
	if direction:
		
		if key_run:
			final_speed = lerp(final_speed, SPEED * 1.5, ACCEL * .1);
		else:
			final_speed = lerp(final_speed, SPEED, DECCEL);
		
		velocity.x = lerp(velocity.x, direction.normalized().x * final_speed, ACCEL)
		velocity.z = lerp(velocity.z, direction.normalized().z * final_speed, ACCEL)
	else:
		
		final_speed = lerp(final_speed, SPEED, DECCEL);
		
		velocity.x = lerp(velocity.x, 0.0, DECCEL)
		velocity.z = lerp(velocity.z, 0.0, DECCEL)

	var vec = Vector2(velocity.z, velocity.x);
	var l = vec.length();
	var r = vec.angle_to_point(Vector2(0, 1));

	direction_sprite.scale = -Vector3(l, 1, l);
	direction_sprite.rotation = Vector3(0, r, 0);

	#print("%.2f" % final_speed)

	if velocity.x != 0.0 || velocity.z != 0.0:
		is_moving = true;
	else:
		is_moving = false;
		
		
	var stop_treshold = 0.1;
	if velocity.x > -stop_treshold && velocity.x < stop_treshold:
		velocity.x = 0.0
	if velocity.z > -stop_treshold && velocity.z < stop_treshold:
		velocity.z = 0.0
	
	# snap position to base pixel size divided by window scale to avoid jitter
	
	#position.x = snapped(position.x, (GLOBAL.TILE_X / 16.0) / GLOBAL.window_scale)
	#position.y = snapped(position.y, (GLOBAL.TILE_X / 16.0) / GLOBAL.window_scale)
	#position.z = snapped(position.z, (GLOBAL.TILE_X / 16.0) / GLOBAL.window_scale)
	
	#if velocity.x == 0.0 && velocity.z == 0.0:
	#	position.x = snapped(position.x, 0.0625)
	#	position.z = snapped(position.z, 0.0625)
	
	move_and_slide()

func jump():
	is_jumping = true
	is_falling = false
	jump_trigger = true
	just_jumped = true
