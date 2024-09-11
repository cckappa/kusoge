class_name BaseScene
extends Node

@onready var pause_menu:= preload("res://scenes/pause_menu.tscn").instantiate()

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	pause_menu.visible = false
	add_child(pause_menu)
	_ready_scene()

func _ready_scene() -> void:
	pass
