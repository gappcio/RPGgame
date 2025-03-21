class_name WindowManager extends Node3D

@export var active: bool;
@onready var canvas_layer: CanvasLayer = $Control/CanvasLayer
@onready var screen_size_value: Label = $Control/CanvasLayer/Control/VBoxContainer2/HBoxContainer/ScreenSizeValue
@onready var window_size_value: Label = $Control/CanvasLayer/Control/VBoxContainer2/HBoxContainer2/WindowSizeValue
@onready var window_scale_input: SpinBox = $Control/CanvasLayer/Control/VBoxContainer/WindowScale/WindowScaleInput
@onready var fps_value: Label = $Control/CanvasLayer/Control/VBoxContainer2/HBoxContainer3/FPSValue
@onready var viewport: Control = $"../Viewport"
@onready var sub_viewport: SubViewport = $"../Viewport/SubViewportContainer/SubViewport"
@onready var sub_viewport_container: SubViewportContainer = $"../Viewport/SubViewportContainer"
@onready var control: Control = $Control


func _ready() -> void:
	#_on_fullscreen_button_toggled(true);
	#_on_window_scale_input_value_changed(int(floor(DisplayServer.screen_get_size()[0] / GLOBAL.window_base_resolution[0])));
	pass


func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("debug_toggle"):
		active = !active

	if active:
		canvas_layer.visible = true
		control.visible = true;
		main()
	else:
		canvas_layer.visible = false
		control.visible = false;
		
func main() -> void:
	screen_size_value.text = str(DisplayServer.screen_get_size());
	window_size_value.text = str(DisplayServer.window_get_size());
	fps_value.text = str(Engine.get_frames_per_second());


func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN);
		var window_scale: int = int(floor(DisplayServer.window_get_size(0)[0] / GLOBAL.window_base_resolution[0]));
		GLOBAL.window_scale = window_scale;
		window_scale_input.value = window_scale;
		window_scale_input.editable = false;
		_on_window_scale_input_value_changed(window_scale);
		#sub_viewport.size = GLOBAL.window_base_resolution * GLOBAL.window_scale;
		#viewport.scale = Vector2(window_scale, window_scale);
		
		print("Changed window mode to fullscreen");
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
		DisplayServer.window_set_size(GLOBAL.window_base_resolution * GLOBAL.window_scale);
		window_scale_input.editable = true;
		#sub_viewport.size = GLOBAL.window_base_resolution * GLOBAL.window_scale;
		#viewport.scale = Vector2(GLOBAL.window_scale, GLOBAL.window_scale);
		get_window().move_to_center();
		print("Changed window mode to windowed");


func _on_window_scale_input_value_changed(value: int) -> void:
	GLOBAL.window_scale = value;
	DisplayServer.window_set_size(GLOBAL.window_base_resolution * value);
	#viewport.scale = Vector2(value, value);
	var offset: Vector2 = Vector2((GLOBAL.window_base_resolution.x * value) / 2, (GLOBAL.window_base_resolution.y * value) / 2);
	#sub_viewport_container.pivot_offset = offset;
	#sub_viewport.size = GLOBAL.window_base_resolution * value;
	#sub_viewport_container.scale = Vector2(1/float(value), 1/float(value));
	get_window().move_to_center();
