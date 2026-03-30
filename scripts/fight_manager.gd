extends Node
class_name FightManager

@export var fights: Array[FightResource] = []
var player:PlayableCharacter

func _ready() -> void:
	player = get_tree().get_nodes_in_group("main_character")[0] as PlayableCharacter
	Dialogic.signal_event.connect(_on_dialogic_signal)
	SignalBus.connect("start_fight", _on_start_fight)
	
func _on_dialogic_signal(argument:Dictionary) -> void:
	if not argument.has("fight"):
		print("Dialogic signal received without 'fight' key:", argument)
		return

	var event_name :String = argument.fight

	print("Dialogic text signal received:", event_name)
	if fights.size() == 0:
		print("No fights configured in FightManager.")
		return
	
	for fight in fights:
		print(fight.identifier)
		if event_name == fight.identifier:
			Globals.set_win_stakes(fight.stakes.key_name, fight.stakes.key_value)
			Globals.target_marker = fight.target_marker
			start_battle(fight.enemies)

func _on_start_fight(fight_identifier:StringName) -> void:
	print("Start fight signal received:", fight_identifier)
	if fights.size() == 0:
		print("No fights configured in FightManager.")
		return

	for fight in fights:
		if fight_identifier == fight.identifier:
			Globals.set_win_stakes(fight.stakes.key_name, fight.stakes.key_value)
			Globals.target_marker = fight.target_marker
			start_battle(fight.enemies)

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

