class_name PlayableCharacter
extends CharacterBody2D

@export var character_info:CharacterInfo

func _ready() -> void:
	position = Globals.player_position
