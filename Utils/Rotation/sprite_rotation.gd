extends Node
class_name SpriteRotation

@export var mesh_node: Node3D;
@export var curve_x: Curve;
@export var curve_y: Curve;

var curve_xx;
var curve_yy;

func _ready() -> void:
	
	var curve_xx = Curve.new();
	curve_xx.min_value = 1;
	curve_xx.max_value = GLOBAL.TILE_Z;
	curve_xx.add_point(Vector2(0, 1), 0.0, 3.28, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR);
	curve_xx.add_point(Vector2(0.125, GLOBAL.TILE_Z), 3.28, -3.28, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR);
	curve_xx.add_point(Vector2(0.25, 1), -3.28, 3.28, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR);
	curve_xx.add_point(Vector2(0.375, GLOBAL.TILE_Z), 3.28, -3.28, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR);
	curve_xx.add_point(Vector2(0.5, 1), -3.28, 3.28, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR);
	curve_xx.add_point(Vector2(0.625, GLOBAL.TILE_Z), 3.28, -3.28, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR);
	curve_xx.add_point(Vector2(0.75, 1), -3.28, 3.28, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR);
	curve_xx.add_point(Vector2(0.875, GLOBAL.TILE_Z), 3.28, -3.28, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR);
	curve_xx.add_point(Vector2(1, 1), -3.28, 0.0, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR);
	
	var curve_yy = Curve.new();
	curve_yy.min_value = 1;
	curve_yy.max_value = GLOBAL.TILE_Z;
	curve_yy.add_point(Vector2(0, GLOBAL.TILE_Z), 0.0, 3.28, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR);
	curve_yy.add_point(Vector2(0.125, 1), 3.28, -3.28, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR);
	curve_yy.add_point(Vector2(0.25, GLOBAL.TILE_Z), -3.28, 3.28, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR);
	curve_yy.add_point(Vector2(0.375, 1), 3.28, -3.28, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR);
	curve_yy.add_point(Vector2(0.5, GLOBAL.TILE_Z), -3.28, 3.28, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR);
	curve_yy.add_point(Vector2(0.625, 1), 3.28, -3.28, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR);
	curve_yy.add_point(Vector2(0.75, GLOBAL.TILE_Z), -3.28, 3.28, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR);
	curve_yy.add_point(Vector2(0.875, 1), 3.28, -3.28, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR);
	curve_yy.add_point(Vector2(1, GLOBAL.TILE_Z), -3.28, 0.0, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR);

func _process(delta: float) -> void:
	
	# optimize
	if mesh_node.rotation.z >= deg_to_rad(360): mesh_node.rotation.z = 0;
	if mesh_node.rotation.z <= deg_to_rad(-360): mesh_node.rotation.z = 0;
	
	var normalized_rotation = (mesh_node.rotation.z + TAU) / (2 * TAU);
	
	if curve_xx:
		mesh_node.scale.x = curve_xx.sample(normalized_rotation);
	if curve_yy:
		mesh_node.scale.y = curve_yy.sample(normalized_rotation);
