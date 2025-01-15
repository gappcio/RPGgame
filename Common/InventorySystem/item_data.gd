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

## Item texture from item atlas
@export var texture: AtlasTexture;
## Item name
@export var name: String = "";
## Item type
@export var type = ITEM_TYPE.none;
## Max stack on slot
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
