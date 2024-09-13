class_name BaseScene
extends Node

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	_ready_scene()

func _ready_scene() -> void:
	pass
