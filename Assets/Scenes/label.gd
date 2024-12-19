extends Label

@onready var player = $"../../Player"

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	
	text = "gravity: " + str(player.global_position) + "\n" +\
	"jump_time: " + str(player.position) + "\n" +\
	"jump_accel_time: " + str(player.jump_accel_time) + "\n"
