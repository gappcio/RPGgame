extends Node

class_name Global

var TILE_X: float = 1.0;
var TILE_Y: float = 1.414;
var TILE_Z: float = 1.414;

var PIXEL_X: float = TILE_X / 16.0;
var PIXEL_YZ: float = TILE_Z / 16.0;

var window_scale: int = 1;
var window_base_resolution: Vector2i = Vector2i(480, 270);

func get_map():
	# REMEMBER to add a check when map is being changed (make a map manager)
	for node in get_node("/root/MainScene/").get_children():
		if "MAP_" in str(node.get_name()):
			return node;

func lerp_fr(a: float, b: float, decay: float, delta: float):
	return b + (a - b) * exp(-decay * delta);
