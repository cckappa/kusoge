extends Control

@onready var overwrite_button := %OverwriteButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	overwrite_button.button_pressed = Globals.overwrite_map_state

func _on_check_button_toggled(toggled_on:bool) -> void:
	Globals.overwrite_map_state = toggled_on
	print("Overwrite map state set to: ", Globals.overwrite_map_state)
