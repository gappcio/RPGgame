extends Resource
class_name HeldItem

@export var item_data: ItemData
@export var amount: int = 1: set = set_amount;

func set_amount(_amount: int) -> void:
	amount = _amount;
	if amount > item_data.max_stack:
		amount = item_data.max_stack;
