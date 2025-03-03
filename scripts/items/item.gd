class_name Item
extends Resource

@export var identifier:StringName
@export var display_name:String
@export var description:String
@export_enum(
	"HEAL", 
	"BUFF", 
	"REVIVE",
	"KEY"
	) var type: String = "HEAL"

@export var item_effect:ItemEffect

func remove_from_items(amount:int=1) -> void:
	if identifier in Items.item_list:
		Items.item_list[identifier].total -= amount
		if Items.item_list[identifier].total <= 0:
			Items.item_list.erase(identifier)  

func add_to_items(amount:int=1) -> void:
	if identifier in Items.item_list:
		Items.item_list[identifier].total += amount
	else:
		var new_entry := {
			"resource": self,
			"total": amount
		}
		Items.item_list[identifier] = new_entry

func use_item(targets: Array = [])->void:
	item_effect.apply_effect(targets)
	remove_from_items()
