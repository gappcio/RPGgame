extends Resource
class_name ItemData

enum ITEM_TYPE {
	none,
	resource,
	food,
	drink,
	melee,
	tool
}

@export var texture: AtlasTexture;
@export var name: String = "";
@export var type = ITEM_TYPE.none;
@export var max_stack: int = 1;
@export var health: float = 0.0;
@export var stamina: float = 0.0;

# level
# damage
# defence
# effects
# temperature
# capacity
# max capacity
