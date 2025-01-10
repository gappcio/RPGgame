extends Camera3D

@onready var player = $"../Player";
@onready var sun = $"../DirectionalLight3D";

var camera_speed = 0.3;
var camera_speed_y = 0.1;

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	
	# snap to base pixel size divided by window scale
	# TODO: make window manager -> change the 3.0 to window scale
	
	if !player.is_jumping:
		camera_speed_y = 1.0;
	else:
		camera_speed_y = 0.1;
	
	global_position.x = snapped(lerp(global_position.x, player.global_position.x, camera_speed), (GLOBAL.TILE_X / 16.0) / GLOBAL.window_scale);
	global_position.y = snapped(lerp(global_position.y, player.global_position.y + 48.0, camera_speed * .5 * camera_speed_y), (GLOBAL.TILE_Y / 16.0) / GLOBAL.window_scale);
	global_position.z = snapped(lerp(global_position.z, player.global_position.z + 46.0, camera_speed), (GLOBAL.TILE_Z / 16.0) / GLOBAL.window_scale);
