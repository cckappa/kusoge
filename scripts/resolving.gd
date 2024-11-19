extends BattleState

var ability : Ability

func enter(previous_state_path: String, data := {}) -> void:
	ability = data.ability
	if ability.has_method("use_ability"):
		ability.use_ability()
	#print(ability.ability_name)
