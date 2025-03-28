class_name SaveButton
extends Node2D

@export var dialogic_save_argument:StringName
var player:PlayableCharacter

func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	player = get_tree().get_first_node_in_group("main_character")

func _on_dialogic_signal(argument:Dictionary) -> void:
	if argument.name == dialogic_save_argument:
		set_player_values()
		GameSaveHandler.save_game()

func set_player_values() -> void:
	Globals.player_position = player.position
