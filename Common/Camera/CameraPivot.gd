extends Node3D

var mouse_sensitivity: float = 0.5;

@onready var player: Player = $".."
@onready var camera_yaw: Node3D = $CameraYaw
@onready var camera_pitch: Node3D = $CameraYaw/CameraPitch
@onready var spring_arm: SpringArm3D = $CameraYaw/CameraPitch/SpringArm
@onready var camera: Camera3D = $CameraYaw/CameraPitch/SpringArm/Camera

var yaw: float = 0.0;
var pitch: float = 0.0;
var pitch_max : float = 45;
var pitch_min : float = -45;
var position_offset : Vector3 = Vector3(0, 1.3, 0);
var position_offset_target : Vector3 = Vector3(0, 1.3, 0);

func _ready() -> void:
	spring_arm.add_excluded_object(player.get_rid())
	top_level = true;

func _unhandled_input(event: InputEvent) -> void:
	
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
	position_offset = lerp(position_offset, position_offset_target, 4 * delta)
	global_position = lerp(global_position, player.global_position + position_offset, 18 * delta)
	
	pitch = clamp(pitch, pitch_min, pitch_max)
	
	camera_yaw.rotation_degrees.y = yaw
	camera_pitch.rotation_degrees.x = pitch	
	
	#camera_yaw.rotation_degrees.y = lerp(camera_yaw.rotation_degrees.y, yaw, mouse_sensitivity * delta * 20)
	#camera_pitch.rotation_degrees.x = lerp(camera_pitch.rotation_degrees.x, pitch, mouse_sensitivity * delta * 20)
