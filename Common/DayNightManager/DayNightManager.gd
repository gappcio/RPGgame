extends Node3D

@onready var environment: WorldEnvironment = $Environment;
@onready var sun: DirectionalLight3D = $Sun;
@onready var sun_cycle: AnimationPlayer = $SunCycle;

@onready var time: TimeSystem = get_node("/root/MainScene/Time");

## Day night cycle in seconds
## Default: 1200 (20 minutes)
@export var cycle_length: float = 4.0;

func _ready() -> void:
	time_start();

func _process(delta: float) -> void:
	pass

func time_start() -> void:
	sun_cycle.play("daynight_act1_may");
	sun_cycle.speed_scale = 1 / (cycle_length / 24.0);
