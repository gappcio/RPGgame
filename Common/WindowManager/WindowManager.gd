extends Node3D
class_name WindowManager

@export var active: bool;
@onready var canvas_layer: CanvasLayer = $Control/CanvasLayer

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
	pass


func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);


func _on_window_scale_input_value_changed(value: float) -> void:
	GLOBAL.window_scale = value
	print(DisplayServer.window_get_size())
