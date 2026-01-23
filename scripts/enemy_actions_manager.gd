extends Node

@onready var state_chart := %StateChart

var time_elapsed := 0.0
var check_interval := 1.0  # Check every 1 second
var character_to_disable:Character
var enter_battle_wait_time := 5.0
var intro_dialogs:Array[EnemyFightDialog]
var current_intro_dialog:=-1
var current_victory_dialog:=-1
var talking:bool=false

var victory_dialog_object:Dictionary = {
	"character": null,
	"dialog": null
}

var victory_dialogs:Array[Dictionary]

var ability_status:={
	"ability":null,
	"from":null,
	"target":null
}

###
### STATE ENTERS

func _on_enter_state_entered() -> void:
	SignalBus.connect("starts_talking", _on_starts_talking)
	SignalBus.connect("stops_talking", _on_stops_talking)
	SignalBus.connect("enemy_health_trigger_dialog", _on_enemy_health_trigger_dialog)
	SignalBus.connect("enemy_victory_dialogs_started", _on_enemy_victory_dialogs_started)
	var enemies:Array[Character] = alive_enemies(Globals.current_arrange_enemies)
	for enemy : Character in enemies:
		enemy.current_container.reset_timer(enter_battle_wait_time)
		if enemy.get_intro_dialog() != null:
			if enemy.get_intro_dialog() not in intro_dialogs:
				intro_dialogs.append(enemy.get_intro_dialog())
		if enemy.get_victory_dialog() != null:
			victory_dialogs.append({"character":enemy, "dialog":enemy.get_victory_dialog()})
	if intro_dialogs.size() > 0:
		var dialog_timer := get_tree().create_timer(1.2)
		await dialog_timer.timeout
		dialog_timer = null
		advance_intro_dialog()

func _on_selecting_state_entered() -> void:
	pass # Replace with function body.

func _on_target_selecting_state_entered() -> void:
	var allies:Array[Character] = alive_allies(Globals.current_arrange_allies)
	var enemies:Array[Character] = alive_enemies(Globals.current_arrange_enemies)
	var current_target:Character=null
	
	if enemies.size() > 0 and allies.size() > 0:
		if ability_status.ability.effect == "POSITIVE":
			current_target = enemies.pick_random()
			ability_status.target = current_target
		elif ability_status.ability.effect == "NEGATIVE":
			current_target = allies.pick_random()
			ability_status.target = current_target
		state_chart.send_event("enemy_using_ability")
	else:
		pass

func _on_abilitying_state_entered() -> void:
	input_ability(ability_status.ability, ability_status.from, ability_status.target)
	state_chart.send_event("enemy_repeat_select")

###
### STATE INPUTS

###
### STATE PROCESSESS

func _on_selecting_state_processing(_delta:float) -> void:
	time_elapsed += _delta
	if time_elapsed >= check_interval:
		time_elapsed = 0.0  # Reset timer
		if talking:
			print("Enemy talking, skipping action selection")
			return
		var enemies : Array[Character] = alive_enemies(Globals.current_arrange_enemies)
		if enemies.size() > 0:
			var enemy : Character = enemies.pick_random()
			if enemy.current_container.check_timer():
				select_ability(enemy)

###
### FUNCTIONS

func select_ability(enemy:Character) -> void:
	ability_status.ability = enemy.abilities.pick_random()
	ability_status.from = enemy
	state_chart.send_event("enemy_target")

func alive_enemies(current_arrange_enemies:Dictionary) -> Array[Character]:
	var alive_enemies_arr : Array[Character]
	for enemy : Character in current_arrange_enemies.values():
		if enemy != null and enemy.current_hp > 0:
			alive_enemies_arr.append(enemy)
	
	return alive_enemies_arr

func alive_allies(current_arrange_allies:Dictionary) -> Array[Character]:
	var alive_allies_arr : Array[Character]
	for ally : Character in current_arrange_allies.values():
		if ally != null and ally.current_hp > 0:
			alive_allies_arr.append(ally)
	
	return alive_allies_arr


func input_ability(ability:Ability, from:Character, target:Character) -> void:
	if from.current_container.reset_timer(ability.wait_time):
		if from.current_hp <= 0:
			pass
		else:
			ability.use_ability(target)

func advance_intro_dialog() -> void:
	if current_intro_dialog < intro_dialogs.size() - 1:
		current_intro_dialog += 1
		print("Advancing intro dialog: ", current_intro_dialog)
		play_intro_dialog()

func advance_victory_dialog() -> void:
	if current_victory_dialog < victory_dialogs.size() - 1:
		current_victory_dialog += 1
		print("Advancing victory dialog: ", current_victory_dialog)
		play_victory_dialog()
	else:
		var victory_dialogs_ended_timer := get_tree().create_timer(0.5)
		await victory_dialogs_ended_timer.timeout
		victory_dialogs_ended_timer = null
		SignalBus.emit_signal("enemy_victory_dialogs_ended")

func play_victory_dialog() -> void:
	var dialog := victory_dialogs[current_victory_dialog]
	print("Playing victory dialog: %s" % dialog.dialog.dialogic_name)
	if dialog.character.current_hp <= 0:
		advance_victory_dialog()
	else:
		start_dialog(dialog.dialog)

func play_intro_dialog() -> void:
	var dialog := intro_dialogs[current_intro_dialog]
	print("Playing dialog: %s" % dialog.dialogic_name)
	start_dialog(dialog)

func start_dialog(dialog:EnemyFightDialog) -> void:
	var timeline_name := dialog.dialogic_name
	print("Starting dialog: %s" % timeline_name)
	SignalBus.emit_signal("starts_talking")
	if dialog.dialog_type == EnemyFightDialog.DialogType.INTRO:
		Dialogic.timeline_ended.connect(_on_timeline_intro_ended)
	elif dialog.dialog_type == EnemyFightDialog.DialogType.VICTORY:
		Dialogic.timeline_ended.connect(_on_timeline_victory_ended)
	else:
		Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.start(timeline_name)

func _on_timeline_ended() -> void:
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	SignalBus.emit_signal("stops_talking")
	print("termina de hablar")

func _on_timeline_intro_ended() -> void:
	Dialogic.timeline_ended.disconnect(_on_timeline_intro_ended)
	SignalBus.emit_signal("stops_talking")
	advance_intro_dialog()

func _on_timeline_victory_ended() -> void:
	Dialogic.timeline_ended.disconnect(_on_timeline_victory_ended)
	SignalBus.emit_signal("stops_talking")
	advance_victory_dialog()

func _on_starts_talking() -> void:
	talking = true

func _on_stops_talking() -> void:
	talking = false
	print("termina de hablar")

func _on_enemy_health_trigger_dialog(character:Character, dialog:EnemyFightDialog) -> void:
	start_dialog(dialog)

func _on_enemy_victory_dialogs_started() -> void:
	if victory_dialogs.size() > 0:
		advance_victory_dialog()
	# pass
