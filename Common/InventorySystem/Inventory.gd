extends PanelContainer
class_name Inventory

const SLOT = preload("res://Common/InventorySystem/Slot.tscn");
const SLOTS_WIDTH = 12;
const SLOTS_HEIGHT = 4;
var inventory_slots_amount = 48;

@export var active: bool;
@export var canvas_layer: CanvasLayer;
@export var inventory_array: Array[SlotData];

@onready var item_grid: GridContainer = $ItemGrid;
var page: int = 0;

func _ready() -> void:
	inventory_array.resize(inventory_slots_amount);
	get_ready();

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("inventory_toggle"):
		active = !active;
	
	if active:
		canvas_layer.visible = true;
	else:
		canvas_layer.visible = false;

func get_ready() -> void:
	
	# Clear the item grid
	# REMEMBER to clear all other future grids like armor slots etc
	for slot in item_grid.get_children():
		slot.queue_free();
	
	var i = 0;
	
	# Instantiate slot scenes in item grid
	# NO PAGES CURRENTLY
	for slot_data in inventory_array:
		var slot = SLOT.instantiate();
		item_grid.add_child(slot);
		slot.name = "Slot%s" % i;
		slot.id = i;
		
		slot.slot_clicked.connect(on_slot_clicked);
		
		if GAME.debug_inventory:
			print("INVENTORY DEBUG: Added slot on position: %s." % slot.id);
	
		# After adding slot scene, set its data
		# usun to potem
		if slot_data:
			slot.set_slot_data(slot_data);
			if GAME.debug_inventory:
				print("INVENTORY DEBUG: Set slot data at slot id %s." % slot.id);
			
		i += 1;

func add_item(item: int, amount: int) -> void:
	if !is_inventory_full():
		var i = 0;
		for slot in inventory_array:
			if slot != null:
				# If amount on slot != maxstack
				if slot.item_data.id == item && slot.amount != slot.item_data.max_stack:
					# If added amount + slot amount > maxstack
					if slot.amount + amount > slot.item_data.max_stack:
						var grid_slot = item_grid.get_child(i);
						var reminder = slot.amount + amount - slot.item_data.max_stack;
						slot.amount = slot.item_data.max_stack;
						grid_slot.update_amount(slot.amount);
						add_item(item, reminder);
						return;
					else:
						var grid_slot = item_grid.get_child(i);
						slot.amount += amount;
						grid_slot.update_amount(slot.amount);
						return;
				else:
					i += 1;
					continue;
					
			else:
				var grid_slot = item_grid.get_child(i);
				var slot_data = SlotData.new();
				var data_name = ITEM.ITEM_ID.keys()[item];
				var data = load("res://Entities/Items/ItemResource/%s.tres" % data_name);
				if data:
					data.set_item_info();
					slot_data.item_data = data;
					slot_data.amount = amount;
					grid_slot.set_slot_data(slot_data);
					inventory_array[i] = slot_data;
				else:
					push_error("Item resource not found");
					return;
				return;
			i += 1;
	else:
		item_drop(item, amount, Player.global_position);
		return;
		
func is_inventory_full() -> bool:
	for slot in inventory_array:
		if slot:
			if slot.amount != slot.item_data.max_stack:
				return false;
		else:
			return false;
	return true;

func item_exists(item: int) -> bool:
	for slot in inventory_array:
		if slot != null:
			if slot.item_data.id == item:
				return true;
	return false;

func item_drop(item: int, amount: int, _position: Vector3) -> void:
	var item_object_scene = load("res://Entities/Items/WorldItem.tscn");
	var item_object = item_object_scene.instantiate();
	var data_name = ITEM.ITEM_ID.keys()[item];
	var data = load("res://Entities/Items/ItemResource/%s.tres" % data_name);
	var map = GLOBAL.get_map();
	if data:
		data.set_item_info();
		item_object.item = data;
		item_object.amount = amount;
		map.add_child(item_object);
		item_object.global_position = Vector3(_position.x, _position.y + 2, _position.z);
		var rng = RandomNumberGenerator.new();
		item_object.velocity = Vector3(rng.randf_range(-15.0, 15.0), rng.randf_range(1.0, 5.0), rng.randf_range(-15.0, 15.0));

func on_slot_clicked(index: int, button: int, shift: bool):
	match(button):
		MOUSE_BUTTON_LEFT:
			# Create new held item data
			var held_item = HeldItem.new();
			
			# Clear slot data on index
			var grid_slot = item_grid.get_child(index);
			grid_slot.remove_slot_data();
			inventory_array[index] = null;
						

		MOUSE_BUTTON_RIGHT:
			pass
		MOUSE_BUTTON_MIDDLE:
			pass
