extends Node

var party:Array[Character]
var character_1 := preload("res://assets/resources/characters/main_character.tres")
var character_2 := preload("res://assets/resources/characters/dog.tres")

func _ready() -> void:
	character_1.current_hp = character_1.max_hp
	character_2.current_hp = character_2.max_hp
	party = [character_1, character_2]
