extends Node

@export var enemies:Array
var player:PlayableCharacter
var demo_1_stakes:StakesResource
var demo_2_stakes:StakesResource
var demo_3_stakes:StakesResource

func _ready() -> void:
	player = get_tree().get_nodes_in_group("main_character")[0] as PlayableCharacter
	Dialogic.signal_event.connect(_on_dialogic_signal)
	demo_1_stakes.key_name = "demo_tecnico_hub-batalla_1"
	demo_1_stakes.key_value = true
	demo_2_stakes.key_name = "demo_tecnico_hub-batalla_2"
	demo_2_stakes.key_value = true
	demo_3_stakes.key_name = "demo_tecnico_hub-batalla_3"
	demo_3_stakes.key_value = true
	
func _on_dialogic_signal(argument:Dictionary) -> void:
	var event_name :String = argument.name

	print("Dialogic text signal received:", event_name)
	if event_name == "batalla_1":
		Globals.set_stakes(demo_1_stakes)
		start_battle(enemies[0])
	elif event_name == "batalla_2":
		Globals.set_stakes(demo_2_stakes)
		start_battle(enemies[1])
	elif event_name == "batalla_3":
		Globals.set_stakes(demo_3_stakes)
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
