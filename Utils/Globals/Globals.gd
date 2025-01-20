extends Node

class_name Global

var TILE_X: float = 1.0;
var TILE_Y: float = 1.414;
var TILE_Z: float = 1.414;

var window_scale: int = 1;
var window_base_resolution: Vector2i = Vector2i(480, 270);

func get_map():
	# REMEMBER to add a check when map is being changed (make a map manager)
	for node in get_node("/root/MainScene/").get_children():
		if "MAP_" in str(node.get_name()):
			return node;
