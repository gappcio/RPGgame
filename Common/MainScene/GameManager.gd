extends Control
class_name Game

@export var debug_inventory: bool = true;
@onready var inventory: Inventory = $/root/MainScene/UI/CanvasInventory/InventoryInferface/Inventory

func _ready() -> void:
	Console.pause_enabled = true;
	Console.add_command("ping", console_pong);
	Console.add_command("give", console_give_item, 2);
	
func console_pong() -> void:
	Console.print_line("pong");

func console_give_item(item_id: int, amount: int):
	print("a")
	inventory.add_item(str(item_id), amount);
