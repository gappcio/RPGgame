extends Control
class_name HeldItem


@onready var texture_rect: TextureRect = $TextureRect
@onready var amount_label: Label = $AmountLabel

@export var item_data: ItemData
@export var amount: int = 1: set = set_amount;

func _process(delta: float) -> void:
	position = Vector2(get_global_mouse_position().x - 64, get_global_mouse_position().y - 64);
	texture_rect.global_position = Vector2(get_global_mouse_position().x + 8, get_global_mouse_position().y + 8);
	amount_label.global_position = Vector2(get_global_mouse_position().x + 24, get_global_mouse_position().y + 24);

func set_amount(_amount: int) -> void:
	amount = _amount;

func set_slot_data(slot_data: SlotData) -> void:
	var item_data = slot_data.item_data;
	texture_rect.texture = item_data.texture;
	
	update_amount(slot_data.amount);

func update_amount(amount: int) -> void:
	var text = "%s" % amount;
	if amount == 1: text = " ";
	amount_label.text = text;
	amount_label.show();
