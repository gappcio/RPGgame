extends PanelContainer
class_name Inventory

const SLOT = preload("res://Common/InventorySystem/Slot.tscn");

@export var active: bool;
@export var canvas_layer: CanvasLayer;

@onready var item_grid: GridContainer = $ItemGrid


func _ready() -> void:
	var inventory_data = preload("res://Common/InventorySystem/inventory.tres");
	populate_grid(inventory_data.inv_slot_data);

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("inventory_toggle"):
		active = !active;
	
	if active:
		canvas_layer.visible = true;
	else:
		canvas_layer.visible = false;

func populate_grid(inv_slot_data: Array[SlotData]) -> void:
	
	for i in item_grid.get_children():
		i.queue_free();
		
		if GAME.debug_inventory:
			print("INVENTORY DEBUG: Cleared inventory.");
	
	var i = 0;
	
	for slot_data in inv_slot_data:
		var slot = SLOT.instantiate();
		item_grid.add_child(slot);
		slot.id = i;
		
		if GAME.debug_inventory:
			print("INVENTORY DEBUG: Added slot on position: %s." % slot.id);
	
		if slot_data:
			slot.set_slot_data(slot_data);
			if GAME.debug_inventory:
				print("INVENTORY DEBUG: Set slot data at slot id %s." % slot.id);
			
		i += 1;

func add_item(item: String, amount: int) -> void:
	var slot = item_grid.get_child(0);
	print(slot)
