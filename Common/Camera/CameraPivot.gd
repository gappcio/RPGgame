extends SpringArm3D

var mouse_sensitivity: float = 0.5;

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotation.y -= event.relative.x * mouse_sensitivity;
			rotation.y = wrapf(rotation.y, 0.0, TAU);
			
			rotation.x -= event.relative.y * mouse_sensitivity;
			rotation.x = clamp(rotation.x, 0.0, 90.0);
			
	print(event)
