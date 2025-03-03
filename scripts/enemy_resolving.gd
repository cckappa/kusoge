extends BattleStateEnemy

var current_member : Character

enum resolver{
	ABILITY
}

func enter(previous_state_path: String, data := {}) -> void:
	check_status()
	current_member = data.current_member
	set_next_ability()
	#reset_positions()
	check_hp()
	

func set_next_ability() -> void:
	var next_ability : Ability = current_member.abilities.pick_random()
	current_member.current_abilities[0] = current_member.current_abilities[1]
	current_member.current_abilities[1] = next_ability
	#current_member.current_container.next_ability(next_ability)

func reset_positions() -> void:
	current_member.current_container.unselected()

func check_hp() -> void:
	for key:StringName in Globals.current_arrange:
		var character:Character=Globals.current_arrange.get(key)
		if character is Character and character.current_hp <= 0:
			character.current_container.death()
			Globals.current_arrange[key] = null
			Globals.current_arrange_allies[key] = null
			Globals.current_arrange_enemies[key] = null
