extends Node
class_name MapStateManager

@export var map_name: StringName

func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	_ready_scene()
	map_state_logic()

func _on_dialogic_signal(argument: Dictionary) -> void:
	if not argument.has("name"):
		print("Dialogic signal received without 'name' key:", argument)
		return
	
	var event_name :String = argument.name
	dialogic_logic(event_name)

func _ready_scene() -> void:
	pass

func dialogic_logic(event_name: String) -> void:
	pass

func map_state_logic() -> void:
	pass