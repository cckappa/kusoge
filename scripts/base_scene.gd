class_name BaseScene
extends Node

const BATTLE = preload("res://scenes/battle.tscn")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	SignalBus.connect("starts_fighting", add_fight)
	_ready_scene()

func _ready_scene() -> void:
	pass

func add_fight() -> void:
	var battle_scene := BATTLE.instantiate()
	add_child(battle_scene)
