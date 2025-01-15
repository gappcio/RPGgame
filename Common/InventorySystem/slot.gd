extends PanelContainer

@onready var texture_rect: TextureRect = $TextureRect
@onready var amount_label: Label = $AmountLabel

var id: int;

func set_slot_data(slot_data: SlotData) -> void:
	var item_data = slot_data.item_data;
	texture_rect.texture = item_data.texture;
	
	if slot_data.amount > 1:
		amount_label.text = "%s" % slot_data.amount;
		amount_label.show()
