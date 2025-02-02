extends Node
class_name TimeSystem

@export var day: int;
@export_range(0, 59) var hour: int;
@export_range(0, 23) var minute: int;
@export_range(0, 59) var second: int;

var speed: float = 1.0;
var time: float = 0.0;
var int_time: int = 0;

func _process(delta: float) -> void:
	
	time += delta * speed;
	int_time = int(floor(time));
	
	second = int_time % 60;
	minute = (int_time / 60) % 60;
	hour = (int_time / 3600) % 24;
	day = (int_time / 86400);
