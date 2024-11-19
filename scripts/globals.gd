extends Node

var party:Array[Character]
var target:=[]
var main_enemy:EnemyResource
var current_enemies:Array[EnemyResource]
var extra_enemies:Array[EnemyResource]
var character_1 := preload("res://assets/resources/characters/main_character.tres")
var character_2 := preload("res://assets/resources/characters/dog.tres")

func _ready() -> void:
	character_1.current_hp = character_1.max_hp
	character_2.current_hp = character_2.max_hp
	party = [character_1, character_2]

func set_current_enemies(enemy:EnemyResource, _extra_enemies:Array[EnemyResource] = []) -> void:
	if main_enemy == null:
		main_enemy = enemy
		current_enemies = [enemy]
		if _extra_enemies.size() != 0:
			current_enemies.append_array(_extra_enemies)
			extra_enemies = _extra_enemies

func clear_current_enemies() -> void:
	main_enemy = null
	current_enemies.clear()
	if extra_enemies.size() != 0:
		extra_enemies.clear()

func set_target(_target:Array) -> void:
	target = _target
