class_name Item
extends Resource

@export var identifier:StringName
@export var section_folder:String
@export var icon:Texture2D=preload("res://assets/icons/warning.png") # Update to a valid path or placeholder

var display_name: String:
	get:
		return tr("%s/%s/name" % [section_folder, identifier])

var description: String:
	get:
		return tr("%s/%s/description" % [section_folder, identifier])

@export_enum(
	"HEAL", 
	"BUFF", 
	"REVIVE",
	"DAMAGE",
	"DEBUFF",
	"KEY"
	) var type: String = "HEAL"

@export var item_effect:ItemEffect

func remove_from_items(amount:int=1) -> void:
	if identifier in Items.item_list:
		Items.item_list[identifier].total -= amount
		if Items.item_list[identifier].total <= 0:
			Items.item_list.erase(identifier)  
	SignalBus.emit_signal("item_removed", self)

func add_to_items(amount:int=1) -> void:
	if identifier in Items.item_list:
		Items.item_list[identifier].total += amount
	else:
		var new_entry := {
			"resource": self,
			"total": amount
		}
		Items.item_list[identifier] = new_entry
	SignalBus.emit_signal("item_added", self)

func use_item(targets: Array = [])->void:
	item_effect.apply_effect(targets)
	remove_from_items()
