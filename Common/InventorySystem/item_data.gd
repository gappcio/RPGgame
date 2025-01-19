extends Resource
class_name ItemData

## Item texture from item atlas
@export var texture: AtlasTexture;
## Item ID
@export var id: int;

var type = ITEM.ITEM_TYPE.none;
var max_stack: int = 1;
var health: float = 0.0;
var stamina: float = 0.0;

# level
# damage
# defence
# effects
# temperature
# capacity
# max capacity

func _ready() -> void:
	set_item_info();

func set_item_info() -> void:
	match(id):
		ITEM.ITEM_ID.none:
			pass
		ITEM.ITEM_ID.quartz:
			type = ITEM.ITEM_TYPE.resource;
			max_stack = set_item_stack_info();
		ITEM.ITEM_ID.stick:
			type = ITEM.ITEM_TYPE.resource;
			max_stack = set_item_stack_info();

func set_item_stack_info() -> int:
	var _max_stack;
	match(type):
		ITEM.ITEM_TYPE.resource:
			_max_stack = 20;
		ITEM.ITEM_TYPE.food:
			_max_stack = 20;
		ITEM.ITEM_TYPE.drink,\
		ITEM.ITEM_TYPE.tool,\
		ITEM.ITEM_TYPE.melee:
			_max_stack = 1;
	return _max_stack;
