extends Node

@onready var state_chart := %StateChart

var time_elapsed := 0.0
var check_interval := 1.0  # Check every 1 second
var character_to_disable:Character
var enter_battle_wait_time := 5.0

var ability_status:={
	"ability":null,
	"from":null,
	"target":null
}

###
### STATE ENTERS

func _on_enter_state_entered() -> void:
	var enemies:Array[Character] = alive_enemies(Globals.current_arrange_enemies)
	for enemy : Character in enemies:
		enemy.current_container.reset_timer(enter_battle_wait_time)

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
