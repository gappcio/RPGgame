extends Camera3D

#@onready var player: Player = $"../MAP_DEVROOM1/Player";
@onready var player: Player = get_tree().get_nodes_in_group("player")[0];
@onready var limit_box = get_tree().get_nodes_in_group("camera_limit")[0].get_child(0);
@onready var label: Label = $"../Label"
@onready var sun: DirectionalLight3D = get_tree().get_nodes_in_group("sun")[0];

var camera_speed = 0.1;
var camera_speed_y = 0.1;

var CAMERA_BASE_X: float = 15.0;
var CAMERA_BASE_Z: float = 42.45 * GLOBAL.TILE_Z;

var CAMERA_SIZE_X: float = 30.0;
var CAMERA_SIZE_Z: float = 16.875 * GLOBAL.TILE_Z;

var limit_box_left: float = 0.0;
var limit_box_right: float = 0.0;
var limit_box_up: float = 0.0;
var limit_box_down: float = 0.0;

var limit_left: float = 0.0;
var limit_right: float = 0.0;
var limit_up: float = 0.0;
var limit_down: float = 0.0;

func _ready() -> void:
	limit_box_left = limit_box.global_position.x - (limit_box.shape.size.x / 2);
	limit_box_right = limit_box.global_position.x + (limit_box.shape.size.x / 2);
	limit_box_up = limit_box.global_position.z - (limit_box.shape.size.z / 2);
	limit_box_down = limit_box.global_position.z + (limit_box.shape.size.z / 2);

func _process(delta: float) -> void:
	
	#if Input.is_action_pressed("camera_left"):
		#sun.rotation.y -= 0.05;
	#
	#if Input.is_action_pressed("camera_right"):
		#sun.rotation.y += 0.05;
	
	if !player.is_jumping:
		camera_speed_y = 1.0;
	else:
		camera_speed_y = 0.1;
	
	var posx = snapped(lerp(global_position.x, player.global_position.x, camera_speed), (GLOBAL.TILE_X / 16.0) / GLOBAL.window_scale);
	var posy = snapped(lerp(global_position.y, player.global_position.y + 48.0, camera_speed * .5 * camera_speed_y), (GLOBAL.TILE_Y / 16.0) / GLOBAL.window_scale);
	var posz = snapped(lerp(global_position.z, player.global_position.z + 46.0, camera_speed), (GLOBAL.TILE_Z / 16.0) / GLOBAL.window_scale);

	global_position.x = posx;
	global_position.y = posy;
	global_position.z = posz;
	
	if global_position.x <= limit_box_left + CAMERA_SIZE_X / 2:
		global_position.x = limit_box_left + CAMERA_SIZE_X / 2;
		
	if global_position.x >= limit_box_right - CAMERA_SIZE_X / 2:
		global_position.x = limit_box_right - CAMERA_SIZE_X / 2;
		
	if global_position.z - CAMERA_BASE_Z <= limit_box_up:
		global_position.z = limit_box_up + CAMERA_BASE_Z;
		
	if global_position.z - CAMERA_BASE_Z >= limit_box_down - (CAMERA_SIZE_Z / 1):
		global_position.z = limit_box_down + CAMERA_BASE_Z - (CAMERA_SIZE_Z / 1);

	#label.	text = "pos.x: " + str(global_position.x) + "\n" +\
	#"pos.z: " + str(global_position.z) + "\n" +\
	#"limit_box_left: " + str(limit_box_left) + "\n" +\
	#"limit_box_right: " + str(limit_box_right) + "\n" +\
	#"limit_box_up: " + str(limit_box_up) + "\n" +\
	#"limit_box_down: " + str(limit_box_down) + "\n" +\
	#"pos.x: " + str(global_position.x - CAMERA_BASE_X) + "\n" +\
	#"pos.z: " + str(global_position.z - CAMERA_BASE_Z) + "\n" +\
	#"up - size_z/2: " + str(limit_box_down + CAMERA_BASE_Z - CAMERA_SIZE_Z / 2) + "\n"
