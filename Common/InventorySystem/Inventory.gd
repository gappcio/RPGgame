extends PanelContainer
class_name Inventory

const SLOT = preload("res://Common/InventorySystem/Slot.tscn");
const HELD_SLOT = preload("res://Common/InventorySystem/HeldItem.tscn");
const SLOTS_WIDTH = 12;
const SLOTS_HEIGHT = 4;
var inventory_slots_amount = 48;

@export var active: bool;
@export var canvas_layer: CanvasLayer;
@export var inventory_array: Array[SlotData];
@export var inventory_interface: Control;

@onready var item_grid: GridContainer = $ItemGrid;
var page: int = 0;
var held_item = null;

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
		
	#held_item = inventory_interface.get_node_or_null("HeldItem");

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
	var held_item = inventory_interface.get_node_or_null("HeldItem");
	match(button):
		MOUSE_BUTTON_LEFT:
			# If we are not holding anything
			if !held_item:
				# If there is an item on a slot
				if inventory_array[index]:
					# Create new held item data
					var held_slot_data = SlotData.new();
					var held_slot = HELD_SLOT.instantiate();
					inventory_interface.add_child(held_slot);
					var item_id = inventory_array[index].item_data.id;
					var item_amount = inventory_array[index].amount;
					var data_name = ITEM.ITEM_ID.keys()[item_id];
					var data = load("res://Entities/Items/ItemResource/%s.tres" % data_name);
					
					if data:
						data.set_item_info();
						held_slot.item_data = data;
						held_slot.amount = item_amount;
						held_slot_data.item_data = data;
						held_slot_data.amount = item_amount;
						held_slot.set_slot_data(held_slot_data);
					else:
						push_error("Item resource not found");
					
					# Show held item and update its position
					held_slot.self_modulate = Color(1.0, 1.0, 1.0, 0.0);
					held_slot.position = get_global_mouse_position();
					
					held_item = held_slot;
					
					# Clear slot data on index
					var grid_slot = item_grid.get_child(index);
					grid_slot.remove_slot_data();
					inventory_array[index] = null;
				
			else:
				# If we are holding an item

				# If there is something on a slot already
				if inventory_array[index]:
					# If held item is same as the item on slot
					var grid_slot = item_grid.get_child(index);
					if inventory_array[index].item_data.id == held_item.item_data.id:
						# Add amount on slot
						if inventory_array[index].amount + held_item.amount > inventory_array[index].item_data.max_stack:
							held_item.amount -= inventory_array[index].item_data.max_stack - inventory_array[index].amount;
							inventory_array[index].amount = inventory_array[index].item_data.max_stack;
							grid_slot.update_amount(inventory_array[index].amount);
							held_item.update_amount(held_item.amount);
						else:
							inventory_array[index].amount += held_item.amount;
							grid_slot.update_amount(inventory_array[index].amount);
							held_item.queue_free();
					else:
						# If held item is of another id
						# Swap slot with held item
						
						var new_slot_data = SlotData.new();
						var temp_data = SlotData.new();
						
						var temp_item = inventory_array[index].item_data;
						var temp_amount = inventory_array[index].amount;
						
						inventory_array[index].item_data = held_item.item_data;
						inventory_array[index].amount = held_item.amount;
						new_slot_data.item_data = held_item.item_data;
						new_slot_data.amount = held_item.amount;
						grid_slot.set_slot_data(new_slot_data);
						grid_slot.update_amount(held_item.amount);
						
						held_item.item_data = temp_item;
						held_item.amount = temp_amount;
						temp_data.item_data = temp_item;
						temp_data.amount = temp_amount;
						held_item.set_slot_data(temp_data);
						held_item.update_amount(temp_amount);
						
				else:
					# If there is nothing on that slot, put the item there
					var grid_slot = item_grid.get_child(index);
					var slot_data = SlotData.new();
					var item_id = held_item.item_data.id;
					var item_amount = held_item.amount;
					var data_name = ITEM.ITEM_ID.keys()[item_id];
					var data = load("res://Entities/Items/ItemResource/%s.tres" % data_name);
					if data:
						data.set_item_info();
						slot_data.item_data = data;
						slot_data.amount = item_amount;
						grid_slot.set_slot_data(slot_data);
						inventory_array[index] = slot_data;
					else:
						push_error("Item resource not found");
						
					held_item.queue_free();
						

		MOUSE_BUTTON_RIGHT:
			# If we are not holding anything
			if !held_item:
				# If there is an item on a slot
				if inventory_array[index]:
					# Create new held item data
					
					var held_slot_data = SlotData.new();
					var held_slot = HELD_SLOT.instantiate();
					inventory_interface.add_child(held_slot);
					var item_id = inventory_array[index].item_data.id;
					var data_name = ITEM.ITEM_ID.keys()[item_id];
					var data = load("res://Entities/Items/ItemResource/%s.tres" % data_name);
					
					# Pick only 1 of the selected item
					
					if data:
						data.set_item_info();
						held_slot.item_data = data;
						held_slot.amount = 1;
						held_slot_data.item_data = data;
						held_slot_data.amount = 1;
						held_slot.set_slot_data(held_slot_data);
					else:
						push_error("Item resource not found");
					
					# Show held item and update its position
					held_slot.self_modulate = Color(1.0, 1.0, 1.0, 0.0);
					held_slot.position = get_global_mouse_position();
					
					held_item = held_slot;
					
					# Remove 1 of the item on selected slot
					var grid_slot = item_grid.get_child(index);
					inventory_array[index].amount -= 1;
					grid_slot.update_amount(inventory_array[index].amount);
					if inventory_array[index].amount < 1:
						grid_slot.remove_slot_data();
						inventory_array[index] = null;
				
			else:
				# If we are holding an item

				# If there is something on a slot already
				if inventory_array[index]:
					# If held item is same as the item on slot
					var grid_slot = item_grid.get_child(index);
					if inventory_array[index].item_data.id == held_item.item_data.id:
						# Remove 1 item from slot and add it to held slot
						
						if held_item.amount < inventory_array[index].item_data.max_stack:
							held_item.amount += 1;
							inventory_array[index].amount -= 1;
							
							grid_slot.update_amount(inventory_array[index].amount);
							held_item.update_amount(held_item.amount);
							
							if inventory_array[index].amount < 1:
								inventory_array[index] = null;
								grid_slot.remove_slot_data();
						
					else:
						# If held item is of another id
						return;
				else:
					# If there is nothing on that slot
					return;
		MOUSE_BUTTON_MIDDLE:
			pass
