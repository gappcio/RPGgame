extends Node3D

var mouse_sensitivity: float = 0.5;

@onready var player: Player = $".."
@onready var camera_yaw: Node3D = $CameraYaw
@onready var camera_pitch: Node3D = $CameraYaw/CameraPitch
@onready var spring_arm: SpringArm3D = $CameraYaw/CameraPitch/SpringArm
#@onready var camera: Camera3D = $CameraYaw/CameraPitch/SpringArm/Camera
@onready var camera: Camera3D = $CameraYaw/CameraPitch/Camera

var yaw: float = 0.0;
var pitch: float = 0.0;
var pitch_max : float = 45;
var pitch_min : float = -45;
var position_offset : Vector3 = Vector3(0, 6, 10);
var position_offset_target : Vector3 = Vector3(0, 6, 10);

var camera_pos: Vector3 = Vector3(0.0, 8.0, 18.0);
var camera_zoom: Vector3 = Vector3(0.0, 0.0, 0.0);

var zoom: float = 7.0;
var zoom_min: float = 4.0;
var zoom_max: float = 12.0;

func _ready() -> void:
	pass
	spring_arm.add_excluded_object(player.get_rid())
	top_level = true;

func _unhandled_input(event: InputEvent) -> void:
	pass
	
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			yaw += -event.relative.x * mouse_sensitivity;
			pitch += -event.relative.y * mouse_sensitivity;
			
			#rotation.y -= event.relative.x * mouse_sensitivity;
			#rotation.y = wrapf(rotation.y, 0.0, TAU);
			#
			#rotation.x -= event.relative.y * mouse_sensitivity;
			#rotation.x = clamp(rotation.x, -PI/2, 0.75);
			#
			#print(rad_to_deg(rotation.y));

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("camera_zoom_in"):
		camera_zoom -= Vector3(0.0, 0.375, 1.0);
	if Input.is_action_just_pressed("camera_zoom_out"):
		camera_zoom += Vector3(0.0, 0.375, 1.0);
	
	camera_zoom = clamp(camera_zoom, Vector3(0.0, -5.25, -14.0), Vector3(0.0, 2.25, 6.0));
	#zoom = clamp(zoom, zoom_min, zoom_max);
		
	#spring_arm.spring_length = lerp(spring_arm.spring_length, zoom, 4 * delta);
	#camera.position.z = spring_arm.spring_length;
	#
	#camera.fov = lerp(camera.fov, 75.0 + zoom, 4 * delta)
	
	#camera_pos = lerp(camera_pos, position_offset_target, 4 * delta);
	global_position = lerp(global_position, player.global_position + camera_zoom, 18 * delta);
	
	
	#pitch = clamp(pitch, pitch_min, pitch_max)
	
	#camera_yaw.rotation_degrees.y = yaw
	#camera_pitch.rotation_degrees.x = pitch	
	#
	#camera_yaw.rotation_degrees.y = lerp(camera_yaw.rotation_degrees.y, yaw, mouse_sensitivity * delta * 30)
	#camera_pitch.rotation_degrees.x = lerp(camera_pitch.rotation_degrees.x, pitch, mouse_sensitivity * delta * 30)
