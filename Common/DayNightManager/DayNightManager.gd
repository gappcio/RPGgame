@tool

extends Node3D
class_name DayNightCycleManager


@onready var world_environment: WorldEnvironment = $Environment;
@onready var sun: DirectionalLight3D = $Sun;
@onready var sun_cycle: AnimationPlayer = $SunCycle;

@onready var time: TimeSystem = get_node("/root/MainScene/Time");

@export var environment: Environment;
## Day night cycle in seconds
## Default: 1200 (20 minutes)
@export var cycle_length: float = 4.0;

@export_group("Sky properties")
@export var color: Color;
@export var energy: float;

func _ready() -> void:
	time_start();
	world_environment.environment = environment;
	world_environment.environment.sky.sky_material.sky_top_color = color;
	

func _process(delta: float) -> void:
	world_environment.environment.background_energy_multiplier = energy;

func time_start() -> void:
	sun_cycle.play("daynight_act1_may");
	sun_cycle.speed_scale = 1 / (cycle_length / 24.0);

func time_stop() -> void:
	sun_cycle.pause();
