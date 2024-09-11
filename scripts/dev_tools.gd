extends Node

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event:InputEvent) -> void:
	if OS.is_debug_build():
		if event.is_action_pressed("esc"):
			get_tree().quit()
		if event.is_action_pressed("reload_game"):
			get_tree().change_scene_to_file("res://scenes/inicio_menu.tscn")
