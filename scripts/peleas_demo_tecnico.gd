extends Node

@export var enemies:Array
var player:PlayableCharacter

func _ready() -> void:
	player = get_tree().get_nodes_in_group("main_character")[0] as PlayableCharacter
	Dialogic.signal_event.connect(_on_dialogic_signal_event)
	
func _on_dialogic_signal_event(event_name: String) -> void:
	print("Dialogic text signal received:", event_name)
	if event_name == "batalla_1":
		start_battle(enemies[0])
	elif event_name == "batalla_2":
		start_battle(enemies[1])
	elif event_name == "batalla_3":
		start_battle(enemies[2])


func start_battle(enemy_group: Array) -> void:
	Globals.player_position = player.position
	set_enemies(enemy_group)
	SignalBus.emit_signal("changing_scene")
	SignalBus.emit_signal("wild_enemy_encounter")

func set_enemies(enemy_group: Array) -> void:
	var new_enemies:Array[Character]
	for single_enemy:Character in enemy_group:
		var new_enemy := single_enemy.duplicate(true)
		new_enemy.set_current_hp()
		new_enemies.append(new_enemy)
	Globals.clear_current_enemies()
	Globals.enemies = new_enemies
