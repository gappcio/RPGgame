extends Resource
class_name SlotData

@export var item_data: ItemData
@export var amount: int = 1: set = set_amount;

func set_amount(_amount: int) -> void:
	amount = _amount;
	if amount > item_data.max_stack:
		amount = item_data.max_stack;
		if GAME.debug_inventory:
			pass
			push_error("INVENTORY DEBUG: %s amount exceeds max_stack." % item_data.name);
