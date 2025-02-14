#@tool

extends Node3D
class_name DayNightCycleManager

@onready var world_environment: WorldEnvironment = $Environment;
@onready var sun: DirectionalLight3D = $Sun;
@onready var sun_cycle: AnimationPlayer = $SunCycle;
@onready var color_rect: ColorRect = $Viewport/SubViewportContainer/ColorRect;

@export_group("Time")
@export var enable_cycle: bool = false;
@export_range(0, 23, 0.1) var hour: float = 12.0;
## Day night cycle in seconds
## Default: 1200 (20 minutes)
@export var cycle_length: float = 1200.0;

@export_group("Environment")
@export var environment: Environment;

@export_group("Sky properties")
@export var sky_color: Color;
@export var sky_horizon_color: Color;
@export var energy: float;

#var LUT_image: ImageTexture3D;
#var LUT_array: Array[Image] = [];
#var LUT_size: int = 32;

func _ready() -> void:
	time_start();
	world_environment.environment = environment;
	
	#LUT_array.resize(LUT_size);
	#for i in range(0, LUT_size):
		#var image_name = "lut_default_%s" % (i + 1);
		#var tex2d: CompressedTexture2D = load("res://Common/DayNightManager/LUTs/lut_default/%s.png" % image_name);
		#var image: Image = tex2d.get_image();
		#image.decompress();
		#image.clear_mipmaps();
		#image.convert(Image.FORMAT_RGB8);
		#LUT_array[i] = image;
	#
	#LUT_image = ImageTexture3D.new();
	#LUT_image.create(Image.FORMAT_RGB8, LUT_size, LUT_size, LUT_size, false, LUT_array);
	#
	#world_environment.environment.adjustment_enabled = true;
	#world_environment.environment.adjustment_color_correction = LUT_image;


func _process(delta: float) -> void:
	world_environment.environment.background_energy_multiplier = energy;
	world_environment.environment.sky.sky_material.sky_top_color = sky_color;
	world_environment.environment.sky.sky_material.sky_horizon_color = sky_horizon_color;
	
	if sun_cycle != null:
		sun_cycle.speed_scale = 1 / (cycle_length / 24.0);
		if !enable_cycle:
			sun_cycle.seek(hour);
	
	var csb: Array[float];
	csb.resize(5);
	csb[0] = 0.1;
	csb[1] = 0.1;
	csb[2] = 0.1;
	csb[3] = 1.0;
	csb[4] = 1.0;
	
	var shader_time = sun_cycle.current_animation_position / sun_cycle.current_animation_length;
	if color_rect != null:
		color_rect.material.set_shader_parameter("time", shader_time);
		color_rect.material.set_shader_parameter("csb", csb);

func time_start() -> void:
	sun_cycle.play("daynight_act1_may");

func time_stop() -> void:
	sun_cycle.pause();
