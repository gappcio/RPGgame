extends Camera3D

@onready var player = $"../Player";
@onready var sun = $"../DirectionalLight3D";

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	
	global_position = Vector3(player.global_position.x, 48.0, player.global_position.z + 46.0);
	
	if Input.is_action_pressed("camera_left"):
		sun.rotation.y -= 0.1;
		
	if Input.is_action_pressed("camera_right"):
		sun.rotation.y += 0.1;
