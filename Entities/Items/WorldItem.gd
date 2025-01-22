extends CharacterBody3D
class_name WorldItem

@export var item: ItemData;
@export var amount: int;

@onready var sprite: Sprite3D = $Sprite3D;
@onready var collect_area: Area3D = $CollectArea
@onready var timer: Timer = $Timer
@onready var sprite_rotation: SpriteRotation = $SpriteRotation


var GRAVITY_BASE = ProjectSettings.get_setting("physics/3d/default_gravity");
var gravity = GRAVITY_BASE;

var can_be_collected = false;
var bounces = 2;


func _ready() -> void:
	sprite.texture = item.texture;
	set_collision_mask_value(2, false);

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	
	if !is_on_floor():
		velocity.y -= gravity * delta;
	else:
		if bounces > 0:
			velocity.y = 3;
			bounces -= 1;
		
	velocity.x = lerp(velocity.x, 0.0, 0.2);
	velocity.z = lerp(velocity.z, 0.0, 0.2);
	
	# sin 0 = 0; sin 90 = 1
	# cos 0 = 1; cos 90 = 1
	
	if Input.is_action_pressed("camera_left"):
		sprite.rotation.z -= 0.05;
		
	if Input.is_action_pressed("camera_right"):
		sprite.rotation.z += 0.05;

	
	# 0, 1
	# pi/2, 1.414
	# pi, 1
	
	#var sinesqr = (sin(sprite.rotation.z))**2;
	#var cosinesqr = (cos(sprite.rotation.z))**2;
	
	#sprite.scale.x = GLOBAL.TILE_Z * 1 / max(abs( sin(sprite.rotation.z) ) + abs( cos(sprite.rotation.z) ), 1);
	#sprite.scale.y = GLOBAL.TILE_Z * 1 / max(abs( cos(sprite.rotation.z) ) + abs( sin(sprite.rotation.z) ), 1);
	
	#sprite.scale.x = 1 / sqrt(cosinesqr + .5 * sinesqr);
	#sprite.scale.y = 1 / sqrt(sinesqr + .5 * cosinesqr);
	
	#sprite.scale.x = (0.414 * abs(sin(sprite.rotation.z))) + 1;
	#sprite.scale.y = (0.414 * abs(cos(sprite.rotation.z))) + 1;
	
	#sprite.scale.x = (0.21 * sin((sprite.rotation.z - 0.79) * 2)) + 1.21;
	#sprite.scale.y = (0.21 * cos((sprite.rotation.z) * 2)) + 1.21;
	
	# for 90  scale.x = 1.414  scale.y = 1
	# for 0   scale.x = 1	   scale.y = 1.414
	
	position.x = snapped(position.x, (GLOBAL.TILE_X / 16.0) / GLOBAL.window_scale);
	position.y = snapped(position.y, (GLOBAL.TILE_Y / 16.0) / GLOBAL.window_scale);
	position.z = snapped(position.z, (GLOBAL.TILE_Z / 16.0) / GLOBAL.window_scale);

	move_and_slide();


func _on_collect_area_body_entered(body: Node3D) -> void:
	if can_be_collected:
		if body is Player:
			var inventory = get_tree().get_nodes_in_group("inventory")[0];
			inventory.add_item(item.id, amount);
			queue_free();


func _on_timer_timeout() -> void:
	can_be_collected = true;
	set_collision_mask_value(2, true);
