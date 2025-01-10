extends Node3D
class_name WindowManager

@export var active: bool;
@onready var canvas_layer: CanvasLayer = $Control/CanvasLayer
@onready var screen_size_value: Label = $Control/CanvasLayer/Control/VBoxContainer2/HBoxContainer/ScreenSizeValue
@onready var window_size_value: Label = $Control/CanvasLayer/Control/VBoxContainer2/HBoxContainer2/WindowSizeValue


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("debug_toggle"):
		active = !active

	if active:
		canvas_layer.visible = true
		main()
	else:
		canvas_layer.visible = false
		
func main():
	screen_size_value.text = str(DisplayServer.screen_get_size());
	window_size_value.text = str(DisplayServer.window_get_size());


func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN);
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);


func _on_window_scale_input_value_changed(value: float) -> void:
	GLOBAL.window_scale = value;
	DisplayServer.window_set_size(GLOBAL.window_base_resolution * value);
	#get_window().content_scale_factor = value;
	print(DisplayServer.window_get_size())
