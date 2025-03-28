class_name ItemGiver
extends Node

@export var item:Item
@export var dialogic_signal:String = ""

func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)


func _on_dialogic_signal(argument:Dictionary) -> void: 
	if dialogic_signal != "" and argument.name == dialogic_signal:
		if argument.amount != null:
			item.add_to_items(argument.amount)
		else:
			printerr("argument.amount not provided")
