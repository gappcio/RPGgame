extends PanelContainer

@onready var texture_rect: TextureRect = $TextureRect
@onready var amount_label: Label = $AmountLabel

var id: int;

signal slot_clicked(index: int, button: int, shift: bool);

func remove_slot_data() -> void:
	texture_rect.texture = null;
	amount_label.text = "";
	amount_label.hide();

func set_slot_data(slot_data: SlotData) -> void:
	var item_data = slot_data.item_data;
	texture_rect.texture = item_data.texture;
	
	update_amount(slot_data.amount);

func update_amount(amount: int) -> void:
	if amount > 1:
		amount_label.text = "%s" % amount;
		amount_label.show();


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	&& (event.button_index == MOUSE_BUTTON_LEFT || event.button_index == MOUSE_BUTTON_RIGHT || event.button_index == MOUSE_BUTTON_MIDDLE) \
	&& event.is_pressed():
		slot_clicked.emit(get_index(), event.button_index, Input.is_action_pressed("inventory_shift"));
